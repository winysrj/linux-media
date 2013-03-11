Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2434 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab3CKLrH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:47:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 31/42] go7007: simplify the PX-TV402U board ID handling.
Date: Mon, 11 Mar 2013 12:46:09 +0100
Message-Id: <0127c90657a65243988d8b5fe8181729663bcc2f.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

There really is no need to split out the board IDs for each tuner.
That's what the tuner_type is for, after all.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/go7007/go7007-priv.h |   15 ++++++---------
 drivers/staging/media/go7007/go7007-usb.c  |    9 +++------
 drivers/staging/media/go7007/go7007-v4l2.c |    9 ---------
 3 files changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-priv.h b/drivers/staging/media/go7007/go7007-priv.h
index c2fafb2..a6ef67b 100644
--- a/drivers/staging/media/go7007/go7007-priv.h
+++ b/drivers/staging/media/go7007/go7007-priv.h
@@ -36,15 +36,12 @@ struct go7007;
 #define GO7007_BOARDID_XMEN_II		5
 #define GO7007_BOARDID_XMEN_III		6
 #define GO7007_BOARDID_MATRIX_REV	7
-#define GO7007_BOARDID_PX_M402U		16
-#define GO7007_BOARDID_PX_TV402U_ANY	17 /* need to check tuner model */
-#define GO7007_BOARDID_PX_TV402U_NA	18 /* detected NTSC tuner */
-#define GO7007_BOARDID_PX_TV402U_EU	19 /* detected PAL tuner */
-#define GO7007_BOARDID_PX_TV402U_JP	20 /* detected NTSC-J tuner */
-#define GO7007_BOARDID_LIFEVIEW_LR192	21 /* TV Walker Ultra */
-#define GO7007_BOARDID_ENDURA		22
-#define GO7007_BOARDID_ADLINK_MPG24	23
-#define GO7007_BOARDID_SENSORAY_2250	24 /* Sensoray 2250/2251 */
+#define GO7007_BOARDID_PX_M402U		8
+#define GO7007_BOARDID_PX_TV402U	9
+#define GO7007_BOARDID_LIFEVIEW_LR192	10 /* TV Walker Ultra */
+#define GO7007_BOARDID_ENDURA		11
+#define GO7007_BOARDID_ADLINK_MPG24	12
+#define GO7007_BOARDID_SENSORAY_2250	13 /* Sensoray 2250/2251 */
 
 /* Various characteristics of each board */
 #define GO7007_BOARD_HAS_AUDIO		(1<<0)
diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index 14d1cda..53c5b16 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -568,7 +568,7 @@ static const struct usb_device_id go7007_usb_id_table[] = {
 		.idProduct	= 0xa104,  /* Product ID of TV402U */
 		.bcdDevice_lo	= 0x1,
 		.bcdDevice_hi	= 0x1,
-		.driver_info	= (kernel_ulong_t)GO7007_BOARDID_PX_TV402U_ANY,
+		.driver_info	= (kernel_ulong_t)GO7007_BOARDID_PX_TV402U,
 	},
 	{
 		.match_flags	= USB_DEVICE_ID_MATCH_DEVICE_AND_VERSION,
@@ -1079,7 +1079,7 @@ static int go7007_usb_probe(struct usb_interface *intf,
 		name = "Plextor PX-M402U";
 		board = &board_matrix_ii;
 		break;
-	case GO7007_BOARDID_PX_TV402U_ANY:
+	case GO7007_BOARDID_PX_TV402U:
 		name = "Plextor PX-TV402U (unknown tuner)";
 		board = &board_px_tv402u;
 		break;
@@ -1200,7 +1200,7 @@ static int go7007_usb_probe(struct usb_interface *intf,
 	num_i2c_devs = go->board_info->num_i2c_devs;
 
 	/* Probe the tuner model on the TV402U */
-	if (go->board_id == GO7007_BOARDID_PX_TV402U_ANY) {
+	if (go->board_id == GO7007_BOARDID_PX_TV402U) {
 		/* Board strapping indicates tuner model */
 		if (go7007_usb_vendor_request(go, 0x41, 0, 0, go->usb_buf, 3, 1) < 0) {
 			printk(KERN_ERR "go7007-usb: GPIO read failed!\n");
@@ -1208,14 +1208,12 @@ static int go7007_usb_probe(struct usb_interface *intf,
 		}
 		switch (go->usb_buf[0] >> 6) {
 		case 1:
-			go->board_id = GO7007_BOARDID_PX_TV402U_EU;
 			go->tuner_type = TUNER_SONY_BTF_PG472Z;
 			go->std = V4L2_STD_PAL;
 			strncpy(go->name, "Plextor PX-TV402U-EU",
 					sizeof(go->name));
 			break;
 		case 2:
-			go->board_id = GO7007_BOARDID_PX_TV402U_JP;
 			go->tuner_type = TUNER_SONY_BTF_PK467Z;
 			go->std = V4L2_STD_NTSC_M_JP;
 			num_i2c_devs -= 2;
@@ -1223,7 +1221,6 @@ static int go7007_usb_probe(struct usb_interface *intf,
 					sizeof(go->name));
 			break;
 		case 3:
-			go->board_id = GO7007_BOARDID_PX_TV402U_NA;
 			go->tuner_type = TUNER_SONY_BTF_PB463Z;
 			num_i2c_devs -= 2;
 			strncpy(go->name, "Plextor PX-TV402U-NA",
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index df5296f..fd6cae0 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -1075,15 +1075,6 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 	if (t->index != 0)
 		return -EINVAL;
 
-	switch (go->board_id) {
-	case GO7007_BOARDID_PX_TV402U_NA:
-	case GO7007_BOARDID_PX_TV402U_JP:
-		/* No selectable options currently */
-		if (t->audmode != V4L2_TUNER_MODE_STEREO)
-			return -EINVAL;
-		break;
-	}
-
 	return call_all(&go->v4l2_dev, tuner, s_tuner, t);
 }
 
-- 
1.7.10.4

