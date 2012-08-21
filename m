Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60946 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab2HUS6n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 14:58:43 -0400
Received: by mail-bk0-f46.google.com with SMTP id j10so48011bkw.19
        for <linux-media@vger.kernel.org>; Tue, 21 Aug 2012 11:58:43 -0700 (PDT)
From: Gregor Jasny <gjasny@googlemail.com>
To: linux-media@vger.kernel.org
Cc: prabhakar.lad@ti.com, Gregor Jasny <gjasny@googlemail.com>
Subject: [PATCH] libdvbv5: Fix byte swapping for embedded toolchains
Date: Tue, 21 Aug 2012 20:58:22 +0200
Message-Id: <1345575502-3779-2-git-send-email-gjasny@googlemail.com>
In-Reply-To: <1345575502-3779-1-git-send-email-gjasny@googlemail.com>
References: <1345575502-3779-1-git-send-email-gjasny@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reported-by: "Lad, Prabhakar" <prabhakar.lad@ti.com>
Signed-off-by: Gregor Jasny <gjasny@googlemail.com>
---
 lib/include/descriptors.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/include/descriptors.h b/lib/include/descriptors.h
index 9039014..a64370c 100644
--- a/lib/include/descriptors.h
+++ b/lib/include/descriptors.h
@@ -25,7 +25,7 @@
 #ifndef _DESCRIPTORS_H
 #define _DESCRIPTORS_H
 
-#include <endian.h>
+#include <arpa/inet.h>
 #include <unistd.h>
 #include <stdint.h>
 
@@ -46,11 +46,11 @@ extern char *default_charset;
 extern char *output_charset;
 
 #define bswap16(b) do {\
-	b = be16toh(b); \
+	b = ntohs(b); \
 } while (0)
 
 #define bswap32(b) do {\
-	b = be32toh(b); \
+	b = ntohl(b); \
 } while (0)
 
 struct dvb_desc {
-- 
1.7.10.4

