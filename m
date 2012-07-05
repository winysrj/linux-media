Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab2GEOQg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jul 2012 10:16:36 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q65EGZJg028910
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 5 Jul 2012 10:16:35 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/3] [media] tuner-core: call has_signal for both TV and radio
Date: Thu,  5 Jul 2012 11:16:30 -0300
Message-Id: <1341497792-6066-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If g_tuner is called and the tuner is able to return the signal strength
via has_signal(), call the tunner callback to retrieve such data for all
tuner types, not only for radio ones.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/tuner-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 1ad5ab6..98adeee 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -1178,6 +1178,8 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 		return 0;
 	if (vt->type == t->mode && analog_ops->get_afc)
 		vt->afc = analog_ops->get_afc(&t->fe);
+	if (analog_ops->has_signal)
+		vt->signal = analog_ops->has_signal(&t->fe);
 	if (vt->type != V4L2_TUNER_RADIO) {
 		vt->capability |= V4L2_TUNER_CAP_NORM;
 		vt->rangelow = tv_range[0] * 16;
@@ -1197,8 +1199,6 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 				V4L2_TUNER_SUB_STEREO :
 				V4L2_TUNER_SUB_MONO;
 		}
-		if (analog_ops->has_signal)
-			vt->signal = analog_ops->has_signal(&t->fe);
 		vt->audmode = t->audmode;
 	}
 	vt->capability |= V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
-- 
1.7.10.4

