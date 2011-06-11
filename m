Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:4733 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264Ab1FKNez (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 09:34:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 3/7] tuner-core: fix g_frequency support.
Date: Sat, 11 Jun 2011 15:34:39 +0200
Message-Id: <0d7f8cae6d252df04dbbcc6515507a9f7e00b895.1307798213.git.hans.verkuil@cisco.com>
In-Reply-To: <1307799283-15518-1-git-send-email-hverkuil@xs4all.nl>
References: <1307799283-15518-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9e1e782993aa0d0edf06fd5697743beca7717a53.1307798213.git.hans.verkuil@cisco.com>
References: <9e1e782993aa0d0edf06fd5697743beca7717a53.1307798213.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

VIDIOC_G_FREQUENCY should not check the tuner type, instead that is
something the driver fill in.

Since apps will often leave the type at 0, the 'supported_mode' call
will return false and the frequency never gets filled in.

Remove this check.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/tuner-core.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index ee43e0a..4d8dcea 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -1132,8 +1132,6 @@ static int tuner_g_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
 	struct tuner *t = to_tuner(sd);
 	struct dvb_tuner_ops *fe_tuner_ops = &t->fe.ops.tuner_ops;
 
-	if (!supported_mode(t, f->type))
-		return 0;
 	f->type = t->mode;
 	if (fe_tuner_ops->get_frequency && !t->standby) {
 		u32 abs_freq;
-- 
1.7.1

