Return-Path: <SRS0=HJwa=PE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9096C43387
	for <linux-media@archiver.kernel.org>; Thu, 27 Dec 2018 18:58:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 738AE20873
	for <linux-media@archiver.kernel.org>; Thu, 27 Dec 2018 18:58:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="LeVxv/m/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbeL0S64 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 27 Dec 2018 13:58:56 -0500
Received: from mta-p6.oit.umn.edu ([134.84.196.206]:57530 "EHLO
        mta-p6.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726732AbeL0S64 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Dec 2018 13:58:56 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p6.oit.umn.edu (Postfix) with ESMTP id 02A2C558
        for <linux-media@vger.kernel.org>; Thu, 27 Dec 2018 18:58:55 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p6.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p6.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3pj12qf2q5gr for <linux-media@vger.kernel.org>;
        Thu, 27 Dec 2018 12:58:54 -0600 (CST)
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p6.oit.umn.edu (Postfix) with ESMTPS id 2D835F06
        for <linux-media@vger.kernel.org>; Thu, 27 Dec 2018 12:58:12 -0600 (CST)
Received: by mail-io1-f69.google.com with SMTP id d63so23244557iog.4
        for <linux-media@vger.kernel.org>; Thu, 27 Dec 2018 10:58:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=hUY2R81IpkxDQV+VP8dNZeYfbpjuKWDQGlzYigVB7HE=;
        b=LeVxv/m/JnwXJsy7LjT4XvlbjtPdB46ZMma3aL13jGK4XzvQ8vU2xk8gMzuvmZv6hw
         EZZwQlIvWe9yEwCwJ5k96k62PDAnFMxWE269wxFpTEWs9lnrxUnKHwzBLrVcwxakMlMo
         JkwSrRcnfJb9rsey07UtNn+lzvR6E+Y/DsyPmDX6joYh9zI3Asa8imsqnlEyE/ixIoNN
         nlrWzox0uIzCqHf8706hMC2Wy6VNzxJwFpipreIT4J+T7c4u8J0NyWbEW9tnNouzz5WF
         Jnyah8lEqqlp08O4NYiVufkrfSNnqGer3M57LVir3mWEk0zSK49WwKqZBc0Z+sMtyNCm
         b6OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hUY2R81IpkxDQV+VP8dNZeYfbpjuKWDQGlzYigVB7HE=;
        b=Kn0y8Cs7HxS4+JDvCRXd+WKGW8TwY4EdWOtF43bDJjSbr/zKgvJgycQdTu2iBnigAj
         xOcorjaewU16hpatqw+O6LmH4JGZ8L7GV6XEMcR2Jp28P7HkQ/g2yboo37NI80Aq2n6u
         Sl0jJtSL0KTYGSQLPS0v0ivStAIiGBvvtBWwynhE9FTSMHBJYf8hSmr+LFT2bpPzYNg6
         CpxlqKgcdBuPAOVfz9Ee+JtHEQhir1h/RwDaslcs23OcDeMQaIcwNkFdtwWI2SaWgy0d
         dBqAaaY8AxXNBjyXEA+xQqrMWIIDLZdnJGyHwz8qDKLt3cChcqsLfIfBU4ohg3aB9FRW
         w3wQ==
X-Gm-Message-State: AA+aEWaKUqXIOCZGsw7M3+Gzg2hXDDxI4MRUL+J4sPT6Kg0q3AtUzCPH
        41xhwtxAriVgI558wRKOEQh0htyVNpbwJuUE1sA7E2HZl7Obgko43vg0ob1LrkubV9a449/kLPd
        aZnnQFLFZxE8bTgAEEm6Mnq+UrSE=
X-Received: by 2002:a24:9307:: with SMTP id y7mr16295295itd.38.1545937091802;
        Thu, 27 Dec 2018 10:58:11 -0800 (PST)
X-Google-Smtp-Source: AFSGD/V9qzz4f+wJfWaRkvH94ZQr6kQ905CNwOQ4Ma56gBT6+ROr1k19eFUg1H+xN7qaeBe25/xviA==
X-Received: by 2002:a24:9307:: with SMTP id y7mr16295289itd.38.1545937091545;
        Thu, 27 Dec 2018 10:58:11 -0800 (PST)
Received: from cs-u-syssec1.cs.umn.edu (cs-u-syssec1.cs.umn.edu. [134.84.121.78])
        by smtp.gmail.com with ESMTPSA id q14sm13609003itb.36.2018.12.27.10.58.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Dec 2018 10:58:11 -0800 (PST)
From:   Aditya Pakki <pakki001@umn.edu>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: dvb: Add check on sp8870_readreg
Date:   Thu, 27 Dec 2018 12:58:01 -0600
Message-Id: <20181227185802.24213-1-pakki001@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

In sp8870_set_frontend_parameters, the function sp8870_readreg
may return an error when i2c_transfer fails. The fix checks for
this error and returns upstream consistent with other invocations.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/media/dvb-frontends/sp8870.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/sp8870.c b/drivers/media/dvb-frontends/sp8870.c
index 8d31cf3f4f07..270a3c559e08 100644
--- a/drivers/media/dvb-frontends/sp8870.c
+++ b/drivers/media/dvb-frontends/sp8870.c
@@ -293,7 +293,9 @@ static int sp8870_set_frontend_parameters(struct dvb_frontend *fe)
 	sp8870_writereg(state, 0xc05, reg0xc05);
 
 	// read status reg in order to clear pending irqs
-	sp8870_readreg(state, 0x200);
+	err = sp8870_readreg(state, 0x200);
+	if (err)
+		return err;
 
 	// system controller start
 	sp8870_microcontroller_start(state);
-- 
2.17.1

