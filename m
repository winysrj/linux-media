Return-Path: <SRS0=0n2Q=QK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D40BCC282DB
	for <linux-media@archiver.kernel.org>; Sun,  3 Feb 2019 13:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5201218F0
	for <linux-media@archiver.kernel.org>; Sun,  3 Feb 2019 13:32:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fbXu2AT2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbfBCNb4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 3 Feb 2019 08:31:56 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36950 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbfBCNbz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Feb 2019 08:31:55 -0500
Received: by mail-pf1-f196.google.com with SMTP id y126so5538624pfb.4;
        Sun, 03 Feb 2019 05:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=84hrRz7nOiZ4YsaH604mLPJ8wBSVpD84s9+8PgQMBhg=;
        b=fbXu2AT2aPrW1Y5IKPdJ9et9x+Ald20wF+zSsCVPz9MK+j20snS9qSMbTF6kVmBLzy
         QT7+6Y0YVlpRlCSeLnlyrS5lWQS7SPdKMR8oh4wbG0Y9gu/uNu5WFV6iQeXMXmTIrjKl
         vFwCdAvO99HoDXCNrZuLGwjRyzNjwk8VnnNPp5SOwqHPnfuFqsxxrLtITPljx4+smtyX
         nVUpXOGAs7MMIhHKw/0NB45Kh+MOetqRbfc5iAmnCBXUUkk0l2vMXnVcKrDhlwKCupua
         A5BJZfSAygelyiN2spJGJrdH7DFP7I1gM1CuRMJtD4/yrhGRyu5y6nz3BDnDef/Zahzp
         BMKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=84hrRz7nOiZ4YsaH604mLPJ8wBSVpD84s9+8PgQMBhg=;
        b=kWW580ZZ0h6INAEMo84kObRKKPqGlYEN2+Mj5z6+LuBO1/fFhjOvpD9sDp517fJErK
         LgVFBc+7YyNA2l7rOypWBdsU2Upx8KPiAMFXod2PYaA/Kwszm62A2vz/eR786wu5G723
         Z1Y6X/BYeZdSYrG+f7l2kObP3euXY3Q3LoIzpECWsZ3mx+UZkXh72nyXeG0I40zec1dl
         Skni5dOL4s/EGeNyTYqOSR4LVIIjVA0FIYDA+vJtFCAAcexUXTs08+8TBB4UwPa0LsyM
         7F+0f9z5IPGUF35/Ti778baS9D/+Y44TaXKF+8ErbyA4dc3XAuBnKhhUBBVPadIvvLDV
         xfMA==
X-Gm-Message-State: AJcUukdAlEE2zYL1C3IjbVKmVQKOsCytqqWbBLLCe/VMQpSpyHqnZulH
        WBLSi/j/7z4rKzhihE9+1io=
X-Google-Smtp-Source: ALg8bN593/sUTswQy8ymmfl1lIJq/CdbjIkRomemqvJoOgHA6Q5LzTo9r213hnAhSUHTgHN8Pkf++w==
X-Received: by 2002:a63:6a05:: with SMTP id f5mr42242966pgc.72.1549200715054;
        Sun, 03 Feb 2019 05:31:55 -0800 (PST)
Received: from jordon-HP-15-Notebook-PC ([106.51.18.176])
        by smtp.gmail.com with ESMTPSA id 24sm71166558pfl.32.2019.02.03.05.31.53
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 03 Feb 2019 05:31:53 -0800 (PST)
Date:   Sun, 3 Feb 2019 19:06:08 +0530
From:   Souptick Joarder <jrdr.linux@gmail.com>
To:     pawel@osciak.com, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, mchehab@kernel.org
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        sabyasachi.linux@gmail.com, brajeswar.linux@gmail.com
Subject: [PATCH] media: videobuf2: Return error after allocation failure
Message-ID: <20190203133608.GA26010@jordon-HP-15-Notebook-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

There is no point to continuing assignemnt after memory allocation
failed, rather throw error immediately.

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---
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

