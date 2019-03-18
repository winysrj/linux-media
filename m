Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 677ACC10F00
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 16:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 385C820854
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 16:40:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ncentric-com.20150623.gappssmtp.com header.i=@ncentric-com.20150623.gappssmtp.com header.b="oAD2jIYF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbfCRQkM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 12:40:12 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42540 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbfCRQkM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 12:40:12 -0400
Received: by mail-ed1-f66.google.com with SMTP id j89so14093454edb.9
        for <linux-media@vger.kernel.org>; Mon, 18 Mar 2019 09:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ncentric-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=XbpQuRzoHfQWllFRUJGEeldvpGNt+SBQiUSZFiTIsKs=;
        b=oAD2jIYFEPZebAHCeXs/B+zYh6RlM4dGkGlWvUBokoWXgX/XLX4kPU4bvIVfIJKNw7
         2Tdp8vBSHCa+mnbewHCxP1hBSkkLp/3Wm6347vHhL46vryFdDJMVI5jaSmzRkq4EQq40
         KlZm8I18fOy5kyc+vzOn80jjJGsR/O42HXCV8HEAWRqKmri3iFg65AQFJ1juMxSjRCxX
         Lb2LwEeiLzfz0ix2oZGFdhdBI9hZ6L2NkJ8J2erK9sPnICrfoJ/mHcxmpCWSCGjK5hUm
         TqF4E6K3dfW+QUVjGZhiAYL5gbS9SXln9bLZsIFKj094K1XJVI0QUfy5+2nfqknGi3cA
         kChg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=XbpQuRzoHfQWllFRUJGEeldvpGNt+SBQiUSZFiTIsKs=;
        b=nYP1XeztFKF724xCqVfI4Byja6ciOCUqBr/N3Jc7ZBUn1G5P28Q7N+cRogw1C/0J/S
         XL4J7QIPGBDGu45bTokWZ9UNl2TGOlFh4+nFfS8EyZgg+cxyl/qStk1PtpjDcb2yGUUT
         /SsP5VHthVNPuNfW0Kk4q2MRp/xkKI6oIyzrs6rS3c+yK/TDDqd7c6VCkLuoekqh92tk
         dVn8cm+amwzZ0ez7UhajqSYuuAPWD90Nt+X+CfD3N5eS7yx9m+hqZ87AZzmxupEA/EEJ
         tkD3Xj/TC57MYVEF1nt6PKgOgmxdzJ0AECUhvvDZdsppJL55qfFUnyuZjldGFYpnXnFI
         /a2g==
X-Gm-Message-State: APjAAAXzPNjdQ1qxpo+P0pC4NEv1/h6NhcTLQPYOXBC+kBd8koWntU3L
        4dTTnUnZJ/fGoZ/Yevd+8I2c3JdLCroJDWgj
X-Google-Smtp-Source: APXvYqyeNlBOi3jnxlkw4OVowRp/Mg7VX4XzJGxzT1mI+zlbTO1pTEap8IFwEibiiTqrWSWrsljrvg==
X-Received: by 2002:a17:906:5595:: with SMTP id y21mr11489592ejp.209.1552927210159;
        Mon, 18 Mar 2019 09:40:10 -0700 (PDT)
Received: from kvdp-BRIX.cmb.citymesh.com (d515300d8.static.telenet.be. [81.83.0.216])
        by smtp.gmail.com with ESMTPSA id g22sm1861828eds.77.2019.03.18.09.40.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Mar 2019 09:40:09 -0700 (PDT)
From:   Koen Vandeputte <koen.vandeputte@ncentric.com>
To:     linux-media@vger.kernel.org
Cc:     Koen Vandeputte <koen.vandeputte@ncentric.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Robin Leblon <robin.leblon@ncentric.com>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tim Harvey <tharvey@gateworks.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] media: i2c: tda1997x: select V4L2_FWNODE
Date:   Mon, 18 Mar 2019 17:40:05 +0100
Message-Id: <20190318164005.4070-1-koen.vandeputte@ncentric.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Building tda1997x fails now unless V4L2_FWNODE is selected:

drivers/media/i2c/tda1997x.o: in function `tda1997x_parse_dt'
undefined reference to `v4l2_fwnode_endpoint_parse'

While at it, also sort the selections alphabetically

Fixes: 9ac0038db9a7 ("media: i2c: Add TDA1997x HDMI receiver driver")
Signed-off-by: Koen Vandeputte <koen.vandeputte@ncentric.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Bingbu Cao <bingbu.cao@intel.com>
Cc: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Robin Leblon <robin.leblon@ncentric.com>
Cc: Rui Miguel Silva <rui.silva@linaro.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Tim Harvey <tharvey@gateworks.com>
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org # v4.17+
---
 drivers/media/i2c/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 4c936e129500..8b296ae7d68c 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -60,8 +60,9 @@ config VIDEO_TDA1997X
 	tristate "NXP TDA1997x HDMI receiver"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
 	depends on SND_SOC
-	select SND_PCM
 	select HDMI
+	select SND_PCM
+	select V4L2_FWNODE
 	---help---
 	  V4L2 subdevice driver for the NXP TDA1997x HDMI receivers.
 
-- 
2.17.1

