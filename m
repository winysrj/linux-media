Return-path: <linux-media-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:59468 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600AbZKHRtD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Nov 2009 12:49:03 -0500
Date: Sun, 8 Nov 2009 18:49:05 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/media/video: correct initialization of audio_mode
Message-ID: <Pine.LNX.4.64.0911081848250.4487@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

This initialization of the value of audio_mode is the one used if nothing
matches in the subsequent switch.  The variable audio_mode is subsequently
assigned to constants such as TUNER_AUDIO_MONO and TUNER_AUDIO_STEREO.
TUNER_AUDIO_STEREO has the same value as V4L2_TUNER_MODE_STEREO, so it
would seem better to use that value here.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/video/saa717x.c       |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/saa717x.c b/drivers/media/video/saa717x.c
index b15c409..a00fb25 100644
--- a/drivers/media/video/saa717x.c
+++ b/drivers/media/video/saa717x.c
@@ -1312,7 +1312,7 @@ static int saa717x_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 		"MONO", "STEREO", "LANG1", "LANG2/SAP"
 	};
 
-	audio_mode = V4L2_TUNER_MODE_STEREO;
+	audio_mode = TUNER_AUDIO_STEREO;
 
 	switch (vt->audmode) {
 		case V4L2_TUNER_MODE_MONO:
