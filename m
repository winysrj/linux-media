Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2062 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab1FLLAF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 07:00:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@isely.net>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv4 PATCH 8/8] bttv: fix s_tuner for radio.
Date: Sun, 12 Jun 2011 12:59:49 +0200
Message-Id: <cd5f6808084d0b1c2aba3e690c35cf3e7abfa445.1307875512.git.hans.verkuil@cisco.com>
In-Reply-To: <1307876389-30347-1-git-send-email-hverkuil@xs4all.nl>
References: <1307876389-30347-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <980897e53f7cc2ec9bbbf58d9d451ee56a249309.1307875512.git.hans.verkuil@cisco.com>
References: <980897e53f7cc2ec9bbbf58d9d451ee56a249309.1307875512.git.hans.verkuil@cisco.com>
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

