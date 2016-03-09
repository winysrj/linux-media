Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:53511 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933047AbcCIQDb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Mar 2016 11:03:31 -0500
From: Antonio Ospite <ao2@ao2.it>
To: Linux Media <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, Antonio Ospite <ao2@ao2.it>
Subject: [PATCH 1/7] [media] gspca: ov534/topro: use a define for the default framerate
Date: Wed,  9 Mar 2016 17:03:15 +0100
Message-Id: <1457539401-11515-2-git-send-email-ao2@ao2.it>
In-Reply-To: <1457539401-11515-1-git-send-email-ao2@ao2.it>
References: <1457539401-11515-1-git-send-email-ao2@ao2.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When writing the change in commit dcc7fdbec53a ("[media] gspca:
ov534/topro: prevent a division by 0") I used magic numbers for the
default framerate to minimize the code footprint to make it easier to
backport the patch to the stable trees.

However it's better if the default framerate has its own define to avoid
risking using different values in different places, and for readability.

While at it also remove some trivial comments about the framerates which
don't add much to the code anymore.

Signed-off-by: Antonio Ospite <ao2@ao2.it>
---
 drivers/media/usb/gspca/ov534.c | 7 +++----
 drivers/media/usb/gspca/topro.c | 6 ++++--
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/gspca/ov534.c b/drivers/media/usb/gspca/ov534.c
index bfff1d1..9266a5c 100644
--- a/drivers/media/usb/gspca/ov534.c
+++ b/drivers/media/usb/gspca/ov534.c
@@ -51,6 +51,7 @@
 #define OV534_OP_READ_2		0xf9
 
 #define CTRL_TIMEOUT 500
+#define DEFAULT_FRAME_RATE 30
 
 MODULE_AUTHOR("Antonio Ospite <ospite@studenti.unina.it>");
 MODULE_DESCRIPTION("GSPCA/OV534 USB Camera Driver");
@@ -1061,7 +1062,7 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	cam->cam_mode = ov772x_mode;
 	cam->nmodes = ARRAY_SIZE(ov772x_mode);
 
-	sd->frame_rate = 30;
+	sd->frame_rate = DEFAULT_FRAME_RATE;
 
 	return 0;
 }
@@ -1492,10 +1493,8 @@ static void sd_set_streamparm(struct gspca_dev *gspca_dev,
 	struct sd *sd = (struct sd *) gspca_dev;
 
 	if (tpf->numerator == 0 || tpf->denominator == 0)
-		/* Set default framerate */
-		sd->frame_rate = 30;
+		sd->frame_rate = DEFAULT_FRAME_RATE;
 	else
-		/* Set requested framerate */
 		sd->frame_rate = tpf->denominator / tpf->numerator;
 
 	if (gspca_dev->streaming)
diff --git a/drivers/media/usb/gspca/topro.c b/drivers/media/usb/gspca/topro.c
index c028a5c..15eb069 100644
--- a/drivers/media/usb/gspca/topro.c
+++ b/drivers/media/usb/gspca/topro.c
@@ -175,6 +175,8 @@ static const u8 jpeg_q[17] = {
 #error "USB buffer too small"
 #endif
 
+#define DEFAULT_FRAME_RATE 30
+
 static const u8 rates[] = {30, 20, 15, 10, 7, 5};
 static const struct framerates framerates[] = {
 	{
@@ -4020,7 +4022,7 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	gspca_dev->cam.mode_framerates = sd->bridge == BRIDGE_TP6800 ?
 			framerates : framerates_6810;
 
-	sd->framerate = 30;		/* default: 30 fps */
+	sd->framerate = DEFAULT_FRAME_RATE;
 	return 0;
 }
 
@@ -4803,7 +4805,7 @@ static void sd_set_streamparm(struct gspca_dev *gspca_dev,
 	int fr, i;
 
 	if (tpf->numerator == 0 || tpf->denominator == 0)
-		sd->framerate = 30;
+		sd->framerate = DEFAULT_FRAME_RATE;
 	else
 		sd->framerate = tpf->denominator / tpf->numerator;
 
-- 
2.7.0

