Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:44730 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754610Ab2FJBo4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jun 2012 21:44:56 -0400
From: =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <daniel-gl@gmx.net>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <daniel-gl@gmx.net>
Subject: [PATCH 3/9] tvaudio: use V4L2_TUNER_MODE_SAP for TDA985x SAP
Date: Sun, 10 Jun 2012 03:43:52 +0200
Message-Id: <1339292638-12205-4-git-send-email-daniel-gl@gmx.net>
In-Reply-To: <20120609214100.GA1598@minime.bse>
References: <20120609214100.GA1598@minime.bse>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As V4L2_TUNER_MODE_SAP == V4L2_TUNER_MODE_LANG2, we make
V4L2_TUNER_MODE_LANG1 equal to V4L2_TUNER_MODE_STEREO.

Signed-off-by: Daniel Glöckner <daniel-gl@gmx.net>
---
 drivers/media/video/tvaudio.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/tvaudio.c b/drivers/media/video/tvaudio.c
index 76a8cbe..3fbaaa0 100644
--- a/drivers/media/video/tvaudio.c
+++ b/drivers/media/video/tvaudio.c
@@ -534,9 +534,10 @@ static void tda985x_setmode(struct CHIPSTATE *chip, int mode)
 		c6 |= TDA985x_MONO;
 		break;
 	case V4L2_TUNER_MODE_STEREO:
+	case V4L2_TUNER_MODE_LANG1:
 		c6 |= TDA985x_STEREO;
 		break;
-	case V4L2_TUNER_MODE_LANG1:
+	case V4L2_TUNER_MODE_SAP:
 		c6 |= TDA985x_SAP;
 		break;
 	default:
-- 
1.7.0.5

