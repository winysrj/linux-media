Return-Path: <SRS0=TC89=RZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05BB2C43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 02:51:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDDA9218FE
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 02:51:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uzdYZAUE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbfCVCvv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Mar 2019 22:51:51 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:55124 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727470AbfCVCvu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Mar 2019 22:51:50 -0400
Received: by mail-pf1-f202.google.com with SMTP id h69so908449pfd.21
        for <linux-media@vger.kernel.org>; Thu, 21 Mar 2019 19:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ngOgc8NMJrsPR/pd5Pkh6PqgDUQL5+isFm5PaQ45/j0=;
        b=uzdYZAUE9vZg/dVHiztz5ik63sdmxBSzXVG89IH/D6tcGreVlodDNxh7Vct5Nb0DfH
         NrTxudNEiOgs2UBxndPZDv2o/EDvWuW8zmzWO6lU6X0PsZWA4mlrtEVpq8HPNpNxJUYR
         utE/R/RkxkcrZkktBoqXIxGSNkU5cpUreC/CwOYk2Qsa5PsApe5ZX5nOCtvffxyd2aCR
         0x1PHr955DLbiVIqUYJ8VB55/rVLlsH4kW1mxw+uoYZ3ESsNB+gSe1W854WobjDrK3Mh
         5EGfpermX4LW+UXTyOTg0E2FJy1Ds/micmdVZxli09njV4SgU80nU02AxoEhWuLawT3x
         vxng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ngOgc8NMJrsPR/pd5Pkh6PqgDUQL5+isFm5PaQ45/j0=;
        b=BeZwZxW+zdGITGJQf1yF31qSbp08WMrET7vwdE4sTsFZaZhDEYkhtISYCSw22aiWdr
         jyvLsLqtN4l9dPs8FxDl/nxcvDK52SFIkvA7Hn5cesnz99TBW78xCxH/HeSsxN1H/CEg
         Y8OaFrNkeu8HPyMNQWsTHiHx6qSNV5eBJw5VzvcpGYgGb4wxB+eVI7lDrjNAjRYCFscK
         X9gNRko73tL5TvgMOqaHg8JEe/Gh7flD4WSnzoCpxUAYU+OZ26ewbVqp5WgXM/fxL+4J
         HnhVTXGRlpiRY9drlYkoYK+xGWLOvpE5laO3ovsUTU8Dn4gwxuUMY4E61oSM+RoGuybE
         Koqg==
X-Gm-Message-State: APjAAAX9vZJgexTCAyLqCsF0Gl8XG/UCD8MmTPawHSWd2UQcw2Jcw02u
        lOniRfJqQsEyurOWZXKpRJdnu8qiYg==
X-Google-Smtp-Source: APXvYqwegXJy2rzVuAlQxWUtl7LX3V8j+Kp/5/Z94GZ0+JLg3mpi2AOJ+Bsmm8Xr25OjC2Rg35yGZ3/Mng==
X-Received: by 2002:a63:e80d:: with SMTP id s13mr6547585pgh.379.1553223109277;
 Thu, 21 Mar 2019 19:51:49 -0700 (PDT)
Date:   Thu, 21 Mar 2019 19:51:34 -0700
In-Reply-To: <20190322025135.118201-1-fengc@google.com>
Message-Id: <20190322025135.118201-3-fengc@google.com>
Mime-Version: 1.0
References: <20190322025135.118201-1-fengc@google.com>
X-Mailer: git-send-email 2.21.0.225.g810b269d1ac-goog
Subject: [RFC v2 2/3] dma-buf: add DMA_BUF_{GET,SET}_NAME ioctls
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
 drivers/dma-buf/dma-buf.c    | 48 ++++++++++++++++++++++++++++++++++--
 include/linux/dma-buf.h      |  5 +++-
 include/uapi/linux/dma-buf.h |  4 +++
 3 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index ffd5a2ad7d6f..f5e8d4fab950 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -297,6 +297,42 @@ static __poll_t dma_buf_poll(struct file *file, poll_table *poll)
 	return events;
 }
 
+static long dma_buf_set_name(struct dma_buf *dmabuf, const char __user *buf)
+{
+	char *name = strndup_user(buf, DMA_BUF_NAME_LEN);
+	long ret = 0;
+
+	if (IS_ERR(name))
+		return PTR_ERR(name);
+
+	mutex_lock(&dmabuf->lock);
+	if (!list_empty(&dmabuf->attachments)) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+	kfree(dmabuf->name);
+	dmabuf->name = name;
+
+out_unlock:
+	mutex_unlock(&dmabuf->lock);
+	return ret;
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
@@ -335,6 +371,13 @@ static long dma_buf_ioctl(struct file *file,
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
@@ -1082,12 +1125,13 @@ static int dma_buf_debug_show(struct seq_file *s, void *unused)
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
2.21.0.225.g810b269d1ac-goog

