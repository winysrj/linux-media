Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:56936 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753163AbeB0Pk5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 10:40:57 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: mchehab@s-opensource.com, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, g.liakhovetski@gmx.de, bhumirks@gmail.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 07/13] media: tw9910: Sort includes alphabetically
Date: Tue, 27 Feb 2018 16:40:24 +0100
Message-Id: <1519746030-15407-8-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1519746030-15407-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1519746030-15407-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sort include directives alphabetically to ease maintenance.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/tw9910.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/tw9910.c b/drivers/media/i2c/tw9910.c
index f9b75c1..1043f7d 100644
--- a/drivers/media/i2c/tw9910.c
+++ b/drivers/media/i2c/tw9910.c
@@ -16,13 +16,13 @@
  */
 
 #include <linux/clk.h>
+#include <linux/delay.h>
 #include <linux/gpio/consumer.h>
+#include <linux/i2c.h>
 #include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/i2c.h>
 #include <linux/slab.h>
-#include <linux/kernel.h>
-#include <linux/delay.h>
 #include <linux/v4l2-mediabus.h>
 #include <linux/videodev2.h>
 
-- 
2.7.4
