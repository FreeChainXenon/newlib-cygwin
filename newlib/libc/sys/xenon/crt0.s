# Program initialisation and shutdown code for FreeChainXenon (crt0)
#
# Copyright (c) 2025 Aiden Isik
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

.global _start
.text

_start:
	# Save the link register
	mflr 12
	std 12, 0(1)

	# Determine where the stack pointer should be moved to (16-byte alignment down, at least 8 bytes free)
	subi 14, 1, 0x10
	lis 15, 0xFFFF
	ori 15, 15, 0xFFF0
	and 14, 14, 15

	# Save the stack pointer, then update it
	std 1, 0(14)
	mr 1, 14

  # Call initialisation procedures
  bl __init

	# Call main()
	bl main

  # Call finishing procedures
  bl __fini

	# Restore the stack pointer
	ld 1, 0(1)

	# Restore the link register
	ld 12, 0(1)
	mtlr 12

	# Return to the ELF loader, which will handle returning to dashboard
	blr
