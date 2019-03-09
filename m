Return-Path: <SRS0=5UJH=RM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29263C43381
	for <linux-media@archiver.kernel.org>; Sat,  9 Mar 2019 07:21:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC1F32081B
	for <linux-media@archiver.kernel.org>; Sat,  9 Mar 2019 07:21:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="WJc4/Z52"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbfCIHVI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 9 Mar 2019 02:21:08 -0500
Received: from mta-p5.oit.umn.edu ([134.84.196.205]:47284 "EHLO
        mta-p5.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbfCIHVG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Mar 2019 02:21:06 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p5.oit.umn.edu (Postfix) with ESMTP id BD1FBCF0
        for <linux-media@vger.kernel.org>; Sat,  9 Mar 2019 07:21:04 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p5.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p5.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id U-EIkwm-9S3q for <linux-media@vger.kernel.org>;
        Sat,  9 Mar 2019 01:21:04 -0600 (CST)
Received: from mail-it1-f197.google.com (mail-it1-f197.google.com [209.85.166.197])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p5.oit.umn.edu (Postfix) with ESMTPS id 8E1F7CED
        for <linux-media@vger.kernel.org>; Sat,  9 Mar 2019 01:21:04 -0600 (CST)
Received: by mail-it1-f197.google.com with SMTP id j127so14063319itj.7
        for <linux-media@vger.kernel.org>; Fri, 08 Mar 2019 23:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=pn25Lxb/6HFWwy0AaPTtJqDN7hoQNmgW1nIh0NwMlrA=;
        b=WJc4/Z52ts81slcOiR7HuUB/iFoHlVovn+GMtW4fio4WCYALTxjhVGHj5jloWBVBCa
         wZoKn+agJ3DHknM/FR5B5Kp8IXax134osEJhl9BAhOPQ+Tlco/9Mde+8BVND/ekuaFNj
         9/T8G6BYCX58F28T/Yp2zxKnrEDhE5b3OM9Fwfx+bAeXGZvoeO3LgnmUibvH1pTkuaAz
         h+CA/93knAWA6wOgWCDX2boyJBhIKk72P6st8ZzmysrrVYAYw2bwE36tbgh+Qk6NA+Y8
         8C7jbKlIZlLtSZwmSxEFHda9vcicldNafSPQY2jd9KdaY1h0BS+WVo71npJRHS575Qbi
         qNUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pn25Lxb/6HFWwy0AaPTtJqDN7hoQNmgW1nIh0NwMlrA=;
        b=SzF7wb3GM4nJeL5pZN5h9nkd7slZ4l+ZSHyUkTw3mh3wN6Qk0S7MMTerz2GUGYCTl1
         /H7Vd0TEn2FZvMUWov5t1ANahOmku0aMTZ9zIwvcP7XjyZunP2ZPC9t/O34WX6T/REmP
         UsH0t0YMQNpy5ZGzSkc08o4zl90SQZauiNx8W/ZixTwm/do4aWldMKlrWYwYh6KCjUKo
         8HUurL+yYGUbPxjazSE2aMD/cYt5lZuANver2F4evUFITbBNeL2C8jivhS0oSpEtCHa1
         2lC9ASNJorKAicpGeRD/VNzjTtwB4pvL9rAhkhy8GzXzKdT+Mb6q7tPGqZ1+dqOOAh6b
         d31A==
X-Gm-Message-State: APjAAAXA5CI1O2sEEyn6RUi5hbEMjSw/EKoatdtt0iG16LLlDo1de6wC
        TGs5AijXrqbkWB/pjOhTobh3MwpMn7L7+3lXwg8iOU7VPHjM8LRGnGScQRDC2+eXEYMYDFEV8MP
        wjK7Ot1EGlUUEunhK1zBt6TiF2As=
X-Received: by 2002:a6b:9189:: with SMTP id t131mr1080261iod.95.1552116063703;
        Fri, 08 Mar 2019 23:21:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqxP2aFGKCA1uQmY4X+NGubgWgOvxg7EmmtiEJTXWQpbqVtb3+Hip+WjQIdfbgKbv+v81ItD+Q==
X-Received: by 2002:a6b:9189:: with SMTP id t131mr1080258iod.95.1552116063452;
        Fri, 08 Mar 2019 23:21:03 -0800 (PST)
Received: from bee.dtc.umn.edu (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id s11sm4254138ioe.84.2019.03.08.23.21.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Mar 2019 23:21:02 -0800 (PST)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: video-mux: fix  null pointer dereferences
Date:   Sat,  9 Mar 2019 01:20:56 -0600
Message-Id: <20190309072056.4618-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

devm_kcalloc may fail and return a null pointer. The fix returns
-ENOMEM upon failures to avoid null pointer dereferences.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/media/platform/video-mux.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/video-mux.c b/drivers/media/platform/video-mux.c
index c33900e3c23e..4135165cdabe 100644
--- a/drivers/media/platform/video-mux.c
+++ b/drivers/media/platform/video-mux.c
@@ -399,9 +399,14 @@ static int video_mux_probe(struct platform_device *pdev)
 	vmux->active = -1;
 	vmux->pads = devm_kcalloc(dev, num_pads, sizeof(*vmux->pads),
 				  GFP_KERNEL);
+	if (!vmux->pads)
+		return -ENOMEM;
+
 	vmux->format_mbus = devm_kcalloc(dev, num_pads,
 					 sizeof(*vmux->format_mbus),
 					 GFP_KERNEL);
+	if (!vmux->format_mbus)
+		return -ENOMEM;
 
 	for (i = 0; i < num_pads; i++) {
 		vmux->pads[i].flags = (i < num_pads - 1) ? MEDIA_PAD_FL_SINK
-- 
2.17.1

