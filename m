Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56452 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaJWNgw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Oct 2014 09:36:52 -0400
Received: by mail-pa0-f46.google.com with SMTP id fa1so1077286pad.19
        for <linux-media@vger.kernel.org>; Thu, 23 Oct 2014 06:36:51 -0700 (PDT)
Date: Thu, 23 Oct 2014 21:36:49 +0800
From: "Nibble Max" <nibble.max@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
Cc: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH 1/1] m88ts2022: return the err code in its probe function when error occurs.
Message-ID: <201410232136466253099@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

if "chip_id" is wrong or "dev->cfg.clock_out" is invalid, the i2c model is still loaded.
It will cause "kernel NULL pointer dereference" oops when the i2c model remove.
returning the err code will prevent the i2c model load. 

Signed-off-by: Nibble Max <nibble.max@gmail.com>
---
 drivers/media/tuners/m88ts2022.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/tuners/m88ts2022.c b/drivers/media/tuners/m88ts2022.c
index caa5423..066e543 100644
--- a/drivers/media/tuners/m88ts2022.c
+++ b/drivers/media/tuners/m88ts2022.c
@@ -488,6 +488,7 @@ static int m88ts2022_probe(struct i2c_client *client,
 	case 0x83:
 		break;
 	default:
+		ret = -ENODEV;
 		goto err;
 	}
 
@@ -505,6 +506,7 @@ static int m88ts2022_probe(struct i2c_client *client,
 		u8tmp = 0x6c;
 		break;
 	default:
+		ret = -EINVAL;
 		goto err;
 	}
 
-- 
1.9.1

