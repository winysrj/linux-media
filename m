Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-231.synserver.de ([212.40.185.231]:1062 "EHLO
	smtp-out-227.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751709AbbAMMB1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 07:01:27 -0500
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 02/16] [media] adv7180: Pass correct flags to request_threaded_irq()
Date: Tue, 13 Jan 2015 13:01:07 +0100
Message-Id: <1421150481-30230-3-git-send-email-lars@metafoo.de>
In-Reply-To: <1421150481-30230-1-git-send-email-lars@metafoo.de>
References: <1421150481-30230-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most IRQ controllers support different types of interrupts. The adv7180
generates falling edge interrupts, so make sure to pass IRQF_TRIGGER_FALLING
to request_threaded_irq() so the IRQ controller is configured for the
correct mode.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
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

