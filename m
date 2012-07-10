Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:24974 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325Ab2GJPKl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 11:10:41 -0400
Received: from eusync1.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M6Y00H6CA6RADC0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Jul 2012 16:11:15 +0100 (BST)
Received: from AMDN157 ([106.116.147.102])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0M6Y00B3MA5POZ00@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Jul 2012 16:10:39 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Arun Kumar K' <arun.kk@samsung.com>, linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, janghyuck.kim@samsung.com,
	jaeryul.oh@samsung.com, ch.naveen@samsung.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	hans.verkuil@cisco.com, mchehab@infradead.org
References: <1341583217-11305-1-git-send-email-arun.kk@samsung.com>
 <1341583217-11305-3-git-send-email-arun.kk@samsung.com>
In-reply-to: <1341583217-11305-3-git-send-email-arun.kk@samsung.com>
Subject: RE: [PATCH v2 2/2] [media] s5p-mfc: update MFC v4l2 driver to support
 MFC6.x
Date: Tue, 10 Jul 2012 17:10:37 +0200
Message-id: <007901cd5eae$29fc3f50$7df4bdf0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

Please find some additional comments below.

> From: Arun Kumar K [mailto:arun.kk@samsung.com]
> Sent: 06 July 2012 16:00

[snip]


> diff --git a/drivers/media/video/s5p-mfc/Makefile
> b/drivers/media/video/s5p-mfc/Makefile
> index d066340..0308d74 100644
> --- a/drivers/media/video/s5p-mfc/Makefile
> +++ b/drivers/media/video/s5p-mfc/Makefile
> @@ -1,5 +1,6 @@
>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC) := s5p-mfc.o
> -s5p-mfc-y += s5p_mfc.o s5p_mfc_intr.o s5p_mfc_opr.o
> +s5p-mfc-y += s5p_mfc.o s5p_mfc_intr.o
>  s5p-mfc-y += s5p_mfc_dec.o s5p_mfc_enc.o
> -s5p-mfc-y += s5p_mfc_ctrl.o s5p_mfc_cmd.o
> -s5p-mfc-y += s5p_mfc_pm.o s5p_mfc_shm.o
> +s5p-mfc-y += s5p_mfc_ctrl.o s5p_mfc_pm.o
> +obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC_V5) += s5p_mfc_opr.o s5p_mfc_cmd.o
> s5p_mfc_shm.o
> +obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC_V6) += s5p_mfc_opr_v6.o
> s5p_mfc_cmd_v6.o
> diff --git a/drivers/media/video/s5p-mfc/regs-mfc-v6.h
> b/drivers/media/video/s5p-mfc/regs-mfc-v6.h
> new file mode 100644
> index 0000000..f22a159

This Makefile does not work when compiling the driver as a module.
(I also wrote about this in my previous email)

[snip]

> 
>  #endif /* _REGS_FIMV_H */
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c
> b/drivers/media/video/s5p-mfc/s5p_mfc.c
> index 9bb68e7..bec94bc 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc.c

[snip]

> @@ -285,12 +276,13 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx
> *ctx,
> 
>  	dst_frame_status = s5p_mfc_get_dspl_status()
>  				& S5P_FIMV_DEC_STATUS_DECODING_STATUS_MASK;
> -	res_change = s5p_mfc_get_dspl_status()
> -				& S5P_FIMV_DEC_STATUS_RESOLUTION_MASK;
> +	res_change = (s5p_mfc_get_dspl_status()
> +				& S5P_FIMV_DEC_STATUS_RESOLUTION_MASK)
> +				>> S5P_FIMV_DEC_STATUS_RESOLUTION_SHIFT;
>  	mfc_debug(2, "Frame Status: %x\n", dst_frame_status);
>  	if (ctx->state == MFCINST_RES_CHANGE_INIT)
>  		ctx->state = MFCINST_RES_CHANGE_FLUSH;
> -	if (res_change) {
> +	if (res_change && res_change != 3) {

Maybe 
If (res_change == 1 || res_change == 2) {
would be better, at least it would be more clear.

[snip]


> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_common.h
> b/drivers/media/video/s5p-mfc/s5p_mfc_common.h
> index bd5706a..8c646f4 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_common.h
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_common.h

[snip]

> @@ -499,37 +563,42 @@ struct s5p_mfc_ctx {
>  	int display_delay;
>  	int display_delay_enable;
>  	int after_packed_pb;
> +	int sei_fp_parse;
> 
>  	int dpb_count;
>  	int total_dpb_count;
> 
>  	/* Buffers */
> -	void *ctx_buf;
> -	size_t ctx_phys;
> -	size_t ctx_ofs;
> -	size_t ctx_size;
> -
> -	void *desc_buf;
> -	size_t desc_phys;
> -
> -
> -	void *shm_alloc;
> -	void *shm;
> -	size_t shm_ofs;
> +	unsigned int ctx_size;
> +	struct s5p_mfc_priv_buf ctx;
> +	struct s5p_mfc_priv_buf dsc;
> +	struct s5p_mfc_priv_buf shm;

I think that ctx_size could be integrated in struct s5p_mfc_priv_buf.
Also - why unsigned int, where in other places you use size_t for size?
I think it should be consistent. I would choose size_t.

> 
>  	struct s5p_mfc_enc_params enc_params;
> 
>  	size_t enc_dst_buf_size;
> +	size_t luma_dpb_size;
> +	size_t chroma_dpb_size;
> +	size_t me_buffer_size;
> +	size_t tmv_buffer_size;
> 

^^ You use size_t here.

[snip]

> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
> b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
> index 08a5cfe..65ff15d 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
> @@ -15,7 +15,6 @@
>  #include <linux/firmware.h>
>  #include <linux/jiffies.h>
>  #include <linux/sched.h>
> -#include "regs-mfc.h"
>  #include "s5p_mfc_cmd.h"
>  #include "s5p_mfc_common.h"
>  #include "s5p_mfc_debug.h"
> @@ -38,12 +37,12 @@ int s5p_mfc_alloc_and_load_firmware(struct
> s5p_mfc_dev *dev)
>  	 * into kernel. */
>  	mfc_debug_enter();
>  	err = request_firmware((const struct firmware **)&fw_blob,
> -				     "s5p-mfc.fw", dev->v4l2_dev.dev);
> +				     "mfc_fw.bin", dev->v4l2_dev.dev);

Another name change? This is getting ridiculous. Nein, nein, nein ! ;)
If you _*really*_ need such a change then go ahead and try to convince
me, but I tell you - it's going to be hard.

>  	if (err != 0) {
>  		mfc_err("Firmware is not present in the /lib/firmware
> directory nor compiled in kernel\n");
>  		return -EINVAL;
>  	}
> -	dev->fw_size = ALIGN(fw_blob->size, FIRMWARE_ALIGN);
> +	dev->fw_size = dev->variant->buf_size->fw;

Why is size taken from there instead of the size of the firmware file?
Even if there was some point to do it this way then you really *should*
check if the firmware read from the file fits in the allocated buffer.

This is a straight way to a buffer overflow error. All I need is to
prepare an extra big firmware file and "viola!" we have a buffer overflow
that could be fatal to the system. 

>  	if (s5p_mfc_bitproc_buf) {
>  		mfc_err("Attempting to allocate firmware when it seems that
> it is already loaded\n");
>  		release_firmware(fw_blob);
> @@ -77,28 +76,33 @@ int s5p_mfc_alloc_and_load_firmware(struct
> s5p_mfc_dev *dev)
>  		return -EIO;
>  	}
>  	dev->bank1 = s5p_mfc_bitproc_phys;
> -	b_base = vb2_dma_contig_memops.alloc(
> -		dev->alloc_ctx[MFC_BANK2_ALLOC_CTX], 1 <<
> MFC_BANK2_ALIGN_ORDER);
> -	if (IS_ERR(b_base)) {
> -		vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
> -		s5p_mfc_bitproc_phys = 0;
> -		s5p_mfc_bitproc_buf = NULL;
> -		mfc_err("Allocating bank2 base failed\n");
> -	release_firmware(fw_blob);
> -		return -ENOMEM;
> -	}
> -	bank2_base_phys = s5p_mfc_mem_cookie(
> -		dev->alloc_ctx[MFC_BANK2_ALLOC_CTX], b_base);
> -	vb2_dma_contig_memops.put(b_base);
> -	if (bank2_base_phys & ((1 << MFC_BASE_ALIGN_ORDER) - 1)) {
> -		mfc_err("The base memory for bank 2 is not aligned to
> 128KB\n");
> -		vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
> -		s5p_mfc_bitproc_phys = 0;
> -		s5p_mfc_bitproc_buf = NULL;
> -		release_firmware(fw_blob);
> -		return -EIO;
> +	if (HAS_PORTNUM(dev) && IS_TWOPORT(dev)) {
> +		b_base = vb2_dma_contig_memops.alloc(
> +			dev->alloc_ctx[MFC_BANK2_ALLOC_CTX],
> +			1 << MFC_BANK2_ALIGN_ORDER);
> +		if (IS_ERR(b_base)) {
> +			vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
> +			s5p_mfc_bitproc_phys = 0;
> +			s5p_mfc_bitproc_buf = 0;
> +			mfc_err("Allocating bank2 base failed\n");
> +			release_firmware(fw_blob);
> +			return -ENOMEM;
> +		}
> +		bank2_base_phys = s5p_mfc_mem_cookie(
> +			dev->alloc_ctx[MFC_BANK2_ALLOC_CTX], b_base);
> +		vb2_dma_contig_memops.put(b_base);
> +		if (bank2_base_phys & ((1 << MFC_BASE_ALIGN_ORDER) - 1)) {
> +			mfc_err("The base memory for bank 2 is not aligned to
> 128KB\n");
> +			vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
> +			s5p_mfc_bitproc_phys = 0;
> +			s5p_mfc_bitproc_buf = 0;
> +			release_firmware(fw_blob);
> +			return -EIO;
> +		}
> +		dev->bank2 = bank2_base_phys;
> +	} else {
> +		dev->bank2 = dev->bank1;
>  	}
> -	dev->bank2 = bank2_base_phys;
>  	memcpy(s5p_mfc_bitproc_virt, fw_blob->data, fw_blob->size);
>  	wmb();
>  	release_firmware(fw_blob);
> @@ -116,7 +120,7 @@ int s5p_mfc_reload_firmware(struct s5p_mfc_dev *dev)
>  	 * into kernel. */
>  	mfc_debug_enter();
>  	err = request_firmware((const struct firmware **)&fw_blob,
> -				     "s5p-mfc.fw", dev->v4l2_dev.dev);
> +				     "mfc_fw.bin", dev->v4l2_dev.dev);

Ditto.

[snip]


> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h
> b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h
> index 61dc23b..b72c8c6 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h

[snip]

> 
> @@ -336,21 +364,35 @@ static int vidioc_g_fmt(struct file *file, void
> *priv, struct v4l2_format *f)
>  /* Try format */
>  static int vidioc_try_fmt(struct file *file, void *priv, struct
> v4l2_format *f)
>  {
> +	struct s5p_mfc_dev *dev = video_drvdata(file);
>  	struct s5p_mfc_fmt *fmt;
> 
> -	if (f->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> -		mfc_err("This node supports decoding only\n");
> -		return -EINVAL;
> -	}
> -	fmt = find_format(f, MFC_FMT_DEC);
> -	if (!fmt) {
> -		mfc_err("Unsupported format\n");
> -		return -EINVAL;
> -	}
> -	if (fmt->type != MFC_FMT_DEC) {
> -		mfc_err("\n");
> -		return -EINVAL;
> +	mfc_debug(2, "Type is %d\n", f->type);
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		fmt = find_format(f, MFC_FMT_DEC);
> +		if (!fmt) {
> +			mfc_err("Unsupported format for source.\n");
> +			return -EINVAL;
> +		}
> +		if (!IS_MFCV6(dev) && (fmt->fourcc == V4L2_PIX_FMT_VP8)) {
> +			mfc_err("Not supported format.\n");
> +			return -EINVAL;
> +		}
> +	} else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		fmt = find_format(f, MFC_FMT_RAW);
> +		if (!fmt) {
> +			mfc_err("Unsupported format for destination.\n");
> +			return -EINVAL;
> +		}
> +		if (IS_MFCV6(dev) && (fmt->fourcc == V4L2_PIX_FMT_NV12MT)) {

Ok. Let's see.
If IS_MFCV6(dev) is 1 and
fmt->fourcc == V4L2_PIX_FMT_NV12MT is 0
then the following code is not run.

> +			mfc_err("Not supported format.\n");
> +			return -EINVAL;

And we get here.

> +		} else if (fmt->fourcc != V4L2_PIX_FMT_NV12MT) {

fmt->fourcc == V4L2_PIX_FMT_NV12MT is still 0, so
fmt->fourcc != V4L2_PIX_FMT_NV12MT is 1 and this code is run

> +			mfc_err("Not supported format.\n");
> +			return -EINVAL;
> +		}
>  	}
> +
>  	return 0;
>  }

My question is - what targets did you run this code on? Did you run it
on Exynos5 with MFC v6? Arun, it is important that you test the patches
that you send to the mailing list. Maybe you have sent different files
than the ones you have tested?

[snip]

diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
index 03d8334..645a8ef 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
@@ -24,48 +24,63 @@
 #include <linux/workqueue.h>
 #include <media/v4l2-ctrls.h>
 #include <media/videobuf2-core.h>
-#include "regs-mfc.h"
 #include "s5p_mfc_common.h"
 #include "s5p_mfc_debug.h"
 #include "s5p_mfc_enc.h"
 #include "s5p_mfc_intr.h"
-#include "s5p_mfc_opr.h"
+
+#define DEF_SRC_FMT	2
+#define DEF_DST_FMT	4

I would add ENC/DEC to the name of this define as it has confused me
because there are two symbols with the same name in different files.
Same applies to the s5p_mfc_dec.c file.

[snip] 

diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.h
b/drivers/media/video/s5p-mfc/s5p_mfc_enc.h
index 405bdd3..413f22f 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.h
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.h
@@ -19,5 +19,6 @@ const struct v4l2_ioctl_ops *get_enc_v4l2_ioctl_ops(void);
 struct s5p_mfc_fmt *get_enc_def_fmt(bool src);
 int s5p_mfc_enc_ctrls_setup(struct s5p_mfc_ctx *ctx);
 void s5p_mfc_enc_ctrls_delete(struct s5p_mfc_ctx *ctx);
+void s5p_mfc_enc_init(struct s5p_mfc_ctx *ctx);
 
 #endif /* S5P_MFC_ENC_H_  */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_intr.c
b/drivers/media/video/s5p-mfc/s5p_mfc_intr.c
index 8f2f8bf..dfdc558 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_intr.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_intr.c
@@ -17,7 +17,6 @@
 #include <linux/io.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
-#include "regs-mfc.h"
 #include "s5p_mfc_common.h"
 #include "s5p_mfc_debug.h"
 #include "s5p_mfc_intr.h"


> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
> b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
> index e6217cb..1fd9c92 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
> @@ -12,15 +12,12 @@
>   * published by the Free Software Foundation.
>   */
> 
> -#include "regs-mfc.h"
> -#include "s5p_mfc_cmd.h"
>  #include "s5p_mfc_common.h"
> +#include "s5p_mfc_cmd.h"
>  #include "s5p_mfc_ctrl.h"
>  #include "s5p_mfc_debug.h"
>  #include "s5p_mfc_intr.h"
> -#include "s5p_mfc_opr.h"
>  #include "s5p_mfc_pm.h"
> -#include "s5p_mfc_shm.h"
>  #include <asm/cacheflush.h>
>  #include <linux/delay.h>
>  #include <linux/dma-mapping.h>
> @@ -37,39 +34,31 @@
>  /* Allocate temporary buffers for decoding */
>  int s5p_mfc_alloc_dec_temp_buffers(struct s5p_mfc_ctx *ctx)
>  {
> -	void *desc_virt;
>  	struct s5p_mfc_dev *dev = ctx->dev;
> +	struct s5p_mfc_buf_size_v5 *buf_size = dev->variant->buf_size->priv;
> 
> -	ctx->desc_buf = vb2_dma_contig_memops.alloc(
> -			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], DESC_BUF_SIZE);
> -	if (IS_ERR_VALUE((int)ctx->desc_buf)) {
> -		ctx->desc_buf = NULL;
> +	ctx->dsc.alloc = vb2_dma_contig_memops.alloc(
> +			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX],
> +			buf_size->dsc);
> +	if (IS_ERR_VALUE((int)ctx->dsc.alloc)) {
> +		ctx->dsc.alloc = NULL;
>  		mfc_err("Allocating DESC buffer failed\n");
>  		return -ENOMEM;
>  	}
> -	ctx->desc_phys = s5p_mfc_mem_cookie(
> -			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->desc_buf);
> -	BUG_ON(ctx->desc_phys & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
> -	desc_virt = vb2_dma_contig_memops.vaddr(ctx->desc_buf);
> -	if (desc_virt == NULL) {
> -		vb2_dma_contig_memops.put(ctx->desc_buf);
> -		ctx->desc_phys = 0;
> -		ctx->desc_buf = NULL;
> -		mfc_err("Remapping DESC buffer failed\n");
> -		return -ENOMEM;
> -	}
> -	memset(desc_virt, 0, DESC_BUF_SIZE);
> -	wmb();

Why was this removed?
The driver should work with older firmware versions on Exynos4/S5PC110.
I remember that zeroing the desc buffer was (and still is?) mandatory.

[snip]

> 
> @@ -1395,3 +1471,21 @@ void s5p_mfc_cleanup_queue(struct list_head *lh,
> struct vb2_queue *vq)
>  	}
>  }
> 
> +void s5p_mfc_clear_int_flags(struct s5p_mfc_dev *dev)
> +{
> +	mfc_write(dev, 0, S5P_FIMV_RISC_HOST_INT);
> +	mfc_write(dev, 0, S5P_FIMV_RISC2HOST_CMD);
> +	mfc_write(dev, 0xffff, S5P_FIMV_SI_RTN_CHID);
> +}
> +
> +void s5p_mfc_write_info(struct s5p_mfc_ctx *ctx, unsigned int data,
> +			unsigned int ofs)
> +{
> +	s5p_mfc_write_shm(ctx, data, ofs);
> +}
> +
> +unsigned int s5p_mfc_read_info(struct s5p_mfc_ctx *ctx,
> +				unsigned int ofs)
> +{
> +	return s5p_mfc_read_shm(ctx, ofs);

About s5p_mfc_*_shm functions. If you are adding this kind of support for
two variants of MFC then maybe it would be a good idea to remove the
s5p_mfc_shm.c and s5p_mfc_shm.h files altogether. All register definitions
are already in the regs-mfc.h and regs-mfc-v6.h files. Instead of calling
s5p_mfc_*_shm from s5p_mfc_*_info it might be better to do the hardware
calls there. Also s5p_mfc_init_shm can be move to
s5p_mfc_alloc_instance_buffer.

> +}

[snip]

> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_pm.c
> b/drivers/media/video/s5p-mfc/s5p_mfc_pm.c
> index 738a607..4fa0b54 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_pm.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_pm.c
> @@ -20,7 +20,11 @@
>  #include "s5p_mfc_debug.h"
>  #include "s5p_mfc_pm.h"
> 
> -#define MFC_CLKNAME		"sclk_mfc"
> +#if defined(CONFIG_VIDEO_SAMSUNG_S5P_MFC_V5)
> +#define MFC_CLKNAME            "sclk_mfc"
> +#elif defined(CONFIG_VIDEO_SAMSUNG_S5P_MFC_V6)
> +#define MFC_CLKNAME            "aclk_333"
> +#endif
>  #define MFC_GATE_CLK_NAME	"mfc"

Maybe it would be better to check the variant during init
than use a define. 

> 
>  #define CLK_DEBUG
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_shm.c
> b/drivers/media/video/s5p-mfc/s5p_mfc_shm.c
> index 91fdbac..9ee269d 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_shm.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_shm.c
> @@ -21,26 +21,28 @@ int s5p_mfc_init_shm(struct s5p_mfc_ctx *ctx)
>  {
>  	struct s5p_mfc_dev *dev = ctx->dev;
>  	void *shm_alloc_ctx = dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
> +	struct s5p_mfc_buf_size_v5 *buf_size = dev->variant->buf_size->priv;
> 
> -	ctx->shm_alloc = vb2_dma_contig_memops.alloc(shm_alloc_ctx,
> -							SHARED_BUF_SIZE);
> -	if (IS_ERR(ctx->shm_alloc)) {
> +	ctx->shm.alloc = vb2_dma_contig_memops.alloc(shm_alloc_ctx,
> +							buf_size->shm);
> +	if (IS_ERR(ctx->shm.alloc)) {
>  		mfc_err("failed to allocate shared memory\n");
> -		return PTR_ERR(ctx->shm_alloc);
> +		return PTR_ERR(ctx->shm.alloc);
>  	}
> -	/* shm_ofs only keeps the offset from base (port a) */
> -	ctx->shm_ofs = s5p_mfc_mem_cookie(shm_alloc_ctx, ctx->shm_alloc)
> +	/* shared memory offset only keeps the offset from base (port a) */
> +	ctx->shm.ofs = s5p_mfc_mem_cookie(shm_alloc_ctx, ctx->shm.alloc)
>  								- dev->bank1;
> -	BUG_ON(ctx->shm_ofs & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
> -	ctx->shm = vb2_dma_contig_memops.vaddr(ctx->shm_alloc);
> -	if (!ctx->shm) {
> -		vb2_dma_contig_memops.put(ctx->shm_alloc);
> -		ctx->shm_ofs = 0;
> -		ctx->shm_alloc = NULL;
> +	BUG_ON(ctx->shm.ofs & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
> +
> +	ctx->shm.virt = vb2_dma_contig_memops.vaddr(ctx->shm.alloc);
> +	if (!ctx->shm.virt) {
> +		vb2_dma_contig_memops.put(ctx->shm.alloc);
> +		ctx->shm.alloc = NULL;
> +		ctx->shm.ofs = 0;
>  		mfc_err("failed to virt addr of shared memory\n");
>  		return -ENOMEM;
>  	}
> -	memset((void *)ctx->shm, 0, SHARED_BUF_SIZE);
> +	memset((void *)ctx->shm.virt, 0, buf_size->shm);
>  	wmb();
>  	return 0;
>  }
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_shm.h
> b/drivers/media/video/s5p-mfc/s5p_mfc_shm.h
> index cf962a4..8400ab0 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_shm.h
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_shm.h
> @@ -71,20 +71,23 @@ enum MFC_SHM_OFS {
>  	DBG_HISTORY_INPUT1	= 0xD4,	/* C */
>  	DBG_HISTORY_OUTPUT	= 0xD8,	/* C */
>  	HIERARCHICAL_P_QP	= 0xE0, /* E, H.264 */
> +	FRAME_PACK_SEI_ENABLE	= 0x168, /* C */
> +	FRAME_PACK_SEI_AVAIL	= 0x16c, /* D */
> +	FRAME_PACK_SEI_INFO	= 0x17c, /* E */
>  };
> 
>  int s5p_mfc_init_shm(struct s5p_mfc_ctx *ctx);
> 
> -#define s5p_mfc_write_shm(ctx, x, ofs)		\
> -	do {					\
> -		writel(x, (ctx->shm + ofs));	\
> -		wmb();				\
> +#define s5p_mfc_write_shm(ctx, x, ofs)			\
> +	do {						\
> +		writel(x, (ctx->shm.virt + ofs));	\
> +		wmb();					\
>  	} while (0)
> 
>  static inline u32 s5p_mfc_read_shm(struct s5p_mfc_ctx *ctx, unsigned int
> ofs)
>  {
>  	rmb();
> -	return readl(ctx->shm + ofs);
> +	return readl(ctx->shm.virt + ofs);
>  }
> 
>  #endif /* S5P_MFC_SHM_H_ */
> diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-
> ctrls.c
> index 9abd9ab..61d6583 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -502,7 +502,6 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>  		return mpeg4_profile;
>  	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
>  		return jpeg_chroma_subsampling;
> -
>  	default:
>  		return NULL;
>  	}
> --
> 1.7.0.4

