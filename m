Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6FDu3wL017635
	for <video4linux-list@redhat.com>; Tue, 15 Jul 2008 09:56:03 -0400
Received: from metis.extern.pengutronix.de (metis.extern.pengutronix.de
	[83.236.181.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6FDtqK2027771
	for <video4linux-list@redhat.com>; Tue, 15 Jul 2008 09:55:52 -0400
Received: from kiwi.ptxnet.pengutronix.de ([10.1.0.84])
	by metis.extern.pengutronix.de with esmtp (Exim 4.63)
	(envelope-from <sha@pengutronix.de>) id 1KIl0M-000141-Tx
	for video4linux-list@redhat.com; Tue, 15 Jul 2008 15:55:46 +0200
Received: from sha by kiwi.ptxnet.pengutronix.de with local (Exim 4.69)
	(envelope-from <sha@pengutronix.de>) id 1KIl65-0002W2-Bc
	for video4linux-list@redhat.com; Tue, 15 Jul 2008 16:01:41 +0200
Date: Tue, 15 Jul 2008 16:01:41 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: video4linux-list@redhat.com
Message-ID: <20080715140141.GG6739@pengutronix.de>
References: <20080715135618.GE6739@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715135618.GE6739@pengutronix.de>
Subject: Re: PATCH: soc-camera: use flag for colour / bw camera instead of
	module parameter
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


Also in -p1 fashion:


Use a flag in struct soc_camera_link for differentiation between
a black/white and a colour camera rather than a module parameter.
This allows for having colour and black/white cameras in the same
system.
Note that this one breaks the phytec pcm027 pxa board as it makes it
impossible to switch between cameras on the command line. I will send
an updated version of this patch once I know this patch is acceptable
this way.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

---
 drivers/media/video/mt9v022.c |    7 +------
 include/media/soc_camera.h    |    8 ++++++++
 2 files changed, 9 insertions(+), 6 deletions(-)

Index: linux-2.6/include/media/soc_camera.h
===================================================================
--- linux-2.6.orig/include/media/soc_camera.h
+++ linux-2.6/include/media/soc_camera.h
@@ -80,6 +80,12 @@ struct soc_camera_host_ops {
 	void (*spinlock_free)(spinlock_t *);
 };
 
+/* There are several cameras out there which come in a black/white
+ * and a colour variant. They are logically the same cameras and thus
+ * can't be detected in software
+ */
+#define SOCAM_LINK_COLOUR	(1 << 0)
+
 struct soc_camera_link {
 	/* Camera bus id, used to match a camera and a bus */
 	int bus_id;
@@ -88,6 +94,8 @@ struct soc_camera_link {
 	/* (de-)activate this camera. Can be left empty if only one camera is
 	 * connected to this bus. */
 	void (*activate)(struct soc_camera_link *, int);
+
+	unsigned long flags;
 };
 
 static inline struct soc_camera_device *to_soc_camera_dev(struct device *dev)
Index: linux-2.6/drivers/media/video/mt9v022.c
===================================================================
--- linux-2.6.orig/drivers/media/video/mt9v022.c
+++ linux-2.6/drivers/media/video/mt9v022.c
@@ -23,10 +23,6 @@
  * The platform has to define i2c_board_info
  * and call i2c_register_board_info() */
 
-static char *sensor_type;
-module_param(sensor_type, charp, S_IRUGO);
-MODULE_PARM_DESC(sensor_type, "Sensor type: \"colour\" or \"monochrome\"\n");
-
 /* mt9v022 selected register addresses */
 #define MT9V022_CHIP_VERSION		0x00
 #define MT9V022_COLUMN_START		0x01
@@ -698,8 +694,7 @@ static int mt9v022_video_probe(struct so
 	}
 
 	/* Set monochrome or colour sensor type */
-	if (sensor_type && (!strcmp("colour", sensor_type) ||
-			    !strcmp("color", sensor_type))) {
+	if (icd->link->flags & SOCAM_LINK_COLOUR) {
 		ret = reg_write(icd, MT9V022_PIXEL_OPERATION_MODE, 4 | 0x11);
 		mt9v022->model = V4L2_IDENT_MT9V022IX7ATC;
 		icd->formats = mt9v022_colour_formats;

-- 
-- 
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
