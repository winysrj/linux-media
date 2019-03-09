Return-Path: <SRS0=5UJH=RM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC64DC43381
	for <linux-media@archiver.kernel.org>; Sat,  9 Mar 2019 07:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9B9F2081B
	for <linux-media@archiver.kernel.org>; Sat,  9 Mar 2019 07:14:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="Emf9R+hH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfCIHOf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 9 Mar 2019 02:14:35 -0500
Received: from mta-p7.oit.umn.edu ([134.84.196.207]:39390 "EHLO
        mta-p7.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbfCIHOd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Mar 2019 02:14:33 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p7.oit.umn.edu (Postfix) with ESMTP id 98F86D36
        for <linux-media@vger.kernel.org>; Sat,  9 Mar 2019 07:14:31 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p7.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p7.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ssui4fpFgUEJ for <linux-media@vger.kernel.org>;
        Sat,  9 Mar 2019 01:14:31 -0600 (CST)
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p7.oit.umn.edu (Postfix) with ESMTPS id 65928D07
        for <linux-media@vger.kernel.org>; Sat,  9 Mar 2019 01:14:31 -0600 (CST)
Received: by mail-io1-f70.google.com with SMTP id k24so17144084ioa.18
        for <linux-media@vger.kernel.org>; Fri, 08 Mar 2019 23:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=IrAGSpfys/QRpyQxtm8xVIS+s2k0EJhnsyr/EmBfg3g=;
        b=Emf9R+hHZkRNSk2YcKYX1LebaWp09A7ghSZBNACFrsTuzuGYZWagpvY8Y/ttTr+Hfk
         7z7R1R7ArZa/YbK8Ji8ZX66XUNxHHzfu4n/B6DUWUHxo7u99Wt0NGDhBgZ6kujSsW7tF
         FRwMMlx3s49nJgUNRwUzoVf7ksDvfu67m6yF4e6wQyqvbW9GOCQTsTlFYL7NnGW/Ju82
         WGu/it8KcdSq7S3ydq4Y17+Dk8fF42Fk79A244hh+HB+7+eA7AJSB8XBneiffaXMu2jX
         QSPwNe55e+CiCr9NiShDGx/pCOaYWzgBeO5nmk1f7C0Gn/k9S5pRZXHO9WJx5SMC1mWC
         4W2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=IrAGSpfys/QRpyQxtm8xVIS+s2k0EJhnsyr/EmBfg3g=;
        b=oROhRHRpIyirazQ6eXYFs6H9wBZcNJK2Au4f/KfBTxR+DZEzNkc1IxwpsalndPjnFH
         qJ7umR3zCUd64V1rq2b0WURxcH4cvACDvKJfNe/tKEfe+3uAEY4We983o6nXPEIQjej/
         X8CFFO+4+9gh6oaVFq0KCIzEYUDcLW+O5XoOEsSmWcq3pPIrj/WI3HR2EQI8EwKfd473
         sOiFAr5JIccIX4UXLXj8+6Yf2ImyJXzCGs1xhWfAGX1gB0K+APySwnLBgHXAxEkRpA15
         c10MGbLwG1sBPTXMlpab7+pr9lYuZrHRVY8cqdnCyxGeMJGGS7UUzVVqd4c2BA8vD00o
         xzSw==
X-Gm-Message-State: APjAAAWT7pKZqYtL+X7ApJZVq3Ic5I5yH2By2vfkP6rwFD5cne9svRQV
        vkvxUVghIAsvDqUUBCLbiGWcURhPh7sdcBZIqrjkqf7XfhrOxUsVKfVuUDAB7knM3NlZTyHvHAn
        8i87hI6gsm+FPTfZBZSr8ahkeuAA=
X-Received: by 2002:a02:47:: with SMTP id 68mr13019159jaa.121.1552115670973;
        Fri, 08 Mar 2019 23:14:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqxFz+Wa8QqySDaPF5/FMuaIn/65zGb6HXAHEp5gqDbcprybYPSh+TFVbDgF89iBafKOvqnOJQ==
X-Received: by 2002:a02:47:: with SMTP id 68mr13019154jaa.121.1552115670748;
        Fri, 08 Mar 2019 23:14:30 -0800 (PST)
Received: from bee.dtc.umn.edu (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id v8sm3886449iop.42.2019.03.08.23.14.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Mar 2019 23:14:30 -0800 (PST)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Jacopo Mondi <jacopo@jmondi.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: renesas-ceu: fix a potential NULL pointer dereference
Date:   Sat,  9 Mar 2019 01:14:24 -0600
Message-Id: <20190309071424.3600-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

In case of_match_device cannot find a match, the check returns
-EINVAL to avoid a potential NULL pointer dereference

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/media/platform/renesas-ceu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/renesas-ceu.c b/drivers/media/platform/renesas-ceu.c
index 150196f7cf96..4aa807c0b6c7 100644
--- a/drivers/media/platform/renesas-ceu.c
+++ b/drivers/media/platform/renesas-ceu.c
@@ -1682,7 +1682,10 @@ static int ceu_probe(struct platform_device *pdev)
 
 	if (IS_ENABLED(CONFIG_OF) && dev->of_node) {
 		ceu_data = of_match_device(ceu_of_match, dev)->data;
-		num_subdevs = ceu_parse_dt(ceudev);
+		if (unlikely(!ceu_data))
+			num_subdevs = -EINVAL;
+		else
+			num_subdevs = ceu_parse_dt(ceudev);
 	} else if (dev->platform_data) {
 		/* Assume SH4 if booting with platform data. */
 		ceu_data = &ceu_data_sh4;
-- 
2.17.1

