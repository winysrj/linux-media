Return-Path: <SRS0=5UJH=RM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50B6EC43381
	for <linux-media@archiver.kernel.org>; Sat,  9 Mar 2019 07:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F52820866
	for <linux-media@archiver.kernel.org>; Sat,  9 Mar 2019 07:42:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="ZDH29pyd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbfCIHmk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 9 Mar 2019 02:42:40 -0500
Received: from mta-p7.oit.umn.edu ([134.84.196.207]:42886 "EHLO
        mta-p7.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfCIHmk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Mar 2019 02:42:40 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p7.oit.umn.edu (Postfix) with ESMTP id 4AB87D44
        for <linux-media@vger.kernel.org>; Sat,  9 Mar 2019 07:42:38 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p7.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p7.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id oJoa_fyKURvf for <linux-media@vger.kernel.org>;
        Sat,  9 Mar 2019 01:42:38 -0600 (CST)
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p7.oit.umn.edu (Postfix) with ESMTPS id 207EAD40
        for <linux-media@vger.kernel.org>; Sat,  9 Mar 2019 01:42:38 -0600 (CST)
Received: by mail-io1-f70.google.com with SMTP id n15so935473ioc.0
        for <linux-media@vger.kernel.org>; Fri, 08 Mar 2019 23:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=yqBKTjuQAlpMccG/uYBRHQdcAenQYeNaV0PQuyDoSh4=;
        b=ZDH29pydESGmaZBepsX5lG0vuWqe+rWbDSRUgo5utgbe/5GJaI7BtthTwx9TW5h9JM
         rCUzoHPABXPfk9OGtNneZdhxx3ZM02mNOPgnBzykaBAUGl1FP8QVxXfVfUa+9kQhyw8Q
         k5VSe/OOnA47EIF7cwzBzuWx3UxHJUEIOtlWTeqIQ7KnK/zHivd2gn6e7WreJ/P5OF1b
         2S4RKrtdXTrV7giYZqbopyGMWbIZr2VDwojvn5R7wASclau4Ocwknz/65N8mStSn/sJx
         ddfIj9mtS3wbEQqxCemcxO+QvUN51tuV0mXkSDvsTeIM8Zumgo5TDo9JpkVLM3DERIKB
         9UuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yqBKTjuQAlpMccG/uYBRHQdcAenQYeNaV0PQuyDoSh4=;
        b=f91rR/GewX16qV7T1fjeEUXhhiFaEe/+1UXznXWSN3WcbS60yieYy8uowMzZkEU2nX
         m1BKeOKSF1zWL/0CMXasflSR3R24wc4DelrGdImlzKgcHH/uM1dw6Gv9cna0T0QFh2Tv
         EGqGoMt8C00kpZj87m+UfztnnMUbi5w/HY1dT3ZASIY5qf0PbD2pfGlUmMLNG+SCqEtV
         HnmgjWB1pZjCOfuckYrUA6v25sr1y+/3ix4ZMmb3mJTcHezE23ahId02Xpx3R2m3Qy34
         V4ZRGNQPKYyXypmrQ8MG5kFgFB8XHzoj2ky4LOaAe21MFG5810jBuTPh4TZnkqgifbW+
         7Rng==
X-Gm-Message-State: APjAAAV0fWsRrG36/nsT8OwcT41bsuVTwYc8d6VXrgY0siwOOv/w6I/k
        fnJuDZihgkaXwtmr2I3Z8+S2Q0P8WG5VLh37MeyyBhl8xC87j05fmLvt3S/u3zzPA0MDDih2SkI
        MWUG+WxG84ljjQ7NPYV5zeAc7VhY=
X-Received: by 2002:a02:5145:: with SMTP id s66mr12032755jaa.109.1552117357701;
        Fri, 08 Mar 2019 23:42:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqxecZ54wEETSB+xHARO4IL1pc6XoAVwJB1sdTs8pe3K/zZDh1XKs1RKJQ0hSPcGQ5FOLYqJSQ==
X-Received: by 2002:a02:5145:: with SMTP id s66mr12032744jaa.109.1552117357430;
        Fri, 08 Mar 2019 23:42:37 -0800 (PST)
Received: from bee.dtc.umn.edu (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id p141sm5165412itb.39.2019.03.08.23.42.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Mar 2019 23:42:36 -0800 (PST)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: usbvision: fix a potential NULL pointer dereference
Date:   Sat,  9 Mar 2019 01:42:26 -0600
Message-Id: <20190309074228.5723-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

In case usb_alloc_coherent fails, the fix returns -ENOMEM to
avoid a potential NULL pointer dereference.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/media/usb/usbvision/usbvision-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/usbvision/usbvision-core.c b/drivers/media/usb/usbvision/usbvision-core.c
index 31e0e98d6daf..1b0d0a0f0e87 100644
--- a/drivers/media/usb/usbvision/usbvision-core.c
+++ b/drivers/media/usb/usbvision/usbvision-core.c
@@ -2302,6 +2302,9 @@ int usbvision_init_isoc(struct usb_usbvision *usbvision)
 					   sb_size,
 					   GFP_KERNEL,
 					   &urb->transfer_dma);
+		if (!usbvision->sbuf[buf_idx].data)
+			return -ENOMEM;
+
 		urb->dev = dev;
 		urb->context = usbvision;
 		urb->pipe = usb_rcvisocpipe(dev, usbvision->video_endp);
-- 
2.17.1

