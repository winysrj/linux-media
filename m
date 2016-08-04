Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36013 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbcHDJea (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2016 05:34:30 -0400
Received: by mail-pf0-f194.google.com with SMTP id y134so17330338pfg.3
        for <linux-media@vger.kernel.org>; Thu, 04 Aug 2016 02:34:30 -0700 (PDT)
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Wei Yongjun <weiyj.lk@gmail.com>, linux-media@vger.kernel.org
Subject: [PATCH -next] [media] adv7511: fix error return code in adv7511_probe()
Date: Thu,  4 Aug 2016 08:31:22 +0000
Message-Id: <1470299482-23543-1-git-send-email-weiyj.lk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix to return error code -ENOMEM from the i2c client register error
handling case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <weiyj.lk@gmail.com>
---
 drivers/media/i2c/adv7511.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 53030d6..5ba0f21 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -1898,6 +1898,7 @@ static int adv7511_probe(struct i2c_client *client, const struct i2c_device_id *
 					       state->i2c_cec_addr >> 1);
 		if (state->i2c_cec == NULL) {
 			v4l2_err(sd, "failed to register cec i2c client\n");
+			err = -ENOMEM;
 			goto err_unreg_edid;
 		}
 		adv7511_wr(sd, 0xe2, 0x00); /* power up cec section */

