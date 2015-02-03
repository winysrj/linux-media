Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:59626 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965900AbbBCSDo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2015 13:03:44 -0500
Message-ID: <54D10D79.4020409@users.sourceforge.net>
Date: Tue, 03 Feb 2015 19:03:37 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] [media] au0828: Delete unnecessary checks before the function
 call "video_unregister_device"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 3 Feb 2015 19:00:25 +0100

The video_unregister_device() function tests whether its argument is NULL
and then returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/au0828/au0828-video.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 5f337b1..e593fb5 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -870,12 +870,8 @@ void au0828_analog_unregister(struct au0828_dev *dev)
 {
 	dprintk(1, "au0828_release_resources called\n");
 	mutex_lock(&au0828_sysfs_lock);
-
-	if (dev->vdev)
-		video_unregister_device(dev->vdev);
-	if (dev->vbi_dev)
-		video_unregister_device(dev->vbi_dev);
-
+	video_unregister_device(dev->vdev);
+	video_unregister_device(dev->vbi_dev);
 	mutex_unlock(&au0828_sysfs_lock);
 }
 
-- 
2.2.2

