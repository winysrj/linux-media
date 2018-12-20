Return-Path: <SRS0=s3Lq=O5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D950C43387
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 08:12:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54BCF2176F
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 08:12:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="oViJlhCH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725562AbeLTIMb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 20 Dec 2018 03:12:31 -0500
Received: from mta-p8.oit.umn.edu ([134.84.196.208]:34032 "EHLO
        mta-p8.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbeLTIMb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Dec 2018 03:12:31 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p8.oit.umn.edu (Postfix) with ESMTP id 0B13AC7C
        for <linux-media@vger.kernel.org>; Thu, 20 Dec 2018 08:12:30 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p8.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p8.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3OVK4E02DgLS for <linux-media@vger.kernel.org>;
        Thu, 20 Dec 2018 02:12:29 -0600 (CST)
Received: from mail-it1-f197.google.com (mail-it1-f197.google.com [209.85.166.197])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p8.oit.umn.edu (Postfix) with ESMTPS id CF700C35
        for <linux-media@vger.kernel.org>; Thu, 20 Dec 2018 02:12:29 -0600 (CST)
Received: by mail-it1-f197.google.com with SMTP id p21so1396896itb.8
        for <linux-media@vger.kernel.org>; Thu, 20 Dec 2018 00:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=iPMrAI3bLWBOMHdbC/v0OmDCeGkFjS0XKiHDe7hscpk=;
        b=oViJlhCHLrCtStkRktQVHWLAZKNWvxF+fRu0xWXq3jqyCl1pBY/Em5pos5VAcJF9je
         63Lj8LnsTTRbMzYhodVgw9YK0nLexeu6i3CBw/eKEcbXc22KXuW+HWbaqebvCJTiMRgs
         BpgHmakKibEXma3mEZ6+lPT8ONo93I0w4uWw7ueimANdk8nSYTk5+j0hP5waX3ZO6JgK
         ag9uR/UJmyC98KGq6z5zNzsR+a8LiIAfTc7w2ntPv92pXMuZ8p3WnGqSoHzdu5G/eBNO
         Pph6MRaQoDd71Zeg0I1RvU6ZAAlJdukC2QFAJ8Ir/XlAA7BHJcZGwd+MqBDYOZlHA/Gi
         FZnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=iPMrAI3bLWBOMHdbC/v0OmDCeGkFjS0XKiHDe7hscpk=;
        b=W0vCvCTsYFanDKjeguh08EuRj+naBXb6pDYIvdU0RMDacRI7LxQgFx1a62WbmKazCS
         A8wA5Ztl3o0Ccz2X3WPjau4XNMg47tAqilmPhYbXVSfBr7eU25LWDtXxy9epqWjEDwRN
         IzY5zg5P7RzM/d8BvLloiXFNU3UWLjfLuPg/GlipC87eN57gqATItxNRZqEAYgwM5lbp
         /0CY1RK3824RwryN7JKX4WOPfTPZAoLb11wEt0a4JguJ8Idw/9PL4OO0D9KkjhyI5+yC
         MUpdp3x2Oj+eJEhbW/XFzUhaxjLFMpQkMyzXTEM8ATg5DDeNtgjwqnSiaywwdQxrcqK0
         sZXA==
X-Gm-Message-State: AA+aEWay4f8UrnmGK0oZ9f0++XUOGshVqhQwos6Lde2chXzpvm4o1VC0
        fV+05W6Viaf1MnElCteZ6v8Eo22K9aNb38IBxm7FA1kWUApNYYhZQAeJQP8Fm3+52E1itdqJSBZ
        AXo/Gl0r39mLDWxTTAv8+fTyO2E8=
X-Received: by 2002:a02:8c4a:: with SMTP id j10mr22677918jal.129.1545293549450;
        Thu, 20 Dec 2018 00:12:29 -0800 (PST)
X-Google-Smtp-Source: AFSGD/WCEeCZfW3oesFZ+Mry2MjYfPMndYE32X/zKdL36o+W+b2dG/dqx6raCupaDbaUZTX+/Kt4Ng==
X-Received: by 2002:a02:8c4a:: with SMTP id j10mr22677912jal.129.1545293549203;
        Thu, 20 Dec 2018 00:12:29 -0800 (PST)
Received: from localhost.localdomain (host-173-230-104-24.mnmigsc.mn.minneapolis.us.clients.pavlovmedia.net. [173.230.104.24])
        by smtp.gmail.com with ESMTPSA id f10sm4352122itf.41.2018.12.20.00.12.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 20 Dec 2018 00:12:28 -0800 (PST)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Matthias Schwarzott <zzam@gentoo.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: si2165: fix a missing check of return value
Date:   Thu, 20 Dec 2018 02:12:09 -0600
Message-Id: <20181220081209.40807-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

si2165_readreg8() may fail. Looking into si2165_readreg8(), we will find
that "val_tmp" will be an uninitialized value when regmap_read() fails.
"val_tmp" is then assigned to "val". So if si2165_readreg8() fails,
"val" will be a random value. Further use will lead to undefined
behaviors. The fix checks if si2165_readreg8() fails, and if so, returns
"-EINVAL".

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/media/dvb-frontends/si2165.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index feacd8da421d..c134f312fa5b 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -275,18 +275,20 @@ static u32 si2165_get_fe_clk(struct si2165_state *state)
 
 static int si2165_wait_init_done(struct si2165_state *state)
 {
-	int ret = -EINVAL;
+	int ret;
 	u8 val = 0;
 	int i;
 
 	for (i = 0; i < 3; ++i) {
-		si2165_readreg8(state, REG_INIT_DONE, &val);
+		ret = si2165_readreg8(state, REG_INIT_DONE, &val);
+		if (ret < 0)
+			return -EINVAL;
 		if (val == 0x01)
 			return 0;
 		usleep_range(1000, 50000);
 	}
 	dev_err(&state->client->dev, "init_done was not set\n");
-	return ret;
+	return -EINVAL;
 }
 
 static int si2165_upload_firmware_block(struct si2165_state *state,
-- 
2.17.2 (Apple Git-113)

