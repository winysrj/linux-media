Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2380AC10F00
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 00:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0B1F2147A
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 00:35:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dCkSHuqD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729238AbfCYAfs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Mar 2019 20:35:48 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39454 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729182AbfCYAfs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Mar 2019 20:35:48 -0400
Received: by mail-lj1-f193.google.com with SMTP id l7so6249900ljg.6;
        Sun, 24 Mar 2019 17:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VVcpEikfavp7o3/zPNhsZuUbJZE00gtSshpha6Y1Jok=;
        b=dCkSHuqDzjkslP1Ri+bLBDyc9aOTHjR3vxvE8iDQNPDiPQ1I5VrmdjKYRx8VcJQ3In
         9VxJqNdOgHb9I1n9hQyWp1l7Yf/9/J2H36yrKV7IEYMd6P0NvyZ7lY7DikZLTsHuXZ7W
         BiGRHhh/nbYRArOWfH/HTf2VmJ4VZtuKvx6lIBaARgmzDOXdqY3l0j6N1FAk2drhmd2H
         6725Rv8L+hM54kBq2/W9jovrPQXbdxl12Cx13vMOMETFDjFLuD6sN10y3xxChKEhGrtG
         dnu4zjHKl5JlWFzYLoTx2r8o1xJQ/nxKE6JUJC8+zU+CN6bo3YtZjhpYGWIoEP/AlhAZ
         Y5yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VVcpEikfavp7o3/zPNhsZuUbJZE00gtSshpha6Y1Jok=;
        b=IRfvkLyXdKUwd2TfYho7g0YGylJbVa0PN9UiovDS02pSys00iimHig5uhrsgpCpDK7
         W1WJ5Y279xQIjNGvp0zk+wD166qkHHqCXtMqfNrflmUpWP5YRtudekOk7nZKIhDtNH00
         Hss+GcRjtoYQqSD/aLmt9895lRrIo1LJyCc+sGRWxTDefu+nguZ3H6e1AypjHCF6Ochn
         yHEo0hogxHpOvoiztnBs2a6SeWimhNxOrAirsMB7ok7i03zW7Bgg+DT94SpEJ2iTqgXo
         yXaH2TCxzqnrXC55W3SRoxbMRwuCledYxm3iv8xM9DEy7Q0hC1m4RebFGTFMl1dYVX79
         Gwvg==
X-Gm-Message-State: APjAAAVrW4hryo4jNfg82/bLneWXu8pafNXttpYwKWR3k/WQgxpPcU7w
        jf4BArGcrojX1XT11pYxY40=
X-Google-Smtp-Source: APXvYqxO+OBnABcmobxfooN5Pcn+H9nJd0nKS1OeECP4NobJ12vHW/bm6htW4FdOBBzKPReXS605cg==
X-Received: by 2002:a2e:9b13:: with SMTP id u19mr8814990lji.134.1553474145742;
        Sun, 24 Mar 2019 17:35:45 -0700 (PDT)
Received: from z50.gdansk-morena.vectranet.pl (109241207190.gdansk.vectranet.pl. [109.241.207.190])
        by smtp.gmail.com with ESMTPSA id y17sm1217993ljd.54.2019.03.24.17.35.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Mar 2019 17:35:45 -0700 (PDT)
From:   Janusz Krzysztofik <jmkrzyszt@gmail.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>
Subject: [PATCH 1/2] media: ov6650: Move v4l2_clk_get() to ov6650_video_probe() helper
Date:   Mon, 25 Mar 2019 01:35:00 +0100
Message-Id: <20190325003501.14687-2-jmkrzyszt@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190325003501.14687-1-jmkrzyszt@gmail.com>
References: <20190325003501.14687-1-jmkrzyszt@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

In preparation for adding asynchronous subdevice support to the driver,
don't acquire v4l2_clk from the driver .probe() callback as that may
fail if the clock is provided by a bridge driver which may be not yet
initialized.  Move the v4l2_clk_get() to ov6650_video_probe() helper
which is going to be converted to v4l2_subdev_internal_ops.registered()
callback, executed only when the bridge driver is ready.

Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
---
 drivers/media/i2c/ov6650.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/media/i2c/ov6650.c b/drivers/media/i2c/ov6650.c
index c33fd584cb44..f10b8053ed73 100644
--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -810,9 +810,16 @@ static int ov6650_video_probe(struct i2c_client *client)
 	u8		pidh, pidl, midh, midl;
 	int		ret;
 
+	priv->clk = v4l2_clk_get(&client->dev, NULL);
+	if (IS_ERR(priv->clk)) {
+		ret = PTR_ERR(priv->clk);
+		dev_err(&client->dev, "v4l2_clk request err: %d\n", ret);
+		return ret;
+	}
+
 	ret = ov6650_s_power(&priv->subdev, 1);
 	if (ret < 0)
-		return ret;
+		goto eclkput;
 
 	/*
 	 * check and show product ID and manufacturer ID
@@ -847,6 +854,11 @@ static int ov6650_video_probe(struct i2c_client *client)
 
 done:
 	ov6650_s_power(&priv->subdev, 0);
+	if (ret) {
+eclkput:
+		v4l2_clk_put(priv->clk);
+	}
+
 	return ret;
 }
 
@@ -989,18 +1001,9 @@ static int ov6650_probe(struct i2c_client *client,
 	priv->code	  = MEDIA_BUS_FMT_YUYV8_2X8;
 	priv->colorspace  = V4L2_COLORSPACE_JPEG;
 
-	priv->clk = v4l2_clk_get(&client->dev, NULL);
-	if (IS_ERR(priv->clk)) {
-		ret = PTR_ERR(priv->clk);
-		goto eclkget;
-	}
-
 	ret = ov6650_video_probe(client);
-	if (ret) {
-		v4l2_clk_put(priv->clk);
-eclkget:
+	if (ret)
 		v4l2_ctrl_handler_free(&priv->hdl);
-	}
 
 	return ret;
 }
-- 
2.19.2

