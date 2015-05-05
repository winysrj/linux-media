Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48530 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbbEEWB3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 18:01:29 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/4] e4000: disable sysfs device bind / unbind
Date: Wed,  6 May 2015 01:01:17 +0300
Message-Id: <1430863280-10266-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We are not allowed manually bind / unbind device from the driver
currently.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/e4000.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index 510239f..59190cb 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -601,6 +601,7 @@ static struct i2c_driver e4000_driver = {
 	.driver = {
 		.owner	= THIS_MODULE,
 		.name	= "e4000",
+		.suppress_bind_attrs = true,
 	},
 	.probe		= e4000_probe,
 	.remove		= e4000_remove,
-- 
http://palosaari.fi/

