Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:37456 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751622AbbGQLam (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2015 07:30:42 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 8420C2A0091
	for <linux-media@vger.kernel.org>; Fri, 17 Jul 2015 13:29:40 +0200 (CEST)
Message-ID: <55A8E724.8090800@xs4all.nl>
Date: Fri, 17 Jul 2015 13:29:40 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] cobalt: accept unchanged timings when vb2_is_busy().
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When vb2_is_busy() it should still be possible to call S_DV_TIMINGS
provided the new timings are the same as the current timings.

For input 1 (test generator) the size is always 1080p, so just return
that.

Fixes a v4l2-compliance issue.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cobalt/cobalt-v4l2.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index b40c2d1..9756fd3 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -28,6 +28,7 @@
 
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-event.h>
+#include <media/v4l2-dv-timings.h>
 #include <media/adv7604.h>
 #include <media/adv7842.h>
 
@@ -641,13 +642,17 @@ static int cobalt_s_dv_timings(struct file *file, void *priv_fh,
 	struct cobalt_stream *s = video_drvdata(file);
 	int err;
 
-	if (vb2_is_busy(&s->q))
-		return -EBUSY;
-
 	if (s->input == 1) {
 		*timings = cea1080p60;
 		return 0;
 	}
+
+	if (v4l2_match_dv_timings(timings, &s->timings, 0))
+		return 0;
+
+	if (vb2_is_busy(&s->q))
+		return -EBUSY;
+
 	err = v4l2_subdev_call(s->sd,
 			video, s_dv_timings, timings);
 	if (!err) {
-- 
2.1.4

