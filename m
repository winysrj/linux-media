Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:10656 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab3AHMnq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 07:43:46 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: gennarone@gmail.com
Subject: Re: cron job: media_tree daily build: ERRORS
Date: Tue, 8 Jan 2013 13:43:43 +0100
Cc: linux-media@vger.kernel.org
References: <20130107213823.ED56311E00F1@alastor.dyndns.org> <201301081058.11297.hverkuil@xs4all.nl> <50EBFC9F.2060103@gmail.com>
In-Reply-To: <50EBFC9F.2060103@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201301081343.43562.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 8 January 2013 12:01:51 Gianluca Gennari wrote:
> Il 08/01/2013 10:58, Hans Verkuil ha scritto:
> > On Mon 7 January 2013 22:38:23 Hans Verkuil wrote:
> >> This message is generated daily by a cron job that builds media_tree for
> >> the kernels and architectures in the list below.
> >>
> >> Results of the daily build of media_tree:
> >>
> >> date:        Mon Jan  7 19:00:18 CET 2013
> >> git hash:    73ec66c000e9816806c7380ca3420f4e0638c40e
> >> gcc version:      i686-linux-gcc (GCC) 4.7.1
> >> host hardware:    x86_64
> >> host os:          3.4.07-marune
> >>
> >> linux-git-arm-eabi-davinci: WARNINGS
> >> linux-git-arm-eabi-exynos: WARNINGS
> >> linux-git-arm-eabi-omap: ERRORS
> >> linux-git-i686: OK
> >> linux-git-m32r: OK
> >> linux-git-mips: WARNINGS
> >> linux-git-powerpc64: OK
> >> linux-git-sh: OK
> >> linux-git-x86_64: OK
> >> linux-2.6.31.12-i686: WARNINGS
> >> linux-2.6.32.6-i686: WARNINGS
> >> linux-2.6.33-i686: WARNINGS
> >> linux-2.6.34-i686: WARNINGS
> >> linux-2.6.35.3-i686: WARNINGS
> >> linux-2.6.36-i686: WARNINGS
> >> linux-2.6.37-i686: WARNINGS
> >> linux-2.6.38.2-i686: WARNINGS
> >> linux-2.6.39.1-i686: WARNINGS
> >> linux-3.0-i686: WARNINGS
> >> linux-3.1-i686: WARNINGS
> >> linux-3.2.1-i686: WARNINGS
> >> linux-3.3-i686: WARNINGS
> >> linux-3.4-i686: WARNINGS
> >> linux-3.5-i686: WARNINGS
> >> linux-3.6-i686: WARNINGS
> >> linux-3.7-i686: WARNINGS
> >> linux-3.8-rc1-i686: WARNINGS
> >> linux-2.6.31.12-x86_64: WARNINGS
> >> linux-2.6.32.6-x86_64: WARNINGS
> >> linux-2.6.33-x86_64: WARNINGS
> >> linux-2.6.34-x86_64: WARNINGS
> >> linux-2.6.35.3-x86_64: WARNINGS
> >> linux-2.6.36-x86_64: WARNINGS
> >> linux-2.6.37-x86_64: WARNINGS
> >> linux-2.6.38.2-x86_64: WARNINGS
> >> linux-2.6.39.1-x86_64: WARNINGS
> >> linux-3.0-x86_64: WARNINGS
> >> linux-3.1-x86_64: WARNINGS
> >> linux-3.2.1-x86_64: WARNINGS
> >> linux-3.3-x86_64: WARNINGS
> >> linux-3.4-x86_64: WARNINGS
> >> linux-3.5-x86_64: WARNINGS
> >> linux-3.6-x86_64: WARNINGS
> >> linux-3.7-x86_64: WARNINGS
> >> linux-3.8-rc1-x86_64: WARNINGS
> >> apps: WARNINGS
> >> spec-git: OK
> >> sparse: ERRORS
> >>
> >> Detailed results are available here:
> >>
> >> http://www.xs4all.nl/~hverkuil/logs/Monday.log
> > 
> > There were a lot of new 'redefined' warnings that I have fixed.
> > 
> > In addition, it turned out that any driver using vb2 wasn't compiled for
> > kernels <3.2 due to the fact that DMA_SHARED_BUFFER wasn't set. That's fixed
> > as well, so drivers like em28xx and vivi will now compile on those older
> > kernels. This also was the reason I never saw that the usb_translate_error
> > function needed to be added to compat.h: it's used in em28xx but that driver
> > was never compiled on kernels without usb_translate_error.
> > 
> > Hopefully everything works now.
> > 
> > Regards,
> > 
> > 	Hans
> 
> Hi Hans,
> on kernel 2.6.32 (Ubuntu 10.04) the media_build tree compiles fine, with
> just a few remaining warnings.
> 
> In particular, there are several new warnings related to DMA_SHARED_BUFFER:
> 
> WARNING: "dma_buf_vunmap" [media_build/v4l/videobuf2-vmalloc.ko] undefined!
> WARNING: "dma_buf_vmap" [media_build/v4l/videobuf2-vmalloc.ko] undefined!
> WARNING: "dma_buf_fd" [media_build/v4l/videobuf2-core.ko] undefined!
> WARNING: "dma_buf_put" [media_build/v4l/videobuf2-core.ko] undefined!
> WARNING: "dma_buf_get" [media_build/v4l/videobuf2-core.ko] undefined!

Gianluca,

Can you patch media_build with the patch below and try again? If it doesn't
work, then replace '#ifdef CONFIG_DMA_SHARED_BUFFER' by '#if 0' in the patch
below and try that instead.

Let me know what works.

Thanks,

	Hans


diff --git a/backports/backports.txt b/backports/backports.txt
index f2d08b9..73ecbf6 100644
--- a/backports/backports.txt
+++ b/backports/backports.txt
@@ -26,6 +26,7 @@ add pr_fmt.patch
 
 [3.1.255]
 add v3.1_no_export_h.patch
+add v3.1_no_dma_buf_h.patch
 add v3.1_no_pm_qos.patch
 
 [3.0.255]
diff --git a/backports/v3.1_no_dma_buf_h.patch b/backports/v3.1_no_dma_buf_h.patch
new file mode 100644
index 0000000..5a7a7fb
--- /dev/null
+++ b/backports/v3.1_no_dma_buf_h.patch
@@ -0,0 +1,116 @@
+diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
+index bd2e52c..eb48f38 100644
+--- a/include/linux/dma-buf.h
++++ b/include/linux/dma-buf.h
+@@ -156,6 +156,7 @@ static inline void get_dma_buf(struct dma_buf *dmabuf)
+ 	get_file(dmabuf->file);
+ }
+ 
++#ifdef CONFIG_DMA_SHARED_BUFFER
+ struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
+ 							struct device *dev);
+ void dma_buf_detach(struct dma_buf *dmabuf,
+@@ -183,5 +184,103 @@ int dma_buf_mmap(struct dma_buf *, struct vm_area_struct *,
+ 		 unsigned long);
+ void *dma_buf_vmap(struct dma_buf *);
+ void dma_buf_vunmap(struct dma_buf *, void *vaddr);
++#else
++
++static inline struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
++							struct device *dev)
++{
++	return ERR_PTR(-ENODEV);
++}
++
++static inline void dma_buf_detach(struct dma_buf *dmabuf,
++				  struct dma_buf_attachment *dmabuf_attach)
++{
++	return;
++}
++
++static inline struct dma_buf *dma_buf_export(void *priv,
++					     const struct dma_buf_ops *ops,
++					     size_t size, int flags)
++{
++	return ERR_PTR(-ENODEV);
++}
++
++static inline int dma_buf_fd(struct dma_buf *dmabuf, int flags)
++{
++	return -ENODEV;
++}
++
++static inline struct dma_buf *dma_buf_get(int fd)
++{
++	return ERR_PTR(-ENODEV);
++}
++
++static inline void dma_buf_put(struct dma_buf *dmabuf)
++{
++	return;
++}
++
++static inline struct sg_table *dma_buf_map_attachment(
++	struct dma_buf_attachment *attach, enum dma_data_direction write)
++{
++	return ERR_PTR(-ENODEV);
++}
++
++static inline void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
++			struct sg_table *sg, enum dma_data_direction dir)
++{
++	return;
++}
++
++static inline int dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
++					   size_t start, size_t len,
++					   enum dma_data_direction dir)
++{
++	return -ENODEV;
++}
++
++static inline void dma_buf_end_cpu_access(struct dma_buf *dmabuf,
++					  size_t start, size_t len,
++					  enum dma_data_direction dir)
++{
++}
++
++static inline void *dma_buf_kmap_atomic(struct dma_buf *dmabuf,
++					unsigned long pnum)
++{
++	return NULL;
++}
++
++static inline void dma_buf_kunmap_atomic(struct dma_buf *dmabuf,
++					 unsigned long pnum, void *vaddr)
++{
++}
++
++static inline void *dma_buf_kmap(struct dma_buf *dmabuf, unsigned long pnum)
++{
++	return NULL;
++}
++
++static inline void dma_buf_kunmap(struct dma_buf *dmabuf,
++				  unsigned long pnum, void *vaddr)
++{
++}
++
++static inline int dma_buf_mmap(struct dma_buf *dmabuf,
++			       struct vm_area_struct *vma,
++			       unsigned long pgoff)
++{
++	return -ENODEV;
++}
++
++static inline void *dma_buf_vmap(struct dma_buf *dmabuf)
++{
++	return NULL;
++}
++
++static inline void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
++{
++}
++#endif /* CONFIG_DMA_SHARED_BUFFER */
+ 
+ #endif /* __DMA_BUF_H__ */
