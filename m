Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:54183 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729932AbeKFApj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 19:45:39 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Subject: [PATCH 08/15] media: coda: set V4L2_CAP_TIMEPERFRAME flag in coda_s_parm
Date: Mon,  5 Nov 2018 16:25:06 +0100
Message-Id: <20181105152513.26345-8-p.zabel@pengutronix.de>
In-Reply-To: <20181105152513.26345-1-p.zabel@pengutronix.de>
References: <20181105152513.26345-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The flag is already set in coda_g_parm, but v4l2-compliance complains
about it not being set during S_PARM.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 60b866160094..1ba3301b35de 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1135,6 +1135,7 @@ static int coda_s_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
 	if (a->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		return -EINVAL;
 
+	a->parm.output.capability = V4L2_CAP_TIMEPERFRAME;
 	tpf = &a->parm.output.timeperframe;
 	coda_approximate_timeperframe(tpf);
 	ctx->params.framerate = coda_timeperframe_to_frate(tpf);
-- 
2.19.1
