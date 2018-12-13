Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 216CDC65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 15:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA4DC20870
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 15:39:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C2CTy8sq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA4DC20870
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729208AbeLMPjQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 10:39:16 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45988 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729197AbeLMPjP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 10:39:15 -0500
Received: by mail-lj1-f194.google.com with SMTP id s5-v6so2133916ljd.12
        for <linux-media@vger.kernel.org>; Thu, 13 Dec 2018 07:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iA3kX9RDiY8CP1jDVJ1yKbjOQfoYKGDq1F39dMsEmn8=;
        b=C2CTy8sqiRNin2XutxCxQxVpg0VDYg2dTHU05GpgzllL/jMa0ODnE3Z5isTAMjar04
         jiBBTYDtKdwG0ZfmjRLG1ZE4FHWmyPRdGk0tGpWufKFhgz7WTu2+sRxHhHciTGek/QE0
         N1IgPzK/QZhpSTEQpmOA3KmWztAY5S5IbSsqKLoLdvrfTMpaYZ1mJB+6F8wvVUl3IC2j
         T7CLxnhlOSngXMPiKiAR5egpVM7/RKFug46TP4l1ZCiLffFu3VLZkK8AA0oPbIzJaLsx
         rKVt8Rw3P7J+o2+7MlLWL0vdu25Vxzv8FlE8PUFAavDtNi96nMK3pnyPQ6giaZbgHmap
         6eCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iA3kX9RDiY8CP1jDVJ1yKbjOQfoYKGDq1F39dMsEmn8=;
        b=i4Kc7Wzc/Su/00/MvE7FLOA8js6e9n6AeV8osT8KdPWWZsxSbNB020QuOjaxtgPk0h
         BIKg5XU+ogttEY0rLmTZpevAAwRwJJ0FRE3Ec/Lhl+bdv3qlDxLPYJQn8n59KmTWd+Vm
         bAzx5EUIw9PQ6KP+JoMc+gK8gUocmEUytLLyMAPH72cgTdc23m0ipJcAhtDwG311gbfN
         mlvMbYWDkvmB5KaeW6q5oNDNRaciT2RiODLxk6KzLfb09kmqqET7QRV0D60ktD6sYFAh
         7WDzgkt4Il1BvHJx5HkXbNTQzRfxQR+/gmvJp6WrHM2+6hcZhj0ZzJNUjQavTvhcPlyA
         EFGQ==
X-Gm-Message-State: AA+aEWaffccSfPUURnXRDYv3Gd2ZcoW9FgUpHqpTo0hv9ViwfRlUBDN/
        TIbzT4t336NQBnSJDvLpOOY=
X-Google-Smtp-Source: AFSGD/W9fEA5FhgHFHd6U/fWT63x6kiIPZ3qq0yWyhZls0CRRznHKEwY3NvfasC3FTgR4u2A2QsJIw==
X-Received: by 2002:a2e:3012:: with SMTP id w18-v6mr12786990ljw.75.1544715553700;
        Thu, 13 Dec 2018 07:39:13 -0800 (PST)
Received: from kontron.lan (2001-1ae9-0ff1-f191-41f2-812a-df1c-0485.ip6.tmcz.cz. [2001:1ae9:ff1:f191:41f2:812a:df1c:485])
        by smtp.gmail.com with ESMTPSA id q67sm412869lfe.19.2018.12.13.07.39.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Dec 2018 07:39:13 -0800 (PST)
From:   petrcvekcz@gmail.com
X-Google-Original-From: petrcvekcz.gmail.com
To:     hans.verkuil@cisco.com, jacopo@jmondi.org, mchehab@kernel.org,
        marek.vasut@gmail.com
Cc:     Petr Cvek <petrcvekcz@gmail.com>, linux-media@vger.kernel.org,
        robert.jarzmik@free.fr, slapin@ossfans.org,
        philipp.zabel@gmail.com, sakari.ailus@iki.fi
Subject: [PATCH v3 6/8] media: i2c: ov9640: add space before return for better clarity
Date:   Thu, 13 Dec 2018 16:39:17 +0100
Message-Id: <dfe1085ed122edd83717da20f2d91db893225ccb.1544713575.git.petrcvekcz@gmail.com>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <cover.1544713575.git.petrcvekcz@gmail.com>
References: <cover.1544713575.git.petrcvekcz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Petr Cvek <petrcvekcz@gmail.com>

Some returns were adjoined to unrelated code blocks. This patch adds
a space inbetween.

Signed-off-by: Petr Cvek <petrcvekcz@gmail.com>
---
 drivers/media/i2c/ov9640.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/i2c/ov9640.c b/drivers/media/i2c/ov9640.c
index 08f3f8247759..2839aa3b4fb4 100644
--- a/drivers/media/i2c/ov9640.c
+++ b/drivers/media/i2c/ov9640.c
@@ -286,6 +286,7 @@ static int ov9640_s_ctrl(struct v4l2_ctrl *ctrl)
 							OV9640_MVFP_H, 0);
 		return ov9640_reg_rmw(client, OV9640_MVFP, 0, OV9640_MVFP_H);
 	}
+
 	return -EINVAL;
 }
 
@@ -341,6 +342,7 @@ static int ov9640_s_power(struct v4l2_subdev *sd, int on)
 		usleep_range(1000, 2000);
 		gpiod_set_value(priv->gpio_power, 0);
 	}
+
 	return ret;
 }
 
@@ -545,6 +547,7 @@ static int ov9640_set_fmt(struct v4l2_subdev *sd,
 		return ov9640_s_fmt(sd, mf);
 
 	cfg->try_fmt = *mf;
+
 	return 0;
 }
 
@@ -556,6 +559,7 @@ static int ov9640_enum_mbus_code(struct v4l2_subdev *sd,
 		return -EINVAL;
 
 	code->code = ov9640_codes[code->index];
+
 	return 0;
 }
 
@@ -731,6 +735,7 @@ static int ov9640_probe(struct i2c_client *client,
 	v4l2_clk_put(priv->clk);
 eclkget:
 	v4l2_ctrl_handler_free(&priv->hdl);
+
 	return ret;
 }
 
-- 
2.20.0

