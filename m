Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:52687 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288Ab3L1Pq2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 10:46:28 -0500
Received: by mail-ee0-f54.google.com with SMTP id e51so3764751eek.41
        for <linux-media@vger.kernel.org>; Sat, 28 Dec 2013 07:46:28 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 11/13] libdvbv5: fix double entry in Makefile.am
Date: Sat, 28 Dec 2013 16:45:59 +0100
Message-Id: <1388245561-8751-11-git-send-email-neolynx@gmail.com>
In-Reply-To: <1388245561-8751-1-git-send-email-neolynx@gmail.com>
References: <1388245561-8751-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/libdvbv5/Makefile.am | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
index 368baf8..dc5005f 100644
--- a/lib/libdvbv5/Makefile.am
+++ b/lib/libdvbv5/Makefile.am
@@ -47,7 +47,6 @@ libdvbv5_la_SOURCES = \
   descriptors/desc_partial_reception.c  ../include/descriptors/desc_partial_reception.h \
   descriptors/nit.c  ../include/descriptors/nit.h \
   descriptors/sdt.c  ../include/descriptors/sdt.h \
-  descriptors/vct.c  ../include/descriptors/vct.h \
   descriptors/atsc_header.c ../include/descriptors/atsc_header.h \
   descriptors/vct.c  ../include/descriptors/vct.h \
   descriptors/mgt.c  ../include/descriptors/mgt.h \
@@ -58,7 +57,7 @@ libdvbv5_la_SOURCES = \
   descriptors/mpeg_pes.c  ../include/descriptors/mpeg_pes.h \
   descriptors/mpeg_es.c  ../include/descriptors/mpeg_es.h
 
-libdvbv5_la_CPPFLAGS = $(ENFORCE_LIBDVBV5_STATIC)
+libdvbv5_la_CPPFLAGS = $(ENFORCE_LIBDVBV5_STATIC) -std=c99
 libdvbv5_la_LDFLAGS = $(LIBDVBV5_VERSION) $(ENFORCE_LIBDVBV5_STATIC) -lm
 libdvbv5_la_LIBADD = $(LTLIBICONV)
 
-- 
1.8.3.2

