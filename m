Return-Path: <SRS0=3Wpa=PB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C63C64E75
	for <linux-media@archiver.kernel.org>; Mon, 24 Dec 2018 15:38:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4C1F2173C
	for <linux-media@archiver.kernel.org>; Mon, 24 Dec 2018 15:38:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="eTYVuqPh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725765AbeLXPiv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 24 Dec 2018 10:38:51 -0500
Received: from mta-p5.oit.umn.edu ([134.84.196.205]:48086 "EHLO
        mta-p5.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbeLXPiu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Dec 2018 10:38:50 -0500
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Dec 2018 10:38:49 EST
Received: from localhost (unknown [127.0.0.1])
        by mta-p5.oit.umn.edu (Postfix) with ESMTP id 1289A5E8
        for <linux-media@vger.kernel.org>; Mon, 24 Dec 2018 15:29:17 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p5.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p5.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Fit40gHAAWjp for <linux-media@vger.kernel.org>;
        Mon, 24 Dec 2018 09:29:16 -0600 (CST)
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p5.oit.umn.edu (Postfix) with ESMTPS id D63A36D8
        for <linux-media@vger.kernel.org>; Mon, 24 Dec 2018 09:29:16 -0600 (CST)
Received: by mail-io1-f72.google.com with SMTP id f7so147028ioo.8
        for <linux-media@vger.kernel.org>; Mon, 24 Dec 2018 07:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Vc1r3nUkSsEHofy6wG/QWMwv6RdlZ4kscbXuxXJyNmQ=;
        b=eTYVuqPhfCbGPo1Z2wiGJBuimJYPcbdjmnxsBaQZjLHUKA2pEOMXpZa/JVJXGYX9zM
         3PdO8O6VkJwok0878aGxv46O6RDdhL/k3NDSM84qxeic1XUrA+XwQeASeRnuKV/hLTva
         wT03cV9VJWDJnchfejV4/wwqxo4AAJIgueipld+Sbl1ZxXIgdNnt4cPFhhbxle/hpJ9T
         m67jYWGXi5QtHnLewImx1Pdqkh2YzGUl9Bm5SPwH/iduiF7cNmMWSNucUdSBRZAPiMrE
         KOdDT0ffNCOWAIYW+0bcvE9zd1eskVs7pMoZG+ZhWnTwQL0KHDT7/5wut3DLZZYAMOgy
         oiMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Vc1r3nUkSsEHofy6wG/QWMwv6RdlZ4kscbXuxXJyNmQ=;
        b=EJQPFvp6sSl31aD0/Hh9HPOOLcVZse9yFN75XaA9lJK2YdFqpqtiLUD9glHgTBv9UX
         s53BuNoig6SjKvQJRQgQciWBd1ynFPgTzHYebazMWSyX+k6sCcAQj+fjQzNVGQ7uhrEc
         C4txbHoHqlfPtLwg6MP3YoZRFIdI7q/5dO6Ef9cj8oCIjbyLvvyv6GbZzpUX558lKX03
         0hXrWFz4p5E1W6OUftO8w01jRnBOlmFn6lYM7+tEezHvactUmik57zD2U3mb9zJHwuRZ
         AuzQy3vHbEX2oBgprte/ggQ/eW7ERZyVW6ecE3F7zKWB62pi7jQ3ji08oloRbztgUiMu
         IEDA==
X-Gm-Message-State: AA+aEWZcOoQwFO8aBOAU7T4iClQCeynYVnBIVuhiOn5JFAs45Ip2qAmA
        0l5uS+euQP7PEyXbEv86dUChPtgfPNqkGpbFiexisE5j0MrRHH3VuSI/rMPrX//rP9zct+JSx4E
        OaCst4FaqlTTCqWPjE19BFjSdXtQ=
X-Received: by 2002:a24:a542:: with SMTP id w2mr7512831iti.64.1545665356435;
        Mon, 24 Dec 2018 07:29:16 -0800 (PST)
X-Google-Smtp-Source: AFSGD/UJzzU7SLrf+tW7IQmgT/bXOQA0YM+mE0+S/OnAXYYmnCYHdL6kF8KTh486YrC8FtAeWTvAtw==
X-Received: by 2002:a24:a542:: with SMTP id w2mr7512817iti.64.1545665356198;
        Mon, 24 Dec 2018 07:29:16 -0800 (PST)
Received: from cs-u-syssec1.cs.umn.edu (cs-u-syssec1.cs.umn.edu. [134.84.121.78])
        by smtp.gmail.com with ESMTPSA id k4sm13526267ion.61.2018.12.24.07.29.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Dec 2018 07:29:15 -0800 (PST)
From:   Aditya Pakki <pakki001@umn.edu>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Brad Love <brad@nextdimension.cc>,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media/lgdt3306a: Add a missing return value check.
Date:   Mon, 24 Dec 2018 09:29:01 -0600
Message-Id: <20181224152903.15828-1-pakki001@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

In lgdt3306a.c, lgdt3306a_read_signal_strength() can fail while reading
the registers via lgdt3306a_read_reg(). The function can return an error
from i2c_transfer(). The fix checks the return value for this failure.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/media/dvb-frontends/lgdt3306a.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index 0e1f5daaf20c..b79f652d05e1 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -1685,7 +1685,10 @@ static int lgdt3306a_read_signal_strength(struct dvb_frontend *fe,
 	case QAM_256:
 	case QAM_AUTO:
 		/* need to know actual modulation to set proper SNR baseline */
-		lgdt3306a_read_reg(state, 0x00a6, &val);
+		ret = lgdt3306a_read_reg(state, 0x00a6, &val);
+		if (lg_chkerr(ret))
+			goto fail;
+
 		if(val & 0x04)
 			ref_snr = 2800; /* QAM-256 28dB */
 		else
-- 
2.17.1

