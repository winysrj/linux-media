Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23DDFC67839
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 15:39:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DECF720870
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 15:39:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bzrctfXG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DECF720870
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729224AbeLMPjU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 10:39:20 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:40257 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729197AbeLMPjU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 10:39:20 -0500
Received: by mail-lf1-f67.google.com with SMTP id v5so1895177lfe.7
        for <linux-media@vger.kernel.org>; Thu, 13 Dec 2018 07:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vNAtbq0HBKRMbj1l8aQgmHBF0xlSjnrrrDOeFy2T1SU=;
        b=bzrctfXGH4L8AD2VzKQUWq4iU8RjFJdVVXZBAgBeUWXBDsIPUMvjOm+K8z/9uOo0BY
         VanQStPjzMCwY3Vs317V+AN8l8nMVwBgBm3wvShcbz+xaaWB4hf8fUerEXoyOr2K9kYa
         c4BTdKGZBN5gP+eEIGMr/65wQVjRd/S+Go0ABR9gsQ12AU5d9dOz4OWiv84PedAo5cz7
         mLq36xC+yLKbF51fGyBZvuuTEcvSBbs1gSVypBx3OCMiUrVBHHAYnoJzQVrlwDwAxUle
         jwkrrpKIl1uSeIjgwYX3TzX8yaBjZHOcWoSo86ig82Uj7nrTczhUEDq/6H2k0yv7N7qg
         /hfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vNAtbq0HBKRMbj1l8aQgmHBF0xlSjnrrrDOeFy2T1SU=;
        b=oJQuBQsPbbuhsr5S21CK1dgDZKrzL4rcx/NlqMdB+JRUMpSrHwtCg3WuWeTzSLUuav
         ADc8LGM4B3GZVI/o5apxbjXKhS7L0NqopJFknxt0o+AlqiAsfvstJM3z/FEQK6lSr2VS
         riyo6P66KpHYUBcvwfCe0rgNCWIOAvGBNW9oqgpGA7wAbqU8Lh0+8tuzwKrOO4eBi718
         84AMHz+YM61+q1guAXJZNkg7kYyflTpfd1VqXLm8qt5HTgpoMXOiEQneqSFVtZYy3ud7
         AwrV+Pabg3eKIHSIibR7JzApAZXH6ByFuTCauHO6NTREMQrcAiHE0bNDyseliOYsQa0M
         +SmA==
X-Gm-Message-State: AA+aEWbikVsuy0/PmAfl27puJsaKQUiYXPasQorc3kS8cwhmyqjAaSwE
        VsBawsQ+kZ8lohjS8n1Ln7U=
X-Google-Smtp-Source: AFSGD/XhxVyfam/n/j7swVpTHENvTbgyWrjFmTzwYNBu/kWduYsSeOVCt+9Jpx9V3PS8H+Y9OPrwCA==
X-Received: by 2002:a19:7111:: with SMTP id m17mr943408lfc.64.1544715557517;
        Thu, 13 Dec 2018 07:39:17 -0800 (PST)
Received: from kontron.lan (2001-1ae9-0ff1-f191-41f2-812a-df1c-0485.ip6.tmcz.cz. [2001:1ae9:ff1:f191:41f2:812a:df1c:485])
        by smtp.gmail.com with ESMTPSA id q67sm412869lfe.19.2018.12.13.07.39.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Dec 2018 07:39:17 -0800 (PST)
From:   petrcvekcz@gmail.com
X-Google-Original-From: petrcvekcz.gmail.com
To:     hans.verkuil@cisco.com, jacopo@jmondi.org, mchehab@kernel.org,
        marek.vasut@gmail.com
Cc:     Petr Cvek <petrcvekcz@gmail.com>, linux-media@vger.kernel.org,
        robert.jarzmik@free.fr, slapin@ossfans.org,
        philipp.zabel@gmail.com, sakari.ailus@iki.fi
Subject: [PATCH v3 8/8] media: i2c: ov9640: fix missing error handling in probe
Date:   Thu, 13 Dec 2018 16:39:19 +0100
Message-Id: <95729cb49c520310674050678a94773d665587c7.1544713575.git.petrcvekcz@gmail.com>
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

Control handlers registration lacked error path with
v4l2_ctrl_handler_free() call. Fix it by using goto to alread existing
v4l2_ctrl_handler_free() call.

Signed-off-by: Petr Cvek <petrcvekcz@gmail.com>
---
 drivers/media/i2c/ov9640.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ov9640.c b/drivers/media/i2c/ov9640.c
index 9739fa8d433a..c183273fd332 100644
--- a/drivers/media/i2c/ov9640.c
+++ b/drivers/media/i2c/ov9640.c
@@ -710,14 +710,18 @@ static int ov9640_probe(struct i2c_client *client,
 			V4L2_CID_VFLIP, 0, 1, 1, 0);
 	v4l2_ctrl_new_std(&priv->hdl, &ov9640_ctrl_ops,
 			V4L2_CID_HFLIP, 0, 1, 1, 0);
+
+	if (priv->hdl.error) {
+		ret = priv->hdl.error;
+		goto ectrlinit;
+	}
+
 	priv->subdev.ctrl_handler = &priv->hdl;
-	if (priv->hdl.error)
-		return priv->hdl.error;
 
 	priv->clk = v4l2_clk_get(&client->dev, "mclk");
 	if (IS_ERR(priv->clk)) {
 		ret = PTR_ERR(priv->clk);
-		goto eclkget;
+		goto ectrlinit;
 	}
 
 	ret = ov9640_video_probe(client);
@@ -733,7 +737,7 @@ static int ov9640_probe(struct i2c_client *client,
 
 eprobe:
 	v4l2_clk_put(priv->clk);
-eclkget:
+ectrlinit:
 	v4l2_ctrl_handler_free(&priv->hdl);
 
 	return ret;
-- 
2.20.0

