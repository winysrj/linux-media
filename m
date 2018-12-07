Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	T_DKIMWL_WL_HIGH,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53CACC64EB1
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19808214DE
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544188082;
	bh=2fJ9kciRpOk+GYSlwPi1AIx6iTRAd1R/SXzmT6Ny3Dg=;
	h=From:Cc:Subject:Date:In-Reply-To:References:To:List-ID:From;
	b=Qj149cNdp3oXNg2P6s/jeoUhOQiOPioApupOirYtpzjia6kDOl/uYlzVDP41aa37Q
	 Dd9JBLBWOVQsiMbjqegV4WtCgr4+NeVBe4CSJ0OfE1gB1OmS/aP/RB+KbfIK5uIaTu
	 KcKr7qyvI+uRCFCLharBtODPLAzFPprkuRbuJbuk=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 19808214DE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbeLGNIB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 08:08:01 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:33332 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbeLGNIA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 08:08:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mYGu2l8QdCYHQuBk0O4Sq+QGUtkkmRuGS2DOrLSjq9U=; b=m1TEadZVOvFlj5p+fsr0vmN7sH
        3Q+kQcFhPaD94czMGxPv3cUmD691zVpCbm2TdOAaLFM8ctGkCIwcFBl5WXDo285XMubv0tz93A7yE
        DZ4PAgrDGRyjtCblyzK3fc9oJ/dc6rDUXmGU8IkmjrBhHQmqElbc2IoJkDRd/hUct3oIQL9DPjyfL
        KI2Uxe1x5K9P+LA3Tmbys6wDrp54WYGa9TwaUfDuV9JPynCh0t9ow+shsbBvckn+WRAnjaQB+HIO6
        /8dVCMk281IvKHTC+U8jtbdKNta9chCb8qk28DAuK+ZwvfAWMTrN1D2MS0ecYqR7nPKn86mlv0/KC
        5/mN6WQA==;
Received: from [179.95.33.236] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVFrK-000336-Qp; Fri, 07 Dec 2018 13:07:58 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gVFrI-0004Pn-7r; Fri, 07 Dec 2018 08:07:56 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Peter Rosin <peda@axentia.se>,
        Wolfram Sang <wsa@the-dreams.de>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 2/2] media: drxk_hard: check if parameter is not NULL
Date:   Fri,  7 Dec 2018 08:07:55 -0500
Message-Id: <94488f55b92ab1567dfeaf1fffb12fecc8c0b1d0.1544188058.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <aa54ca91f2310ecea413daa289ab882cf9f37245.1544188058.git.mchehab+samsung@kernel.org>
References: <aa54ca91f2310ecea413daa289ab882cf9f37245.1544188058.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

There is a smatch warning:
	drivers/media/dvb-frontends/drxk_hard.c: drivers/media/dvb-frontends/drxk_hard.c:1478 scu_command() error: we previously assumed 'parameter' could be null (see line 1467)

Telling that parameter might be NULL. Well, it can't, due to the
way the driver works, but it doesn't hurt to add a check, in order
to shut up smatch.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/dvb-frontends/drxk_hard.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index 84ac3f73f8fe..8ea1e45be710 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -1474,9 +1474,11 @@ static int scu_command(struct drxk_state *state,
 
 	/* assume that the command register is ready
 		since it is checked afterwards */
-	for (ii = parameter_len - 1; ii >= 0; ii -= 1) {
-		buffer[cnt++] = (parameter[ii] & 0xFF);
-		buffer[cnt++] = ((parameter[ii] >> 8) & 0xFF);
+	if (parameter) {
+		for (ii = parameter_len - 1; ii >= 0; ii -= 1) {
+			buffer[cnt++] = (parameter[ii] & 0xFF);
+			buffer[cnt++] = ((parameter[ii] >> 8) & 0xFF);
+		}
 	}
 	buffer[cnt++] = (cmd & 0xFF);
 	buffer[cnt++] = ((cmd >> 8) & 0xFF);
-- 
2.19.2

