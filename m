Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:2300 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757689Ab1FKNe5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 09:34:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 7/7] tuner-core: s_tuner should not change tuner mode.
Date: Sat, 11 Jun 2011 15:34:43 +0200
Message-Id: <2a85334a8d3f0861fc10f2d6adbf46946d12bb0e.1307798213.git.hans.verkuil@cisco.com>
In-Reply-To: <1307799283-15518-1-git-send-email-hverkuil@xs4all.nl>
References: <1307799283-15518-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9e1e782993aa0d0edf06fd5697743beca7717a53.1307798213.git.hans.verkuil@cisco.com>
References: <9e1e782993aa0d0edf06fd5697743beca7717a53.1307798213.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

According to the spec the tuner type field is not used when calling
S_TUNER: index, audmode and reserved are the only writable fields.

So remove the type check. Instead, just set the audmode if the current
tuner mode is set to radio.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/tuner-core.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 7280998..0ffcf54 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -1156,12 +1156,10 @@ static int tuner_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 {
 	struct tuner *t = to_tuner(sd);
 
-	if (!set_mode(t, vt->type))
-		return 0;
-
-	if (t->mode == V4L2_TUNER_RADIO)
+	if (t->mode == V4L2_TUNER_RADIO) {
 		t->audmode = vt->audmode;
-	set_freq(t, 0);
+		set_freq(t, 0);
+	}
 
 	return 0;
 }
-- 
1.7.1

