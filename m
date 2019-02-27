Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C1C2C00319
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 03:55:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B87620C01
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 03:55:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o/Owk6qk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729719AbfB0DzF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 22:55:05 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:40115 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729638AbfB0DzC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 22:55:02 -0500
Received: by mail-pf1-f201.google.com with SMTP id z24so11045595pfn.7
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2019 19:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OeEbxgdEvD7vVmHTXrOO/jaZroEBj9Mfsqoiz7bsGqk=;
        b=o/Owk6qki0EHKuavI3s2QYe8Si20yn7yvy0fW7oYtTT16BFT6Ez+CxIngEz/GgBC+5
         vfp2xvA6b8jy6gAvR1YAHrv2XZIRnptxj9FSgzM8SzMvy+2CnRwG5xLVnjgjqpNHRZqu
         UyTSA4AmMUFHsmSKY4GR6T1MhcjZRGk/f5r6h9RJDo0ag/OLdxPKmhJkFDSDtcbfdZIu
         EmIBTdJjel2nHHbEHp7lKLPqSaRUOBJ2rgjtIV6ArB+t1nVso2AOdCeQ8adD3HRMsJ9o
         teXVa5eA4TpZv5dhOq88B2ZkhGAin6Dw/M967yOlS0njb3u+w3rozr9JPm1Op2+LiXJW
         JqWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OeEbxgdEvD7vVmHTXrOO/jaZroEBj9Mfsqoiz7bsGqk=;
        b=kGXZiw3RRcVOWhRWUfUF7h5Sqb8bnQA1iLUUMXT9Eeg+mtTsl+oE8O+ht1cONaSSvP
         4o97RqpPqRsTCwBeeA3AC4FjeRXFCEb+FXGlnLIeVxjqEi0MZOJzsfOwKcjzqoW04rrW
         /V7qQNrFd/dAr0ahJR2Ip6wMaGIIasKh30kVA2G9CbVXc5v91BXeC3MQn8wLtN7QDeuP
         IMoQz5JZxAXTtJTKSUgwhSDPF0XjU+ECV34aIc5HGmRPFOJ/9lOMM6zfsn9XAtq41oey
         a1HXKK1u2rYVfp4I6Xx1sx6UyD5liNxgu27ME4DzNopTqB8zBoa7DDj6Onvp5un9AxuY
         XWpA==
X-Gm-Message-State: AHQUAuajH30u9oibLORAdia6Hx6VTy96IG3JKSvcjn6LUW7Rxa2p2Uvo
        0Cx3qxkLvwm9ivdhTzQ0np+/p+Nulg==
X-Google-Smtp-Source: AHgI3Ibziiz4/32CFSgBthelLG0rzMXhLXQt6Cu1VGEvEol7+xxgXkLXAZkgND/ETrPhtm8L/iD3ZuPsEw==
X-Received: by 2002:a62:6b06:: with SMTP id g6mr9965004pfc.76.1551239701364;
 Tue, 26 Feb 2019 19:55:01 -0800 (PST)
Date:   Tue, 26 Feb 2019 19:54:47 -0800
In-Reply-To: <20190227035448.117169-1-fengc@google.com>
Message-Id: <20190227035448.117169-3-fengc@google.com>
Mime-Version: 1.0
References: <20190227035448.117169-1-fengc@google.com>
X-Mailer: git-send-email 2.21.0.rc2.261.ga7da99ff1b-goog
Subject: [RFC dma-buf 2/3] dma-buf: add DMA_BUF_{GET,SET}_NAME ioctls
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

This patch adds complimentary DMA_BUF_SET_NAME and DMA_BUF_GET_NAME
ioctls, which lets userspace processes attach a free-form name to each
buffer.

This information can be extremely helpful for tracking and accounting
shared buffers.  For example, on Android, we know what each buffer will
be used for at allocation time: GL, multimedia, camera, etc.  The
userspace allocator can use DMA_BUF_SET_NAME to associate that
information with the buffer, so we can later give developers a
breakdown of how much memory they're allocating for graphics, camera,
etc.

Signed-off-by: Greg Hackmann <ghackmann@google.com>
Signed-off-by: Chenbo Feng <fengc@google.com>
---
 drivers/dma-buf/dma-buf.c    | 42 ++++++++++++++++++++++++++++++++++--
 include/linux/dma-buf.h      |  5 ++++-
 include/uapi/linux/dma-buf.h |  4 ++++
 3 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index d72352356ac5..e0d9cdd3520b 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -297,6 +297,36 @@ static __poll_t dma_buf_poll(struct file *file, poll_table *poll)
 	return events;
 }
 
+static long dma_buf_set_name(struct dma_buf *dmabuf, const char __user *buf)
+{
+	char *name = strndup_user(buf, DMA_BUF_NAME_LEN);
+
+	if (IS_ERR(name))
+		return PTR_ERR(name);
+
+	mutex_lock(&dmabuf->lock);
+	kfree(dmabuf->name);
+	dmabuf->name = name;
+	mutex_unlock(&dmabuf->lock);
+
+	return 0;
+}
+
+static long dma_buf_get_name(struct dma_buf *dmabuf, char __user *buf)
+{
+	const char *name = "";
+	long ret = 0;
+
+	mutex_lock(&dmabuf->lock);
+	if (dmabuf->name)
+		name = dmabuf->name;
+	if (copy_to_user(buf, name, strlen(name) + 1))
+		ret = -EFAULT;
+	mutex_unlock(&dmabuf->lock);
+
+	return ret;
+}
+
 static long dma_buf_ioctl(struct file *file,
 			  unsigned int cmd, unsigned long arg)
 {
@@ -335,6 +365,13 @@ static long dma_buf_ioctl(struct file *file,
 			ret = dma_buf_begin_cpu_access(dmabuf, direction);
 
 		return ret;
+
+	case DMA_BUF_SET_NAME:
+		return dma_buf_set_name(dmabuf, (const char __user *)arg);
+
+	case DMA_BUF_GET_NAME:
+		return dma_buf_get_name(dmabuf, (char __user *)arg);
+
 	default:
 		return -ENOTTY;
 	}
@@ -1083,12 +1120,13 @@ static int dma_buf_debug_show(struct seq_file *s, void *unused)
 			continue;
 		}
 
-		seq_printf(s, "%08zu\t%08x\t%08x\t%08ld\t%s\t%08lu\n",
+		seq_printf(s, "%08zu\t%08x\t%08x\t%08ld\t%s\t%08lu\t%s\n",
 				buf_obj->size,
 				buf_obj->file->f_flags, buf_obj->file->f_mode,
 				file_count(buf_obj->file),
 				buf_obj->exp_name,
-				file_inode(buf_obj->file)->i_ino);
+				file_inode(buf_obj->file)->i_ino,
+				buf_obj->name ?: "");
 
 		robj = buf_obj->resv;
 		while (true) {
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 58725f890b5b..582998e19df6 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -255,10 +255,12 @@ struct dma_buf_ops {
  * @file: file pointer used for sharing buffers across, and for refcounting.
  * @attachments: list of dma_buf_attachment that denotes all devices attached.
  * @ops: dma_buf_ops associated with this buffer object.
- * @lock: used internally to serialize list manipulation, attach/detach and vmap/unmap
+ * @lock: used internally to serialize list manipulation, attach/detach and
+ *        vmap/unmap, and accesses to name
  * @vmapping_counter: used internally to refcnt the vmaps
  * @vmap_ptr: the current vmap ptr if vmapping_counter > 0
  * @exp_name: name of the exporter; useful for debugging.
+ * @name: userspace-provided name; useful for accounting and debugging.
  * @owner: pointer to exporter module; used for refcounting when exporter is a
  *         kernel module.
  * @list_node: node for dma_buf accounting and debugging.
@@ -286,6 +288,7 @@ struct dma_buf {
 	unsigned vmapping_counter;
 	void *vmap_ptr;
 	const char *exp_name;
+	const char *name;
 	struct module *owner;
 	struct list_head list_node;
 	void *priv;
diff --git a/include/uapi/linux/dma-buf.h b/include/uapi/linux/dma-buf.h
index d75df5210a4a..4e9c5fe7aecd 100644
--- a/include/uapi/linux/dma-buf.h
+++ b/include/uapi/linux/dma-buf.h
@@ -35,7 +35,11 @@ struct dma_buf_sync {
 #define DMA_BUF_SYNC_VALID_FLAGS_MASK \
 	(DMA_BUF_SYNC_RW | DMA_BUF_SYNC_END)
 
+#define DMA_BUF_NAME_LEN	32
+
 #define DMA_BUF_BASE		'b'
 #define DMA_BUF_IOCTL_SYNC	_IOW(DMA_BUF_BASE, 0, struct dma_buf_sync)
+#define DMA_BUF_SET_NAME	_IOW(DMA_BUF_BASE, 1, const char *)
+#define DMA_BUF_GET_NAME	_IOR(DMA_BUF_BASE, 2, char *)
 
 #endif
-- 
2.21.0.rc2.261.ga7da99ff1b-goog

