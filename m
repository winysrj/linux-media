Return-path: <mchehab@pedra>
Received: from mail-out.m-online.net ([212.18.0.10]:49614 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab1AaM5L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Jan 2011 07:57:11 -0500
From: Anatolij Gustschin <agust@denx.de>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Markus Niebel <Markus.Niebel@tqs.de>
Subject: [PATCH] v4l: mx3_camera.c: correct 'sizeimage' value reporting
Date: Mon, 31 Jan 2011 13:58:01 +0100
Message-Id: <1296478681-11119-1-git-send-email-agust@denx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The 'pix->width' field may be updated in mx3_camera_set_fmt() to
fulfill the IPU stride line alignment requirements. If this update
takes place, the 'fmt.pix.sizeimage' field in the struct v4l2_format
stucture returned by VIDIOC_S_FMT is wrong. We need to update the
'pix->sizeimage' field in the mx3_camera_set_fmt() function to fix
this issue.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 drivers/media/video/mx3_camera.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index 7bcaaf7..6b0b25d 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -918,6 +918,12 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 	pix->colorspace		= mf.colorspace;
 	icd->current_fmt	= xlate;
 
+	pix->bytesperline = soc_mbus_bytes_per_line(pix->width,
+						    xlate->host_fmt);
+	if (pix->bytesperline < 0)
+		return pix->bytesperline;
+	pix->sizeimage = pix->height * pix->bytesperline;
+
 	dev_dbg(icd->dev.parent, "Sensor set %dx%d\n", pix->width, pix->height);
 
 	return ret;
-- 
1.7.1

