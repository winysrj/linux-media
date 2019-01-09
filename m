Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07C15C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:00:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCBE620685
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:00:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nN3l1YHT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbfAISAv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 13:00:51 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:40343 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbfAISAu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 13:00:50 -0500
Received: by mail-lf1-f67.google.com with SMTP id v5so6325475lfe.7;
        Wed, 09 Jan 2019 10:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f/Exw1NcVYYqGrDV4q3XAZMtf+t2lHH10SHKVIs+s0M=;
        b=nN3l1YHTwyNvgXU5aHouPLyz5RKleujjsUrUQZNpon475ZWiOOpJhVfzvr8J8jmsyo
         4J80CT+b2kpk0JndsiBspEE2vT08vfhyAM8SZVxkeRTpqrE+fZI3qhAHWCyeCLZZXdw7
         HJuNtqnIKTOJiT+q1ZvS0vh87pBnDs8B2HWKr462Hk/xGzwy7gVb+C6tqI2j0rBi1BwK
         2WQu75lAirxUOH+Vwvou68ojYlRqFHKaRzPSJ4gRa5+5rj7DyoRX7yhttS/3hO/qz6dP
         LTPlb/LnyO6SwXkP2Xp3VgG7tsmX97plEXlJHE56QAbKQ+w2O0qvTtVSWndptRT4KCuF
         K4Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f/Exw1NcVYYqGrDV4q3XAZMtf+t2lHH10SHKVIs+s0M=;
        b=bkxAhdSPLFtfHGHMxxTAZquGM6CA9kn3Mem8ydeCGqxBZv9lvI0Z9tKShduobbKfwS
         z8HubQTJekWTA01PH/iL1tdy4ZwIlRg6v2fCvpmslRFKfcMWN2xvXR//YzY3OqyZmi/I
         tCq3OEgNnYNBN3Z67qVdnICwTz4Os/2tGWbNkByaEqWcRNfJa37QH7TEWtJ8CniCCh8k
         hKz4EKriCdUxxgOgmQaBbxp/XjBiO6Xxs8KVsyW9RDWtxemAzgXOmZ9o7hSJMyGnUkfz
         55A7GY/ASOYC6zn2b1fJD8xd/k/tMiB+F1uk3EI1ySlEDIvEa4IhG7cDB218e/9xKEBR
         HQxQ==
X-Gm-Message-State: AJcUukdW9NY5QVzPfZ1IQF8UbOwi+lmkxTd1nFD1yv2UEJ947qcApUmu
        /z07zEcjyLoxaY7o/wWtt7wzxdu8CHP5OA==
X-Google-Smtp-Source: ALg8bN5fQjwNwyGqcTdgDv8HuAV34HEznubOvmzRp6xS1BVxGJxxbr7M5qR87k+TaO5am3Uy05NqNQ==
X-Received: by 2002:a19:660a:: with SMTP id a10mr4350637lfc.146.1547056847286;
        Wed, 09 Jan 2019 10:00:47 -0800 (PST)
Received: from localhost.localdomain ([2a02:a315:5445:5300:c1c3:bc43:64cd:2432])
        by smtp.googlemail.com with ESMTPSA id p67sm13817510lfe.14.2019.01.09.10.00.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 10:00:46 -0800 (PST)
From:   =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>
To:     andrzej.p@samsung.com
Cc:     jacek.anaszewski@gmail.com, mchehab@kernel.org,
        s.nawrocki@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>
Subject: [PATCH] media: s5p-jpeg: Correct step and max values for V4L2_CID_JPEG_RESTART_INTERVAL
Date:   Wed,  9 Jan 2019 19:00:41 +0100
Message-Id: <20190109180041.31052-1-pawel.mikolaj.chmiel@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This commit corrects max and step values for v4l2 control for
V4L2_CID_JPEG_RESTART_INTERVAL. Max should be 0xffff and step should be 1.
It was found by using v4l2-compliance tool and checking result of
VIDIOC_QUERY_EXT_CTRL/QUERYMENU test.
Previously it was complaining that step was bigger than difference
between max and min.

Fixes: 15f4bc3b1f42 ("[media] s5p-jpeg: Add JPEG controls support")
Signed-off-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 3f9000b70385..33e9927db9a0 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2002,7 +2002,7 @@ static int s5p_jpeg_controls_create(struct s5p_jpeg_ctx *ctx)
 
 		v4l2_ctrl_new_std(&ctx->ctrl_handler, &s5p_jpeg_ctrl_ops,
 				  V4L2_CID_JPEG_RESTART_INTERVAL,
-				  0, 3, 0xffff, 0);
+				  0, 0xffff, 1, 0);
 		if (ctx->jpeg->variant->version == SJPEG_S5P)
 			mask = ~0x06; /* 422, 420 */
 	}
-- 
2.17.1

