Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4020 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab1FMMxa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2011 08:53:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@isely.net>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv5 PATCH 2/9] tuner-core: fix tuner_resume: use t->mode instead of t->type.
Date: Mon, 13 Jun 2011 14:53:13 +0200
Message-Id: <13d4fd3be0d093618389607db994d7c48fd5d070.1307969319.git.hans.verkuil@cisco.com>
In-Reply-To: <1307969600-31536-1-git-send-email-hverkuil@xs4all.nl>
References: <1307969600-31536-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <6f25028df2439cef04708e3fd8d57b05662793a6.1307969319.git.hans.verkuil@cisco.com>
References: <6f25028df2439cef04708e3fd8d57b05662793a6.1307969319.git.hans.verkuil@cisco.com>
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
index b634bab..3b30d80 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -1242,7 +1242,7 @@ static int tuner_resume(struct i2c_client *c)
 	tuner_dbg("resume\n");
 
 	if (!t->standby)
-		if (set_mode(t, t->type) == 0)
+		if (set_mode(t, t->mode) == 0)
 			set_freq(t, 0);
 
 	return 0;
-- 
1.7.1

