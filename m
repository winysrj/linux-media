Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:54122 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932179Ab2JQPiX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 11:38:23 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Cc: =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH] [media] winbond-cir: do not rename input name
Date: Wed, 17 Oct 2012 16:38:21 +0100
Message-Id: <1350488301-10767-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"54fd321 [media] winbond: remove space from driver name" inadvertently
renamed the input device name.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/winbond-cir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index de48a79..ce3ffc5 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -184,7 +184,7 @@ enum wbcir_txstate {
 };
 
 /* Misc */
-#define WBCIR_NAME	"winbond-cir"
+#define WBCIR_NAME	"Winbond CIR"
 #define WBCIR_ID_FAMILY          0xF1 /* Family ID for the WPCD376I	*/
 #define	WBCIR_ID_CHIP            0x04 /* Chip ID for the WPCD376I	*/
 #define INVALID_SCANCODE   0x7FFFFFFF /* Invalid with all protos	*/
@@ -987,7 +987,7 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 	}
 
 	data->dev->driver_type = RC_DRIVER_IR_RAW;
-	data->dev->driver_name = WBCIR_NAME;
+	data->dev->driver_name = DRVNAME;
 	data->dev->input_name = WBCIR_NAME;
 	data->dev->input_phys = "wbcir/cir0";
 	data->dev->input_id.bustype = BUS_HOST;
-- 
1.7.11.7

