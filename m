Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:32868 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751125AbdFBMTR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Jun 2017 08:19:17 -0400
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v52CD3N5006345
        for <linux-media@vger.kernel.org>; Fri, 2 Jun 2017 13:19:00 +0100
Received: from mail-wm0-f69.google.com (mail-wm0-f69.google.com [74.125.82.69])
        by mx08-00252a01.pphosted.com with ESMTP id 2apwxetx0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Fri, 02 Jun 2017 13:19:00 +0100
Received: by mail-wm0-f69.google.com with SMTP id r203so16819224wmb.2
        for <linux-media@vger.kernel.org>; Fri, 02 Jun 2017 05:19:00 -0700 (PDT)
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
To: Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>
Subject: [PATCH 2/3] [media] tc358743: Setup default mbus_fmt before registering
Date: Fri,  2 Jun 2017 13:18:13 +0100
Message-Id: <77dde71a5d81ebf274b5b403b54e4086b29afc08.1496398217.git.dave.stevenson@raspberrypi.org>
In-Reply-To: <cover.1496397071.git.dave.stevenson@raspberrypi.org>
References: <cover.1496397071.git.dave.stevenson@raspberrypi.org>
In-Reply-To: <cover.1496398217.git.dave.stevenson@raspberrypi.org>
References: <cover.1496398217.git.dave.stevenson@raspberrypi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Previously the mbus_fmt_code was set after the device was
registered. If a connected sub-device called tc358743_get_fmt
prior to that point it would get an invalid code back.

Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
---
 drivers/media/i2c/tc358743.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 06bfdca..2f5763d 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1905,6 +1905,8 @@ static int tc358743_probe(struct i2c_client *client,
 	if (err < 0)
 		goto err_hdl;
 
+	state->mbus_fmt_code = MEDIA_BUS_FMT_RGB888_1X24;
+
 	sd->dev = &client->dev;
 	err = v4l2_async_register_subdev(sd);
 	if (err < 0)
@@ -1919,7 +1921,6 @@ static int tc358743_probe(struct i2c_client *client,
 
 	tc358743_s_dv_timings(sd, &default_timing);
 
-	state->mbus_fmt_code = MEDIA_BUS_FMT_RGB888_1X24;
 	tc358743_set_csi_color_space(sd);
 
 	tc358743_init_interrupts(sd);
-- 
2.7.4
