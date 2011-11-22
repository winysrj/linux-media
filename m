Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:58955 "HELO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753189Ab1KVOFY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Nov 2011 09:05:24 -0500
From: Lei Wen <leiwen@marvell.com>
To: linux-media@vger.kernel.org, jqsu@marvell.com, qingx@marvell.com,
	fswu@marvell.com, twang13@marvell.com, ytang5@marvell.com,
	wwang27@marvell.com, wzhu10@marvell.com
Subject: [PATCH] [media] V4L: soc-camera: change order of removing device
Date: Tue, 22 Nov 2011 06:04:29 -0800
Message-Id: <1321970669-23423-1-git-send-email-leiwen@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As our general practice, we use stream off before we close
the video node. So that the drivers its stream off function
would be called before its remove function.

But for the case for ctrl+c, the program would be force closed.
We have no chance to call that vb2 stream off from user space,
but directly call the remove function in soc_camera.

In that common code of soc_camera:

                ici->ops->remove(icd);
                if (ici->ops->init_videobuf2)
                        vb2_queue_release(&icd->vb2_vidq);

It would first call the device remove function, then release vb2,
in which stream off function is called. Thus it create different
order for the driver.

This patch change the order to make driver see the same sequence
to make it happy.

Signed-off-by: Lei Wen <leiwen@marvell.com>
---
 drivers/media/video/soc_camera.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index b72580c..fdc6167 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -600,9 +600,9 @@ static int soc_camera_close(struct file *file)
 		pm_runtime_suspend(&icd->vdev->dev);
 		pm_runtime_disable(&icd->vdev->dev);
 
-		ici->ops->remove(icd);
 		if (ici->ops->init_videobuf2)
 			vb2_queue_release(&icd->vb2_vidq);
+		ici->ops->remove(icd);
 
 		soc_camera_power_off(icd, icl);
 	}
-- 
1.7.0.4

