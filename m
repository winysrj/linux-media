Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:42347 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab1CDI6f (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 03:58:35 -0500
From: Michael Jones <michael.jones@matrix-vision.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 1/4] v4l: add V4L2_PIX_FMT_Y12 format
Date: Fri,  4 Mar 2011 09:58:01 +0100
Message-Id: <1299229084-8335-2-git-send-email-michael.jones@matrix-vision.de>
In-Reply-To: <1299229084-8335-1-git-send-email-michael.jones@matrix-vision.de>
References: <1299229084-8335-1-git-send-email-michael.jones@matrix-vision.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
---
 include/linux/videodev2.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 02da9e7..6fac463 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -288,6 +288,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_Y4      v4l2_fourcc('Y', '0', '4', ' ') /*  4  Greyscale     */
 #define V4L2_PIX_FMT_Y6      v4l2_fourcc('Y', '0', '6', ' ') /*  6  Greyscale     */
 #define V4L2_PIX_FMT_Y10     v4l2_fourcc('Y', '1', '0', ' ') /* 10  Greyscale     */
+#define V4L2_PIX_FMT_Y12     v4l2_fourcc('Y', '1', '2', ' ') /* 12  Greyscale     */
 #define V4L2_PIX_FMT_Y16     v4l2_fourcc('Y', '1', '6', ' ') /* 16  Greyscale     */
 
 /* Palette formats */
-- 
1.7.4.1


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
