Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2172 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab1HYOIt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Aug 2011 10:08:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 08/12] tvaudio: fix compiler warnings
Date: Thu, 25 Aug 2011 16:08:31 +0200
Message-Id: <1de3891a303b5b33eb46e23310c1a2ee9b219111.1314281302.git.hans.verkuil@cisco.com>
In-Reply-To: <1314281315-32366-1-git-send-email-hverkuil@xs4all.nl>
References: <1314281315-32366-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <afd314e95a520c3a4de0f112735d1d5584ec8a9a.1314281302.git.hans.verkuil@cisco.com>
References: <afd314e95a520c3a4de0f112735d1d5584ec8a9a.1314281302.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

v4l-dvb-git/drivers/media/video/tvaudio.c: In function 'tvaudio_s_ctrl':
v4l-dvb-git/drivers/media/video/tvaudio.c:1697:15: warning: variable 'balance' set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/video/tvaudio.c:1697:7: warning: variable 'volume' set but not used [-Wunused-but-set-variable]

This is indeed a bug: balance and volume must be used to set the left and right
channel volume. Fixed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/tvaudio.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/tvaudio.c b/drivers/media/video/tvaudio.c
index c46a3bb..f22dbef 100644
--- a/drivers/media/video/tvaudio.c
+++ b/drivers/media/video/tvaudio.c
@@ -1695,14 +1695,17 @@ static int tvaudio_s_ctrl(struct v4l2_subdev *sd,
 	case V4L2_CID_AUDIO_BALANCE:
 	{
 		int volume, balance;
+
 		if (!(desc->flags & CHIP_HAS_VOLUME))
 			break;
 
-		volume = max(chip->left,chip->right);
+		volume = max(chip->left, chip->right);
 		balance = ctrl->value;
+		chip->left = (min(65536 - balance, 32768) * volume) / 32768;
+		chip->right = (min(balance, volume * (__u16)32768)) / 32768;
 
-		chip_write(chip,desc->leftreg,desc->volfunc(chip->left));
-		chip_write(chip,desc->rightreg,desc->volfunc(chip->right));
+		chip_write(chip, desc->leftreg, desc->volfunc(chip->left));
+		chip_write(chip, desc->rightreg, desc->volfunc(chip->right));
 
 		return 0;
 	}
-- 
1.7.5.4

