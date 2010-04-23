Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5.tech.numericable.fr ([82.216.111.41]:44476 "EHLO
	smtp5.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab0DWPDZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Apr 2010 11:03:25 -0400
Received: from ibiza.bxl.tuxicoman.be (cable-85.28.107.20.coditel.net [85.28.107.20])
	by smtp5.tech.numericable.fr (Postfix) with ESMTP id 30169124019
	for <linux-media@vger.kernel.org>; Fri, 23 Apr 2010 17:03:21 +0200 (CEST)
Received: from [2001:6f8:310:301::1] (helo=borg.bxl.tuxicoman.be)
	by ibiza.bxl.tuxicoman.be with esmtps (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.71)
	(envelope-from <gmsoft@tuxicoman.be>)
	id 1O5KPU-0006eJ-Aj
	for linux-media@vger.kernel.org; Fri, 23 Apr 2010 17:03:21 +0200
Date: Fri, 23 Apr 2010 17:03:16 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Xawtv sparc 64bit fix
Message-ID: <20100423170316.12e01bfc@borg.bxl.tuxicoman.be>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/8prk+CuY3Pl2xmSkW7TZJpw"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/8prk+CuY3Pl2xmSkW7TZJpw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline



Hi,

Here is an old patch of mine which I tried to submit in 2006 but never
got it. I didn't really know who was xawtv's maintainer at that time.



The calculation to compute the 64bit alignement in struct-dump.c is
plain wrong. The alignment has to be computed with a structure
containing a char and then a 64bit integer and then substract the
pointer of the 64bit int to the one of the char.

This fix v4l-info doing a Bus Error on sparc with structs containing
64 bit integer following a non 64bit field aligned on a 8 byte boundary
like v4l2_standard.


Signed-off-by: Guy Martin <gmsoft@tuxicoman.be>


Regards,
  Guy
--MP_/8prk+CuY3Pl2xmSkW7TZJpw
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=xawtv-struct-dump.diff

diff --git a/structs/struct-dump.c b/structs/struct-dump.c
index 0ee7fc8..ba1dc6f 100644
--- a/structs/struct-dump.c
+++ b/structs/struct-dump.c
@@ -43,7 +43,9 @@ int print_struct(FILE *fp, struct struct_desc *desc, void *data,
 	int16_t  s16;
 	uint8_t  u8;
 	int8_t   s8;
-	int al = sizeof(long)-1; /* struct + union + 64bit alignment */
+	struct al64_t { char c; uint64_t t; } al64_t;
+	int al = sizeof(long)-1; /* struct + union */
+	int al64 = (unsigned)&al64_t.t - (unsigned)&al64_t.c - 1; /* 64 bit alignement */
 	void *p;
 	unsigned int i,j,first;
 
@@ -149,7 +151,7 @@ int print_struct(FILE *fp, struct struct_desc *desc, void *data,
 			ptr += 4;
 			break;
 		case BITS64:
-			ptr = (void*)(((intptr_t)ptr + al) & ~al);
+			ptr = (void*)(((intptr_t)ptr + al64) & ~al64);
 			u64 = *((uint64_t*)ptr);
 			first = 1;
 			fprintf(fp,"0x%" PRIx64 " [",u64);
@@ -166,13 +168,13 @@ int print_struct(FILE *fp, struct struct_desc *desc, void *data,
 			break;
 
 		case UINT64:
-			ptr = (void*)(((intptr_t)ptr + al) & ~al);
+			ptr = (void*)(((intptr_t)ptr + al64) & ~al64);
 			u64 = *((uint64_t*)ptr);
 			fprintf(fp,"%" PRIu64,u64);
 			ptr += 8;
 			break;
 		case SINT64:
-			ptr = (void*)(((intptr_t)ptr + al) & ~al);
+			ptr = (void*)(((intptr_t)ptr + al64) & ~al64);
 			s64 = *((int64_t*)ptr);
 			fprintf(fp,"%" PRId64,s64);
 			ptr += 8;

--MP_/8prk+CuY3Pl2xmSkW7TZJpw--
