Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D69D3C4360F
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 03:55:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A96A020C01
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 03:55:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YG+1PilH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729723AbfB0DzN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 22:55:13 -0500
Received: from mail-io1-f74.google.com ([209.85.166.74]:44996 "EHLO
        mail-io1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729638AbfB0DzF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 22:55:05 -0500
Received: by mail-io1-f74.google.com with SMTP id k24so11967626ioh.11
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2019 19:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kKIv4WwP+TPekq1SKWfh6PaUQyZ3d/TjdhpPmq98mVc=;
        b=YG+1PilHwX7taDLPGloi6h1wSVvw5xc9dfM9lsl6lVk5w0Z/R99JVD1tcDgiXEjnjj
         79u7JiOiO8mTkub1fsvd8SiDoonspwod4sSPTeVtz9DIg4LFgeFr4ybkoUw47h89TWfF
         2+D1BCkAj35/TWPT0FdXfUvzND58+2oP4RMC9OjtL8yCJqquH7RxwHWriM7UJcZGgoWX
         cTLvDJRUlFAPwe6f5uFdZgcnHWG/4Y3vsnzWtsG8XImB1dOwXWbenozsZXUTLcd1pfry
         km0sd7Y1mPsNLcPFpT32uz8sRZVVEOiT1QK6BxxEwmu6i4ZvXAMhBKvZnmJmc3MfHiy2
         w/WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kKIv4WwP+TPekq1SKWfh6PaUQyZ3d/TjdhpPmq98mVc=;
        b=NiX/QG3sAs4PZPkYRiIkKjmRBJ9YmEXi/a0wSt0hbZwr5u6nab/O5kPMP6i7/LlOcg
         5Ymg79+Vybyey5y28k7OiEpj0vsc9dCf4tGMoDk3LVdQIIvI5AvYbIb3UQRm2+J0JQvG
         Ztv+JAsjdAv2+QdOuaq0cG6An38dK3QK8/W1zne3Uwqy7nIKdtJwXaIjmSlq92ecfF+d
         sUp5Sn+Lql/ePL8MezHmySuufW/U36X95PvJIbXitKynO8MKVGg74hLVV/dpzkOMEOJV
         8RmC4lvDQ1n1l/DWlmotrdkrHJTiMI/wvgi65qoKH86QECiBclhOjwJtg9+6QQPMIz7k
         XTuQ==
X-Gm-Message-State: AHQUAubOHhv8t33gJ+hgnqpZZ3stx/swhxPIt+legiqNPZ6cgto55lwO
        5phl6d44F+l8RpzjEAtDbu0eZICZLw==
X-Google-Smtp-Source: APXvYqx9BGSeRGlUYxAEGoGkf4qYjPo4cRaBykUu+mhrePl+3xHx2M+aTvv4cinx9+w37opDghA6wrKoDw==
X-Received: by 2002:a24:13d3:: with SMTP id 202mr231200itz.20.1551239704922;
 Tue, 26 Feb 2019 19:55:04 -0800 (PST)
Date:   Tue, 26 Feb 2019 19:54:48 -0800
In-Reply-To: <20190227035448.117169-1-fengc@google.com>
Message-Id: <20190227035448.117169-4-fengc@google.com>
Mime-Version: 1.0
References: <20190227035448.117169-1-fengc@google.com>
X-Mailer: git-send-email 2.21.0.rc2.261.ga7da99ff1b-goog
Subject: [RFC dma-buf 3/3] dma-buf: add show_fdinfo handler
From:   Chenbo Feng <fengc@google.com>
To:     linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org
Cc:     Sumit Semwal <sumit.semwal@linaro.org>, erickreyes@google.com,
        Greg Hackmann <ghackmann@google.com>,
        Chenbo Feng <fengc@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Greg Hackmann <ghackmann@google.com>

The show_fdinfo handler exports the same information available through
debugfs on a per-buffer basis.

Signed-off-by: Greg Hackmann <ghackmann@google.com>
Signed-off-by: Chenbo Feng <fengc@google.com>
---
 drivers/dma-buf/dma-buf.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index e0d9cdd3520b..2da3e2653f92 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -377,6 +377,20 @@ static long dma_buf_ioctl(struct file *file,
 	}
 }
 
+static void dma_buf_show_fdinfo(struct seq_file *m, struct file *file)
+{
+	struct dma_buf *dmabuf = file->private_data;
+
+	seq_printf(m, "size:\t%zu\n", dmabuf->size);
+	/* Don't count the temporary reference taken inside procfs seq_show */
+	seq_printf(m, "count:\t%ld\n", file_count(dmabuf->file) - 1);
+	seq_printf(m, "exp_name:\t%s\n", dmabuf->exp_name);
+	mutex_lock(&dmabuf->lock);
+	if (dmabuf->name)
+		seq_printf(m, "name:\t%s\n", dmabuf->name);
+	mutex_unlock(&dmabuf->lock);
+}
+
 static const struct file_operations dma_buf_fops = {
 	.release	= dma_buf_release,
 	.mmap		= dma_buf_mmap_internal,
@@ -386,6 +400,7 @@ static const struct file_operations dma_buf_fops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= dma_buf_ioctl,
 #endif
+	.show_fdinfo	= dma_buf_show_fdinfo,
 };
 
 /*
-- 
2.21.0.rc2.261.ga7da99ff1b-goog

