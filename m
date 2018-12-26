Return-Path: <SRS0=4xye=PD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17119C43444
	for <linux-media@archiver.kernel.org>; Wed, 26 Dec 2018 05:58:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9DF3217D6
	for <linux-media@archiver.kernel.org>; Wed, 26 Dec 2018 05:58:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="FeLaWvn9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726001AbeLZF6p (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 26 Dec 2018 00:58:45 -0500
Received: from mta-p5.oit.umn.edu ([134.84.196.205]:40192 "EHLO
        mta-p5.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbeLZF6o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Dec 2018 00:58:44 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p5.oit.umn.edu (Postfix) with ESMTP id 31591B1B
        for <linux-media@vger.kernel.org>; Wed, 26 Dec 2018 05:58:43 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p5.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p5.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id H6UTWWxYPJg8 for <linux-media@vger.kernel.org>;
        Tue, 25 Dec 2018 23:58:43 -0600 (CST)
Received: from mail-it1-f197.google.com (mail-it1-f197.google.com [209.85.166.197])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p5.oit.umn.edu (Postfix) with ESMTPS id 00281AFF
        for <linux-media@vger.kernel.org>; Tue, 25 Dec 2018 23:58:42 -0600 (CST)
Received: by mail-it1-f197.google.com with SMTP id y86so18962250ita.2
        for <linux-media@vger.kernel.org>; Tue, 25 Dec 2018 21:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=pjMN8InkLwiFKli2b/Cz4EPEVVsHxDp2Eh2x3nLA/6g=;
        b=FeLaWvn9rzN59vD8BPGed/ZeOg7zcmod4LFV1dmNonlyZQbajGDiwuE2AJaFkOyvdF
         ZU8dlANSxqzdTNWRbfv7O1u2AzeUxT+7FRpuUFb0pJ1ZL709cdXIW7nLStIJLALdIm17
         nlnwh3Mfd40rt6URU/ic4O/hDR4Eif4BU/Kn1SFUKx5nRx6IlAlOmbvI0MvD2njFNBMB
         H48tVE68hvzGSVLlLIXI9wr2ITa77bawd1GTLwvV4zo5yytymS4Ihm4x7wdiO4ZzhQlw
         VjrBhW+pKQzni3Z94nW0yRBBCS9/1ES2Tp+BMB94p5/0DT7/VldWABBtli2Rbltycmxy
         rvOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pjMN8InkLwiFKli2b/Cz4EPEVVsHxDp2Eh2x3nLA/6g=;
        b=gmC5Y0GB2vmIDRU5r3ou6qc3vhWgTyPwMJKC6iyyNgpU3M033wW9kuhJF05hW6Pys+
         fZBtBWOOXCNv5wr96kxkbnizfwTB/BMqndCp1q5WOBVkVnHeYbsQUsjbZi+l21QbgxDH
         ged0h/SNq6JaYD72Cz4ftTw7T+XPMQOLXTu2ARDCbu593e6vNMCtEaffIUa+MhaMKcB/
         n0MwchT2CfliNbYK+WD+rQmg7rIjE65PifPo79xy/VHhuR+VxfW59dzwsh8Kaymt/7vc
         uFHpna2agiwQVG/MRL+mwOuylfop+/vRtO1NnjHe3Qi9kF59UnOfaT2LbViyV8TRgavF
         NNHg==
X-Gm-Message-State: AJcUukfUuZLSFpXu6sRrxeavJJjnOYokWr5X1CHoCoxVYJhebZEWYHOo
        txCtmyGZHx3f41Z0CxkWQNrs/mDkjT8uH2DMgj2NSelyecUlbqsOGRZ+0VaV9PGoltoqbve3sGr
        n4yGOrWB31y8qB7U3S3hG6CrzMOQ=
X-Received: by 2002:a5d:9a84:: with SMTP id c4mr13018934iom.123.1545803922651;
        Tue, 25 Dec 2018 21:58:42 -0800 (PST)
X-Google-Smtp-Source: ALg8bN4qEqYvAAz3pKaXhsO3Af40Sl7cECLpw0kkjFjWV+PPdvA0Q5J6GRNCbNT98mh/PekfK07Fbg==
X-Received: by 2002:a5d:9a84:: with SMTP id c4mr13018819iom.123.1545803917530;
        Tue, 25 Dec 2018 21:58:37 -0800 (PST)
Received: from localhost.localdomain (host-173-230-104-22.mnmigsc.mn.minneapolis.us.clients.pavlovmedia.net. [173.230.104.22])
        by smtp.gmail.com with ESMTPSA id m18sm4889121ion.78.2018.12.25.21.58.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 25 Dec 2018 21:58:36 -0800 (PST)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: dvb: check status of mxl111sf_read_reg
Date:   Tue, 25 Dec 2018 23:58:09 -0600
Message-Id: <20181226055809.74979-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

When mxl111sf_read_reg fails, we shouldn't use "mode". The fix checks
its return value using mxl_fail

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/media/usb/dvb-usb-v2/mxl111sf-phy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-phy.c b/drivers/media/usb/dvb-usb-v2/mxl111sf-phy.c
index ffb6e7c72f57..aecc3d02fc1e 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-phy.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-phy.c
@@ -130,7 +130,8 @@ int mxl111sf_config_mpeg_in(struct mxl111sf_state *state,
 	mxl_fail(ret);
 
 	/* Configure MPEG Clock phase */
-	mxl111sf_read_reg(state, V6_MPEG_IN_CLK_INV_REG, &mode);
+	ret = mxl111sf_read_reg(state, V6_MPEG_IN_CLK_INV_REG, &mode);
+	mxl_fail(ret);
 
 	if (clock_phase == TSIF_NORMAL)
 		mode &= ~V6_INVERTED_CLK_PHASE;
-- 
2.17.2 (Apple Git-113)

