Return-path: <mchehab@pedra>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2758 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab1FKRsn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 13:48:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 5/6] tuner-core: fix tuner_resume: use t->mode instead of t->type.
Date: Sat, 11 Jun 2011 19:48:34 +0200
Message-Id: <ce2a9bf37e65aba48a2835bfcb4b84abe497bcb7.1307813916.git.hans.verkuil@cisco.com>
In-Reply-To: <1307814515-17351-1-git-send-email-hverkuil@xs4all.nl>
References: <1307814515-17351-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <980897e53f7cc2ec9bbbf58d9d451ee56a249309.1307813916.git.hans.verkuil@cisco.com>
References: <980897e53f7cc2ec9bbbf58d9d451ee56a249309.1307813916.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

set_mode is called with t->type, which is the tuner type. Instead, use
t->mode which is the actual tuner mode (i.e. radio vs tv).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/tuner-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index bf7fc33..ffe5de3 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -1201,7 +1201,7 @@ static int tuner_resume(struct i2c_client *c)
 	tuner_dbg("resume\n");
 
 	if (!t->standby)
-		if (set_mode(t, t->type))
+		if (set_mode(t, t->mode))
 			set_freq(t, 0);
 	return 0;
 }
-- 
1.7.1

