Return-Path: <SRS0=Hs4g=PC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB9CC43387
	for <linux-media@archiver.kernel.org>; Tue, 25 Dec 2018 08:03:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68FF121773
	for <linux-media@archiver.kernel.org>; Tue, 25 Dec 2018 08:03:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="LIjeBLsP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbeLYIDk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 25 Dec 2018 03:03:40 -0500
Received: from mta-p7.oit.umn.edu ([134.84.196.207]:34760 "EHLO
        mta-p7.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbeLYIDk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Dec 2018 03:03:40 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p7.oit.umn.edu (Postfix) with ESMTP id 4A6E5BF6
        for <linux-media@vger.kernel.org>; Tue, 25 Dec 2018 08:03:39 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p7.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p7.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id SgX4tfUeizxh for <linux-media@vger.kernel.org>;
        Tue, 25 Dec 2018 02:03:39 -0600 (CST)
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p7.oit.umn.edu (Postfix) with ESMTPS id 168E5BEB
        for <linux-media@vger.kernel.org>; Tue, 25 Dec 2018 02:03:39 -0600 (CST)
Received: by mail-io1-f69.google.com with SMTP id q207so13462374iod.18
        for <linux-media@vger.kernel.org>; Tue, 25 Dec 2018 00:03:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=JcN3Rf30IuJKLJ4ezaJyg+AZGeSySBgxTmgFWUrU114=;
        b=LIjeBLsPmwAWWn+71fCKNzqA8+DB/f3OFnE4OiaWTfrez1di1VA/MYdieYZyqp/Lm5
         k/rB9JdCWyZ4EZfRC5Yv883MlUHBLD0POcA+Fn4YBa12Dv/kYmvde59Atw8gsAGkNyS3
         YDZeB1dhIYUKofqQVX+lw/IinF2PIYNKQZFhMxICyek5LF5I+BpqfmZa0CmNhkabWiKa
         bbIN0+fWBwroYyrUxYrjlE8SNPDzjU4BYX/OjqQ1TQZ39fBnEqBIZObZGmyhH8onqM5G
         H6cCWKKW/AScxqPdw/BkdUittDjsoDvtg8HF0eoejImYF3lOHO7MXoHDqH8Dz42tL9/S
         WGtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JcN3Rf30IuJKLJ4ezaJyg+AZGeSySBgxTmgFWUrU114=;
        b=McYEEtqxmiPsaMJTjHXX8IRskMxdsib9MCwU+MOE6BzpldmpvyuOlODMNqaDjhlLdu
         JlCk1IZtDNOvU9rjhlXaii36en1o3bvFZgQifqQ5ou5ZlPu31fp1/M5fFv17I7+HDYWg
         8UUoTYl3LdmAhGyaI6jkdcSz79wtc2Eg3HfqH7Aly15cec+9oWHWftOEDdxvpwVRUEWs
         dE4Tv7GC1eerqkfZNA3Em7y8NcptUMp7z5VG0J65hd3BLVY+uxT6Wug3DtAf73PuA4PT
         2CesLaRD+20+S5wHsCCxqevkb7mdEee4yswyin2DxhiChutaj2pQRpHdrvThZ7ekKiFG
         Hipg==
X-Gm-Message-State: AJcUukcLpqmXJKgRs8C5DmR93xO/BC+UBM/uQ7q2hFzENJn/N7mKWVGE
        Q4Ap+3+Mqie5Gsv2aLHBE02j7VHv5RwhtqlSzk3a6KozNO6GXzsh1g6fl8NI5iSnL5miT8p4PNk
        YdYa6s9bqMxW7iy+Z16OQLGMLhmU=
X-Received: by 2002:a6b:7207:: with SMTP id n7mr7521868ioc.85.1545725018689;
        Tue, 25 Dec 2018 00:03:38 -0800 (PST)
X-Google-Smtp-Source: ALg8bN48UKF0grf5fy6j9qdAJIjgduCLRUggvwQL104DTkqlUIqNYou4KUWrwG69IDnWS4bskntXmA==
X-Received: by 2002:a6b:7207:: with SMTP id n7mr7521855ioc.85.1545725018471;
        Tue, 25 Dec 2018 00:03:38 -0800 (PST)
Received: from localhost.localdomain (host-173-230-104-22.mnmigsc.mn.minneapolis.us.clients.pavlovmedia.net. [173.230.104.22])
        by smtp.gmail.com with ESMTPSA id k18sm8808iog.31.2018.12.25.00.03.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 25 Dec 2018 00:03:37 -0800 (PST)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Peter Rosin <peda@axentia.se>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: drxk: add a missed check of the return value of write16
Date:   Tue, 25 Dec 2018 02:03:07 -0600
Message-Id: <20181225080308.68178-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

write16() could fail. The fix inserts a check for its return value
in case it fails.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/media/dvb-frontends/drxk_hard.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index 84ac3f73f8fe..b7579ffae690 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -6610,7 +6610,9 @@ static int drxk_get_stats(struct dvb_frontend *fe)
 	if (status < 0)
 		goto error;
 	pkt_error_count = reg16;
-	write16(state, SCU_RAM_FEC_ACCUM_PKT_FAILURES__A, 0);
+	status = write16(state, SCU_RAM_FEC_ACCUM_PKT_FAILURES__A, 0);
+	if (status < 0)
+		goto error;
 
 	post_bit_err_count *= post_bit_error_scale;
 
-- 
2.17.2 (Apple Git-113)

