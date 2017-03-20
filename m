Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:8587 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753714AbdCTOqD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 10:46:03 -0400
Subject: [PATCH 24/24] staging: atomisp: simplify if statement in
 atomisp_get_sensor_fps()
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 20 Mar 2017 14:42:55 +0000
Message-ID: <149002096919.17109.8984650938425885621.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
References: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daeseok Youn <daeseok.youn@gmail.com>

If v4l2_subdev_call() gets the global frame interval values,
it returned 0 and it could be checked whether numerator is zero or not.

If the numerator is not zero, the fps could be calculated in this function.
If not, it just returns 0.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       |   22 +++++++++-----------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index 0a2df3d..9d44a1d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -153,20 +153,18 @@ struct atomisp_acc_pipe *atomisp_to_acc_pipe(struct video_device *dev)
 
 static unsigned short atomisp_get_sensor_fps(struct atomisp_sub_device *asd)
 {
-	struct v4l2_subdev_frame_interval frame_interval;
+	struct v4l2_subdev_frame_interval fi;
 	struct atomisp_device *isp = asd->isp;
-	unsigned short fps;
 
-	if (v4l2_subdev_call(isp->inputs[asd->input_curr].camera,
-	    video, g_frame_interval, &frame_interval)) {
-		fps = 0;
-	} else {
-		if (frame_interval.interval.numerator)
-			fps = frame_interval.interval.denominator /
-			    frame_interval.interval.numerator;
-		else
-			fps = 0;
-	}
+	unsigned short fps = 0;
+	int ret;
+
+	ret = v4l2_subdev_call(isp->inputs[asd->input_curr].camera,
+			       video, g_frame_interval, &fi);
+
+	if (!ret && fi.interval.numerator)
+		fps = fi.interval.denominator / fi.interval.numerator;
+
 	return fps;
 }
 
