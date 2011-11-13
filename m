Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:35080 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab1KMPKO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Nov 2011 10:10:14 -0500
Date: Sun, 13 Nov 2011 18:09:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] pwc: unlock on error in pwc_ioctl()
Message-ID: <20111113150946.GA10072@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In 82dfdada40 "pwc: rework locking" we changed the locking so that
we handle it ourselves instead of doing it at the vl42 layer.  There
were a couple ioctls, VIDIOCPWCSLED and VIDIOCPWCGLED, where we
didn't unlock on the error path.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/video/pwc/pwc-ctrl.c b/drivers/media/video/pwc/pwc-ctrl.c
index ad77b23..ea17230 100644
--- a/drivers/media/video/pwc/pwc-ctrl.c
+++ b/drivers/media/video/pwc/pwc-ctrl.c
@@ -840,13 +840,15 @@ long pwc_ioctl(struct pwc_device *pdev, unsigned int cmd, void *arg)
 
 		mutex_lock(&pdev->udevlock);
 		if (!pdev->udev) {
+			mutex_unlock(&pdev->udevlock);
 			ret = -ENODEV;
-			goto leave;
+			break;
 		}
 
 		if (pdev->iso_init) {
+			mutex_unlock(&pdev->udevlock);
 			ret = -EBUSY;
-			goto leave;
+			break;
 		}
 
 		ARG_IN(qual)
@@ -854,7 +856,6 @@ long pwc_ioctl(struct pwc_device *pdev, unsigned int cmd, void *arg)
 			ret = -EINVAL;
 		else
 			ret = pwc_set_video_mode(pdev, pdev->view.x, pdev->view.y, pdev->vframes, ARGR(qual), pdev->vsnapshot);
-leave:
 		mutex_unlock(&pdev->udevlock);
 		break;
 	}
@@ -978,6 +979,7 @@ leave:
 
 		mutex_lock(&pdev->udevlock);
 		if (!pdev->udev) {
+			mutex_unlock(&pdev->udevlock);
 			ret = -ENODEV;
 			break;
 		}
@@ -996,6 +998,7 @@ leave:
 
 		mutex_lock(&pdev->udevlock);
 		if (!pdev->udev) {
+			mutex_unlock(&pdev->udevlock);
 			ret = -ENODEV;
 			break;
 		}
