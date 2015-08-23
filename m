Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcdn-iport-2.cisco.com ([173.37.86.73]:20942 "EHLO
	rcdn-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbbHWN4P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2015 09:56:15 -0400
Received: from XCH-RCD-007.cisco.com (xch-rcd-007.cisco.com [173.37.102.17])
	by alln-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id t7NDkgeQ032153
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Sun, 23 Aug 2015 13:46:42 GMT
From: "Prashant Laddha (prladdha)" <prladdha@cisco.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH] vivid: add support for reduced fps in video out.
Date: Sun, 23 Aug 2015 13:46:41 +0000
Message-ID: <D1FFCC7C.51D16%prladdha@cisco.com>
References: <1439658915-2511-1-git-send-email-prladdha@cisco.com>
 <1439658915-2511-2-git-send-email-prladdha@cisco.com>
In-Reply-To: <1439658915-2511-2-git-send-email-prladdha@cisco.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B6B010F151305B4BBAAE469DD2942268@emea.cisco.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

Please ignore this patch. I am resending this patch along with a patch
adding the reduced fps support in vivid capture.

Regards,
Prashant


On 15/08/15 10:45 pm, "Prashant Laddha (prladdha)" <prladdha@cisco.com>
wrote:

>If bt timing has REDUCED_FPS flag set, then reduce the frame rate
>by factor of 1000 / 1001. For vivid, timeperframe_vid_out indicates
>the frame timings used by video out thread. The timeperframe_vid_out
>is derived from pixel clock. Adjusting the timeperframe_vid_out by
>scaling down pixel clock with factor of 1000 / 1001.
>
>The reduced fps is supported for CVT timings if reduced blanking v2
>(indicated by vsync = 8) is true. For CEA861 timings, reduced fps is
>supported if V4L2_DV_FL_CAN_REDUCE_FPS flag is true. For GTF timings,
>reduced fps is not supported.
>
>The reduced fps will allow refresh rates like 29.97, 59.94 etc.
>
>Cc: Hans Verkuil <hans.verkuil@cisco.com>
>Signed-off-by: Prashant Laddha <prladdha@cisco.com>
>---
> drivers/media/platform/vivid/vivid-vid-out.c | 30
>+++++++++++++++++++++++++++-
> drivers/media/v4l2-core/v4l2-dv-timings.c    |  5 +++++
> 2 files changed, 34 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/media/platform/vivid/vivid-vid-out.c
>b/drivers/media/platform/vivid/vivid-vid-out.c
>index c404e27..ca6ec78 100644
>--- a/drivers/media/platform/vivid/vivid-vid-out.c
>+++ b/drivers/media/platform/vivid/vivid-vid-out.c
>@@ -213,6 +213,27 @@ const struct vb2_ops vivid_vid_out_qops = {
> };
> 
> /*
>+ * Called to check conditions for reduced fps. For CVT timings, reduced
>+ * fps is allowed only with reduced blanking v2 (vsync == 8). For CEA861
>+ * timings, reduced fps is allowed if V4L2_DV_FL_CAN_REDUCE_FPS flag is
>+ * true.
>+ */
>+static bool reduce_fps(struct v4l2_bt_timings *bt)
>+{
>+	if (!(bt->flags & V4L2_DV_FL_REDUCED_FPS))
>+		return false;
>+
>+	if ((bt->standards & V4L2_DV_BT_STD_CVT) && (bt->vsync == 8))
>+			return true;
>+
>+	if ((bt->standards & V4L2_DV_BT_STD_CEA861) &&
>+	    (bt->flags & V4L2_DV_FL_CAN_REDUCE_FPS))
>+			return true;
>+
>+	return false;
>+}
>+
>+/*
>  * Called whenever the format has to be reset which can occur when
>  * changing outputs, standard, timings, etc.
>  */
>@@ -220,6 +241,7 @@ void vivid_update_format_out(struct vivid_dev *dev)
> {
> 	struct v4l2_bt_timings *bt = &dev->dv_timings_out.bt;
> 	unsigned size, p;
>+	u64 pixelclock;
> 
> 	switch (dev->output_type[dev->output]) {
> 	case SVID:
>@@ -241,8 +263,14 @@ void vivid_update_format_out(struct vivid_dev *dev)
> 		dev->sink_rect.width = bt->width;
> 		dev->sink_rect.height = bt->height;
> 		size = V4L2_DV_BT_FRAME_WIDTH(bt) * V4L2_DV_BT_FRAME_HEIGHT(bt);
>+
>+		if (reduce_fps(bt))
>+			pixelclock = div_u64((bt->pixelclock * 1000), 1001);
>+		else
>+			pixelclock = bt->pixelclock;
>+
> 		dev->timeperframe_vid_out = (struct v4l2_fract) {
>-			size / 100, (u32)bt->pixelclock / 100
>+			size / 100, (u32)pixelclock / 100
> 		};
> 		if (bt->interlaced)
> 			dev->field_out = V4L2_FIELD_ALTERNATE;
>diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c
>b/drivers/media/v4l2-core/v4l2-dv-timings.c
>index 6a83d61..adc03bd 100644
>--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
>+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
>@@ -210,7 +210,12 @@ bool v4l2_find_dv_timings_cap(struct v4l2_dv_timings
>*t,
> 					  fnc, fnc_handle) &&
> 		    v4l2_match_dv_timings(t, v4l2_dv_timings_presets + i,
> 					  pclock_delta)) {
>+			u32 flags = t->bt.flags & V4L2_DV_FL_REDUCED_FPS;
>+
> 			*t = v4l2_dv_timings_presets[i];
>+			if (t->bt.flags & V4L2_DV_FL_CAN_REDUCE_FPS)
>+				t->bt.flags |= flags;
>+
> 			return true;
> 		}
> 	}
>-- 
>1.9.1
>

