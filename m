Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:49647 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751960AbbFYJbO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2015 05:31:14 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 11/15] media: soc_camera: soc_scale_crop: Use correct pad number in try_fmt
Date: Thu, 25 Jun 2015 10:31:05 +0100
Message-Id: <1435224669-23672-12-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1435224669-23672-1-git-send-email-william.towle@codethink.co.uk>
References: <1435224669-23672-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Rob Taylor <rob.taylor@codethink.co.uk>

Fix calls to subdev try_fmt function to use valid pad numbers, fixing
the case where subdevs (eg. ADV7612) have valid pad numbers that are
non-zero.

Signed-off-by: William Towle <william.towle@codethink.co.uk>
Reviewed-by: Rob Taylor <rob.taylor@codethink.co.uk>
---
 drivers/media/platform/soc_camera/soc_scale_crop.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/soc_camera/soc_scale_crop.c b/drivers/media/platform/soc_camera/soc_scale_crop.c
index bda29bc..2772215 100644
--- a/drivers/media/platform/soc_camera/soc_scale_crop.c
+++ b/drivers/media/platform/soc_camera/soc_scale_crop.c
@@ -225,6 +225,7 @@ static int client_set_fmt(struct soc_camera_device *icd,
 	bool host_1to1;
 	int ret;
 
+	format->pad = icd->src_pad_idx;
 	ret = v4l2_device_call_until_err(sd->v4l2_dev,
 					 soc_camera_grp_id(icd), pad,
 					 set_fmt, NULL, format);
-- 
1.7.10.4

