Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:41436 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932968AbdEAQKY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 12:10:24 -0400
Subject: [PATCH 6/7] rc-core: cx231xx - leave the internals of rc_dev alone
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Mon, 01 May 2017 18:10:22 +0200
Message-ID: <149365502220.13489.11712034094657134184.stgit@zeus.hardeman.nu>
In-Reply-To: <149365487447.13489.15793446874818182829.stgit@zeus.hardeman.nu>
References: <149365487447.13489.15793446874818182829.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just some debug statements to change.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/usb/cx231xx/cx231xx-input.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-input.c b/drivers/media/usb/cx231xx/cx231xx-input.c
index 6e80f3c573f3..eecf074b0a48 100644
--- a/drivers/media/usb/cx231xx/cx231xx-input.c
+++ b/drivers/media/usb/cx231xx/cx231xx-input.c
@@ -30,7 +30,7 @@ static int get_key_isdbt(struct IR_i2c *ir, enum rc_type *protocol,
 	int	rc;
 	u8	cmd, scancode;
 
-	dev_dbg(&ir->rc->input_dev->dev, "%s\n", __func__);
+	dev_dbg(&ir->rc->dev, "%s\n", __func__);
 
 		/* poll IR chip */
 	rc = i2c_master_recv(ir->c, &cmd, 1);
@@ -48,8 +48,7 @@ static int get_key_isdbt(struct IR_i2c *ir, enum rc_type *protocol,
 
 	scancode = bitrev8(cmd);
 
-	dev_dbg(&ir->rc->input_dev->dev, "cmd %02x, scan = %02x\n",
-		cmd, scancode);
+	dev_dbg(&ir->rc->dev, "cmd %02x, scan = %02x\n", cmd, scancode);
 
 	*protocol = RC_TYPE_OTHER;
 	*pscancode = scancode;
