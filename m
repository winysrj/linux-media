Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3785DC282C0
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 10:40:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 045E620861
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 10:40:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="k2xCnkOg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbfAWKkp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 05:40:45 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34977 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727430AbfAWKk0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 05:40:26 -0500
Received: by mail-wm1-f66.google.com with SMTP id t200so1473724wmt.0
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2019 02:40:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LEvH43xu7H3IGM1c03kDUGjc4dAlpCaDkOPzDBfsxYc=;
        b=k2xCnkOgsNy4I95sYTzT7qLTncbBtKlqDx2NsIdTCosKO2OW6ni291XyQDUoEK6q6Q
         Chmal0crcMWyVnG+yV16hNll4MFKYl08bSwBE7x3iZ9Qc0qsLi6djhWld7iRO6mmZBzj
         xUnqmMhYViX0haKP0U8gUKvqYsIpPMRRnoXVQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LEvH43xu7H3IGM1c03kDUGjc4dAlpCaDkOPzDBfsxYc=;
        b=m9dn3R27qEG65q4v4Rez6a1rLflsdtJpAwweHhYeX2TA7h3LpKKPk271Bl6g4wjgsU
         AtMU/gSq9pt5Khmx0QPeCqIEKka3uE4cwYLQH+X4zoF2urpM1RvKxd6rJ1eCceXqBRP6
         Cn1g8EvPIfIAbUcOLg1Obt9ULmmqpB0Ws+YTm/R8/k/a3qfzGFXmX303tR4AYrKnCEhE
         T10sfH1UHPkyiSL5mPqUfY/FWvA5l55BHFQVmHh6jCe48vlbECjD4TkkVl3UifIhKpPh
         CsJdyk+jn/HTH9HkyssRaOdxT619oMU7LTR8z5NvCFbJSjCk3+p4HomGMrglOoVr1ijc
         Ikqg==
X-Gm-Message-State: AJcUukep9dNsR34kGlGON7IX2CCGuHATrn4jtYr6iqMMsIG+H1mPc/V5
        C5whPVtpYX4WdQd76O2ellovaKGiVY4=
X-Google-Smtp-Source: ALg8bN6fxo7EYptMsaZ6Ns1NnB5dDFeBR+wOu2j7/n510v6X8d3yGQD94tLRhUZbSMF8MWriD1IOzQ==
X-Received: by 2002:a1c:4c10:: with SMTP id z16mr2266123wmf.117.1548240023984;
        Wed, 23 Jan 2019 02:40:23 -0800 (PST)
Received: from localhost.localdomain ([37.157.136.206])
        by smtp.gmail.com with ESMTPSA id b18sm84525211wrw.83.2019.01.23.02.40.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Jan 2019 02:40:23 -0800 (PST)
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
To:     linux-media@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v2 2/4] venus: core: correct maximum hardware load for sdm845
Date:   Wed, 23 Jan 2019 12:39:47 +0200
Message-Id: <20190123103949.13496-3-stanimir.varbanov@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190123103949.13496-1-stanimir.varbanov@linaro.org>
References: <20190123103949.13496-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This correct maximum hardware load constant in per SoC resources
for sdm845 aka Venus v4.

Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
Tested-by: Alexandre Courbot <acourbot@chromium.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index cb411eb85ee4..d95185ea32c3 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -455,7 +455,7 @@ static const struct venus_resources msm8996_res = {
 	.reg_tbl_size = ARRAY_SIZE(msm8996_reg_preset),
 	.clks = {"core", "iface", "bus", "mbus" },
 	.clks_num = 4,
-	.max_load = 2563200,
+	.max_load = 3110400,	/* 4096x2160@90 */
 	.hfi_version = HFI_VERSION_3XX,
 	.vmem_id = VIDC_RESOURCE_NONE,
 	.vmem_size = 0,
-- 
2.17.1

