Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:34656 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752266AbaGEW0j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Jul 2014 18:26:39 -0400
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-sh@vger.kernel.org
Cc: magnus.damm@opensource.se, horms@verge.net.au,
	g.liakhovetski@gmx.de, linux-kernel@lists.codethink.co.uk,
	Ian Molton <ian.molton@codethink.co.uk>,
	Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH 1/6] adv7180: Remove duplicate unregister call
Date: Sat,  5 Jul 2014 23:26:20 +0100
Message-Id: <1404599185-12353-2-git-send-email-ben.dooks@codethink.co.uk>
In-Reply-To: <1404599185-12353-1-git-send-email-ben.dooks@codethink.co.uk>
References: <1404599185-12353-1-git-send-email-ben.dooks@codethink.co.uk>
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

