Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:51902 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab3EMGAM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 02:00:12 -0400
Received: by mail-bk0-f44.google.com with SMTP id jk13so2212667bkc.3
        for <linux-media@vger.kernel.org>; Sun, 12 May 2013 23:00:10 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 13 May 2013 14:00:10 +0800
Message-ID: <CAPgLHd_5h-ZBTB+ouZ9At1MRR8tCf2XFUD2qag3p=ceMdVfgUA@mail.gmail.com>
Subject: [PATCH] [media] ad9389b: fix error return code in ad9389b_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: hans.verkuil@cisco.com, mchehab@redhat.com
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/i2c/ad9389b.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index 58344b6..decef36 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -1251,12 +1251,14 @@ static int ad9389b_probe(struct i2c_client *client, const struct i2c_device_id *
 	state->edid_i2c_client = i2c_new_dummy(client->adapter, (0x7e>>1));
 	if (state->edid_i2c_client == NULL) {
 		v4l2_err(sd, "failed to register edid i2c client\n");
+		err = -ENOMEM;
 		goto err_entity;
 	}
 
 	state->work_queue = create_singlethread_workqueue(sd->name);
 	if (state->work_queue == NULL) {
 		v4l2_err(sd, "could not create workqueue\n");
+		err = -ENOMEM;
 		goto err_unreg;
 	}
 

