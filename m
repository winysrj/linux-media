Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:38707 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750981AbaFOT44 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jun 2014 15:56:56 -0400
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-sh@vger.kernel.org,
	linux-media@vger.kernel.org
Cc: robert.jarzmik@free.fr, g.liakhovetski@gmx.de,
	magnus.damm@opensource.se, horms@verge.net.au,
	ian.molton@codethink.co.uk, william.towle@codethink.co.uk,
	Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH 3/9] adv7180: Remove duplicate unregister call
Date: Sun, 15 Jun 2014 20:56:28 +0100
Message-Id: <1402862194-17743-4-git-send-email-ben.dooks@codethink.co.uk>
In-Reply-To: <1402862194-17743-1-git-send-email-ben.dooks@codethink.co.uk>
References: <1402862194-17743-1-git-send-email-ben.dooks@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ian Molton <ian.molton@codethink.co.uk>

This driver moved over to v4l2_async_unregister_subdev()
but still retained a call to v4l2_unregister_subdev(). Remove.

Signed-off-by: Ian Molton <ian.molton@codethink.co.uk>
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 drivers/media/i2c/adv7180.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index ac1cdbe..821178d 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -663,7 +663,6 @@ static int adv7180_remove(struct i2c_client *client)
 	if (state->irq > 0)
 		free_irq(client->irq, state);
 
-	v4l2_device_unregister_subdev(sd);
 	adv7180_exit_controls(state);
 	mutex_destroy(&state->mutex);
 	return 0;
-- 
2.0.0

