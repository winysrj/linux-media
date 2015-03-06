Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33792 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbbCFNKF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Mar 2015 08:10:05 -0500
Received: from avalon.ideasonboard.com (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 15B3420066
	for <linux-media@vger.kernel.org>; Fri,  6 Mar 2015 14:09:07 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] uvcvideo: Validate index during step-wise frame intervals enumeration
Date: Fri,  6 Mar 2015 15:10:03 +0200
Message-Id: <1425647403-5591-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Frame intervals exposed as an interval and step (so-called step-wise)
are restricted by the V4L2 API to a single enumeration entry. Return an
error when the index is not zero.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_v4l2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 43e953f..8a92eb7 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -1133,6 +1133,9 @@ static int uvc_ioctl_enum_frameintervals(struct file *file, void *fh,
 		uvc_simplify_fraction(&fival->discrete.numerator,
 			&fival->discrete.denominator, 8, 333);
 	} else {
+		if (fival->index)
+			return -EINVAL
+
 		fival->type = V4L2_FRMIVAL_TYPE_STEPWISE;
 		fival->stepwise.min.numerator = frame->dwFrameInterval[0];
 		fival->stepwise.min.denominator = 10000000;
-- 
Regards,

Laurent Pinchart

