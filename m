Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2550 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbaAaNc3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jan 2014 08:32:29 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 2/2] v4l2-dv-timings: mention missing 'reduced blanking V2'
Date: Fri, 31 Jan 2014 14:32:16 +0100
Message-Id: <1391175136-27875-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1391175136-27875-1-git-send-email-hverkuil@xs4all.nl>
References: <1391175136-27875-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The VESA standard added a version 2 of the reduced blanking formula.
Note in the comment that this is not yet supported by the v4l2_detect_cvt
function.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index ee52b9f4..41bf3f9 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -324,6 +324,10 @@ EXPORT_SYMBOL_GPL(v4l2_print_dv_timings);
  * This function will attempt to detect if the given values correspond to a
  * valid CVT format. If so, then it will return true, and fmt will be filled
  * in with the found CVT timings.
+ *
+ * TODO: VESA defined a new version 2 of their reduced blanking
+ * formula. Support for that is currently missing in this CVT
+ * detection function.
  */
 bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
 		u32 polarities, struct v4l2_dv_timings *fmt)
-- 
1.8.5.2

