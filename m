Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-08v.sys.comcast.net ([96.114.154.167]:47707 "EHLO
	resqmta-po-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751914AbbJBWHo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Oct 2015 18:07:44 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	tiwai@suse.de, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, perex@perex.cz,
	dan.carpenter@oracle.com, tskd08@gmail.com, arnd@arndb.de,
	ruchandani.tina@gmail.com, corbet@lwn.net, k.kozlowski@samsung.com,
	chehabrafael@gmail.com, prabhakar.csengg@gmail.com,
	elfring@users.sourceforge.net, Julia.Lawall@lip6.fr,
	p.zabel@pengutronix.de, ricardo.ribalda@gmail.com,
	labbott@fedoraproject.org, chris.j.arges@canonical.com,
	pierre-louis.bossart@linux.intel.com, johan@oljud.se,
	wsa@the-dreams.de, jcragg@gmail.com, clemens@ladisch.de,
	daniel@zonque.org, gtmkramer@xs4all.nl, misterpib@gmail.com,
	takamichiho@gmail.com, pmatilai@laiskiainen.org,
	vladcatoi@gmail.com, damien@zamaudio.com, normalperson@yhbt.net,
	joe@oampo.co.uk, jussi@sonarnerd.net, calcprogrammer1@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH MC Next Gen 15/20] media: au0828 video change to use v4l_enable_media_tuner()
Date: Fri,  2 Oct 2015 16:07:27 -0600
Message-Id: <2c8b4a96ea5e03f4f9166da23ebc78dbef0813b5.1443822799.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1443822799.git.shuahkh@osg.samsung.com>
References: <cover.1443822799.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1443822799.git.shuahkh@osg.samsung.com>
References: <cover.1443822799.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

au0828 is changed to use v4l_enable_media_tuner() to check for
tuner availability from vidioc_g_tuner(), and au0828_v4l2_close(),
before changing tuner settings. If tuner isn't free, return busy
condition from vidioc_g_tuner() and in au0828_v4l2_close() tuner
is left untouched without powering down to save energy.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-video.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 062730d..6581f79 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1004,8 +1004,12 @@ static int au0828_v4l2_close(struct file *filp)
 		goto end;
 
 	if (dev->users == 1) {
-		/* Save some power by putting tuner to sleep */
-		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
+		/* Save some power by putting tuner to sleep, if it is free */
+		/* What happens when radio is using tuner?? */
+		ret = v4l_enable_media_tuner(vdev);
+		if (ret == 0)
+			v4l2_device_call_all(&dev->v4l2_dev, 0, core,
+					     s_power, 0);
 		dev->std_set_in_tuner_core = 0;
 
 		/* When close the device, set the usb intf0 into alt0 to free
@@ -1406,10 +1410,16 @@ static int vidioc_s_audio(struct file *file, void *priv, const struct v4l2_audio
 static int vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 {
 	struct au0828_dev *dev = video_drvdata(file);
+	struct video_device *vfd = video_devdata(file);
+	int ret;
 
 	if (t->index != 0)
 		return -EINVAL;
 
+	ret = v4l_enable_media_tuner(vfd);
+	if (ret)
+		return ret;
+
 	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
 		dev->std_set_in_tuner_core, dev->dev_state);
 
-- 
2.1.4

