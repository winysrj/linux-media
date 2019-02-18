Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D270CC43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 19:29:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3539217F5
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 19:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550518154;
	bh=chQadpGw1kFyDUpEXlLGOsPNg4qKTpxeeiDhcxpL3aA=;
	h=From:Cc:Subject:Date:In-Reply-To:References:To:List-ID:From;
	b=rv95L4HPZuFuNXThw+JfBr84WulLLmJ7/2F3prESRiySoIugQFw4wKcfrDrb35VWk
	 8xIY39cHJuqrG2JjAhO0OSkQm5CtaCjvjvEsR1ZGjqCI14C4XVMNpjZ14cHxiIYhNE
	 DaFAtt9uiqmlyz987l5Is/MqML+sOb/YDGeLW/EY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbfBRT3O (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 14:29:14 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34210 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbfBRT3N (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 14:29:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CQUweSS7cuHyLUcvBrD0b8JCHGpjnQrkcJjMezwu/zw=; b=kznVpAl9LUDlI+U3UZXkUz9ItW
        1Ua5VYGWLC0o60/FH4UGfYPDPbipeTa4rjDNx73pW8ekFdxgDhP1ICYdgZwF04tuyTRK4DT1HeMoc
        jHp3qryYgpzHA/jxZaRs3O+xyXNUnXNEMeS8L230u1+rj9/pr0P4ocjioeqMI9QB2mDBYmqJNKv2x
        0mV3gtD/w6MPAh33NTx0LlbzRcQVIk9Kek2QysqkvR4UBHBxSRIzc4PJ2XSXp2DZz68+tC1UHqSKf
        ZURYAwfsLKbozYzA5XiYY1bqhluN0LbYAZMme0iQ8wPG6G3Ig+oCmbPciaziCjsiBBBTRb+m0owb/
        PaZXlpFw==;
Received: from 177.96.194.24.dynamic.adsl.gvt.net.br ([177.96.194.24] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gvobJ-0002Uj-6U; Mon, 18 Feb 2019 19:29:13 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gvobG-0006fe-7o; Mon, 18 Feb 2019 14:29:10 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 02/14] media: radio: fix several typos
Date:   Mon, 18 Feb 2019 14:28:56 -0500
Message-Id: <59a23a52caaee4c7d69856cf94ac1b3c4b596679.1550518128.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <f235ba60b2b7e5fba09d3c6b0d5dbbd8a86ea9b9.1550518128.git.mchehab+samsung@kernel.org>
References: <f235ba60b2b7e5fba09d3c6b0d5dbbd8a86ea9b9.1550518128.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Use codespell to fix lots of typos over frontends.

Manually verified to avoid false-positives.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/radio/radio-si476x.c | 2 +-
 drivers/media/radio/wl128x/fmdrv.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/radio/radio-si476x.c b/drivers/media/radio/radio-si476x.c
index 269971145f88..0261f4d28f16 100644
--- a/drivers/media/radio/radio-si476x.c
+++ b/drivers/media/radio/radio-si476x.c
@@ -1550,7 +1550,7 @@ static int si476x_radio_probe(struct platform_device *pdev)
 
 	rval = si476x_radio_init_debugfs(radio);
 	if (rval < 0) {
-		dev_err(&pdev->dev, "Could not creat debugfs interface\n");
+		dev_err(&pdev->dev, "Could not create debugfs interface\n");
 		goto exit;
 	}
 
diff --git a/drivers/media/radio/wl128x/fmdrv.h b/drivers/media/radio/wl128x/fmdrv.h
index 1ff2eec4ed52..4c0d13539988 100644
--- a/drivers/media/radio/wl128x/fmdrv.h
+++ b/drivers/media/radio/wl128x/fmdrv.h
@@ -133,7 +133,7 @@ struct fm_rds {
 /*
  * Current RX channel Alternate Frequency cache.
  * This info is used to switch to other freq (AF)
- * when current channel signal strengh is below RSSI threshold.
+ * when current channel signal strength is below RSSI threshold.
  */
 struct tuned_station_info {
 	u16 picode;
@@ -228,7 +228,7 @@ struct fmdev {
 	struct fm_rx rx;	/* FM receiver info */
 	struct fmtx_data tx_data;
 
-	/* V4L2 ctrl framwork handler*/
+	/* V4L2 ctrl framework handler*/
 	struct v4l2_ctrl_handler ctrl_handler;
 
 	/* For core assisted locking */
-- 
2.20.1

