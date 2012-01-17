Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:58485 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab2AQTpz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jan 2012 14:45:55 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH] dvbv5-scan: bugfix possible crash by parsing strings
Date: Tue, 17 Jan 2012 20:45:42 +0100
Message-Id: <1326829542-4134-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

PID 0x0010, TableID 0x40 ID=0x3001, version 4, size 132
        40 f0 81 30 01 c9 00 00 f0 26 40 18 44 56 42 2d
        54 20 42 65 72 6c 69 6e 2f 42 72 61 6e 64 65 6e
        62 75 72 67 6c 0a 01 01 49 9a 08 89 21 01 ec 00
        f0 4e 01 01 21 14 f0 24 5a 0b 04 10 a6 40 1f 41
        12 ff ff ff ff 6d 07 01 01 04 10 a6 40 00 41 0c
        00 02 01 00 41 01 00 61 01 00 81 01 01 02 21 14
        f0 1e 5a 0b 03 1c 82 40 1f 41 12 ff ff ff ff 41
        0f 00 0b 01 00 0c 01 00 0d 01 00 0e 01 00 0f 01
        5a 5e 75 59
        section_length = 129 section 0, last section 0
Descriptors table len 38
network_name_descriptor (0x40), len 24
        44 56 42 2d 54 20 42 65 72 6c 69 6e 2f 42 72 61
        6e 64 65 6e 62 75 72 67
*** glibc detected *** ./dvbv5-scan: free(): invalid pointer: 0x0000000000618dc0 ***
======= Backtrace: =========
/lib64/libc.so.6(+0x74c06)[0x7ffe9b15dc06]
./dvbv5-scan[0x407ba6]
./dvbv5-scan[0x407339]
./dvbv5-scan[0x405c7e]
./dvbv5-scan[0x4067d3]
./dvbv5-scan[0x401749]
/lib64/libc.so.6(__libc_start_main+0xed)[0x7ffe9b10a23d]
./dvbv5-scan[0x401dd5]
======= Memory map: ========
00400000-0040e000 r-xp 00000000 08:03 15084544                           /home/stefan/build/dvb_utils/v4l-utils/utils/dvb/dvbv5-scan
0060d000-0060e000 r--p 0000d000 08:03 15084544                           /home/stefan/build/dvb_utils/v4l-utils/utils/dvb/dvbv5-scan
0060e000-00610000 rw-p 0000e000 08:03 15084544                           /home/stefan/build/dvb_utils/v4l-utils/utils/dvb/dvbv5-scan
00610000-00631000 rw-p 00000000 00:00 0                                  [heap]
7ffe9acd0000-7ffe9ace5000 r-xp 00000000 08:03 15859816                   /lib64/libgcc_s.so.1
7ffe9ace5000-7ffe9aee4000 ---p 00015000 08:03 15859816                   /lib64/libgcc_s.so.1
7ffe9aee4000-7ffe9aee5000 r--p 00014000 08:03 15859816                   /lib64/libgcc_s.so.1
7ffe9aee5000-7ffe9aee6000 rw-p 00015000 08:03 15859816                   /lib64/libgcc_s.so.1
7ffe9aee6000-7ffe9aee8000 r-xp 00000000 08:03 59904690                   /usr/lib64/gconv/ISO8859-1.so
7ffe9aee8000-7ffe9b0e7000 ---p 00002000 08:03 59904690                   /usr/lib64/gconv/ISO8859-1.so
7ffe9b0e7000-7ffe9b0e8000 r--p 00001000 08:03 59904690                   /usr/lib64/gconv/ISO8859-1.so
7ffe9b0e8000-7ffe9b0e9000 rw-p 00002000 08:03 59904690                   /usr/lib64/gconv/ISO8859-1.so
7ffe9b0e9000-7ffe9b26e000 r-xp 00000000 08:03 15859719                   /lib64/libc-2.14.1.so
7ffe9b26e000-7ffe9b46e000 ---p 00185000 08:03 15859719                   /lib64/libc-2.14.1.so
7ffe9b46e000-7ffe9b472000 r--p 00185000 08:03 15859719                   /lib64/libc-2.14.1.so
7ffe9b472000-7ffe9b473000 rw-p 00189000 08:03 15859719                   /lib64/libc-2.14.1.so
7ffe9b473000-7ffe9b478000 rw-p 00000000 00:00 0
7ffe9b478000-7ffe9b498000 r-xp 00000000 08:03 15859714                   /lib64/ld-2.14.1.so
7ffe9b671000-7ffe9b674000 rw-p 00000000 00:00 0
7ffe9b68e000-7ffe9b68f000 rw-p 00000000 00:00 0
7ffe9b68f000-7ffe9b696000 r--s 00000000 08:03 59904753                   /usr/lib64/gconv/gconv-modules.cache
7ffe9b696000-7ffe9b698000 rw-p 00000000 00:00 0
7ffe9b698000-7ffe9b699000 r--p 00020000 08:03 15859714                   /lib64/ld-2.14.1.so
7ffe9b699000-7ffe9b69a000 rw-p 00021000 08:03 15859714                   /lib64/ld-2.14.1.so
7ffe9b69a000-7ffe9b69b000 rw-p 00000000 00:00 0
7fffab429000-7fffab44a000 rw-p 00000000 00:00 0                          [stack]
7fffab51c000-7fffab51d000 r-xp 00000000 00:00 0                          [vdso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]
Abgebrochen
localhost:/home/stefan/build/dvb_utils/v4l-utils/utils/dvb #


Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 utils/dvb/parse_string.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/utils/dvb/parse_string.c b/utils/dvb/parse_string.c
index f073a07..37f5c3a 100644
--- a/utils/dvb/parse_string.c
+++ b/utils/dvb/parse_string.c
@@ -410,8 +410,8 @@ void parse_string(char **dest, char **emph,
 		 * Handles the ISO/IEC 10646 1-byte control codes
 		 * (EN 300 468 v1.11.1 Table A.1)
 		 */
-		tmp1 = malloc(len);
-		tmp2 = malloc(len);
+		tmp1 = malloc(len + 2);
+		tmp2 = malloc(len + 2);
 		p = (char *)tmp1;
 		p2 = (char *)tmp2;
 		s = src;
-- 
1.7.7

