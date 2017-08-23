Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60388 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754160AbdHWVUN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 17:20:13 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-media@vger.kernel.org,
        Max Kellermann <max.kellermann@gmail.com>
Subject: [RFC 3/3] media: drxk: Initialize the frontend after allocating it
Date: Thu, 24 Aug 2017 00:20:39 +0300
Message-Id: <20170823212039.27751-4-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20170823212039.27751-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20170823212039.27751-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Frontends must now be initialized explicitly. Do it.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/dvb-frontends/drxk_hard.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index 48a8aad47a74..5cc29fcc9468 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -6780,6 +6780,7 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 	struct drxk_state *state = NULL;
 	u8 adr = config->adr;
 	int status;
+	int ret;
 
 	dprintk(1, "\n");
 	state = kzalloc(sizeof(struct drxk_state), GFP_KERNEL);
@@ -6827,6 +6828,10 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 
 	mutex_init(&state->mutex);
 
+	ret = dvb_frontend_init(&state->frontend);
+	if (ret < 0)
+		goto error;
+
 	memcpy(&state->frontend.ops, &drxk_ops, sizeof(drxk_ops));
 	state->frontend.demodulator_priv = state;
 
-- 
Regards,

Laurent Pinchart
