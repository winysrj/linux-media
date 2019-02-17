Return-Path: <SRS0=7VZ/=QY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85C4EC43381
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 15:18:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 532DE21A4A
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 15:18:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lel7eo2s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbfBQPSF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 17 Feb 2019 10:18:05 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36050 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfBQPSF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Feb 2019 10:18:05 -0500
Received: by mail-pl1-f195.google.com with SMTP id g9so7461797plo.3
        for <linux-media@vger.kernel.org>; Sun, 17 Feb 2019 07:18:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=TpJo/qaFhJ+02X/anyjnqKv4lS+kdfeKxuEF/bI43AI=;
        b=lel7eo2shPonbRR4m896AkmTkZHrj2Bv6EofszKgly8/c1sQ+wNFEvrdbsYdgVPmkj
         XxB5puZAd2K8uKEmlmiJ+U8bYceeYLE3mWKbyTK4zw3PQRdND+mmuXOrvdoquywTcTPh
         ihSPfpjWzQ6jXs4MoWJJYQ+/2fp7vseLkOrKFByzycrKJSugr1URrHjMBA5WV+Xx2sCo
         WXT7YIA3lj9uwzSn1CbB1uytk9s4F1TOp8rL8RR5k8/2lV/pR04/Ci/0n6E7SjJN4Zuf
         Kf3aORZvOrg7kFRUCNSUdJPEmaZHrNGsG7ErgAOBvh8P56H/OeErlLFvkIfRsXnQkCRx
         LenA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TpJo/qaFhJ+02X/anyjnqKv4lS+kdfeKxuEF/bI43AI=;
        b=l6aKDU7S+grnicsSzr/OYO0eR+eVMCtWt1RVnvX0r1WIFkBILLrAlFVX3g7+wumZWy
         vX7nO3YxJtO716EDfvIXoClILc6hYIqKFyt+jvJv2+5BaIVcpF5cDSVSqPXZxxILoHRD
         Whlt8U0jQvMD5CeSjHnNs6pGvV+WvKUaPCmjOHyrXsG1orVs8Pb1oUJXYIdogv1ZRk1Q
         R0E06/zofs9hWJysYxMgi3Hm3QePN6hG4WTu+RUeuagL1ped+4qQRjSYPQzlDwF/BLc0
         7op3iMJIJLDYvsTV3lMk4o6TwCHU2Vuwwy8EcUW0Z5xw6VLzCA3T7pmQr5fO+49laKRC
         vX6A==
X-Gm-Message-State: AHQUAuYKQx6T6o3Ex9JFO9tUMdaY6dc+20Y1k71tsbgcAxynimSA7du1
        +SurRwl5FbU5yYA8S64zPSTbfrQIcGE=
X-Google-Smtp-Source: AHgI3IbltobAVDaRik5t8OKMKjiAq7gbbEz3YejxtETTriL9gECCLyfJW2Lcmh4IfhK1/Ex7FERMUg==
X-Received: by 2002:a17:902:9683:: with SMTP id n3mr20814234plp.333.1550416684694;
        Sun, 17 Feb 2019 07:18:04 -0800 (PST)
Received: from mita-MS-7A45.lan ([240f:34:212d:1:bd2b:5443:c6c4:9b4])
        by smtp.gmail.com with ESMTPSA id w10sm11831457pgr.42.2019.02.17.07.18.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 17 Feb 2019 07:18:03 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Wenyou Yang <wenyou.yang@microchip.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH] media: ov7740: fix runtime pm initialization
Date:   Mon, 18 Feb 2019 00:17:47 +0900
Message-Id: <1550416667-9372-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The runtime PM of this device is enabled after v4l2_ctrl_handler_setup(),
and this makes this device's runtime PM usage count a negative value.

The ov7740_set_ctrl() tries to do something only if the device's runtime
PM usage counter is nonzero.

ov7740_set_ctrl()
{
	if (!pm_runtime_get_if_in_use(&client->dev))
		return 0;

	<do something>;

	pm_runtime_put(&client->dev);

	return ret;
}

However, the ov7740_set_ctrl() is called by v4l2_ctrl_handler_setup()
while the runtime PM of this device is not yet enabled.  In this case,
the pm_runtime_get_if_in_use() returns -EINVAL (!= 0).

Therefore we can't bail out of this function and the usage count is
decreased by pm_runtime_put() without increment.

This fixes this problem by enabling the runtime PM of this device before
v4l2_ctrl_handler_setup() so that the ov7740_set_ctrl() is always called
when the runtime PM is enabled.

Cc: Eugen Hristev <eugen.hristev@microchip.com>
Cc: Wenyou Yang <wenyou.yang@microchip.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
I don't have the ov7740 device, but I saw the same problem with the
mt9m001 device when I was adding the runtime PM support for it.

Eugen Hristev reported the problem with ov7740.

https://www.mail-archive.com/linux-media@vger.kernel.org/msg144540.html

I suspect that it is related to this runtime PM problem.

There seems to be the same problem in other devices.  I would like to see
if this patch actually fix the ov7740's problem and then propagate other
devices.

 drivers/media/i2c/ov7740.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov7740.c b/drivers/media/i2c/ov7740.c
index 177688a..8835b83 100644
--- a/drivers/media/i2c/ov7740.c
+++ b/drivers/media/i2c/ov7740.c
@@ -1101,6 +1101,9 @@ static int ov7740_probe(struct i2c_client *client,
 	if (ret)
 		return ret;
 
+	pm_runtime_set_active(&client->dev);
+	pm_runtime_enable(&client->dev);
+
 	ret = ov7740_detect(ov7740);
 	if (ret)
 		goto error_detect;
@@ -1123,8 +1126,6 @@ static int ov7740_probe(struct i2c_client *client,
 	if (ret)
 		goto error_async_register;
 
-	pm_runtime_set_active(&client->dev);
-	pm_runtime_enable(&client->dev);
 	pm_runtime_idle(&client->dev);
 
 	return 0;
@@ -1134,6 +1135,8 @@ static int ov7740_probe(struct i2c_client *client,
 error_init_controls:
 	ov7740_free_controls(ov7740);
 error_detect:
+	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
 	ov7740_set_power(ov7740, 0);
 	media_entity_cleanup(&ov7740->subdev.entity);
 
-- 
2.7.4

