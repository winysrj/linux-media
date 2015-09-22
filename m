Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-05v.sys.comcast.net ([96.114.154.164]:46408 "EHLO
	resqmta-po-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758801AbbIVR2G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 13:28:06 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	tiwai@suse.de, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, perex@perex.cz,
	stefanr@s5r6.in-berlin.de, crope@iki.fi, dan.carpenter@oracle.com,
	tskd08@gmail.com, ruchandani.tina@gmail.com, arnd@arndb.de,
	chehabrafael@gmail.com, prabhakar.csengg@gmail.com,
	Julia.Lawall@lip6.fr, elfring@users.sourceforge.net,
	ricardo.ribalda@gmail.com, chris.j.arges@canonical.com,
	pierre-louis.bossart@linux.intel.com, gtmkramer@xs4all.nl,
	clemens@ladisch.de, misterpib@gmail.com, takamichiho@gmail.com,
	pmatilai@laiskiainen.org, damien@zamaudio.com, daniel@zonque.org,
	vladcatoi@gmail.com, normalperson@yhbt.net, joe@oampo.co.uk,
	bugzilla.frnkcg@spamgourmet.com, jussi@sonarnerd.net
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH v3 17/21] media: au0828 change to use Managed Media Controller API
Date: Tue, 22 Sep 2015 11:19:36 -0600
Message-Id: <09c9eecd550423ca02024c4901e88886e776b3d7.1442937669.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1442937669.git.shuahkh@osg.samsung.com>
References: <cover.1442937669.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1442937669.git.shuahkh@osg.samsung.com>
References: <cover.1442937669.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change au0828 to use Managed Media Controller API to coordinate
creating/deleting media device on parent usb device it shares
with the snd-usb-audio driver. With this change, au0828 uses
media_device_get_devres() to allocate a new media device devres
or return an existing one, if it finds one.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 45 +++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 0b8dc49..63e31e2 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -132,9 +132,9 @@ static void au0828_unregister_media_device(struct au0828_dev *dev)
 {
 
 #ifdef CONFIG_MEDIA_CONTROLLER
-	if (dev->media_dev) {
+	if (dev->media_dev &&
+	    media_devnode_is_registered(&dev->media_dev->devnode)) {
 		media_device_unregister(dev->media_dev);
-		kfree(dev->media_dev);
 		dev->media_dev = NULL;
 	}
 #endif
@@ -204,31 +204,30 @@ static void au0828_media_device_register(struct au0828_dev *dev,
 	struct media_device *mdev;
 	int ret;
 
-	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
+	mdev = media_device_get_devres(&udev->dev);
 	if (!mdev)
 		return;
 
-	mdev->dev = &udev->dev;
-
-	if (!dev->board.name)
-		strlcpy(mdev->model, "unknown au0828", sizeof(mdev->model));
-	else
-		strlcpy(mdev->model, dev->board.name, sizeof(mdev->model));
-	if (udev->serial)
-		strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
-	strcpy(mdev->bus_info, udev->devpath);
-	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
-	mdev->driver_version = LINUX_VERSION_CODE;
-
-	ret = media_device_register(mdev);
-	if (ret) {
-		pr_err(
-			"Couldn't create a media device. Error: %d\n",
-			ret);
-		kfree(mdev);
-		return;
+	if (!media_devnode_is_registered(&mdev->devnode)) {
+		/* register media device */
+		mdev->dev = &udev->dev;
+
+		if (udev->product)
+			strlcpy(mdev->model, udev->product,
+				sizeof(mdev->model));
+		if (udev->serial)
+			strlcpy(mdev->serial, udev->serial,
+				sizeof(mdev->serial));
+		strcpy(mdev->bus_info, udev->devpath);
+		mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
+		ret = media_device_register(mdev);
+		if (ret) {
+			dev_err(&udev->dev,
+				"Couldn't create a media device. Error: %d\n",
+				ret);
+			return;
+		}
 	}
-
 	dev->media_dev = mdev;
 #endif
 }
-- 
2.1.4

