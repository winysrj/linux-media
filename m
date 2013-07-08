Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:52831 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab3GHAXL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Jul 2013 20:23:11 -0400
Received: by mail-ee0-f44.google.com with SMTP id c13so2461721eek.17
        for <linux-media@vger.kernel.org>; Sun, 07 Jul 2013 17:23:10 -0700 (PDT)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-media@vger.kernel.org
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 3/3] ene_ir: don't use pr_debug after all
Date: Mon,  8 Jul 2013 03:22:47 +0300
Message-Id: <1373242968-16055-4-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1373242968-16055-1-git-send-email-maximlevitsky@gmail.com>
References: <1373242968-16055-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This way to only way to get debug info is to use dynamic debug, but I left debugging
prints to debug hardware issues, and so I want this to be enabled by module param

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/media/rc/ene_ir.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/ene_ir.h b/drivers/media/rc/ene_ir.h
index 6f978e8..a7911e3 100644
--- a/drivers/media/rc/ene_ir.h
+++ b/drivers/media/rc/ene_ir.h
@@ -185,7 +185,7 @@
 #define __dbg(level, format, ...)				\
 do {								\
 	if (debug >= level)					\
-		pr_debug(format "\n", ## __VA_ARGS__);		\
+		pr_info(format "\n", ## __VA_ARGS__);		\
 } while (0)
 
 #define dbg(format, ...)		__dbg(1, format, ## __VA_ARGS__)
-- 
1.7.9.5

