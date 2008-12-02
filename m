Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB212Vhe002104
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 20:02:31 -0500
Received: from mail02.idc.renesas.com (mail.renesas.com [202.234.163.13])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB212J3H000404
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 20:02:20 -0500
Date: Tue, 02 Dec 2008 09:34:14 +0900
From: Kuninori Morimoto <morimoto.kuninori@renesas.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-id: <uvdu38k4n.wl%morimoto.kuninori@renesas.com>
MIME-version: 1.0 (generated by SEMI 1.14.6 - "Maruoka")
Content-type: text/plain; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: [PATCH 2/2] Change device ID selection method on ov772x driver
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
this patch came from "Change device ID selection method on ov772x driver" yesterday

 drivers/media/video/ov772x.c    |   27 +++++++++++++++++++++------
 include/media/v4l2-chip-ident.h |    2 +-
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index 2b8d72d..f417df1 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -346,6 +346,12 @@
 #define OP_SWAP_RGB 0x00000002
 
 /*
+ * ID
+ */
+#define OV7720  0x7720
+#define VERSION(pid, ver) ((pid<<8)|(ver&0xFF))
+
+/*
  * struct
  */
 struct regval_list {
@@ -374,6 +380,7 @@ struct ov772x_priv {
 	struct soc_camera_device          icd;
 	const struct ov772x_color_format *fmt;
 	const struct ov772x_win_size     *win;
+	int                               model;
 };
 
 #define ENDMARKER { 0xff, 0xff }
@@ -702,7 +709,9 @@ static unsigned long ov772x_query_bus_param(struct soc_camera_device *icd)
 static int ov772x_get_chip_id(struct soc_camera_device *icd,
 			      struct v4l2_chip_ident   *id)
 {
-	id->ident    = V4L2_IDENT_OV772X;
+	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
+
+	id->ident    = priv->model;
 	id->revision = 0;
 
 	return 0;
@@ -796,6 +805,7 @@ static int ov772x_video_probe(struct soc_camera_device *icd)
 {
 	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
 	u8                  pid, ver;
+	const char         *devname;
 
 	/*
 	 * We must have a parent by now. And it cannot be a wrong one.
@@ -822,15 +832,21 @@ static int ov772x_video_probe(struct soc_camera_device *icd)
 	 */
 	pid = i2c_smbus_read_byte_data(priv->client, PID);
 	ver = i2c_smbus_read_byte_data(priv->client, VER);
-	if (pid != 0x77 ||
-	    ver != 0x21) {
+
+	switch (VERSION(pid, ver)) {
+	case OV7720:
+		devname     = "ov7720";
+		priv->model = V4L2_IDENT_OV7720;
+		break;
+	default:
 		dev_err(&icd->dev,
 			"Product ID error %x:%x\n", pid, ver);
 		return -ENODEV;
 	}
 
 	dev_info(&icd->dev,
-		 "ov772x Product ID %0x:%0x Manufacturer ID %x:%x\n",
+		 "%s Product ID %0x:%0x Manufacturer ID %x:%x\n",
+		 devname,
 		 pid,
 		 ver,
 		 i2c_smbus_read_byte_data(priv->client, MIDH),
@@ -921,7 +937,7 @@ static int ov772x_remove(struct i2c_client *client)
 }
 
 static const struct i2c_device_id ov772x_id[] = {
-	{"ov772x", 0},
+	{ "ov772x", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, ov772x_id);
@@ -941,7 +957,6 @@ static struct i2c_driver ov772x_i2c_driver = {
 
 static int __init ov772x_module_init(void)
 {
-	printk(KERN_INFO "ov772x driver\n");
 	return i2c_add_driver(&ov772x_i2c_driver);
 }
 
diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
index bfe5142..456ac0d 100644
--- a/include/media/v4l2-chip-ident.h
+++ b/include/media/v4l2-chip-ident.h
@@ -60,7 +60,7 @@ enum {
 
 	/* OmniVision sensors: reserved range 250-299 */
 	V4L2_IDENT_OV7670 = 250,
-	V4L2_IDENT_OV772X = 251,
+	V4L2_IDENT_OV7720 = 251,
 
 	/* Conexant MPEG encoder/decoders: reserved range 410-420 */
 	V4L2_IDENT_CX23415 = 415,
-- 
1.5.6.3

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
