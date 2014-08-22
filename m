Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:58702 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233AbaHVQp0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Aug 2014 12:45:26 -0400
Received: by mail-lb0-f173.google.com with SMTP id u10so9733397lbd.4
        for <linux-media@vger.kernel.org>; Fri, 22 Aug 2014 09:45:24 -0700 (PDT)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] drivers: media: i2c: adv7343_regs.h: Fix typo in #ifndef
Date: Fri, 22 Aug 2014 18:45:17 +0200
Message-Id: <1408725917-2842-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Test for definedness of the macro which is actually defined, and which
matches the name of the file.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/media/i2c/adv7343_regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7343_regs.h b/drivers/media/i2c/adv7343_regs.h
index 4466067..2f04ce4 100644
--- a/drivers/media/i2c/adv7343_regs.h
+++ b/drivers/media/i2c/adv7343_regs.h
@@ -13,7 +13,7 @@
  * GNU General Public License for more details.
  */
 
-#ifndef ADV7343_REG_H
+#ifndef ADV7343_REGS_H
 #define ADV7343_REGS_H
 
 struct adv7343_std_info {
-- 
2.0.4

