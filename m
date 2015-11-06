Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:56061 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbbKFFgI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Nov 2015 00:36:08 -0500
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NXD02V2XOW6ISD0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 06 Nov 2015 14:36:06 +0900 (KST)
Message-id: <563C3C45.5020800@samsung.com>
Date: Fri, 06 Nov 2015 14:36:05 +0900
From: Junghak Sung <jh1009.sung@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/2] vb2: drop v4l2_format argument from queue_setup
References: <1446092666-2313-1-git-send-email-hverkuil@xs4all.nl>
 <1446092666-2313-2-git-send-email-hverkuil@xs4all.nl>
In-reply-to: <1446092666-2313-2-git-send-email-hverkuil@xs4all.nl>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Hans,
I leave some comments on the body of your patch.

On 10/29/2015 01:24 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> The queue_setup callback has a void pointer that is just for V4L2
> and is the pointer to the v4l2_format struct that was passed to
> VIDIOC_CREATE_BUFS. The idea was that drivers would use the information
> from that struct to buffers suitable for the requested format.
>
> After the vb2 split series this pointer is now a void pointer,
> which is ugly, and the reality is that all existing drivers will
> effectively just look at the sizeimage field of v4l2_format.
>
> To make this more generic the queue_setup callback is changed:
> the void pointer is dropped, instead if the *num_planes argument
> is 0, then use the current format size, if it is non-zero, then
> it contains the number of requested planes and the sizes array
> contains the requested sizes. If either is unsupported, then return
> -EINVAL, otherwise use the requested size(s).
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>   Documentation/video4linux/v4l2-pci-skeleton.c      | 10 ++---
>   drivers/input/touchscreen/sur40.c                  | 11 +++--
>   drivers/media/dvb-frontends/rtl2832_sdr.c          |  2 +-
>   drivers/media/pci/cobalt/cobalt-v4l2.c             | 12 ++---
>   drivers/media/pci/cx23885/cx23885-417.c            |  2 +-
>   drivers/media/pci/cx23885/cx23885-dvb.c            |  2 +-
>   drivers/media/pci/cx23885/cx23885-vbi.c            |  2 +-
>   drivers/media/pci/cx23885/cx23885-video.c          |  2 +-
>   drivers/media/pci/cx25821/cx25821-video.c          | 12 ++---
>   drivers/media/pci/cx88/cx88-blackbird.c            |  2 +-
>   drivers/media/pci/cx88/cx88-dvb.c                  |  2 +-
>   drivers/media/pci/cx88/cx88-vbi.c                  |  2 +-
>   drivers/media/pci/cx88/cx88-video.c                |  2 +-
>   drivers/media/pci/dt3155/dt3155.c                  | 11 +++--
>   drivers/media/pci/netup_unidvb/netup_unidvb_core.c |  1 -
>   drivers/media/pci/saa7134/saa7134-ts.c             |  2 +-
>   drivers/media/pci/saa7134/saa7134-vbi.c            |  2 +-
>   drivers/media/pci/saa7134/saa7134-video.c          |  2 +-
>   drivers/media/pci/saa7134/saa7134.h                |  2 +-
>   drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |  1 -
>   drivers/media/pci/solo6x10/solo6x10-v4l2.c         |  2 +-
>   drivers/media/pci/sta2x11/sta2x11_vip.c            |  2 +-
>   drivers/media/pci/tw68/tw68-video.c                | 20 ++++-----
>   drivers/media/platform/am437x/am437x-vpfe.c        | 17 ++++----
>   drivers/media/platform/blackfin/bfin_capture.c     | 12 +++--
>   drivers/media/platform/coda/coda-common.c          |  2 +-
>   drivers/media/platform/davinci/vpbe_display.c      | 13 +++---
>   drivers/media/platform/davinci/vpif_capture.c      | 17 ++++----
>   drivers/media/platform/davinci/vpif_display.c      | 13 +++---
>   drivers/media/platform/exynos-gsc/gsc-m2m.c        |  1 -
>   drivers/media/platform/exynos4-is/fimc-capture.c   | 31 +++++++------
>   drivers/media/platform/exynos4-is/fimc-isp-video.c | 31 ++++++-------
>   drivers/media/platform/exynos4-is/fimc-lite.c      | 31 ++++++-------
>   drivers/media/platform/exynos4-is/fimc-m2m.c       |  2 +-
>   drivers/media/platform/m2m-deinterlace.c           |  1 -
>   drivers/media/platform/marvell-ccic/mcam-core.c    | 13 +++---
>   drivers/media/platform/mx2_emmaprp.c               |  1 -
>   drivers/media/platform/omap3isp/ispvideo.c         |  1 -
>   drivers/media/platform/rcar_jpu.c                  | 25 ++++++-----
>   drivers/media/platform/s3c-camif/camif-capture.c   | 33 +++++---------
>   drivers/media/platform/s5p-g2d/g2d.c               |  2 +-
>   drivers/media/platform/s5p-jpeg/jpeg-core.c        |  1 -
>   drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |  2 +-
>   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |  1 -
>   drivers/media/platform/s5p-tv/mixer_video.c        |  2 +-
>   drivers/media/platform/sh_veu.c                    | 31 ++++---------
>   drivers/media/platform/sh_vou.c                    | 11 +++--
>   drivers/media/platform/soc_camera/atmel-isi.c      |  2 +-
>   drivers/media/platform/soc_camera/mx2_camera.c     |  6 ---
>   drivers/media/platform/soc_camera/mx3_camera.c     | 38 +++-------------
>   drivers/media/platform/soc_camera/rcar_vin.c       | 40 +++--------------
>   .../platform/soc_camera/sh_mobile_ceu_camera.c     | 37 +++-------------
>   drivers/media/platform/sti/bdisp/bdisp-v4l2.c      | 10 ++---
>   drivers/media/platform/ti-vpe/vpe.c                |  1 -
>   drivers/media/platform/vim2m.c                     | 13 ++----
>   drivers/media/platform/vivid/vivid-sdr-cap.c       |  2 +-
>   drivers/media/platform/vivid/vivid-vbi-cap.c       |  2 +-
>   drivers/media/platform/vivid/vivid-vbi-out.c       |  2 +-
>   drivers/media/platform/vivid/vivid-vid-cap.c       | 22 +++-------
>   drivers/media/platform/vivid/vivid-vid-out.c       | 19 ++------
>   drivers/media/platform/vsp1/vsp1_video.c           | 51 +++++-----------------
>   drivers/media/platform/xilinx/xilinx-dma.c         | 12 +++--
>   drivers/media/usb/airspy/airspy.c                  |  2 +-
>   drivers/media/usb/au0828/au0828-vbi.c              | 14 ++----
>   drivers/media/usb/au0828/au0828-video.c            | 12 ++---
>   drivers/media/usb/em28xx/em28xx-vbi.c              | 20 ++++-----
>   drivers/media/usb/em28xx/em28xx-video.c            | 19 ++------
>   drivers/media/usb/go7007/go7007-v4l2.c             |  1 -
>   drivers/media/usb/hackrf/hackrf.c                  |  2 +-
>   drivers/media/usb/msi2500/msi2500.c                |  1 -
>   drivers/media/usb/pwc/pwc-if.c                     |  2 +-
>   drivers/media/usb/s2255/s2255drv.c                 |  2 +-
>   drivers/media/usb/stk1160/stk1160-v4l.c            |  2 +-
>   drivers/media/usb/usbtv/usbtv-video.c              |  9 ++--
>   drivers/media/usb/uvc/uvc_queue.c                  | 14 +++---
>   drivers/media/v4l2-core/videobuf2-core.c           | 23 +++++++---
>   drivers/media/v4l2-core/videobuf2-v4l2.c           | 48 +++++++++++++++++---
>   drivers/staging/media/davinci_vpfe/vpfe_video.c    |  2 +-
>   drivers/staging/media/omap4iss/iss_video.c         |  1 -
>   drivers/usb/gadget/function/uvc_queue.c            |  2 +-
>   include/media/videobuf2-core.h                     | 40 +++++++++--------
>   81 files changed, 356 insertions(+), 519 deletions(-)
>
> diff --git a/Documentation/video4linux/v4l2-pci-skeleton.c b/Documentation/video4linux/v4l2-pci-skeleton.c
> index 95ae828..2f08638 100644
> --- a/Documentation/video4linux/v4l2-pci-skeleton.c
> +++ b/Documentation/video4linux/v4l2-pci-skeleton.c
> @@ -163,7 +163,7 @@ static irqreturn_t skeleton_irq(int irq, void *dev_id)
>    * minimum number: many DMA engines need a minimum of 2 buffers in the
>    * queue and you need to have another available for userspace processing.
>    */
> -static int queue_setup(struct vb2_queue *vq, const void *parg,
> +static int queue_setup(struct vb2_queue *vq,
>   		       unsigned int *nbuffers, unsigned int *nplanes,
>   		       unsigned int sizes[], void *alloc_ctxs[])
>   {
> @@ -183,12 +183,12 @@ static int queue_setup(struct vb2_queue *vq, const void *parg,
>

-	const struct v4l2_format *fmt = parg;

This line seems to be not necessary although this file is
a just skeleton.


>   	if (vq->num_buffers + *nbuffers < 3)
>   		*nbuffers = 3 - vq->num_buffers;
> +	alloc_ctxs[0] = skel->alloc_ctx;
>
> -	if (fmt && fmt->fmt.pix.sizeimage < skel->format.sizeimage)
> -		return -EINVAL;
> +	if (*nplanes)
> +		return sizes[0] < skel->format.sizeimage ? -EINVAL : 0;
>   	*nplanes = 1;
> -	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : skel->format.sizeimage;
> -	alloc_ctxs[0] = skel->alloc_ctx;
> +	sizes[0] = skel->format.sizeimage;
>   	return 0;
>   }
>
<snip>
> diff --git a/drivers/media/pci/dt3155/dt3155.c b/drivers/media/pci/dt3155/dt3155.c
> index d84abde..1981382 100644
> --- a/drivers/media/pci/dt3155/dt3155.c
> +++ b/drivers/media/pci/dt3155/dt3155.c
> @@ -131,22 +131,21 @@ static int wait_i2c_reg(void __iomem *addr)
>   }
>
>   static int
> -dt3155_queue_setup(struct vb2_queue *vq, const void *parg,
> +dt3155_queue_setup(struct vb2_queue *vq,
>   		unsigned int *nbuffers, unsigned int *num_planes,
>   		unsigned int sizes[], void *alloc_ctxs[])
>
>   {
> -	const struct v4l2_format *fmt = parg;
>   	struct dt3155_priv *pd = vb2_get_drv_priv(vq);
>   	unsigned size = pd->width * pd->height;
>
>   	if (vq->num_buffers + *nbuffers < 2)
>   		*nbuffers = 2 - vq->num_buffers;
> -	if (fmt && fmt->fmt.pix.sizeimage < size)
> -		return -EINVAL;
> -	*num_planes = 1;
> -	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : size;
>   	alloc_ctxs[0] = pd->alloc_ctx;
> +	if (num_planes)
> +		return sizes[0] < size ? -EINVAL : 0;
I think that * is missed in front of num_planes by mistake.

> +	*num_planes = 1;
> +	sizes[0] = size;
>   	return 0;
>   }
<snip>

> diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
> index 4c3293d..5b5bc5c 100644
> --- a/drivers/media/pci/tw68/tw68-video.c
> +++ b/drivers/media/pci/tw68/tw68-video.c
> @@ -376,28 +376,28 @@ static int tw68_buffer_count(unsigned int size, unsigned int count)
>   /* ------------------------------------------------------------- */
>   /* vb2 queue operations                                          */
>
> -static int tw68_queue_setup(struct vb2_queue *q, const void *parg,
> +static int tw68_queue_setup(struct vb2_queue *q,
>   			   unsigned int *num_buffers, unsigned int *num_planes,
>   			   unsigned int sizes[], void *alloc_ctxs[])
>   {
> -	const struct v4l2_format *fmt = parg;
>   	struct tw68_dev *dev = vb2_get_drv_priv(q);
>   	unsigned tot_bufs = q->num_buffers + *num_buffers;
> +	unsigned size = (dev->fmt->depth * dev->width * dev->height) >> 3;
>
> -	sizes[0] = (dev->fmt->depth * dev->width * dev->height) >> 3;
> +	if (tot_bufs < 2)
> +		tot_bufs = 2;
> +	tot_bufs = tw68_buffer_count(sizes[0], tot_bufs);

If sizes[0] is not set from caller side, it can cause "divide by zero"
inside of tw68_buffer_count().
So, sizes[0] should be replaced with size in my opinion.

> +	*num_buffers = tot_bufs - q->num_buffers;
>   	alloc_ctxs[0] = dev->alloc_ctx;
>   	/*
> -	 * We allow create_bufs, but only if the sizeimage is the same as the
> +	 * We allow create_bufs, but only if the sizeimage is >= as the
>   	 * current sizeimage. The tw68_buffer_count calculation becomes quite
>   	 * difficult otherwise.
>   	 */
> -	if (fmt && fmt->fmt.pix.sizeimage < sizes[0])
> -		return -EINVAL;
> +	if (*num_planes)
> +		return sizes[0] < size ? -EINVAL : 0;
>   	*num_planes = 1;
> -	if (tot_bufs < 2)
> -		tot_bufs = 2;
> -	tot_bufs = tw68_buffer_count(sizes[0], tot_bufs);
> -	*num_buffers = tot_bufs - q->num_buffers;
> +	sizes[0] = size;
>
>   	return 0;
>   }

Other things look good for me.
Thank you.

Best regards,
Junghak
