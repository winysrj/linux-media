Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:4404 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757665Ab1FKNe5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 09:34:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 6/7] tuner-core: fix g_tuner
Date: Sat, 11 Jun 2011 15:34:42 +0200
Message-Id: <54ea5935863e922ac5b9e5faf61d9b69e4f31492.1307798213.git.hans.verkuil@cisco.com>
In-Reply-To: <1307799283-15518-1-git-send-email-hverkuil@xs4all.nl>
References: <1307799283-15518-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9e1e782993aa0d0edf06fd5697743beca7717a53.1307798213.git.hans.verkuil@cisco.com>
References: <9e1e782993aa0d0edf06fd5697743beca7717a53.1307798213.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

g_tuner just returns the tuner data for the current tuner mode and the
application does not have to set the tuner type. So don't test for a
valid tuner type.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/tuner-core.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 8ef7790..7280998 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -1120,8 +1120,6 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
 	struct dvb_tuner_ops *fe_tuner_ops = &t->fe.ops.tuner_ops;
 
-	if (!supported_mode(t, vt->type))
-		return 0;
 	vt->type = t->mode;
 	if (analog_ops->get_afc)
 		vt->afc = analog_ops->get_afc(&t->fe);
-- 
1.7.1

