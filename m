Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:36101 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbcBKXmX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2016 18:42:23 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de,
	hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com,
	tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com,
	corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com,
	stefanr@s5r6.in-berlin.de, inki.dae@samsung.com,
	jh1009.sung@samsung.com, elfring@users.sourceforge.net,
	prabhakar.csengg@gmail.com, sw0312.kim@samsung.com,
	p.zabel@pengutronix.de, ricardo.ribalda@gmail.com,
	labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com,
	ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com,
	dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org,
	gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk,
	linuxbugs@vittgam.net, johan@oljud.se, klock.android@gmail.com,
	nenggun.kim@samsung.com, j.anaszewski@samsung.com,
	geliangtang@163.com, albert@huitsing.nl,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH v3 15/22] media: au0828 handle media_init and media_register window
Date: Thu, 11 Feb 2016 16:41:31 -0700
Message-Id: <31acd1abfe83e778ad6e9baa5494ca48a167d95a.1455233155.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1455233150.git.shuahkh@osg.samsung.com>
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1455233150.git.shuahkh@osg.samsung.com>
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Media device initialization and registration
steps are split. There is a window between
media device init and media device register
during usb probe.

au0828 bridge driver and snd-usb-audio could
try to initialize the media device, if they
simply checked, whether the device has been
registered. They also need to check whether
the device has been initialized.

Change the au0828-core to check if media device
is already initialized during initialization step
and check if media device is already registered
during the registration step.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index a740bea..99f8022 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -228,7 +228,8 @@ static int au0828_media_device_init(struct au0828_dev *dev,
 	if (!mdev)
 		return -ENOMEM;
 
-	if (!media_devnode_is_registered(&mdev->devnode)) {
+	/* check if media device is already initialized */
+	if (!mdev->dev) {
 		mdev->dev = &udev->dev;
 
 		if (udev->product)
@@ -328,6 +329,27 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
 	return 0;
 }
 
+static int au0828_media_device_register(struct au0828_dev *dev,
+					struct usb_device *udev)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	int ret;
+
+	if (dev->media_dev &&
+		!media_devnode_is_registered(&dev->media_dev->devnode)) {
+
+		/* register media device */
+		ret = media_device_register(dev->media_dev);
+		if (ret) {
+			dev_err(&udev->dev,
+				"Media Device Register Error: %d\n", ret);
+			return ret;
+		}
+	}
+#endif
+	return 0;
+}
+
 static int au0828_usb_probe(struct usb_interface *interface,
 	const struct usb_device_id *id)
 {
@@ -455,7 +477,7 @@ static int au0828_usb_probe(struct usb_interface *interface,
 	}
 
 #ifdef CONFIG_MEDIA_CONTROLLER
-	retval = media_device_register(dev->media_dev);
+	retval = au0828_media_device_register(dev, usbdev);
 #endif
 
 done:
-- 
2.5.0

