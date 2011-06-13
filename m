Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3288 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab1FMMxb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2011 08:53:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@isely.net>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv5 PATCH 5/9] bttv: fix s_tuner for radio.
Date: Mon, 13 Jun 2011 14:53:16 +0200
Message-Id: <095001664932a4ae427877f97b1a408f64707c72.1307969319.git.hans.verkuil@cisco.com>
In-Reply-To: <1307969600-31536-1-git-send-email-hverkuil@xs4all.nl>
References: <1307969600-31536-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <6f25028df2439cef04708e3fd8d57b05662793a6.1307969319.git.hans.verkuil@cisco.com>
References: <6f25028df2439cef04708e3fd8d57b05662793a6.1307969319.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

Fix typo: g_tuner should have been s_tuner.

Tested with a bttv card.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/bt8xx/bttv-driver.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index a97cf27..834a483 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -3474,7 +3474,7 @@ static int radio_s_tuner(struct file *file, void *priv,
 	if (0 != t->index)
 		return -EINVAL;
 
-	bttv_call_all(btv, tuner, g_tuner, t);
+	bttv_call_all(btv, tuner, s_tuner, t);
 	return 0;
 }
 
-- 
1.7.1

