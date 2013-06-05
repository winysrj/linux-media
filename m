Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:60175 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753207Ab3FEJmw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Jun 2013 05:42:52 -0400
From: Wenbing Wang <wangwb@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: <linux-media@vger.kernel.org>, Wenbing Wang <wangwb@marvell.com>
Subject: [PATCH] [media] soc_camera: error dev remove and v4l2 call
Date: Wed, 5 Jun 2013 17:37:14 +0800
Message-ID: <1370425034-3648-1-git-send-email-wangwb@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wenbing Wang <wangwb@marvell.com>

in soc_camera_close(), if ici->ops->remove() removes device firstly,
and then call __soc_camera_power_off(), it has logic error. Since
if remove device, it should disable subdev clk. but in __soc_camera_
power_off(), it will callback v4l2 s_power function which will
read/write subdev registers to control power by i2c. and then
i2c read/write will fail because of clk disable.
So suggest to re-sequence two functions call.

Change-Id: Iee7a6d4fc7c7c1addb5d342621eb8dcd00fa2745
Signed-off-by: Wenbing Wang <wangwb@marvell.com>
---
 drivers/media/platform/soc_camera/soc_camera.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index eea832c..3a4efbd 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -643,9 +643,9 @@ static int soc_camera_close(struct file *file)
 
 		if (ici->ops->init_videobuf2)
 			vb2_queue_release(&icd->vb2_vidq);
-		ici->ops->remove(icd);
-
 		__soc_camera_power_off(icd);
+
+		ici->ops->remove(icd);
 	}
 
 	if (icd->streamer == file)
-- 
1.7.5.4

