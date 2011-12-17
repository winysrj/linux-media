Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:22068 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab1LQU57 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Dec 2011 15:57:59 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 2/3] drxk: correction frontend attatching
Date: Sat, 17 Dec 2011 21:57:16 +0100
Message-Id: <1324155437-15834-2-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1324155437-15834-1-git-send-email-linuxtv@stefanringel.de>
References: <1324155437-15834-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

all drxk have dvb-t, but not dvb-c.

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 drivers/media/dvb/frontends/drxk_hard.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 038e470..8a59801 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -6460,9 +6460,11 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 	init_state(state);
 	if (init_drxk(state) < 0)
 		goto error;
-	*fe_t = &state->t_frontend;
 
-	return &state->c_frontend;
+	if (state->m_hasDVBC)
+		*fe_t = &state->c_frontend;
+
+	return &state->t_frontend;
 
 error:
 	printk(KERN_ERR "drxk: not found\n");
-- 
1.7.7

