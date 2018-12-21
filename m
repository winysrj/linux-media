Return-Path: <SRS0=g7QC=O6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51993C43387
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 04:55:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15A5921903
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 04:55:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="f8gx0Kw/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389102AbeLUEzn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 20 Dec 2018 23:55:43 -0500
Received: from mta-p6.oit.umn.edu ([134.84.196.206]:54972 "EHLO
        mta-p6.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387417AbeLUEzn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Dec 2018 23:55:43 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p6.oit.umn.edu (Postfix) with ESMTP id 6792BCF7
        for <linux-media@vger.kernel.org>; Fri, 21 Dec 2018 04:55:41 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p6.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p6.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ppz1_QkoMTn1 for <linux-media@vger.kernel.org>;
        Thu, 20 Dec 2018 22:55:41 -0600 (CST)
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p6.oit.umn.edu (Postfix) with ESMTPS id 34040CF6
        for <linux-media@vger.kernel.org>; Thu, 20 Dec 2018 22:55:41 -0600 (CST)
Received: by mail-io1-f70.google.com with SMTP id x2so3243491ioa.23
        for <linux-media@vger.kernel.org>; Thu, 20 Dec 2018 20:55:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=MBP4FkDC5u7iym32JDQSQJ7E5NApyVp5LNb2GTuR6pE=;
        b=f8gx0Kw/Oyc0Mc84BMqPCDgjmBaW6DiGcMUG5K8VFMCRkgqp23fgojzTLzPsQW1xCp
         2RrgQt3JQGX8bldLll0E69yQrcZ3fbplOAn9HopFnSO5ElN06yr9czVRCM2hzL9nw12Z
         F4L+5QRFZtLNGH7L0dvqa1EdqjylfLC/GrcA8ZQ/LSoFUMzX22KJ1r17yJ31KYU54E8a
         5R++k95uARkpHl/cv3QeMpOgJ13xggXUtVUa7roL/a1i+sVBAs9Cz9+p2rzOV2ZzNdnR
         VGUkNpI+doAViGqbMZpJjMVbIIHc4t4Twqn6mKltCUWs6s7TBilrjbxg6ZS5icwTt3UF
         oicA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MBP4FkDC5u7iym32JDQSQJ7E5NApyVp5LNb2GTuR6pE=;
        b=QD2QH+sME5z9QyFe+jkknNYsRWupPvycOJhbjuC0nfEsgnf3++mYlGW+LHct/au67q
         SmETwGmp/CGYRmKUPAybuwAWv1CTgYzp1k/a5q33NDMhxROUfXurVM+8XnAGAYX1+L4Z
         6xj1/FXVFfTOIeYfY6ticaZSf1+vxubqZm27rhNRCQl97mM2NZkdh9wFO59aKgHdn4Lk
         t7GOXjEIrD8bTKl0g/J62wsvZfvHY17dUb0grQt+XEUK9KP7pspdE85i0IXI8ErGMrdI
         sDq0NuQa1NnSz77mP2mswPHxmPHIMp5FUL3VbGjL+T0CSKsscNyI7rvqD6Qx6rvp9lIA
         caYw==
X-Gm-Message-State: AA+aEWa8g8rTTB+5uj5zI57OhReptHLhiW1k1S4zaJv1Ki2RM7GBqDXt
        Hcu0nTJaXLBKsBGsHnJZjOz03Es4Qd3cDq3MZHlkPsOhsQBogfcfanUDvCN0CdHSHdUGikfMqrI
        ijsReLruiHelgNV1TxCBI4LMifP8=
X-Received: by 2002:a24:6c12:: with SMTP id w18mr1213505itb.14.1545368140787;
        Thu, 20 Dec 2018 20:55:40 -0800 (PST)
X-Google-Smtp-Source: AFSGD/WeK7nmkTtjQR5Csl4eohGld5+jlJ4mgXIFQf/ox/gyMVG8X9jkcDJxAhrYQTjwsqiVC8gAQA==
X-Received: by 2002:a24:6c12:: with SMTP id w18mr1213498itb.14.1545368140476;
        Thu, 20 Dec 2018 20:55:40 -0800 (PST)
Received: from localhost.localdomain (host-173-230-104-23.mnmigsc.mn.minneapolis.us.clients.pavlovmedia.net. [173.230.104.23])
        by smtp.gmail.com with ESMTPSA id l11sm10412539iob.24.2018.12.20.20.55.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 20 Dec 2018 20:55:39 -0800 (PST)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Matthias Schwarzott <zzam@gentoo.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] media: si2165: fix a missing check of return value
Date:   Thu, 20 Dec 2018 22:54:03 -0600
Message-Id: <20181221045403.59303-1-kjlu@umn.edu>
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
its error code upstream.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/media/dvb-frontends/si2165.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index feacd8da421d..d55d8f169dca 100644
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
+			return ret;
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

