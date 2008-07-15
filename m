Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6FDlM7B010097
	for <video4linux-list@redhat.com>; Tue, 15 Jul 2008 09:47:22 -0400
Received: from metis.extern.pengutronix.de (metis.extern.pengutronix.de
	[83.236.181.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6FDklii020929
	for <video4linux-list@redhat.com>; Tue, 15 Jul 2008 09:47:08 -0400
Date: Tue, 15 Jul 2008 15:52:35 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: video4linux-list@redhat.com
Message-ID: <20080715135235.GD6739@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: PATCH: soc-camera: Support multiple camera chips per host
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

Hi,

soc-camera already supports more than one camera chip per host
which can be used exclusively. This patch adds a hook for the
board code to switch between different cameras.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

---
 drivers/media/video/soc_camera.c |   20 ++++++++++++++++----
 include/media/soc_camera.h       |    7 ++++++-
 2 files changed, 22 insertions(+), 5 deletions(-)

Index: drivers/media/video/soc_camera.c
===================================================================
--- drivers/media/video/soc_camera.c.orig
+++ drivers/media/video/soc_camera.c
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
 
Index: include/media/soc_camera.h
===================================================================
--- include/media/soc_camera.h.orig
+++ include/media/soc_camera.h
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


-- 
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
