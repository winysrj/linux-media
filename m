Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1ACBC43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 22:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D5AB20857
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 22:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553551427;
	bh=rj89IS6NBqMCtG0tgj9705zTQNwGHNaeKbQlFGjUaZA=;
	h=From:Cc:Subject:Date:In-Reply-To:References:To:List-ID:From;
	b=qPCjVhHR2ENW/Xdy5jC/U6eRMd9wKVmqbcSTYLeN1uqxtTSJOJ8Rrc06BnwGndogM
	 V9PXiEAd6ZpL2qyC+5eK563SBZXxyauvRVLIAOzwCIVB8uVWbzAGCf2OS76nX4OdTo
	 YwnpYvxD4YCvn8JRu0Y7QSUoQRHdDWgYQpQ6KgxU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730599AbfCYWDq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 18:03:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54904 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730239AbfCYWDm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 18:03:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8VVRBoSZaHcx+Icp5Vi++XQ8nBFddv1snNBVIo4konU=; b=Iz4j6C2sVemHUewI0E5Aw94XJV
        cQGpZtcJ9Fw+TN9qySMhsdetqPnjMbPZBZn+CGREaMH2gC0ItGvg7f3obBgan0IoAS1YYaOpTs2cQ
        sNijvnSRKht/NrJ0NfmFCbZ27RQlhZrrXr0iDmT9GgrySNdL949PliWkMqvvLZbygteJK1yN9/MRW
        ECW7ONLquSNWw8+ZTw7kClJItd3B5AxMKsVMIfksrZ/S/juVotghRgTDQ5a+no2WcYNI9Xp6sQV1m
        zup8hYoogEJvslVsYH9IblRZ7oWtMd1LoTb5JITXUYqW2QEWi+rVPsIBmg3RD+xpzTCKn5km8s1nQ
        KkRWeDDA==;
Received: from 177.41.113.24.dynamic.adsl.gvt.net.br ([177.41.113.24] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h8Xh0-0001YH-AV; Mon, 25 Mar 2019 22:03:42 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1h8Xgw-0001ax-KH; Mon, 25 Mar 2019 18:03:38 -0400
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Andy Gross <andy.gross@linaro.org>,
        David Brown <david.brown@linaro.org>,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 5/5] media: hfi_parser: don't trick gcc with a wrong expected size
Date:   Mon, 25 Mar 2019 18:03:37 -0400
Message-Id: <ded716267196862809e5926072adc962a611a1e3.1553551369.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1553551369.git.mchehab+samsung@kernel.org>
References: <cover.1553551369.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Smatch warns about small size on two structs:

	drivers/media/platform/qcom/venus/hfi_parser.c:103 parse_profile_level() error: memcpy() 'proflevel' too small (8 vs 128)
	drivers/media/platform/qcom/venus/hfi_parser.c: drivers/media/platform/qcom/venus/hfi_parser.c:129 parse_caps() error: memcpy() 'cap' too small (16 vs 512)

The reason is that the hfi_parser actually expects:
    - multiple data entries on hfi_capabilities
    - multiple profile_level on hfi_profile_level_supported

However, the structs trick gcc, making it to believe that
there's just one value for each.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/qcom/venus/hfi_helper.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/hfi_helper.h b/drivers/media/platform/qcom/venus/hfi_helper.h
index 15804ad7e65d..34ea503a9842 100644
--- a/drivers/media/platform/qcom/venus/hfi_helper.h
+++ b/drivers/media/platform/qcom/venus/hfi_helper.h
@@ -569,7 +569,7 @@ struct hfi_capability {
 
 struct hfi_capabilities {
 	u32 num_capabilities;
-	struct hfi_capability data[1];
+	struct hfi_capability *data;
 };
 
 #define HFI_DEBUG_MSG_LOW	0x01
@@ -726,7 +726,7 @@ struct hfi_profile_level {
 
 struct hfi_profile_level_supported {
 	u32 profile_count;
-	struct hfi_profile_level profile_level[1];
+	struct hfi_profile_level *profile_level;
 };
 
 struct hfi_quality_vs_speed {
-- 
2.20.1

