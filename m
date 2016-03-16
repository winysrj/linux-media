Return-path: <linux-media-owner@vger.kernel.org>
Received: from [198.137.202.9] ([198.137.202.9]:59717 "EHLO
	bombadil.infradead.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755288AbcCPNBc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2016 09:01:32 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	alsa-devel@alsa-project.org
Subject: [PATCH 1/2] sound/usb/media: use core routine to initialize media_device
Date: Wed, 16 Mar 2016 10:00:37 -0300
Message-Id: <907cfedffb3524aeffcdfde0efe3f23f2eb70dd1.1458133227.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The media core has now a routine to initialize media_device
for USB devices. Use it, instead of doing its own logic,
as it warrants that all USB drivers will behave the same. It
also warrants that the device will get the same data, no matter
if it was initialized initially via snd-usb-audio or via
some other driver, like au0828.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 sound/usb/media.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/sound/usb/media.c b/sound/usb/media.c
index 93a50d01490c..44a5de91f748 100644
--- a/sound/usb/media.c
+++ b/sound/usb/media.c
@@ -263,19 +263,11 @@ int media_snd_device_create(struct snd_usb_audio *chip,
 	mdev = media_device_get_devres(&usbdev->dev);
 	if (!mdev)
 		return -ENOMEM;
-	if (!mdev->dev) {
-		/* register media device */
-		mdev->dev = &usbdev->dev;
-		if (usbdev->product)
-			strlcpy(mdev->model, usbdev->product,
-				sizeof(mdev->model));
-		if (usbdev->serial)
-			strlcpy(mdev->serial, usbdev->serial,
-				sizeof(mdev->serial));
-		strcpy(mdev->bus_info, usbdev->devpath);
-		mdev->hw_revision = le16_to_cpu(usbdev->descriptor.bcdDevice);
-		media_device_init(mdev);
-	}
+
+	/* Initialize media device */
+	if (!mdev->dev)
+		media_device_usb_init(mdev, usbdev, NULL);
+
 	if (!media_devnode_is_registered(&mdev->devnode)) {
 		ret = media_device_register(mdev);
 		if (ret) {
-- 
2.5.0

