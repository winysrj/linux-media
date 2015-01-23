Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-190.synserver.de ([212.40.185.190]:1086 "EHLO
	smtp-out-190.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595AbbAWPwj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 10:52:39 -0500
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
	=?UTF-8?q?Richard=20R=C3=B6jfors?=
	<richard.rojfors@mocean-labs.com>,
	Federico Vaga <federico.vaga@gmail.com>,
	linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 02/15] [media] adv7180: Pass correct flags to request_threaded_irq()
Date: Fri, 23 Jan 2015 16:52:21 +0100
Message-Id: <1422028354-31891-3-git-send-email-lars@metafoo.de>
In-Reply-To: <1422028354-31891-1-git-send-email-lars@metafoo.de>
References: <1422028354-31891-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most IRQ controllers support different types of interrupts. The adv7180
generates falling edge interrupts, so make sure to pass IRQF_TRIGGER_FALLING
to request_threaded_irq() so the IRQ controller is configured for the
correct mode.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7180.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 172e4a2..f424a4d 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -632,7 +632,8 @@ static int adv7180_probe(struct i2c_client *client,
 
 	if (state->irq) {
 		ret = request_threaded_irq(client->irq, NULL, adv7180_irq,
-					   IRQF_ONESHOT, KBUILD_MODNAME, state);
+					   IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
+					   KBUILD_MODNAME, state);
 		if (ret)
 			goto err_free_ctrl;
 	}
-- 
1.8.0

