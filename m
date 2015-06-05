Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-3.cisco.com ([72.163.197.27]:59420 "EHLO
	bgl-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbbFEIwt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2015 04:52:49 -0400
Received: from pla-VB.cisco.com ([10.142.60.220])
	by bgl-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id t558qcTh030105
	for <linux-media@vger.kernel.org>; Fri, 5 Jun 2015 08:52:38 GMT
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH] Support for reduced blanking version 2 
Date: Fri,  5 Jun 2015 14:22:37 +0530
Message-Id: <1433494358-29050-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Current cvt timing calculation supports reduced blanking (RB) version 1.
This patch adds the support for RB version 2, which was missing.
 
Compared to RB version 1, RB version 2 differs on different parameters.
This difference is summarized in the document VESA Coordinated Video
Timings Standard Version 1.2, Page 24, Table 5-4: Delta between Original
Reduced Blank Timing and Reduced Blank Timing V2.

One of the key difference to note is related to vsync parameter. Normally
vsync pulse duration varies based on aspect ratio. v4l2_detect_cvt()
makes use of this fact and infers the apsect ratio from vsync. However,
in case of RB version 2, one cannot infer aspect ratio from vsync because
for RB version 2 standard uses fixed value of vsync = 8 irrespective of
aspect ratio. In fact, vsync = 8 is used to indicate the timings are based
RB version 2. As such RB version 2 allows for non standard aspect ratios and
it needs to be calculated from image height and width. 

Referring to input parameters available to v4l2_detect_cvt(), it does not
have infromation about width. It rather have information about height and
the function calculates width after it infers about aspect ratio from vsync.
For RB version 2, this needs to be changed, possibly, by supplying aspect
ratio to v4l2_detect_cvt(). (on the lines similar to that of detect_gtf())

I have not done any API change in this patch. This patch is rather limited
to changes in timing calculation for RB version 2. As of now, I have just
assumed a default value for aspect ratio at 16:9.

Please review the timing calculation part and share your comments. Also
share your suggestions, comments about if we should extend v4l2_detect_cvt()
api to include aspect ratio.

Regards,
Prashant

Prashant Laddha (1):
  v4l2-dv-timings: add support for reduced blanking v2

 drivers/media/v4l2-core/v4l2-dv-timings.c | 72 +++++++++++++++++++++++--------
 1 file changed, 54 insertions(+), 18 deletions(-)

-- 
1.9.1

