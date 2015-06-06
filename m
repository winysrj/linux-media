Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54347 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbbFFLUC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2015 07:20:02 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] fc2580: add missing error status when probe() fails
Date: Sat,  6 Jun 2015 14:19:39 +0300
Message-Id: <1433589579-20611-2-git-send-email-crope@iki.fi>
In-Reply-To: <1433589579-20611-1-git-send-email-crope@iki.fi>
References: <1433589579-20611-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We must return -ENODEV error on case probe() fails to detect chip.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/fc2580.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/tuners/fc2580.c b/drivers/media/tuners/fc2580.c
index db21902..12f916e 100644
--- a/drivers/media/tuners/fc2580.c
+++ b/drivers/media/tuners/fc2580.c
@@ -571,6 +571,7 @@ static int fc2580_probe(struct i2c_client *client,
 	case 0x5a:
 		break;
 	default:
+		ret = -ENODEV;
 		goto err_kfree;
 	}
 
-- 
http://palosaari.fi/

