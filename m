Return-Path: <SRS0=TC89=RZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BFF5C10F00
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 02:51:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AD04218FE
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 02:51:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SjeYvfv8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbfCVCvx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Mar 2019 22:51:53 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:45913 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727549AbfCVCvx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Mar 2019 22:51:53 -0400
Received: by mail-pg1-f202.google.com with SMTP id f1so819274pgv.12
        for <linux-media@vger.kernel.org>; Thu, 21 Mar 2019 19:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=H4IOWZCkGYhUPwHHpFSIM1VKmYj0I6VEVbKesqW/rWE=;
        b=SjeYvfv8Nh9cZPFzPL1DWyNB4x4zoH+B5MKpu68fGKXAXIzrNxVz7F4D8N/9ttHP+I
         nNM0/5w+KuUuTXz4s+cQ0zWBKWFBO5t3PpHBZvP2zc7LdxCLdzDLoXNFpSMYeuJx9rPu
         1d/pSP5YE5nHRPZ3m3vEfZ9/tk/EQjnmEfYYaykGyt+e+v1VuTTjiPzEAMlfy2aT7D51
         E9/MIrlL7G9HZJQSII+yQMLLZpIl4YxYY2C1E4MX47G5PCZJ7Oa/ftIXGWIBxSl725EA
         R34wUndAjXVOtZRzDGvO2D9Kmcfqt/xFnD56bLJk5Z5MVzKjTkBGFsuZyDDet6Mrm8cX
         YpHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=H4IOWZCkGYhUPwHHpFSIM1VKmYj0I6VEVbKesqW/rWE=;
        b=OXcejDsuCic7brIUgJxHmo2tj/YScydiO+cu1J7cmHt954rEQU4uRFUNAWUTyTQwrn
         9Lj4bDcQ+c94RA8N3zgtn+JD3Zsay8yQSoPHf884MI8QLLV3kU89O8ajYzCCpCXSRUaW
         j1ukO8GY2jL+qaENpX3edeQP1OpUyf7S0AyOq6UAd5MGfMIhNzny9cjxkYoV9nR6A1fi
         fPbWh+aP+ym4du2N7/EGTk32clnW/yZm4tA2M+VHoVgs9bvZG1GVYoskd/hRBdupy8Vi
         dNStC8nBHijmKF6H89PYnS4XsMqdgA4Uf/8pWp1EyKUGNoqjZ7Y2AQngAsI6XSMVZNrS
         SWvw==
X-Gm-Message-State: APjAAAVB7rzuNdMO1xtkjlmiO5BlSHN2amEssqBpCZfCNLUnmS4c+CQp
        GBrl8+PvWnJBIgyunWGh5XPEdWI19g==
X-Google-Smtp-Source: APXvYqwdtCPG1+7twB0gRW+8DwLDfOq5u3mV3fQy3e1VGEncft2iI6eY/DeOWiLjEWWHb0IbFHWBh1b8Dw==
X-Received: by 2002:a63:545f:: with SMTP id e31mr6450118pgm.409.1553223112247;
 Thu, 21 Mar 2019 19:51:52 -0700 (PDT)
Date:   Thu, 21 Mar 2019 19:51:35 -0700
In-Reply-To: <20190322025135.118201-1-fengc@google.com>
Message-Id: <20190322025135.118201-4-fengc@google.com>
Mime-Version: 1.0
References: <20190322025135.118201-1-fengc@google.com>
X-Mailer: git-send-email 2.21.0.225.g810b269d1ac-goog
Subject: [RFC v2 3/3] dma-buf: add show_fdinfo handler
From:   Chenbo Feng <fengc@google.com>
To:     linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org
Cc:     kernel-team@android.com, Sumit Semwal <sumit.semwal@linaro.org>,
        erickreyes@google.com, Daniel Vetter <daniel@ffwll.ch>,
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
index f5e8d4fab950..fc7be2939ba1 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -383,6 +383,20 @@ static long dma_buf_ioctl(struct file *file,
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
@@ -392,6 +406,7 @@ static const struct file_operations dma_buf_fops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= dma_buf_ioctl,
 #endif
+	.show_fdinfo	= dma_buf_show_fdinfo,
 };
 
 /*
-- 
2.21.0.225.g810b269d1ac-goog

