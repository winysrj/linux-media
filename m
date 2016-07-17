Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:47862 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814AbcGQJDV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 05:03:21 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 0F6AF180C37
	for <linux-media@vger.kernel.org>; Sun, 17 Jul 2016 11:03:16 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cobalt: support reduced fps
Message-ID: <0f78b670-9a2b-fc00-f1ac-2ac11b81dae4@xs4all.nl>
Date: Sun, 17 Jul 2016 11:03:15 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for reduced fps (i.e. 59.94 Hz instead of 60 Hz) for the
HDMI output.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cobalt/cobalt-v4l2.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index 5790095..3fea246 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -161,8 +161,11 @@ static void cobalt_enable_output(struct cobalt_stream *s)
 	struct v4l2_subdev_format sd_fmt = {
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
 	};
+	u64 clk = bt->pixelclock;

-	if (!cobalt_cpld_set_freq(cobalt, bt->pixelclock)) {
+	if (bt->flags & V4L2_DV_FL_REDUCED_FPS)
+		clk = div_u64(clk * 1000ULL, 1001);
+	if (!cobalt_cpld_set_freq(cobalt, clk)) {
 		cobalt_err("pixelclock out of range\n");
 		return;
 	}
@@ -644,7 +647,7 @@ static int cobalt_s_dv_timings(struct file *file, void *priv_fh,
 		return 0;
 	}

-	if (v4l2_match_dv_timings(timings, &s->timings, 0, false))
+	if (v4l2_match_dv_timings(timings, &s->timings, 0, true))
 		return 0;

 	if (vb2_is_busy(&s->q))
-- 
2.8.1

