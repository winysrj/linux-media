Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:4752 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab1HYOIl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Aug 2011 10:08:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 01/12] radio-si4713.c: fix compiler warning
Date: Thu, 25 Aug 2011 16:08:24 +0200
Message-Id: <afd314e95a520c3a4de0f112735d1d5584ec8a9a.1314281302.git.hans.verkuil@cisco.com>
In-Reply-To: <1314281315-32366-1-git-send-email-hverkuil@xs4all.nl>
References: <1314281315-32366-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

v4l-dvb-git/drivers/media/radio/radio-si4713.c: In function 'radio_si4713_querycap':
v4l-dvb-git/drivers/media/radio/radio-si4713.c:95:30: warning: variable 'rsdev' set but not used [-Wunused-but-set-variable]

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/radio-si4713.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
index 444b4cf..d1fab58 100644
--- a/drivers/media/radio/radio-si4713.c
+++ b/drivers/media/radio/radio-si4713.c
@@ -92,10 +92,6 @@ static int radio_si4713_s_audout(struct file *file, void *priv,
 static int radio_si4713_querycap(struct file *file, void *priv,
 					struct v4l2_capability *capability)
 {
-	struct radio_si4713_device *rsdev;
-
-	rsdev = video_get_drvdata(video_devdata(file));
-
 	strlcpy(capability->driver, "radio-si4713", sizeof(capability->driver));
 	strlcpy(capability->card, "Silicon Labs Si4713 Modulator",
 				sizeof(capability->card));
-- 
1.7.5.4

