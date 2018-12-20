Return-Path: <SRS0=s3Lq=O5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1838C43387
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 07:49:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FE5F21720
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 07:49:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="Z7aztYeT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730602AbeLTHtI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 20 Dec 2018 02:49:08 -0500
Received: from mta-p8.oit.umn.edu ([134.84.196.208]:58540 "EHLO
        mta-p8.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbeLTHtH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Dec 2018 02:49:07 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p8.oit.umn.edu (Postfix) with ESMTP id D424991E
        for <linux-media@vger.kernel.org>; Thu, 20 Dec 2018 07:49:05 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p8.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p8.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Zwqw9Cft6XUf for <linux-media@vger.kernel.org>;
        Thu, 20 Dec 2018 01:49:05 -0600 (CST)
Received: from mail-it1-f197.google.com (mail-it1-f197.google.com [209.85.166.197])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p8.oit.umn.edu (Postfix) with ESMTPS id A4B60863
        for <linux-media@vger.kernel.org>; Thu, 20 Dec 2018 01:49:05 -0600 (CST)
Received: by mail-it1-f197.google.com with SMTP id 128so1362068itw.8
        for <linux-media@vger.kernel.org>; Wed, 19 Dec 2018 23:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=IW8nFsGJ120mWoROgUXJuT+1N+HNIJQhDiQ6MIXoCJs=;
        b=Z7aztYeTxM6JUlWHJIdUCAzs2UxECuo0vFJB/3MaBcRE8WWkJf06fs0d6r0Kfz0yQa
         6kfBXpfBE0jdL/7uhzEPa/Qyjtjr/9ivCIDvMkQaw71CHkz96cgRHR5BrFtHLMDc/M4X
         Jdti4I4hpOREQ+fUBbD6XH5Fj9wOn0QeELvaqFdZSpOjZC09/BZnftHkklgGuwv8X59R
         YqQG5Z3RKB2+Oh3ZJm37HKCn3L1nRiiGwue34iMXz7dWFNxUjV3W1HxF54B5EiwFGp/Z
         1jcV+3GCruiw8gPAIGWMZWANwyxJl9XXN2TXSj/lfD7LBIadKhom85e5UVPQgW1z8gMg
         iKrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=IW8nFsGJ120mWoROgUXJuT+1N+HNIJQhDiQ6MIXoCJs=;
        b=EBfulbtua6HFKfvw2+KhDG7+o8HD8iBNFMUv5YykOr5wfUTnTl+MkbRkqXoZ4PHjXV
         USwsIhXXNq/64uiCTw0ShPUEH9I+meSYuO1i2jtSN76qkJ7f08YTLt+pDDW1nQG/d4iR
         84fgkSPFMZ16ZNY60ZykmVcjAkeIWu/lvNpGwSoC4Ldostfc0qjmhPXc5SNOwUtkVdEn
         o1aDw3ombaBdjaq8pC3oJ6KgXCYWnMb3qRGlmWfE7+EXp6EmOqXW0bEAUD7r2Z0bdiqk
         cwYvFofn6FO9GtFjcSH3VHOZnbx/Dlzoxs9bYIGYzxp/0sZR+YeqY9bcE8OgkcasXx+T
         oZug==
X-Gm-Message-State: AA+aEWb6HnVvxo14lY03BRPQTOvE0SK6G8h9mnkI9x+sNdQOauAPgbyo
        8tvb31h4nardHzZi2ilz5R3ET3UUEo8QEzIbMa3BK1VygLyE4ILE7o5uvtFTrLgkEiEViZXG/80
        OU8dkxq/g1TeEqmjyxQAR2uazOQg=
X-Received: by 2002:a24:67c6:: with SMTP id u189mr9310951itc.106.1545292145287;
        Wed, 19 Dec 2018 23:49:05 -0800 (PST)
X-Google-Smtp-Source: AFSGD/WkriPr96sNFq3ew2/vkmZdHuaJbGNbEKGPBKLqZMOCHj7KYwmFxHOi+pf3yfXOC5iPk51l1g==
X-Received: by 2002:a24:67c6:: with SMTP id u189mr9310938itc.106.1545292145046;
        Wed, 19 Dec 2018 23:49:05 -0800 (PST)
Received: from localhost.localdomain (host-173-230-104-24.mnmigsc.mn.minneapolis.us.clients.pavlovmedia.net. [173.230.104.24])
        by smtp.gmail.com with ESMTPSA id j14sm9625305ioa.5.2018.12.19.23.49.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 19 Dec 2018 23:49:04 -0800 (PST)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Brad Love <brad@nextdimension.cc>,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: lgdt3306a: fix a missing check of return value
Date:   Thu, 20 Dec 2018 01:48:42 -0600
Message-Id: <20181220074844.40666-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

If lgdt3306a_read_reg() fails, the read data in "val" is incorrect, thus
shouldn't be further used. The fix inserts a check for the return value
of lgdt3306a_read_reg(). If it fails, goto fail.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/media/dvb-frontends/lgdt3306a.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index 0e1f5daaf20c..7410f23314bc 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -1685,7 +1685,9 @@ static int lgdt3306a_read_signal_strength(struct dvb_frontend *fe,
 	case QAM_256:
 	case QAM_AUTO:
 		/* need to know actual modulation to set proper SNR baseline */
-		lgdt3306a_read_reg(state, 0x00a6, &val);
+		ret = lgdt3306a_read_reg(state, 0x00a6, &val);
+		if (lg_chkerr(ret))
+			goto fail;
 		if(val & 0x04)
 			ref_snr = 2800; /* QAM-256 28dB */
 		else
-- 
2.17.2 (Apple Git-113)

