Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAC1ACfB002236
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 20:10:12 -0500
Received: from mail04.idc.renesas.com (mail.renesas.com [202.234.163.13])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAC18vnU032240
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 20:08:57 -0500
Date: Wed, 12 Nov 2008 09:39:10 +0900
From: Kuninori Morimoto <morimoto.kuninori@renesas.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-id: <u7i79sqcd.wl%morimoto.kuninori@renesas.com>
MIME-version: 1.0 (generated by SEMI 1.14.6 - "Maruoka")
Content-type: text/plain; charset=US-ASCII
Cc: V4L <video4linux-list@redhat.com>, mchehab@infradead.org
Subject: [PATCH v2] Change power on/off sequence on ov772x
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
---
This patch is based on linux-next git

Patch v1 -> v2
having "if"

 drivers/media/video/ov772x.c |   35 ++++++++++++++++++++++-------------
 1 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index 0af2ca6..d3b54a4 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -593,12 +593,30 @@ static int ov772x_reset(struct i2c_client *client)
 
 static int ov772x_init(struct soc_camera_device *icd)
 {
-	return 0;
+	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
+	int ret = 0;
+
+	if (priv->info->link.power) {
+		ret = priv->info->link.power(&priv->client->dev, 1);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (priv->info->link.reset)
+		ret = priv->info->link.reset(&priv->client->dev);
+
+	return ret;
 }
 
 static int ov772x_release(struct soc_camera_device *icd)
 {
-	return 0;
+	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
+	int ret = 0;
+
+	if (priv->info->link.power)
+		ret = priv->info->link.power(&priv->client->dev, 0);
+
+	return ret;
 }
 
 static int ov772x_start_capture(struct soc_camera_device *icd)
@@ -814,9 +832,6 @@ static int ov772x_video_probe(struct soc_camera_device *icd)
 	icd->formats     = ov772x_fmt_lists;
 	icd->num_formats = ARRAY_SIZE(ov772x_fmt_lists);
 
-	if (priv->info->link.power)
-		priv->info->link.power(&priv->client->dev, 1);
-
 	/*
 	 * check and show product ID and manufacturer ID
 	 */
@@ -824,8 +839,8 @@ static int ov772x_video_probe(struct soc_camera_device *icd)
 	ver = i2c_smbus_read_byte_data(priv->client, VER);
 	if (pid != 0x77 ||
 	    ver != 0x21) {
-		if (priv->info->link.power)
-			priv->info->link.power(&priv->client->dev, 0);
+		dev_err(&icd->dev,
+			"Product ID error %x:%x\n", pid, ver);
 		return -ENODEV;
 	}
 
@@ -842,13 +857,7 @@ static int ov772x_video_probe(struct soc_camera_device *icd)
 
 static void ov772x_video_remove(struct soc_camera_device *icd)
 {
-	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
-
 	soc_camera_video_stop(icd);
-
-	if (priv->info->link.power)
-		priv->info->link.power(&priv->client->dev, 0);
-
 }
 
 static struct soc_camera_ops ov772x_ops = {
-- 
1.5.4.3

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
