Return-Path: <SRS0=7C2H=RS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01CB3C43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 09:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2A5921872
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 09:32:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CVZOhr/S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbfCOJch (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Mar 2019 05:32:37 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55800 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728713AbfCOJcb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Mar 2019 05:32:31 -0400
Received: by mail-wm1-f65.google.com with SMTP id 4so5731070wmf.5
        for <linux-media@vger.kernel.org>; Fri, 15 Mar 2019 02:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=lnYpdY1RvqL9G6kpqzscMSNBpa01+DuYhbiy+zc6reA=;
        b=CVZOhr/Smx8dnmAp5WnKgUwdvbARVBQO53nRixMB4xJx6o2ynLjXC5uuyEVre78K9I
         M5CbOi33w0IrvRNpd2gIGUoAcB67fNLBdM9BvBepDe+LWTFSJUvixqxlzTKxL/BKaj3l
         GE25Rt53sSoNO2+cTCXN+o4hN+iC1jHwnVNP5LKDWoMnu5q+cqUSywASR2q/By7FUK2o
         xjVVyt85EDnppnCaoZqhivE8TrOIl0XFAR8i+IzeeYymGsJKGT+7TUi/HsTMQgDuK51S
         ggv18DfxJjWZ9XccriXGeQGAqKLrWloaTKehStJxQsZ4XhCeaf+FxAu/a17p97k0rPTR
         vLvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lnYpdY1RvqL9G6kpqzscMSNBpa01+DuYhbiy+zc6reA=;
        b=reT9lzcwgpNZF2yD8JHlLvLCcHpTuFC1iqUQVF5P4Uk7pBDylllJ//urrXMtXrwSIi
         pHK3XJk3zY/QvtsWHCP/gdlJJwUbcH6BgHQyJLcMx+lUZ5RS7/ixAuYm5V+mJwDSpxaT
         g/5nOwxvj7LeLKkRMqCmEErhIuUXSOIgP05qbiF89naPoWKZCfmsALIlzmNCNdJzLbiR
         7HbKcAXOTW6yyrFCLiQOlMOcb0Eo+N/joEuXQCNB4hihQAL4wYsei6FrGCoRB5jON/Xo
         UHiRoxCZ4PkZatMlbanIcyF3bd2q32Tzt7lDF3y7qS4vp63YIAZH78jn51Qhlfih+itB
         zBdg==
X-Gm-Message-State: APjAAAV+G6xwU+pyoASOtm1G8nWI8pM2v+qkfqnu9sq5djJiKDyCAKzY
        PxsfZcSamh7t9N0xaYca6QeJwXBLGEs=
X-Google-Smtp-Source: APXvYqzTl0DrTcU5AbIb4hx5JYSMowbNVDD7JQgAL3TT2uUfFMTYeOqmL2X5N4Kxj67atccCizwQ/g==
X-Received: by 2002:a1c:b403:: with SMTP id d3mr1389069wmf.85.1552642349088;
        Fri, 15 Mar 2019 02:32:29 -0700 (PDT)
Received: from mms-0440.qualcomm.mm-sol.com ([37.157.136.206])
        by smtp.gmail.com with ESMTPSA id d10sm3640890wrh.83.2019.03.15.02.32.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Mar 2019 02:32:28 -0700 (PDT)
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
To:     linux-media@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v2] venus: hfi_parser: fix Source Matcher errors
Date:   Fri, 15 Mar 2019 11:32:07 +0200
Message-Id: <20190315093207.2730-1-stanimir.varbanov@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This fixes following two smatch errors:

hfi_parser.c:103 parse_profile_level() error: memcpy() 'proflevel'
too small (8 vs 128)

hfi_parser.c:129 parse_caps() error: memcpy() 'cap'
too small (16 vs 512)

by modifying structure members to flexible array members.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/hfi_helper.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/hfi_helper.h b/drivers/media/platform/qcom/venus/hfi_helper.h
index 15804ad7e65d..a2b95ff79c4a 100644
--- a/drivers/media/platform/qcom/venus/hfi_helper.h
+++ b/drivers/media/platform/qcom/venus/hfi_helper.h
@@ -569,7 +569,7 @@ struct hfi_capability {
 
 struct hfi_capabilities {
 	u32 num_capabilities;
-	struct hfi_capability data[1];
+	struct hfi_capability data[];
 };
 
 #define HFI_DEBUG_MSG_LOW	0x01
@@ -726,7 +726,7 @@ struct hfi_profile_level {
 
 struct hfi_profile_level_supported {
 	u32 profile_count;
-	struct hfi_profile_level profile_level[1];
+	struct hfi_profile_level profile_level[];
 };
 
 struct hfi_quality_vs_speed {
-- 
2.17.1

