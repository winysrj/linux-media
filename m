Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:49330 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729359AbeHOQdM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Aug 2018 12:33:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Carlos Palminha <palminha@synopsys.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 4/5] cobalt: Use v4l2_calc_timeperframe helper
Date: Wed, 15 Aug 2018 15:40:55 +0200
Message-Id: <20180815134056.98830-5-hverkuil@xs4all.nl>
In-Reply-To: <20180815134056.98830-1-hverkuil@xs4all.nl>
References: <20180815134056.98830-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jose Abreu <Jose.Abreu@synopsys.com>

Currently, cobalt driver always returns 60fps in g_parm.
This patch uses the new v4l2_calc_timeperframe helper to
calculate the time per frame value.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Carlos Palminha <palminha@synopsys.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cobalt/cobalt-v4l2.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index e2a4c705d353..c8fd2d075f43 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -1064,10 +1064,15 @@ static int cobalt_subscribe_event(struct v4l2_fh *fh,
 
 static int cobalt_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
 {
+	struct cobalt_stream *s = video_drvdata(file);
+	struct v4l2_fract fps;
+
 	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
-	a->parm.capture.timeperframe.numerator = 1;
-	a->parm.capture.timeperframe.denominator = 60;
+
+	fps = v4l2_calc_timeperframe(&s->timings);
+	a->parm.capture.timeperframe.numerator = fps.numerator;
+	a->parm.capture.timeperframe.denominator = fps.denominator;
 	a->parm.capture.readbuffers = 3;
 	return 0;
 }
-- 
2.18.0
