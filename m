Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4209 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab1FNHOz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 03:14:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@isely.net>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv6 PATCH 05/10] bttv: fix s_tuner for radio.
Date: Tue, 14 Jun 2011 09:14:37 +0200
Message-Id: <949c6408ded7ad8aaa9598958271ab7bb84aaa36.1308035134.git.hans.verkuil@cisco.com>
In-Reply-To: <1308035682-20447-1-git-send-email-hverkuil@xs4all.nl>
References: <1308035682-20447-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <eff4df001ab17e78b7413b9ed51661777523dbac.1308035134.git.hans.verkuil@cisco.com>
References: <eff4df001ab17e78b7413b9ed51661777523dbac.1308035134.git.hans.verkuil@cisco.com>
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

