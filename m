Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:18016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab1BNVDb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 16:03:31 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1EL3UEG026562
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 16:03:30 -0500
Received: from pedra (vpn-239-121.phx2.redhat.com [10.3.239.121])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1EL3TG3012908
	for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 16:03:29 -0500
Date: Mon, 14 Feb 2011 19:03:11 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 03/14] [media] tuner-core: Remove V4L1/V4L2 API switch
Message-ID: <20110214190311.545e34ba@pedra>
In-Reply-To: <cover.1297716906.git.mchehab@redhat.com>
References: <cover.1297716906.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

V4L1 was removed. So, the code there is just dead code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 1cec122..6041c7d 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -80,7 +80,6 @@ struct tuner {
 	struct i2c_client   *i2c;
 	struct v4l2_subdev  sd;
 	struct list_head    list;
-	unsigned int        using_v4l2:1;
 
 	/* keep track of the current settings */
 	v4l2_std_id         std;
@@ -717,19 +716,6 @@ static inline int set_mode(struct i2c_client *client, struct tuner *t, int mode,
 	return 0;
 }
 
-#define switch_v4l2()	if (!t->using_v4l2) \
-			    tuner_dbg("switching to v4l2\n"); \
-			t->using_v4l2 = 1;
-
-static inline int check_v4l2(struct tuner *t)
-{
-	/* bttv still uses both v4l1 and v4l2 calls to the tuner (v4l2 for
-	   TV, v4l1 for radio), until that is fixed this code is disabled.
-	   Otherwise the radio (v4l1) wouldn't tune after using the TV (v4l2)
-	   first. */
-	return 0;
-}
-
 static int tuner_s_type_addr(struct v4l2_subdev *sd, struct tuner_setup *type)
 {
 	struct tuner *t = to_tuner(sd);
@@ -803,8 +789,6 @@ static int tuner_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 	if (set_mode(client, t, V4L2_TUNER_ANALOG_TV, "s_std") == -EINVAL)
 		return 0;
 
-	switch_v4l2();
-
 	t->std = std;
 	tuner_fixup_std(t);
 	if (t->tv_freq)
@@ -819,7 +803,6 @@ static int tuner_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
 
 	if (set_mode(client, t, f->type, "s_frequency") == -EINVAL)
 		return 0;
-	switch_v4l2();
 	set_freq(client, f->frequency);
 
 	return 0;
@@ -832,7 +815,6 @@ static int tuner_g_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
 
 	if (check_mode(t, "g_frequency") == -EINVAL)
 		return 0;
-	switch_v4l2();
 	f->type = t->mode;
 	if (fe_tuner_ops->get_frequency) {
 		u32 abs_freq;
@@ -856,7 +838,6 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 
 	if (check_mode(t, "g_tuner") == -EINVAL)
 		return 0;
-	switch_v4l2();
 
 	vt->type = t->mode;
 	if (analog_ops->get_afc)
@@ -906,8 +887,6 @@ static int tuner_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	if (check_mode(t, "s_tuner") == -EINVAL)
 		return 0;
 
-	switch_v4l2();
-
 	/* do nothing unless we're a radio tuner */
 	if (t->mode != V4L2_TUNER_RADIO)
 		return 0;
-- 
1.7.1


