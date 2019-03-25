Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BD21C4360F
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 00:21:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6499020896
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 00:21:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CuBMbl0Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbfCYAVe (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Mar 2019 20:21:34 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42277 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729195AbfCYAVe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Mar 2019 20:21:34 -0400
Received: by mail-lj1-f195.google.com with SMTP id v22so6225235lje.9;
        Sun, 24 Mar 2019 17:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zb4WUz8SUAA1BJCmhgFbxG1PUWXncRJQ2t7FG+GNPic=;
        b=CuBMbl0ZI4oyGtzRqCCOa1f1d/x+zZaZcRnc0utjQACGflg7wp3Poy7CcqMjJlf83k
         /sL3wmoWdgz0qbrI67fmESN5xii5v2tdBgNKtupwcDcKCUiLdEH2/g5hf1Z29Vqsw/sL
         iCP2H6/tTYuBRMs9IGDAMoPYHvENcEjNhBRTQO8TbJ9gejxs7M2MaZE6bd+7AsTAd2jT
         ZSkbS6/lvmvDcJmg9KvqbF1egSWmA23YM33aiDKbqEJnCF0coSSK7HxcFipoyJ3vWYFQ
         aaqudq4WUQxylBd6TtgBdKBl5bjXYAqU3MjuMPgGQff2ZWZo82w9FwQ1u9XcgW+Qi3wC
         kcVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zb4WUz8SUAA1BJCmhgFbxG1PUWXncRJQ2t7FG+GNPic=;
        b=W5Q7mdiIQui38DbFnZ27vQuOi3PFXhsYmgVOONueVQeF0cRUnypHST96XXYyyY60Eq
         eOmc+oIcj2gPuEUnXOriLxpFAB4uRmLwP7ZFgSVijsn6M7vBVF3k5p+XHGoxYHMEMML1
         Qrrv0f/9+CftHfR9/s3xsMY34VgWHK5+2yXAobhq1rLL4wIwegcTl8k200ROflUbcdtz
         m4mLGGHAWyUgMXcx9Gur4tkOj/rhyaNoZm7ulDc+EigwmThZ98xbmGvEtjkFXCArSUcG
         8C+XI+6THeed/+GkkFOFx1ZOaVmjyMGa8paKbpg3huiZW1ctr2NyM/0GOnA+CKtr8wt2
         Rc7g==
X-Gm-Message-State: APjAAAWXLhgHmjpJKyIJLvX3CxckmCGPJA2zE7Sd1nYir0hSqmoe++JY
        Th6zhBdhEHdf3ORfqeRev3U=
X-Google-Smtp-Source: APXvYqxoDxK4vGxbFzhXN2KKzRsw/5DeeBwxe6kd4orMlnfDu6/dwSD8FmEha518ro9uzJgn3f0P1w==
X-Received: by 2002:a2e:97d3:: with SMTP id m19mr11491968ljj.63.1553473291799;
        Sun, 24 Mar 2019 17:21:31 -0700 (PDT)
Received: from z50.gdansk-morena.vectranet.pl (109241207190.gdansk.vectranet.pl. [109.241.207.190])
        by smtp.gmail.com with ESMTPSA id r9sm3114637lff.83.2019.03.24.17.21.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Mar 2019 17:21:30 -0700 (PDT)
From:   Janusz Krzysztofik <jmkrzyszt@gmail.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] media: ov6650: Fix sensor possibly not detected on probe
Date:   Mon, 25 Mar 2019 01:21:12 +0100
Message-Id: <20190325002112.6920-1-jmkrzyszt@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

After removal of clock_start() from before soc_camera_init_i2c() in
soc_camera_probe() by commit 9aea470b399d ("[media] soc-camera: switch
I2C subdevice drivers to use v4l2-clk") introduced in v3.11, the ov6650
driver could no longer probe the sensor successfully because its clock
was no longer turned on in advance.  The issue was initially worked
around by adding that missing clock_start() equivalent to OMAP1 camera
interface driver - the only user of this sensor - but a propoer fix
should be rather implemented in the sensor driver code itself.

Fix the issue by inserting a delay between the clock is turned on and
the sensor I2C registers are read for the first time.

Tested on Amstrad Delta with now out of tree but still locally
maintained omap1_camera host driver.

Fixes: 9aea470b399d ("[media] soc-camera: switch I2C subdevice drivers to use v4l2-clk")
Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/media/i2c/ov6650.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/ov6650.c b/drivers/media/i2c/ov6650.c
index c33fd584cb44..f9359b11fa5c 100644
--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -814,6 +814,8 @@ static int ov6650_video_probe(struct i2c_client *client)
 	if (ret < 0)
 		return ret;
 
+	msleep(20);
+
 	/*
 	 * check and show product ID and manufacturer ID
 	 */
-- 
2.19.2

