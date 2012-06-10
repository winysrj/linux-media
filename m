Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:47230 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754616Ab2FJBo4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jun 2012 21:44:56 -0400
From: =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <daniel-gl@gmx.net>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <daniel-gl@gmx.net>
Subject: [PATCH 4/9] tvaudio: remove watch_stereo
Date: Sun, 10 Jun 2012 03:43:53 +0200
Message-Id: <1339292638-12205-5-git-send-email-daniel-gl@gmx.net>
In-Reply-To: <20120609214100.GA1598@minime.bse>
References: <20120609214100.GA1598@minime.bse>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is never read and only assigned 0.

Signed-off-by: Daniel Glöckner <daniel-gl@gmx.net>
---
 drivers/media/video/tvaudio.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/tvaudio.c b/drivers/media/video/tvaudio.c
index 3fbaaa0..fc37587 100644
--- a/drivers/media/video/tvaudio.c
+++ b/drivers/media/video/tvaudio.c
@@ -126,7 +126,6 @@ struct CHIPSTATE {
 	/* thread */
 	struct task_struct   *thread;
 	struct timer_list    wt;
-	int                  watch_stereo;
 	int 		     audmode;
 };
 
@@ -1741,7 +1740,6 @@ static int tvaudio_s_radio(struct v4l2_subdev *sd)
 	struct CHIPSTATE *chip = to_state(sd);
 
 	chip->radio = 1;
-	chip->watch_stereo = 0;
 	/* del_timer(&chip->wt); */
 	return 0;
 }
@@ -1821,7 +1819,6 @@ static int tvaudio_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	chip->audmode = vt->audmode;
 
 	if (mode) {
-		chip->watch_stereo = 0;
 		/* del_timer(&chip->wt); */
 		chip->mode = mode;
 		desc->setmode(chip, mode);
-- 
1.7.0.5

