Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:32769 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753732AbdCTLab (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 07:30:31 -0400
Received: by mail-pf0-f195.google.com with SMTP id p189so11350386pfp.0
        for <linux-media@vger.kernel.org>; Mon, 20 Mar 2017 04:30:06 -0700 (PDT)
Date: Mon, 20 Mar 2017 19:59:40 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, daeseok.youn@gmail.com,
        alan@linux.intel.com, singhalsimran0@gmail.com,
        dan.carpenter@oracle.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 2/4] staging: atomisp: simplify if statement in
 atomisp_get_sensor_fps()
Message-ID: <20170320105940.GA17472@SEL-JYOUN-D1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If v4l2_subdev_call() gets the global frame interval values,
it returned 0 and it could be checked whether numerator is zero or not.

If the numerator is not zero, the fps could be calculated in this function.
If not, it just returns 0.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index 8bdb224..6bdd19e 100644
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
 
-- 
1.9.1
