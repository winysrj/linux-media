Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:35877 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab3IKOIA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Sep 2013 10:08:00 -0400
Received: by mail-bk0-f48.google.com with SMTP id my13so3527235bkb.7
        for <linux-media@vger.kernel.org>; Wed, 11 Sep 2013 07:07:58 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 11 Sep 2013 22:07:58 +0800
Message-ID: <CAPgLHd_xpRN-bn6JmDbxkYQORgtcRLcqEAa3uL8W13Hhr8jSEw@mail.gmail.com>
Subject: [PATCH] [media] adv7511: fix error return code in adv7511_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: hans.verkuil@cisco.com, m.chehab@samsung.com
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENOMEM in the new i2c client and create workqueue error
handling case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/i2c/adv7511.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 7a576097..665b0c9 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -1126,6 +1126,7 @@ static int adv7511_probe(struct i2c_client *client, const struct i2c_device_id *
 	state->i2c_edid = i2c_new_dummy(client->adapter, state->i2c_edid_addr >> 1);
 	if (state->i2c_edid == NULL) {
 		v4l2_err(sd, "failed to register edid i2c client\n");
+		err = -ENOMEM;
 		goto err_entity;
 	}
 
@@ -1133,6 +1134,7 @@ static int adv7511_probe(struct i2c_client *client, const struct i2c_device_id *
 	state->work_queue = create_singlethread_workqueue(sd->name);
 	if (state->work_queue == NULL) {
 		v4l2_err(sd, "could not create workqueue\n");
+		err = -ENOMEM;
 		goto err_unreg_cec;
 	}
 

