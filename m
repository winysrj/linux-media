Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9643C6783B
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 16:00:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DFCC2087F
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 16:00:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ulr2KfWU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7DFCC2087F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbeLJQAo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 11:00:44 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42218 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728187AbeLJQAo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 11:00:44 -0500
Received: by mail-ed1-f66.google.com with SMTP id j6so9895642edp.9;
        Mon, 10 Dec 2018 08:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GqU6pNUYHzxH0die0BGgLenfoTDN7Hdqraqi7UbiBCk=;
        b=ulr2KfWUGYfp1gopJtubeiG/rRJYXrJou/ve8pKpplKT4DPdszhVRLEmJLWYPkIWiY
         8Hd93RDE33ZDr1rGacIQLPxqo3I4k3IX4O57PtB5SRZJqtl8UTIt9JzZjT4QQUmo12U4
         Y61H58FZ+3huvR/KOJK3Eea1psyQ80BcUfSLjZEEPQbjrkQIZ4uIrReImdLGI7l4faDm
         zX25+wdoR/kV+ltxbWahpDbNHWTY6bscu2r6pIhpMVRafkye218IqQfu3L7NlXvky4I5
         CPkXH+HCbRR08oH4xsrvDagBDIhnmxEmyUF4uFZ+GvsZqPYnWfkLuFYgpQJftiOWstsw
         tVXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GqU6pNUYHzxH0die0BGgLenfoTDN7Hdqraqi7UbiBCk=;
        b=aB7ZuIltIFldz0SH0tUpwxXBTV1YK7SBKNdRQoCk3zj+afjAOHFgTCom26t2K62kaC
         m4tVC696z5SmyqcA8cjUudr3d0JHH3anLivsotl1nC5caTPFBYhUWZjqeN0a++YvVXV2
         q4K5Xtt86Zpri56A80UWmB6kE+SndHWuhBcWPxvwihMxVJGQ/65fr0a7faFhRhz23JWQ
         cGDsk4HtCg0Mxmam/1hYtLjkxDFI8VE33EzdpodaDki1i6rld0qPLEGE4pJjRd9x+7ih
         S6w/JT6019xCfUtsP9opAfmsYxBIMAc0XsfzUVRyoNUa44BSt9pdlRFIo4oIvP+IyPIt
         WEoA==
X-Gm-Message-State: AA+aEWZnasjT9NvJlJay+S3F8u/AsgJN/ZWvSuVypc29i7AePAvB1dCY
        eOyRAx4rIxZczfG4AVvXTZw6qhVa
X-Google-Smtp-Source: AFSGD/UZs8JV0ggIBTSvS5AGRonhjUujHmRxFapbeicFavKW97DYS72BtE8Wj7JojXclE3W0kbvAgQ==
X-Received: by 2002:a17:906:2555:: with SMTP id j21-v6mr10105836ejb.103.1544457642452;
        Mon, 10 Dec 2018 08:00:42 -0800 (PST)
Received: from localhost (pD9E51040.dip0.t-ipconnect.de. [217.229.16.64])
        by smtp.gmail.com with ESMTPSA id p30sm3474182eda.68.2018.12.10.08.00.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 10 Dec 2018 08:00:41 -0800 (PST)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH 2/2] media: tegra-cec: Export OF device ID match table
Date:   Mon, 10 Dec 2018 17:00:38 +0100
Message-Id: <20181210160038.16122-2-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181210160038.16122-1-thierry.reding@gmail.com>
References: <20181210160038.16122-1-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Exporting the OF device ID match table allows udev to automatically load
the module upon receiving an "ADD" uevent for the CEC controller device.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/media/platform/tegra-cec/tegra_cec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/tegra-cec/tegra_cec.c b/drivers/media/platform/tegra-cec/tegra_cec.c
index 8a1e10d008d0..4e9f91528f77 100644
--- a/drivers/media/platform/tegra-cec/tegra_cec.c
+++ b/drivers/media/platform/tegra-cec/tegra_cec.c
@@ -476,6 +476,7 @@ static const struct of_device_id tegra_cec_of_match[] = {
 	{ .compatible = "nvidia,tegra194-cec", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, tegra_cec_of_match);
 
 static struct platform_driver tegra_cec_driver = {
 	.driver = {
-- 
2.19.1

