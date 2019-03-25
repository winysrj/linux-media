Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82FFCC43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 00:35:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 514C420989
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 00:35:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VQ48qull"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729262AbfCYAfv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Mar 2019 20:35:51 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34041 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729146AbfCYAft (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Mar 2019 20:35:49 -0400
Received: by mail-lj1-f195.google.com with SMTP id j89so6273512ljb.1;
        Sun, 24 Mar 2019 17:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YUIheokwKP1iea+PUIcrfKDpgFD2izisvAZon9oQcUk=;
        b=VQ48qullWSVtP7SkdrAx0pjwc63YKBGaxmG0YJGhd1J6ZhPWi2fOWgKoSGOGbvDng8
         BzYfnTrFthKy29foIWRTZO/ESztt6qkPlPJxqwq31sBLIoTQ8Msk9EyYCF2RR/jqNZVk
         BmJF6iwdU1g1v+8vsIb6oHGLR/SDbdRuNs9aIBIPJHlptHpQTUqyg72cxZvUunfJsKIk
         GJwmRwshJS5RSNnGfGvQtmP3yvHYYRt+I3CfTlKy3Uey+skGG16vLsTBb1ufOxid+db4
         XA86VlVw7zpESnXVxpOHNuSmlviBmIfQaMTekveM7ArYxh6pIAXgoiYrAM/mVnbVCAoJ
         +Gqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YUIheokwKP1iea+PUIcrfKDpgFD2izisvAZon9oQcUk=;
        b=fxU75qzWbN/YgFW25cbUplACV2GcSNBjHPuJ53QXBHrpAW0UY9xEFcEHH/eHr/d8qW
         EQqTC9S49xdTy3IWIqrCYrW2Id5W18XgY2/rjjdplQLch588QnK4maMt64Fl+DDGsUm5
         P98tAL5abdAiKLKpG0GcDH72no3bWbmHUDWhb5Nl03OyyvnrAOyh5gpt2pwj+cGLdPra
         /bROCXwM2aLiktAxzgSztEg7XXQFNQWox/9+cmhvfwwxmqocjUIw6VZwSehb+phDDNu/
         z+vACakaCT23jdHP2P+QMmRxbzOPjn7dw6/i4fWY+VzO9G852bJMngkuhkNHg0c8M3/N
         GOHg==
X-Gm-Message-State: APjAAAWd3qqv65fPTkW1iJleqgNbN7wNOkhdb7aKtuZYbKJO8ekeWauB
        Qby0ogd4CQud79f79en+nL0=
X-Google-Smtp-Source: APXvYqxfK6aYTyQ5eCBY6yvXZlnOljx3XRyPj+HwkTQKsnxrckwqoxSs/0Zqql6y8LQ3pu7kVmDZ8g==
X-Received: by 2002:a2e:4209:: with SMTP id p9mr4969871lja.175.1553474146994;
        Sun, 24 Mar 2019 17:35:46 -0700 (PDT)
Received: from z50.gdansk-morena.vectranet.pl (109241207190.gdansk.vectranet.pl. [109.241.207.190])
        by smtp.gmail.com with ESMTPSA id y17sm1217993ljd.54.2019.03.24.17.35.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Mar 2019 17:35:46 -0700 (PDT)
From:   Janusz Krzysztofik <jmkrzyszt@gmail.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>
Subject: [PATCH 2/2] media: ov6650: Register with asynchronous subdevice framework
Date:   Mon, 25 Mar 2019 01:35:01 +0100
Message-Id: <20190325003501.14687-3-jmkrzyszt@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190325003501.14687-1-jmkrzyszt@gmail.com>
References: <20190325003501.14687-1-jmkrzyszt@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Register V4L2 subdevice implemented by the driver to the V4L2
asynchronous subdevice framework.

Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
---
 drivers/media/i2c/ov6650.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ov6650.c b/drivers/media/i2c/ov6650.c
index f10b8053ed73..cc9e5388d5ec 100644
--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -804,8 +804,9 @@ static int ov6650_prog_dflt(struct i2c_client *client)
 	return ret;
 }
 
-static int ov6650_video_probe(struct i2c_client *client)
+static int ov6650_video_probe(struct v4l2_subdev *sd)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov6650 *priv = to_ov6650(client);
 	u8		pidh, pidl, midh, midl;
 	int		ret;
@@ -817,7 +818,7 @@ static int ov6650_video_probe(struct i2c_client *client)
 		return ret;
 	}
 
-	ret = ov6650_s_power(&priv->subdev, 1);
+	ret = ov6650_s_power(sd, 1);
 	if (ret < 0)
 		goto eclkput;
 
@@ -853,7 +854,7 @@ static int ov6650_video_probe(struct i2c_client *client)
 		ret = v4l2_ctrl_handler_setup(&priv->hdl);
 
 done:
-	ov6650_s_power(&priv->subdev, 0);
+	ov6650_s_power(sd, 0);
 	if (ret) {
 eclkput:
 		v4l2_clk_put(priv->clk);
@@ -941,6 +942,10 @@ static const struct v4l2_subdev_ops ov6650_subdev_ops = {
 	.pad	= &ov6650_pad_ops,
 };
 
+static const struct v4l2_subdev_internal_ops ov6650_internal_ops = {
+	.registered = ov6650_video_probe,
+};
+
 /*
  * i2c_driver function
  */
@@ -1001,7 +1006,12 @@ static int ov6650_probe(struct i2c_client *client,
 	priv->code	  = MEDIA_BUS_FMT_YUYV8_2X8;
 	priv->colorspace  = V4L2_COLORSPACE_JPEG;
 
-	ret = ov6650_video_probe(client);
+	priv->subdev.internal_ops = &ov6650_internal_ops;
+	priv->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	snprintf(priv->subdev.name, sizeof(priv->subdev.name), "%s %d-%04x",
+		 did->name, i2c_adapter_id(client->adapter), client->addr);
+
+	ret = v4l2_async_register_subdev(&priv->subdev);
 	if (ret)
 		v4l2_ctrl_handler_free(&priv->hdl);
 
@@ -1013,7 +1023,7 @@ static int ov6650_remove(struct i2c_client *client)
 	struct ov6650 *priv = to_ov6650(client);
 
 	v4l2_clk_put(priv->clk);
-	v4l2_device_unregister_subdev(&priv->subdev);
+	v4l2_async_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
 	return 0;
 }
-- 
2.19.2

