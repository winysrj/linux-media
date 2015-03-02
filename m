Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:46408 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbbCBPAx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2015 10:00:53 -0500
Received: by wggy19 with SMTP id y19so33887929wgg.13
        for <linux-media@vger.kernel.org>; Mon, 02 Mar 2015 07:00:51 -0800 (PST)
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-media@vger.kernel.org,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] media: i2c: s5c73m3: make sure we destroy the mutex
Date: Mon,  2 Mar 2015 15:00:34 +0000
Message-Id: <1425308434-26549-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Make sure to call mutex_destroy() in case of probe failure or module
unload.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/i2c/s5c73m3/s5c73m3-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index ee0f57e..da0b3a3 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1658,7 +1658,6 @@ static int s5c73m3_probe(struct i2c_client *client,
 	if (ret < 0)
 		return ret;
 
-	mutex_init(&state->lock);
 	sd = &state->sensor_sd;
 	oif_sd = &state->oif_sd;
 
@@ -1695,6 +1694,8 @@ static int s5c73m3_probe(struct i2c_client *client,
 	if (ret < 0)
 		return ret;
 
+	mutex_init(&state->lock);
+
 	ret = s5c73m3_configure_gpios(state);
 	if (ret)
 		goto out_err;
@@ -1754,6 +1755,7 @@ out_err1:
 	s5c73m3_unregister_spi_driver(state);
 out_err:
 	media_entity_cleanup(&sd->entity);
+	mutex_destroy(&state->lock);
 	return ret;
 }
 
@@ -1772,6 +1774,7 @@ static int s5c73m3_remove(struct i2c_client *client)
 	media_entity_cleanup(&sensor_sd->entity);
 
 	s5c73m3_unregister_spi_driver(state);
+	mutex_destroy(&state->lock);
 
 	return 0;
 }
-- 
1.9.1

