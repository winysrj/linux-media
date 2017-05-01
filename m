Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:41444 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750725AbdEAQK3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 12:10:29 -0400
Subject: [PATCH 7/7] rc-core: tm6000 - leave the internals of rc_dev alone
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Mon, 01 May 2017 18:10:27 +0200
Message-ID: <149365502730.13489.14956537533540738118.stgit@zeus.hardeman.nu>
In-Reply-To: <149365487447.13489.15793446874818182829.stgit@zeus.hardeman.nu>
References: <149365487447.13489.15793446874818182829.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Not sure what the driver is trying to do, however, IR handling seems incomplete
ATM so deleting the offending parts shouldn't affect functionality

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/usb/tm6000/tm6000-input.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/usb/tm6000/tm6000-input.c b/drivers/media/usb/tm6000/tm6000-input.c
index 39c15bb2b20c..1a033f57fcc1 100644
--- a/drivers/media/usb/tm6000/tm6000-input.c
+++ b/drivers/media/usb/tm6000/tm6000-input.c
@@ -63,7 +63,6 @@ struct tm6000_IR {
 	u8			wait:1;
 	u8			pwled:2;
 	u8			submit_urb:1;
-	u16			key_addr;
 	struct urb		*int_urb;
 
 	/* IR device properties */
@@ -321,9 +320,6 @@ static int tm6000_ir_change_protocol(struct rc_dev *rc, u64 *rc_type)
 
 	dprintk(2, "%s\n",__func__);
 
-	if ((rc->rc_map.scan) && (*rc_type == RC_BIT_NEC))
-		ir->key_addr = ((rc->rc_map.scan[0].scancode >> 8) & 0xffff);
-
 	ir->rc_type = *rc_type;
 
 	tm6000_ir_config(ir);
