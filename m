Return-Path: <SRS0=XPZo=QL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 411DBC282C4
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 14:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 113382082E
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 14:57:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jmEBauen"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729368AbfBDO5a (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Feb 2019 09:57:30 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34592 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbfBDO5a (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Feb 2019 09:57:30 -0500
Received: by mail-pl1-f194.google.com with SMTP id w4so54190plz.1;
        Mon, 04 Feb 2019 06:57:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=YTvB89BBnRi3Cx0EmMW59JPDQvoFJsorM7vMSRfLkyE=;
        b=jmEBauenEcxlTGwThmMUdcs/6pqqu2P6X9R/717hUTz0zsO7UrKnwgraQh3BI38C+j
         qMkIjtGQCyiqtm1sZ9AC5lpwMUKw0KlbUMbSJjtpyZfE+qcU6l5b+cyyp7A72vLbuwua
         lkNLwxY7/dODdBw6k1WRhMum9lxlXEP9T2pthL6ieDc+scJk0Xyzehk6mleEd0IdONzS
         yGedM1MhUwm80xtZylYXYbU5oKjFjGQr6QKGdwqwcYNAko2WuiEAyvXjrsikVdkh9jjd
         tcavkTbXqoZ9DeCTdPRQuIShhDP99i8gDZAqTpYyANgYB7NI0lORNraAaaGIyrcomqZ2
         lDBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=YTvB89BBnRi3Cx0EmMW59JPDQvoFJsorM7vMSRfLkyE=;
        b=rioSmMUC7auCtC5h++L84qLXwsikvLFGuf+ZugY8qw9NGSrKhN9TkfG6cRVSu/91iV
         P263PM8GuHaLxA3pbjGt38LN40bSvaOnkInfZAPPyh83VO4UTzjUdgIbn0xjXJhFQAQ5
         PQdqjMtz3JT/pXNYUwTzEInfn4BPjbgCuaoCQfbrBue1ygSyskOObHl1d5SnnBQFIHGs
         UyzAb6gq23KbEfaiU1rcVkB+hmuDHUWEfdtK/T36/EleZ6hv3J80mWPaRZXQzemOunrl
         gW1sNsXXsxjtgxK65krGl3yn5FAhRPwlaa2txUy319s3bJt8Lkl+hXXFlvV1FzOZJAIX
         FpEA==
X-Gm-Message-State: AHQUAua1NWtILCk1Cm97Vpw7zL9yy1/A7MYpJcfM3zlIMx2kr6NrXO4m
        zqqrGoMHkebfvyfretLCE1byKUwi
X-Google-Smtp-Source: AHgI3IaOGMs+3WTNh5R0XP4xmjhms+LdaNnviOFIZDwidaVdxu2qes7Ht+nGpnGZeUUi6kNUhlvakg==
X-Received: by 2002:a17:902:b581:: with SMTP id a1mr7712768pls.36.1549292249179;
        Mon, 04 Feb 2019 06:57:29 -0800 (PST)
Received: from jordon-HP-15-Notebook-PC ([106.51.18.176])
        by smtp.gmail.com with ESMTPSA id g2sm366423pfi.95.2019.02.04.06.57.27
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 04 Feb 2019 06:57:27 -0800 (PST)
Date:   Mon, 4 Feb 2019 20:31:43 +0530
From:   Souptick Joarder <jrdr.linux@gmail.com>
To:     pawel@osciak.com, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, mchehab@kernel.org, nicolas@ndufresne.ca
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2] media: videobuf2: Return error after allocation failure
Message-ID: <20190204150142.GA3900@jordon-HP-15-Notebook-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

There is no point to continuing assignment after memory allocation
failed, rather throw error immediately.

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---
v1 -> v2:
	Corrected typo in change log.

 drivers/media/common/videobuf2/videobuf2-vmalloc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-vmalloc.c b/drivers/media/common/videobuf2/videobuf2-vmalloc.c
index 6dfbd5b..d3f71e2 100644
--- a/drivers/media/common/videobuf2/videobuf2-vmalloc.c
+++ b/drivers/media/common/videobuf2/videobuf2-vmalloc.c
@@ -46,16 +46,16 @@ static void *vb2_vmalloc_alloc(struct device *dev, unsigned long attrs,
 
 	buf->size = size;
 	buf->vaddr = vmalloc_user(buf->size);
-	buf->dma_dir = dma_dir;
-	buf->handler.refcount = &buf->refcount;
-	buf->handler.put = vb2_vmalloc_put;
-	buf->handler.arg = buf;
 
 	if (!buf->vaddr) {
 		pr_debug("vmalloc of size %ld failed\n", buf->size);
 		kfree(buf);
 		return ERR_PTR(-ENOMEM);
 	}
+	buf->dma_dir = dma_dir;
+	buf->handler.refcount = &buf->refcount;
+	buf->handler.put = vb2_vmalloc_put;
+	buf->handler.arg = buf;
 
 	refcount_set(&buf->refcount, 1);
 	return buf;
-- 
1.9.1

