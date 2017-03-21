Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay2.synopsys.com ([198.182.60.111]:48132 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757196AbdCULuM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Mar 2017 07:50:12 -0400
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: linux-media@vger.kernel.org
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
        Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] [media] cobalt: Use v4l2_calc_timeperframe helper
Date: Tue, 21 Mar 2017 11:49:18 +0000
Message-Id: <070c9e71b359c0f6da7410b5ab9207210925549a.1490095965.git.joabreu@synopsys.com>
In-Reply-To: <cover.1490095965.git.joabreu@synopsys.com>
References: <cover.1490095965.git.joabreu@synopsys.com>
In-Reply-To: <cover.1490095965.git.joabreu@synopsys.com>
References: <cover.1490095965.git.joabreu@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, cobalt driver always returns 60fps in g_parm.
This patch uses the new v4l2_calc_timeperframe helper to
calculate the time per frame value.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Carlos Palminha <palminha@synopsys.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/media/pci/cobalt/cobalt-v4l2.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index def4a3b..25532ae 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -1076,10 +1076,15 @@ static int cobalt_subscribe_event(struct v4l2_fh *fh,
 
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
1.9.1
