Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35487 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbcCFNve (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Mar 2016 08:51:34 -0500
Received: by mail-wm0-f67.google.com with SMTP id 1so6411700wmg.2
        for <linux-media@vger.kernel.org>; Sun, 06 Mar 2016 05:51:34 -0800 (PST)
Date: Sun, 6 Mar 2016 15:51:24 +0200
From: Ulrik de Muelenaere <ulrikdem@gmail.com>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>, Antonio Ospite <ao2@ao2.it>
Subject: [PATCH 2/2] [media] gspca_kinect: enable both video and depth streams
Message-ID: <378b4808198c9c64627a565c0a743d01880f5494.1457262292.git.ulrikdem@gmail.com>
References: <cover.1457262292.git.ulrikdem@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1457262292.git.ulrikdem@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Kinect produces both a video stream and a depth stream. Call
gspca_dev_probe() twice to create a video device node for each.

Remove the depth_mode parameter which had to be set at probe time in
order to select either the video or depth stream.

Signed-off-by: Ulrik de Muelenaere <ulrikdem@gmail.com>
---
 drivers/media/usb/gspca/kinect.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/gspca/kinect.c b/drivers/media/usb/gspca/kinect.c
index 3cb30a3..4bc5b7d 100644
--- a/drivers/media/usb/gspca/kinect.c
+++ b/drivers/media/usb/gspca/kinect.c
@@ -36,8 +36,6 @@ MODULE_AUTHOR("Antonio Ospite <ospite@studenti.unina.it>");
 MODULE_DESCRIPTION("GSPCA/Kinect Sensor Device USB Camera Driver");
 MODULE_LICENSE("GPL");
 
-static bool depth_mode;
-
 struct pkt_hdr {
 	uint8_t magic[2];
 	uint8_t pad;
@@ -424,7 +422,7 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev, u8 *__data, int len)
 
 /* sub-driver description */
 static const struct sd_desc sd_desc_video = {
-	.name      = MODULE_NAME,
+	.name      = MODULE_NAME "_video",
 	.config    = sd_config_video,
 	.init      = sd_init,
 	.start     = sd_start_video,
@@ -436,7 +434,7 @@ static const struct sd_desc sd_desc_video = {
 	*/
 };
 static const struct sd_desc sd_desc_depth = {
-	.name      = MODULE_NAME,
+	.name      = MODULE_NAME "_depth",
 	.config    = sd_config_depth,
 	.init      = sd_init,
 	.start     = sd_start_depth,
@@ -460,12 +458,19 @@ MODULE_DEVICE_TABLE(usb, device_table);
 /* -- device connect -- */
 static int sd_probe(struct usb_interface *intf, const struct usb_device_id *id)
 {
-	if (depth_mode)
-		return gspca_dev_probe(intf, id, &sd_desc_depth,
-				       sizeof(struct sd), THIS_MODULE);
-	else
-		return gspca_dev_probe(intf, id, &sd_desc_video,
-				       sizeof(struct sd), THIS_MODULE);
+	int res;
+
+	res = gspca_dev_probe(intf, id, &sd_desc_video, sizeof(struct sd),
+			      THIS_MODULE);
+	if (res < 0)
+		return res;
+
+	res = gspca_dev_probe(intf, id, &sd_desc_depth, sizeof(struct sd),
+			      THIS_MODULE);
+	if (res < 0)
+		gspca_disconnect(intf);
+
+	return res;
 }
 
 static struct usb_driver sd_driver = {
@@ -481,6 +486,3 @@ static struct usb_driver sd_driver = {
 };
 
 module_usb_driver(sd_driver);
-
-module_param(depth_mode, bool, 0644);
-MODULE_PARM_DESC(depth_mode, "0=video 1=depth");
-- 
2.7.0

