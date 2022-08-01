/****************************************************************/
/*                                                              */
/*                          Version                             */
/*                                                              */
/*                  Common version information                  */
/*                                                              */
/*                      Copyright (c) 2022                      */
/*                      Zanvok Corporation                      */
/*                      All Rights Reserved                     */
/*                                                              */
/* This file is part of Flix Kernel.                                  */
/*                                                              */
/* Flix Kernel is free software; you can redistribute it and/or       */
/* modify it under the terms of the GNU General Public License  */
/* as published by the Free Software Foundation; either version */
/* 2, or (at your option) any later version.                    */
/*                                                              */
/* Flix Kernel is distributed in the hope that it will be useful, but */
/* WITHOUT ANY WARRANTY; without even the implied warranty of   */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See    */
/* the GNU General Public License for more details.             */
/*                                                              */
/* You should have received a copy of the GNU General Public    */
/* License along with Flix Kernel; see the file COPYING.  If not,     */
/* write to the Free Software Foundation, 675 Mass Ave,         */
/* Cambridge, MA 02139, USA.                                    */
/****************************************************************/

/* The version the kernel reports as compatible with */
#ifdef WITHFAT32
#define MAJOR_RELEASE   6
#define MINOR_RELEASE   22
#else
#define MAJOR_RELEASE   6
#define MINOR_RELEASE   22
#endif

/* The actual kernel revision, 124+REVISION_SEQ = 22.REVISION_SEQ */
#define REVISION_SEQ    43      /* returned in BL by int 21 function 30 */
#define OEM_ID          0xfd    /* Zanvok Corporation, returned in BH by int 21 30 */

/* Used for version information displayed to user at boot (& stored in os_release string) */
#ifndef KERNEL_VERSION
#define KERNEL_VERSION "- GIT "
#endif

/* actual version string */
#define KVS(v,s,o) "Flix kernel " v "(build 20" #s " OEM:" #o ") [compiled " __DATE__ "]\n"
#define xKVS(v,s,o) KVS(v,s,o)
#define KERNEL_VERSION_STRING xKVS(KERNEL_VERSION, REVISION_SEQ, OEM_ID)

