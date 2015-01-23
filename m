Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-190.synserver.de ([212.40.185.190]:1082 "EHLO
	smtp-out-190.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402AbbAWPwi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 10:52:38 -0500
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
	=?UTF-8?q?Richard=20R=C3=B6jfors?=
	<richard.rojfors@mocean-labs.com>,
	Federico Vaga <federico.vaga@gmail.com>,
	linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 01/15] [media] adv7180: Do not request the IRQ again during resume
Date: Fri, 23 Jan 2015 16:52:20 +0100
Message-Id: <1422028354-31891-2-git-send-email-lars@metafoo.de>
In-Reply-To: <1422028354-31891-1-git-send-email-lars@metafoo.de>
References: <1422028354-31891-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently the IRQ is requested from within the init_device() function. This
function is not only called during device probe, but also during resume
causing the driver to try to request the IRQ again. Move requesting the IRQ
from init_device() to the probe function to make sure that it is only
requested once.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7180.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index bffe6eb..172e4a2 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -553,11 +553,6 @@ static int init_device(struct i2c_client *client, struct adv7180_state *state)
 
 	/* register for interrupts */
 	if (state->irq > 0) {
-		ret = request_threaded_irq(state->irq, NULL, adv7180_irq,
-					   IRQF_ONESHOT, KBUILD_MODNAME, state);
-		if (ret)
-			return ret;
-
 		ret = i2c_smbus_write_byte_data(client, ADV7180_ADI_CTRL_REG,
 						ADV7180_ADI_CTRL_IRQ_SPACE);
 		if (ret < 0)
@@ -597,7 +592,6 @@ static int init_device(struct i2c_client *client, struct adv7180_state *state)
 	return 0;
 
 err:
-	free_irq(state->irq, state);
 	return ret;
 }
 
@@ -636,6 +630,13 @@ static int adv7180_probe(struct i2c_client *client,
 	if (ret)
 		goto err_free_ctrl;
 
+	if (state->irq) {
+		ret = request_threaded_irq(client->irq, NULL, adv7180_irq,
+					   IRQF_ONESHOT, KBUILD_MODNAME, state);
+		if (ret)
+			goto err_free_ctrl;
+	}
+
 	ret = v4l2_async_register_subdev(sd);
 	if (ret)
 		goto err_free_irq;
-- 
1.8.0

