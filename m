Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6FDskHi016125
	for <video4linux-list@redhat.com>; Tue, 15 Jul 2008 09:54:52 -0400
Received: from metis.extern.pengutronix.de (metis.extern.pengutronix.de
	[83.236.181.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6FDsJCG026343
	for <video4linux-list@redhat.com>; Tue, 15 Jul 2008 09:54:20 -0400
Date: Tue, 15 Jul 2008 16:00:08 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: video4linux-list@redhat.com
Message-ID: <20080715140008.GF6739@pengutronix.de>
References: <20080715135235.GD6739@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715135235.GD6739@pengutronix.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: PATCH: soc-camera: Support multiple camera chips per host
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

Excuse me for sending -p0 patches. Here's an updated version:

soc-camera already supports more than one camera chip per host
which can be used exclusively. This patch adds a hook for the
board code to switch between different cameras.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

---
 drivers/media/video/mt9m001.c    |    4 ++--
 drivers/media/video/mt9v022.c    |    4 ++--
 drivers/media/video/soc_camera.c |   20 ++++++++++++++++----
 include/media/soc_camera.h       |    7 ++++++-
 4 files changed, 26 insertions(+), 9 deletions(-)

Index: linux-2.6/drivers/media/video/soc_camera.c
===================================================================
--- linux-2.6.orig/drivers/media/video/soc_camera.c
+++ linux-2.6/drivers/media/video/soc_camera.c
@@ -218,6 +218,9 @@ static int soc_camera_open(struct inode 
 
 	icd->use_count++;
 
+	if (icd->link->activate)
+		icd->link->activate(icd->link, 1);
+
 	/* Now we really have to activate the camera */
 	if (icd->use_count == 1) {
 		ret = ici->ops->add(icd);
@@ -269,6 +272,8 @@ static int soc_camera_close(struct inode
 	icd->use_count--;
 	if (!icd->use_count)
 		ici->ops->remove(icd);
+	if (icd->link->activate)
+		icd->link->activate(icd->link, 0);
 	icf->lock = NULL;
 	if (ici->ops->spinlock_free)
 		ici->ops->spinlock_free(lock);
@@ -670,7 +675,7 @@ static void scan_add_host(struct soc_cam
 	mutex_lock(&list_lock);
 
 	list_for_each_entry(icd, &devices, list) {
-		if (icd->iface == ici->nr) {
+		if (icd->link->bus_id == ici->nr) {
 			icd->dev.parent = &ici->dev;
 			device_register_link(icd);
 		}
@@ -693,7 +698,7 @@ static int scan_add_device(struct soc_ca
 	/* Watch out for class_for_each_device / class_find_device API by
 	 * Dave Young <hidave.darkstar@gmail.com> */
 	list_for_each_entry(ici, &hosts, list) {
-		if (icd->iface == ici->nr) {
+		if (icd->link->bus_id == ici->nr) {
 			ret = 1;
 			icd->dev.parent = &ici->dev;
 			break;
@@ -718,6 +723,9 @@ static int soc_camera_probe(struct devic
 	if (!icd->ops->probe)
 		return -ENODEV;
 
+	if (icd->link->activate)
+		icd->link->activate(icd->link, 1);
+
 	/* We only call ->add() here to activate and probe the camera.
 	 * We shall ->remove() and deactivate it immediately afterwards. */
 	ret = ici->ops->add(icd);
@@ -736,6 +744,9 @@ static int soc_camera_probe(struct devic
 	}
 	ici->ops->remove(icd);
 
+	if (icd->link->activate)
+		icd->link->activate(icd->link, 0);
+
 	return ret;
 }
 
@@ -866,7 +877,8 @@ int soc_camera_device_register(struct so
 	for (i = 0; i < 256 && num < 0; i++) {
 		num = i;
 		list_for_each_entry(ix, &devices, list) {
-			if (ix->iface == icd->iface && ix->devnum == i) {
+			if (ix->link->bus_id == icd->link->bus_id &&
+					ix->devnum == i) {
 				num = -1;
 				break;
 			}
@@ -881,7 +893,7 @@ int soc_camera_device_register(struct so
 	icd->devnum = num;
 	icd->dev.bus = &soc_camera_bus_type;
 	snprintf(icd->dev.bus_id, sizeof(icd->dev.bus_id),
-		 "%u-%u", icd->iface, icd->devnum);
+		 "%u-%u", icd->link->bus_id, icd->devnum);
 
 	icd->dev.release = dummy_release;
 
Index: linux-2.6/include/media/soc_camera.h
===================================================================
--- linux-2.6.orig/include/media/soc_camera.h
+++ linux-2.6/include/media/soc_camera.h
@@ -15,6 +15,8 @@
 #include <linux/videodev2.h>
 #include <media/videobuf-dma-sg.h>
 
+struct soc_camera_link;
+
 struct soc_camera_device {
 	struct list_head list;
 	struct device dev;
@@ -32,7 +34,7 @@ struct soc_camera_device {
 	unsigned short y_skip_top;	/* Lines to skip at the top */
 	unsigned short gain;
 	unsigned short exposure;
-	unsigned char iface;		/* Host number */
+	struct soc_camera_link *link;	/* Link to this camera */
 	unsigned char devnum;		/* Device number per host */
 	unsigned char buswidth;		/* See comment in .c */
 	struct soc_camera_ops *ops;
@@ -83,6 +85,9 @@ struct soc_camera_link {
 	int bus_id;
 	/* GPIO number to switch between 8 and 10 bit modes */
 	unsigned int gpio;
+	/* (de-)activate this camera. Can be left empty if only one camera is
+	 * connected to this bus. */
+	void (*activate)(struct soc_camera_link *, int);
 };
 
 static inline struct soc_camera_device *to_soc_camera_dev(struct device *dev)
Index: linux-2.6/drivers/media/video/mt9m001.c
===================================================================
--- linux-2.6.orig/drivers/media/video/mt9m001.c
+++ linux-2.6/drivers/media/video/mt9m001.c
@@ -557,7 +557,7 @@ static int mt9m001_video_probe(struct so
 	/* We must have a parent by now. And it cannot be a wrong one.
 	 * So this entire test is completely redundant. */
 	if (!icd->dev.parent ||
-	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)
+	    to_soc_camera_host(icd->dev.parent)->nr != icd->link->bus_id)
 		return -ENODEV;
 
 	/* Enable the chip */
@@ -657,7 +657,7 @@ static int mt9m001_probe(struct i2c_clie
 	icd->height_min	= 32;
 	icd->height_max	= 1024;
 	icd->y_skip_top	= 1;
-	icd->iface	= icl->bus_id;
+	icd->link	= icl;
 	/* Default datawidth - this is the only width this camera (normally)
 	 * supports. It is only with extra logic that it can support
 	 * other widths. Therefore it seems to be a sensible default. */
Index: linux-2.6/drivers/media/video/mt9v022.c
===================================================================
--- linux-2.6.orig/drivers/media/video/mt9v022.c
+++ linux-2.6/drivers/media/video/mt9v022.c
@@ -672,7 +672,7 @@ static int mt9v022_video_probe(struct so
 	int ret;
 
 	if (!icd->dev.parent ||
-	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)
+	    to_soc_camera_host(icd->dev.parent)->nr != icd->link->bus_id)
 		return -ENODEV;
 
 	/* Read out the chip version register */
@@ -782,7 +782,7 @@ static int mt9v022_probe(struct i2c_clie
 	icd->height_min	= 32;
 	icd->height_max	= 480;
 	icd->y_skip_top	= 1;
-	icd->iface	= icl->bus_id;
+	icd->link	= icl;
 	/* Default datawidth - this is the only width this camera (normally)
 	 * supports. It is only with extra logic that it can support
 	 * other widths. Therefore it seems to be a sensible default. */

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
