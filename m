Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B399C282C0
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 10:40:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B4F720861
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 10:40:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="PgciD2XA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbfAWKkk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 05:40:40 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55100 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727439AbfAWKk1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 05:40:27 -0500
Received: by mail-wm1-f68.google.com with SMTP id a62so1461065wmh.4
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2019 02:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tLwvGwMa/nYthJwEagIIh9pYKQ7nxE//zSavTLSwxqs=;
        b=PgciD2XAnjoYAVFI0Ezfvd+lZ3hiJQlILmgi4f860imXajRKr5UvZnsojJ8Hhu7hG1
         pDI/Bt1cYQb8VHiO5GP81jmUP7dsPpeQUiQO3SYpoGRceLBZNYxYlgc8+6rAcDGwcRat
         03Rs7jwJiivf39ncCd/zSjlctWXHug5AsfVds=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tLwvGwMa/nYthJwEagIIh9pYKQ7nxE//zSavTLSwxqs=;
        b=GqJ+L2JYYPF1A6AyWDoSSIfasSK9BxDL507EtWiYBDE4JCSnz99frTNuke2eeMsOFf
         8KdhODnduusBUsTmlk3cIxQHK/Ye7OdevXS+qPa9O3pAoBTOTLQw9vcg64FA4/y9Dv3s
         colAa9C9ZMYNJa6SdikG4wTK73c/bkiis3hotCxxGoNZX0amWvqODeOLn1vNqUuNmwg7
         UINclMBed9+cBvUzTVCgk/I65w+gJSNPj+m1HF630NpjI6LpSRkp345JXZpdXXt9eyoe
         Z25L1NfoTBVvvYqJiBitBoMxZ8cwvhSOg8Oc7jzfHuLwvitaot6yiWHEtnnP+zKbSpoL
         3zgg==
X-Gm-Message-State: AJcUukeqMN0+Sm1FUJ7HGuTOQdDG6A9W1uI2dhw+fuOwb3TsZhD/1SoM
        aLhCL7HRwTwTkaM51HD2LQi6F3PBXGM=
X-Google-Smtp-Source: ALg8bN7JTPs5KQOTuBroB323jZvj7ed1iOmVujqeuSg+GPsBvGzNQMovhpTdWqj37/cMpfVZYh9Qfg==
X-Received: by 2002:a1c:2314:: with SMTP id j20mr2162162wmj.142.1548240025471;
        Wed, 23 Jan 2019 02:40:25 -0800 (PST)
Received: from localhost.localdomain ([37.157.136.206])
        by smtp.gmail.com with ESMTPSA id b18sm84525211wrw.83.2019.01.23.02.40.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Jan 2019 02:40:25 -0800 (PST)
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
Subject: [PATCH v2 3/4] venus: core: correct frequency table for sdm845
Date:   Wed, 23 Jan 2019 12:39:48 +0200
Message-Id: <20190123103949.13496-4-stanimir.varbanov@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190123103949.13496-1-stanimir.varbanov@linaro.org>
References: <20190123103949.13496-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This corrects clock frequency table rates to be in sync
with video clock controller frequency table.

Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
Tested-by: Alexandre Courbot <acourbot@chromium.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index d95185ea32c3..739366744e0f 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -465,10 +465,12 @@ static const struct venus_resources msm8996_res = {
 };
 
 static const struct freq_tbl sdm845_freq_table[] = {
-	{ 1944000, 380000000 },	/* 4k UHD @ 60 */
-	{  972000, 320000000 },	/* 4k UHD @ 30 */
-	{  489600, 200000000 },	/* 1080p @ 60 */
-	{  244800, 100000000 },	/* 1080p @ 30 */
+	{ 3110400, 533000000 },	/* 4096x2160@90 */
+	{ 2073600, 444000000 },	/* 4096x2160@60 */
+	{ 1944000, 404000000 },	/* 3840x2160@60 */
+	{  972000, 330000000 },	/* 3840x2160@30 */
+	{  489600, 200000000 },	/* 1920x1080@60 */
+	{  244800, 100000000 },	/* 1920x1080@30 */
 };
 
 static const struct venus_resources sdm845_res = {
-- 
2.17.1

