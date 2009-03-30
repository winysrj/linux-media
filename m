Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41005 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754977AbZC3IsN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 04:48:13 -0400
Date: Mon, 30 Mar 2009 10:48:10 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH] soc-camera: fix breakage caused by 1fa5ae857bb14f6046205171d98506d8112dd74e
Message-ID: <Pine.LNX.4.64.0903301044130.4455@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

soc-camera re-uses struct devices multiple times in calls to device_register(),
therefore it has to reset the embedded struct kobject to avoid the "tried to
init an initialized object" error, which then also erases its name. Now with
the transition to kobject's name for device names, we have to re-initialise the
name before each call to device_register().

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Kay, is this an acceptable fix? Or should I rather replace 

	memset(&icd->dev.kobj, 0, sizeof(icd->dev.kobj));

with just some variant of

	kobj->state_initialized = 0;

?

 drivers/media/video/soc_camera.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 6d8bfd4..0e890cc 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -764,7 +764,10 @@ static int soc_camera_s_register(struct file *file, void *fh,
 
 static int device_register_link(struct soc_camera_device *icd)
 {
-	int ret = device_register(&icd->dev);
+	int ret = dev_set_name(&icd->dev, "%u-%u", icd->iface, icd->devnum);
+
+	if (!ret)
+		ret = device_register(&icd->dev);
 
 	if (ret < 0) {
 		/* Prevent calling device_unregister() */
@@ -1060,7 +1063,6 @@ int soc_camera_device_register(struct soc_camera_device *icd)
 
 	icd->devnum = num;
 	icd->dev.bus = &soc_camera_bus_type;
-	dev_set_name(&icd->dev, "%u-%u", icd->iface, icd->devnum);
 
 	icd->dev.release	= dummy_release;
 	icd->use_count		= 0;
-- 
1.5.4

