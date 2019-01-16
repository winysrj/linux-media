Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0533BC43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 18:45:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CABCD2086D
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 18:45:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NjmdDGh2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbfAPSpb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 13:45:31 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44320 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729022AbfAPSpb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 13:45:31 -0500
Received: by mail-pg1-f195.google.com with SMTP id t13so3192702pgr.11;
        Wed, 16 Jan 2019 10:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=GIqHD+5i6aiV0G0NAFyRGh7lKTGvUOXmhbisqg7OY0s=;
        b=NjmdDGh2z+MzXKdZ3H9zrBrVll7rNDty+vIJojCc0Ryc/MtCnQtQJfSVYScvEr43fB
         1ZzmEKTWQ8QHblcYSjvdzJrY7reBauMVyHGx1HBwKAYW6Tnl41JwsmkbjB4G/GDoyjTt
         NmUnasfImDQcadV0ACE27a4i64wcYDzLokIaqG0IYRL996/9lvdWtt5X3n0L30acqt39
         n8OjZdzTtAXWGbaDjYSVZ1CJt0iRgG6b9U1MxO5a+iUp5fqOOKE1NasXrkrNKnvWlbaq
         uOeyS3qV+ijPFSseKUoAvbAU5812CX+nHf4sQIr/akQfznSmNR9vtISmGMzqk/Dc+SFn
         cIDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=GIqHD+5i6aiV0G0NAFyRGh7lKTGvUOXmhbisqg7OY0s=;
        b=TmR6uZqPtfXNWFhjvvcChB12RgM+pXczkriAwLp607CKTkEUpGZ8mp1hleh3OE/5gh
         9kslpMvT7fKBsmFgSK+LLVuSFLsiGmWlXFROsV515gdbrsdCp6ZhMdcnYYq7DmddW0/s
         LNTadBySI1ZHCYnb2xGGpI6h9VWgb5B2cD5xvrfGm4VGkmU6RwQbWOoa7DDGWLGAuBCN
         90sg/4zfsFQOr1OnsGSiHx0Z5gW4FOV03qrhHMRsP2BxCpRSLQp9UIwrnLkGWL21ORQq
         kxsFsr+qo0siUEpTi7V+uGd9hQ2GncsVJtEcL6mZtf1cAU/5KICG/z675bDeLU/T2nWE
         IZPQ==
X-Gm-Message-State: AJcUukf2X3wqFZuSmZUC9pFWollRgCpZY2mvolhSH9ot5cGpq6e4/o7y
        BGWg+DpvqDJGKcb6iG6iEeAwiwd2
X-Google-Smtp-Source: ALg8bN71Qywd/z2X1CjMuc2KeN6KYpOos041iwSY0XNpoXt/edguqMPNQ/iJL2hQO3M4u+SLTaHPbg==
X-Received: by 2002:a63:e20a:: with SMTP id q10mr9913430pgh.206.1547664330200;
        Wed, 16 Jan 2019 10:45:30 -0800 (PST)
Received: from jordon-HP-15-Notebook-PC ([49.207.55.114])
        by smtp.gmail.com with ESMTPSA id g3sm13351073pfe.37.2019.01.16.10.45.27
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 16 Jan 2019 10:45:28 -0800 (PST)
Date:   Thu, 17 Jan 2019 00:19:33 +0530
From:   Souptick Joarder <jrdr.linux@gmail.com>
To:     mchehab@kernel.org, brian.warner@samsung.com
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        brajeswar.linux@gmail.com, sabyasachi.linux@gmail.com
Subject: [PATCH] media/v4l2-core/videobuf-vmalloc.c: Remove dead code
Message-ID: <20190116184933.GA4562@jordon-HP-15-Notebook-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This code is commented since version 3.7. If there is no plan to
use it in future, we can remove this dead code.

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---
 drivers/media/v4l2-core/videobuf-vmalloc.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf-vmalloc.c b/drivers/media/v4l2-core/videobuf-vmalloc.c
index 45fe781..293213a 100644
--- a/drivers/media/v4l2-core/videobuf-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf-vmalloc.c
@@ -196,26 +196,6 @@ static int __videobuf_iolock(struct videobuf_queue *q,
 		}
 		dprintk(1, "vmalloc is at addr %p (%d pages)\n",
 			mem->vaddr, pages);
-
-#if 0
-		int rc;
-		/* Kernel userptr is used also by read() method. In this case,
-		   there's no need to remap, since data will be copied to user
-		 */
-		if (!vb->baddr)
-			return 0;
-
-		/* FIXME: to properly support USERPTR, remap should occur.
-		   The code below won't work, since mem->vma = NULL
-		 */
-		/* Try to remap memory */
-		rc = remap_vmalloc_range(mem->vma, (void *)vb->baddr, 0);
-		if (rc < 0) {
-			printk(KERN_ERR "mmap: remap failed with error %d", rc);
-			return -ENOMEM;
-		}
-#endif
-
 		break;
 	case V4L2_MEMORY_OVERLAY:
 	default:
-- 
1.9.1

