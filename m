Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3435 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab1FNHOw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 03:14:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@isely.net>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv6 PATCH 02/10] tuner-core: fix tuner_resume: use t->mode instead of t->type.
Date: Tue, 14 Jun 2011 09:14:34 +0200
Message-Id: <79d3fb5596198a47efc2a1c85133d2b4b3fa835e.1308035134.git.hans.verkuil@cisco.com>
In-Reply-To: <1308035682-20447-1-git-send-email-hverkuil@xs4all.nl>
References: <1308035682-20447-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <eff4df001ab17e78b7413b9ed51661777523dbac.1308035134.git.hans.verkuil@cisco.com>
References: <eff4df001ab17e78b7413b9ed51661777523dbac.1308035134.git.hans.verkuil@cisco.com>
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
index accd9d4..a5aaf25 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -1241,7 +1241,7 @@ static int tuner_resume(struct i2c_client *c)
 	tuner_dbg("resume\n");
 
 	if (!t->standby)
-		if (set_mode(t, t->type) == 0)
+		if (set_mode(t, t->mode) == 0)
 			set_freq(t, 0);
 
 	return 0;
-- 
1.7.1

