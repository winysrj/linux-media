Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:35156 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbbFWBL2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2015 21:11:28 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NQD014CIHYUM640@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 23 Jun 2015 10:11:18 +0900 (KST)
Message-id: <5588B235.2080901@samsung.com>
Date: Tue, 23 Jun 2015 10:11:17 +0900
From: Junghak Sung <jh1009.sung@samsung.com>
MIME-version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, sangbae90.lee@samsung.com,
	inki.dae@samsung.com, nenggun.kim@samsung.com,
	sw0312.kim@samsung.com
Subject: Re: [RFC PATCH 1/3] modify the vb2_buffer structure for common video
 buffer and make struct vb2_v4l2_buffer
References: <1433770535-21143-1-git-send-email-jh1009.sung@samsung.com>
 <1433770535-21143-2-git-send-email-jh1009.sung@samsung.com>
 <20150617092729.1f598205@recife.lan>
In-reply-to: <20150617092729.1f598205@recife.lan>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Mauro,

Thank you for your reviewing.
I will rework this patch in order to be easier to review.
I reply to your comment. See below.

Regards,
Junghak


On 06/17/2015 09:27 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 08 Jun 2015 22:35:33 +0900
> Junghak Sung <jh1009.sung@samsung.com> escreveu:
>
>> Make the struct vb2_buffer to common buffer by removing v4l2-specific members.
>> And common video buffer is embedded into v4l2-specific video buffer like:
>> struct vb2_v4l2_buffer {
>>      struct vb2_buffer    vb2;
>>      struct v4l2_buffer    v4l2_buf;
>>      struct v4l2_plane    v4l2_planes[VIDEO_MAX_PLANES];
>> };
>> This changes require the modifications of all device drivers that use this structure.
> Thanks for the patch!
>
> In general, it looks fine. Just a few comments. See below.
>
> Regards,
> Mauro
>
>> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
>> ---
>>   Documentation/video4linux/v4l2-pci-skeleton.c      |   12 +-
>>   drivers/media/dvb-frontends/rtl2832_sdr.c          |   10 +-
>>   drivers/media/pci/cx23885/cx23885-417.c            |   12 +-
>>   drivers/media/pci/cx23885/cx23885-dvb.c            |   12 +-
>>   drivers/media/pci/cx23885/cx23885-vbi.c            |   12 +-
>>   drivers/media/pci/cx23885/cx23885-video.c          |   12 +-
>>   drivers/media/pci/cx23885/cx23885.h                |    2 +-
>>   drivers/media/pci/cx25821/cx25821-video.c          |   12 +-
>>   drivers/media/pci/cx25821/cx25821.h                |    2 +-
>>   drivers/media/pci/cx88/cx88-blackbird.c            |   14 +-
>>   drivers/media/pci/cx88/cx88-dvb.c                  |   14 +-
>>   drivers/media/pci/cx88/cx88-vbi.c                  |   12 +-
>>   drivers/media/pci/cx88/cx88-video.c                |   12 +-
>>   drivers/media/pci/cx88/cx88.h                      |    2 +-
>>   drivers/media/pci/saa7134/saa7134-empress.c        |    2 +-
>>   drivers/media/pci/saa7134/saa7134-ts.c             |   10 +-
>>   drivers/media/pci/saa7134/saa7134-vbi.c            |   12 +-
>>   drivers/media/pci/saa7134/saa7134-video.c          |   18 +-
>>   drivers/media/pci/saa7134/saa7134.h                |    8 +-
>>   drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |   14 +-
>>   drivers/media/pci/solo6x10/solo6x10-v4l2.c         |    6 +-
>>   drivers/media/pci/solo6x10/solo6x10.h              |    4 +-
>>   drivers/media/pci/sta2x11/sta2x11_vip.c            |   20 +-
>>   drivers/media/pci/tw68/tw68-video.c                |   12 +-
>>   drivers/media/pci/tw68/tw68.h                      |    2 +-
>>   drivers/media/platform/am437x/am437x-vpfe.c        |   16 +-
>>   drivers/media/platform/am437x/am437x-vpfe.h        |    2 +-
>>   drivers/media/platform/blackfin/bfin_capture.c     |   20 +-
>>   drivers/media/platform/coda/coda-bit.c             |   20 +-
>>   drivers/media/platform/coda/coda-common.c          |   24 +-
>>   drivers/media/platform/coda/coda-jpeg.c            |    2 +-
>>   drivers/media/platform/coda/coda.h                 |    6 +-
>>   drivers/media/platform/davinci/vpbe_display.c      |    8 +-
>>   drivers/media/platform/davinci/vpif_capture.c      |   16 +-
>>   drivers/media/platform/davinci/vpif_capture.h      |    2 +-
>>   drivers/media/platform/davinci/vpif_display.c      |   18 +-
>>   drivers/media/platform/davinci/vpif_display.h      |    6 +-
>>   drivers/media/platform/exynos-gsc/gsc-core.c       |    2 +-
>>   drivers/media/platform/exynos-gsc/gsc-core.h       |    6 +-
>>   drivers/media/platform/exynos-gsc/gsc-m2m.c        |   16 +-
>>   drivers/media/platform/exynos4-is/fimc-capture.c   |   12 +-
>>   drivers/media/platform/exynos4-is/fimc-core.c      |    4 +-
>>   drivers/media/platform/exynos4-is/fimc-core.h      |    6 +-
>>   drivers/media/platform/exynos4-is/fimc-is.h        |    2 +-
>>   drivers/media/platform/exynos4-is/fimc-isp-video.c |   14 +-
>>   drivers/media/platform/exynos4-is/fimc-isp-video.h |    2 +-
>>   drivers/media/platform/exynos4-is/fimc-isp.h       |    4 +-
>>   drivers/media/platform/exynos4-is/fimc-lite.c      |   10 +-
>>   drivers/media/platform/exynos4-is/fimc-lite.h      |    4 +-
>>   drivers/media/platform/exynos4-is/fimc-m2m.c       |   16 +-
>>   drivers/media/platform/m2m-deinterlace.c           |   16 +-
>>   drivers/media/platform/marvell-ccic/mcam-core.c    |   24 +-
>>   drivers/media/platform/marvell-ccic/mcam-core.h    |    2 +-
>>   drivers/media/platform/mx2_emmaprp.c               |   16 +-
>>   drivers/media/platform/omap3isp/ispvideo.c         |    8 +-
>>   drivers/media/platform/omap3isp/ispvideo.h         |    4 +-
>>   drivers/media/platform/s3c-camif/camif-capture.c   |   12 +-
>>   drivers/media/platform/s3c-camif/camif-core.c      |    2 +-
>>   drivers/media/platform/s3c-camif/camif-core.h      |    4 +-
>>   drivers/media/platform/s5p-g2d/g2d.c               |   16 +-
>>   drivers/media/platform/s5p-jpeg/jpeg-core.c        |   30 +-
>>   drivers/media/platform/s5p-mfc/s5p_mfc.c           |    2 +-
>>   drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |    4 +-
>>   drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   10 +-
>>   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   18 +-
>>   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    |    2 +-
>>   drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |    2 +-
>>   drivers/media/platform/s5p-tv/mixer.h              |    4 +-
>>   drivers/media/platform/s5p-tv/mixer_video.c        |    4 +-
>>   drivers/media/platform/sh_veu.c                    |   20 +-
>>   drivers/media/platform/soc_camera/atmel-isi.c      |   20 +-
>>   drivers/media/platform/soc_camera/mx2_camera.c     |   14 +-
>>   drivers/media/platform/soc_camera/mx3_camera.c     |   18 +-
>>   drivers/media/platform/soc_camera/rcar_vin.c       |   14 +-
>>   .../platform/soc_camera/sh_mobile_ceu_camera.c     |   22 +-
>>   drivers/media/platform/soc_camera/soc_camera.c     |    2 +-
>>   drivers/media/platform/ti-vpe/vpe.c                |   26 +-
>>   drivers/media/platform/vim2m.c                     |   24 +-
>>   drivers/media/platform/vivid/vivid-core.h          |    4 +-
>>   drivers/media/platform/vivid/vivid-sdr-cap.c       |    8 +-
>>   drivers/media/platform/vivid/vivid-vbi-cap.c       |   10 +-
>>   drivers/media/platform/vivid/vivid-vbi-out.c       |   10 +-
>>   drivers/media/platform/vivid/vivid-vid-cap.c       |   12 +-
>>   drivers/media/platform/vivid/vivid-vid-out.c       |    8 +-
>>   drivers/media/platform/vsp1/vsp1_rpf.c             |    4 +-
>>   drivers/media/platform/vsp1/vsp1_video.c           |   16 +-
>>   drivers/media/platform/vsp1/vsp1_video.h           |    6 +-
>>   drivers/media/platform/vsp1/vsp1_wpf.c             |    4 +-
>>   drivers/media/usb/airspy/airspy.c                  |    6 +-
>>   drivers/media/usb/au0828/au0828-vbi.c              |    8 +-
>>   drivers/media/usb/au0828/au0828-video.c            |    8 +-
>>   drivers/media/usb/au0828/au0828.h                  |    2 +-
>>   drivers/media/usb/em28xx/em28xx-vbi.c              |    8 +-
>>   drivers/media/usb/em28xx/em28xx-video.c            |    8 +-
>>   drivers/media/usb/em28xx/em28xx.h                  |    2 +-
>>   drivers/media/usb/go7007/go7007-priv.h             |    4 +-
>>   drivers/media/usb/go7007/go7007-v4l2.c             |   10 +-
>>   drivers/media/usb/hackrf/hackrf.c                  |    6 +-
>>   drivers/media/usb/msi2500/msi2500.c                |    6 +-
>>   drivers/media/usb/pwc/pwc-if.c                     |   18 +-
>>   drivers/media/usb/pwc/pwc.h                        |    2 +-
>>   drivers/media/usb/s2255/s2255drv.c                 |   10 +-
>>   drivers/media/usb/stk1160/stk1160-v4l.c            |    4 +-
>>   drivers/media/usb/stk1160/stk1160.h                |    4 +-
>>   drivers/media/usb/usbtv/usbtv-video.c              |    6 +-
>>   drivers/media/usb/usbtv/usbtv.h                    |    2 +-
>>   drivers/media/usb/uvc/uvc_queue.c                  |   14 +-
>>   drivers/media/usb/uvc/uvcvideo.h                   |    4 +-
>>   drivers/media/v4l2-core/Makefile                   |    2 +-
>>   drivers/media/v4l2-core/v4l2-ioctl.c               |    2 +-
>>   drivers/media/v4l2-core/v4l2-mem2mem.c             |    6 +-
>>   drivers/media/v4l2-core/videobuf2-core.c           |  398 +++++++++----------
>>   drivers/media/v4l2-core/videobuf2-dma-contig.c     |    2 +-
>>   drivers/media/v4l2-core/videobuf2-dma-sg.c         |    2 +-
>>   drivers/media/v4l2-core/videobuf2-dvb.c            |    2 +-
>>   drivers/media/v4l2-core/videobuf2-memops.c         |    2 +-
>>   .../{videobuf2-core.c => videobuf2-v4l2.c}         |  400 ++++++++++----------
>>   drivers/media/v4l2-core/videobuf2-vmalloc.c        |    2 +-
>>   drivers/staging/media/davinci_vpfe/vpfe_video.c    |   30 +-
>>   drivers/staging/media/davinci_vpfe/vpfe_video.h    |    2 +-
>>   drivers/staging/media/dt3155v4l/dt3155v4l.c        |   14 +-
>>   drivers/staging/media/dt3155v4l/dt3155v4l.h        |    2 +-
>>   drivers/staging/media/omap4iss/iss_video.c         |   16 +-
>>   drivers/staging/media/omap4iss/iss_video.h         |    4 +-
>>   drivers/usb/gadget/function/uvc_queue.c            |   14 +-
>>   drivers/usb/gadget/function/uvc_queue.h            |    4 +-
>>   include/media/davinci/vpbe_display.h               |    2 +-
>>   include/media/soc_camera.h                         |    2 +-
>>   include/media/v4l2-mem2mem.h                       |    8 +-
>>   include/media/videobuf2-core.h                     |   76 ++--
>>   include/media/videobuf2-dma-contig.h               |    4 +-
>>   include/media/videobuf2-dma-sg.h                   |    4 +-
>>   include/media/videobuf2-dvb.h                      |    2 +-
>>   include/media/videobuf2-memops.h                   |    2 +-
>>   .../media/{videobuf2-core.h => videobuf2-v4l2.h}   |   80 ++--
>>   include/media/videobuf2-vmalloc.h                  |    2 +-
>>   136 files changed, 1081 insertions(+), 1045 deletions(-)
>>   copy drivers/media/v4l2-core/{videobuf2-core.c => videobuf2-v4l2.c} (89%)
>>   copy include/media/{videobuf2-core.h => videobuf2-v4l2.h} (94%)
>>
> Let me go directly to the header changes. Everything else is consequence
> of that. As I said before, the best is to have a script that would do the
> renaming changes to fulfill what was changed in the headers.
OK, I will try to make a script again.
>> --- a/include/media/videobuf2-core.h
>> +++ b/include/media/videobuf2-core.h
>> @@ -1,5 +1,5 @@
>>   /*
>> - * videobuf2-core.h - V4L2 driver helper framework
>> + * videobuf2-core.h - Video Buffer 2 framework
>>    *
>>    * Copyright (C) 2010 Samsung Electronics
>>    *
>> @@ -171,18 +171,7 @@ enum vb2_buffer_state {
>>   struct vb2_queue;
>>   
>>   /**
>> - * struct vb2_buffer - represents a video buffer
>> - * @v4l2_buf:		struct v4l2_buffer associated with this buffer; can
>> - *			be read by the driver and relevant entries can be
>> - *			changed by the driver in case of CAPTURE types
>> - *			(such as timestamp)
>> - * @v4l2_planes:	struct v4l2_planes associated with this buffer; can
>> - *			be read by the driver and relevant entries can be
>> - *			changed by the driver in case of CAPTURE types
>> - *			(such as bytesused); NOTE that even for single-planar
>> - *			types, the v4l2_planes[0] struct should be used
>> - *			instead of v4l2_buf for filling bytesused - drivers
>> - *			should use the vb2_set_plane_payload() function for that
>> + * struct vb2_buffer - represents a common video buffer
>>    * @vb2_queue:		the queue to which this driver belongs
>>    * @num_planes:		number of planes in the buffer
>>    *			on an internal driver queue
>> @@ -194,11 +183,7 @@ struct vb2_queue;
>>    * @planes:		private per-plane information; do not change
>>    */
>>   struct vb2_buffer {
>> -	struct v4l2_buffer	v4l2_buf;
>> -	struct v4l2_plane	v4l2_planes[VIDEO_MAX_PLANES];
>> -
>>   	struct vb2_queue	*vb2_queue;
>> -
>>   	unsigned int		num_planes;
>>   
>>   /* Private: internal use only */
>> @@ -242,6 +227,27 @@ struct vb2_buffer {
>>   };
>>   
>>   /**
>> + * struct vb2_v4l2_buffer - represents a video buffer for v4l2
>> + * @vb2_buf:		common video buffer
>> + * @v4l2_buf:		struct v4l2_buffer associated with this buffer; can
>> + *			be read by the driver and relevant entries can be
>> + *			changed by the driver in case of CAPTURE types
>> + *			(such as timestamp)
>> + * @v4l2_planes:	struct v4l2_planes associated with this buffer; can
>> + *			be read by the driver and relevant entries can be
>> + *			changed by the driver in case of CAPTURE types
>> + *			(such as bytesused); NOTE that even for single-planar
>> + *			types, the v4l2_planes[0] struct should be used
>> + *			instead of v4l2_buf for filling bytesused - drivers
>> + *			should use the vb2_set_plane_payload() function for that
>> + */
>> +struct vb2_v4l2_buffer {
>> +	struct vb2_buffer	vb2;
>> +	struct v4l2_buffer	v4l2_buf;
>> +	struct v4l2_plane	v4l2_planes[VIDEO_MAX_PLANES];
>> +};
>> +
>> +/**
>>    * struct vb2_ops - driver-specific callbacks
>>    *
>>    * @queue_setup:	called from VIDIOC_REQBUFS and VIDIOC_CREATE_BUFS
>> @@ -328,15 +334,15 @@ struct vb2_ops {
>>   	void (*wait_prepare)(struct vb2_queue *q);
>>   	void (*wait_finish)(struct vb2_queue *q);
>>   
>> -	int (*buf_init)(struct vb2_buffer *vb);
>> -	int (*buf_prepare)(struct vb2_buffer *vb);
>> -	void (*buf_finish)(struct vb2_buffer *vb);
>> -	void (*buf_cleanup)(struct vb2_buffer *vb);
>> +	int (*buf_init)(struct vb2_v4l2_buffer *vb);
>> +	int (*buf_prepare)(struct vb2_v4l2_buffer *vb);
>> +	void (*buf_finish)(struct vb2_v4l2_buffer *vb);
>> +	void (*buf_cleanup)(struct vb2_v4l2_buffer *vb);
>>   
>>   	int (*start_streaming)(struct vb2_queue *q, unsigned int count);
>>   	void (*stop_streaming)(struct vb2_queue *q);
>>   
>> -	void (*buf_queue)(struct vb2_buffer *vb);
>> +	void (*buf_queue)(struct vb2_v4l2_buffer *vb);
>>   };
>>   
>>   struct v4l2_fh;
>> @@ -361,7 +367,7 @@ struct v4l2_fh;
>>    * @drv_priv:	driver private data
>>    * @buf_struct_size: size of the driver-specific buffer structure;
>>    *		"0" indicates the driver doesn't want to use a custom buffer
>> - *		structure type, so sizeof(struct vb2_buffer) will is used
>> + *		structure type, so sizeof(struct vb2_v4l2_buffer) will is used
>>    * @timestamp_flags: Timestamp flags; V4L2_BUF_FLAG_TIMESTAMP_* and
>>    *		V4L2_BUF_FLAG_TSTAMP_SRC_*
>>    * @gfp_flags:	additional gfp flags used when allocating the buffers.
>> @@ -398,7 +404,7 @@ struct vb2_queue {
>>   	unsigned int			io_modes;
>>   	unsigned int			io_flags;
>>   	struct mutex			*lock;
>> -	struct v4l2_fh			*owner;
>> +	void					*owner;
> Looks ok, except for the extra tab that disaligns it. Please notice
> that, on Kernel, a tab is 8 spaces.
OK, I will correct that.
>>   
>>   	const struct vb2_ops		*ops;
>>   	const struct vb2_mem_ops	*mem_ops;
>> @@ -411,7 +417,7 @@ struct vb2_queue {
>>   /* private: internal use only */
>>   	struct mutex			mmap_lock;
>>   	enum v4l2_memory		memory;
>> -	struct vb2_buffer		*bufs[VIDEO_MAX_FRAME];
>> +	void					*bufs[VIDEO_MAX_FRAME];
> Hmm.. why void? It can be struct vb2_buffer. Of course, in order
> to get the buffer, the code would need to do something like:
>
> 	struct vb2_v4l2_buffer *vb;
>
> 	vb = container_of(bufs[0], struct vb2_v4l2_buffer, vb2);
>
> But this would avoid the typecasts at the VB2 core, and, most importantly,
> it would ensure strong type checks by the compiler.
>
It was modified to struct vb2_buffer again at 2/3 patch.
>>   	unsigned int			num_buffers;
>>   
>>   	struct list_head		queued_list;
>> @@ -446,10 +452,10 @@ struct vb2_queue {
>>   #endif
>>   };
>>   
>> -void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no);
>> -void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no);
>> +void *vb2_plane_vaddr(struct vb2_v4l2_buffer *vb, unsigned int plane_no);
>> +void *vb2_plane_cookie(struct vb2_v4l2_buffer *vb, unsigned int plane_no);
>>   
>> -void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state);
>> +void vb2_buffer_done(struct vb2_v4l2_buffer *vb, enum vb2_buffer_state state);
>>   void vb2_discard_done(struct vb2_queue *q);
>>   int vb2_wait_for_all_buffers(struct vb2_queue *q);
>>   
>> @@ -489,7 +495,7 @@ size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
>>    *
>>    * This is called whenever a buffer is dequeued in the thread.
>>    */
>> -typedef int (*vb2_thread_fnc)(struct vb2_buffer *vb, void *priv);
>> +typedef int (*vb2_thread_fnc)(struct vb2_v4l2_buffer *vb, void *priv);
>>   
>>   /**
>>    * vb2_thread_start() - start a thread for the given queue.
>> @@ -566,10 +572,10 @@ static inline void *vb2_get_drv_priv(struct vb2_queue *q)
>>    * @plane_no:	plane number for which payload should be set
>>    * @size:	payload in bytes
>>    */
>> -static inline void vb2_set_plane_payload(struct vb2_buffer *vb,
>> +static inline void vb2_set_plane_payload(struct vb2_v4l2_buffer *vb,
>>   				 unsigned int plane_no, unsigned long size)
>>   {
>> -	if (plane_no < vb->num_planes)
>> +	if (plane_no < vb->vb2.num_planes)
>>   		vb->v4l2_planes[plane_no].bytesused = size;
>>   }
>>   
>> @@ -579,10 +585,10 @@ static inline void vb2_set_plane_payload(struct vb2_buffer *vb,
>>    * @plane_no:	plane number for which payload should be set
>>    * @size:	payload in bytes
>>    */
>> -static inline unsigned long vb2_get_plane_payload(struct vb2_buffer *vb,
>> +static inline unsigned long vb2_get_plane_payload(struct vb2_v4l2_buffer *vb,
>>   				 unsigned int plane_no)
>>   {
>> -	if (plane_no < vb->num_planes)
>> +	if (plane_no < vb->vb2.num_planes)
>>   		return vb->v4l2_planes[plane_no].bytesused;
>>   	return 0;
>>   }
>> @@ -593,9 +599,9 @@ static inline unsigned long vb2_get_plane_payload(struct vb2_buffer *vb,
>>    * @plane_no:	plane number for which size should be returned
>>    */
>>   static inline unsigned long
>> -vb2_plane_size(struct vb2_buffer *vb, unsigned int plane_no)
>> +vb2_plane_size(struct vb2_v4l2_buffer *vb, unsigned int plane_no)
>>   {
>> -	if (plane_no < vb->num_planes)
>> +	if (plane_no < vb->vb2.num_planes)
>>   		return vb->v4l2_planes[plane_no].length;
>>   	return 0;
>>   }
>> diff --git a/include/media/videobuf2-dma-contig.h b/include/media/videobuf2-dma-contig.h
>> index 8197f87..3de9111 100644
>> --- a/include/media/videobuf2-dma-contig.h
>> +++ b/include/media/videobuf2-dma-contig.h
>> @@ -13,11 +13,11 @@
>>   #ifndef _MEDIA_VIDEOBUF2_DMA_CONTIG_H
>>   #define _MEDIA_VIDEOBUF2_DMA_CONTIG_H
>>   
>> -#include <media/videobuf2-core.h>
>> +#include <media/videobuf2-v4l2.h>
>>   #include <linux/dma-mapping.h>
>>   
>>   static inline dma_addr_t
>> -vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb, unsigned int plane_no)
>> +vb2_dma_contig_plane_dma_addr(struct vb2_v4l2_buffer *vb, unsigned int plane_no)
>>   {
>>   	dma_addr_t *addr = vb2_plane_cookie(vb, plane_no);
>>   
>> diff --git a/include/media/videobuf2-dma-sg.h b/include/media/videobuf2-dma-sg.h
>> index 14ce306..36f7ea3 100644
>> --- a/include/media/videobuf2-dma-sg.h
>> +++ b/include/media/videobuf2-dma-sg.h
>> @@ -13,10 +13,10 @@
>>   #ifndef _MEDIA_VIDEOBUF2_DMA_SG_H
>>   #define _MEDIA_VIDEOBUF2_DMA_SG_H
>>   
>> -#include <media/videobuf2-core.h>
>> +#include <media/videobuf2-v4l2.h>
>>   
>>   static inline struct sg_table *vb2_dma_sg_plane_desc(
>> -		struct vb2_buffer *vb, unsigned int plane_no)
>> +		struct vb2_v4l2_buffer *vb, unsigned int plane_no)
>>   {
>>   	return (struct sg_table *)vb2_plane_cookie(vb, plane_no);
>>   }
>> diff --git a/include/media/videobuf2-dvb.h b/include/media/videobuf2-dvb.h
>> index 8f61456..bef9127 100644
>> --- a/include/media/videobuf2-dvb.h
>> +++ b/include/media/videobuf2-dvb.h
>> @@ -6,7 +6,7 @@
>>   #include <dvb_demux.h>
>>   #include <dvb_net.h>
>>   #include <dvb_frontend.h>
>> -#include <media/videobuf2-core.h>
>> +#include <media/videobuf2-v4l2.h>
>>   
>>   struct vb2_dvb {
>>   	/* filling that the job of the driver */
>> diff --git a/include/media/videobuf2-memops.h b/include/media/videobuf2-memops.h
>> index f05444c..7b6d475 100644
>> --- a/include/media/videobuf2-memops.h
>> +++ b/include/media/videobuf2-memops.h
>> @@ -14,7 +14,7 @@
>>   #ifndef _MEDIA_VIDEOBUF2_MEMOPS_H
>>   #define _MEDIA_VIDEOBUF2_MEMOPS_H
>>   
>> -#include <media/videobuf2-core.h>
>> +#include <media/videobuf2-v4l2.h>
>>   
>>   /**
>>    * vb2_vmarea_handler - common vma refcount tracking handler
>> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-v4l2.h
>> similarity index 94%
>> copy from include/media/videobuf2-core.h
>> copy to include/media/videobuf2-v4l2.h
>> index bd2cec2..80b08cb 100644
>> --- a/include/media/videobuf2-core.h
>> +++ b/include/media/videobuf2-v4l2.h
>> @@ -9,8 +9,8 @@
>>    * it under the terms of the GNU General Public License as published by
>>    * the Free Software Foundation.
>>    */
>> -#ifndef _MEDIA_VIDEOBUF2_CORE_H
>> -#define _MEDIA_VIDEOBUF2_CORE_H
>> +#ifndef _MEDIA_VIDEOBUF2_V4L2_H
>> +#define _MEDIA_VIDEOBUF2_V4L2_H
>>   
>>   #include <linux/mm_types.h>
>>   #include <linux/mutex.h>
>> @@ -171,18 +171,7 @@ enum vb2_buffer_state {
>>   struct vb2_queue;
>>   
>>   /**
>> - * struct vb2_buffer - represents a video buffer
>> - * @v4l2_buf:		struct v4l2_buffer associated with this buffer; can
>> - *			be read by the driver and relevant entries can be
>> - *			changed by the driver in case of CAPTURE types
>> - *			(such as timestamp)
>> - * @v4l2_planes:	struct v4l2_planes associated with this buffer; can
>> - *			be read by the driver and relevant entries can be
>> - *			changed by the driver in case of CAPTURE types
>> - *			(such as bytesused); NOTE that even for single-planar
>> - *			types, the v4l2_planes[0] struct should be used
>> - *			instead of v4l2_buf for filling bytesused - drivers
>> - *			should use the vb2_set_plane_payload() function for that
>> + * struct vb2_buffer - represents a common video buffer
>>    * @vb2_queue:		the queue to which this driver belongs
>>    * @num_planes:		number of planes in the buffer
>>    *			on an internal driver queue
>> @@ -194,11 +183,7 @@ struct vb2_queue;
>>    * @planes:		private per-plane information; do not change
>>    */
>>   struct vb2_buffer {
>> -	struct v4l2_buffer	v4l2_buf;
>> -	struct v4l2_plane	v4l2_planes[VIDEO_MAX_PLANES];
>> -
>>   	struct vb2_queue	*vb2_queue;
>> -
>>   	unsigned int		num_planes;
>>   
>>   /* Private: internal use only */
>> @@ -242,6 +227,27 @@ struct vb2_buffer {
>>   };
> Why are you declaring it again here? Instead, just include
> videobuf2-core.h.
It was removed at 2/3 patch.
>>   
>>   /**
>> + * struct vb2_v4l2_buffer - represents a video buffer for v4l2
>> + * @vb2_buf:		common video buffer
>> + * @v4l2_buf:		struct v4l2_buffer associated with this buffer; can
>> + *			be read by the driver and relevant entries can be
>> + *			changed by the driver in case of CAPTURE types
>> + *			(such as timestamp)
>> + * @v4l2_planes:	struct v4l2_planes associated with this buffer; can
>> + *			be read by the driver and relevant entries can be
>> + *			changed by the driver in case of CAPTURE types
>> + *			(such as bytesused); NOTE that even for single-planar
>> + *			types, the v4l2_planes[0] struct should be used
>> + *			instead of v4l2_buf for filling bytesused - drivers
>> + *			should use the vb2_set_plane_payload() function for that
>> + */
>> +struct vb2_v4l2_buffer {
>> +	struct vb2_buffer	vb2;
>> +	struct v4l2_buffer	v4l2_buf;
>> +	struct v4l2_plane	v4l2_planes[VIDEO_MAX_PLANES];
>> +};
>> +
> Same here: this got declared twice.
>
> As I explained on my comment 0/3, in order to easy patch review, I would
> first rename the header, then do those changes and then move the
> non-vb4l2 functions to the new videobuf2-core.h
I agree with you. I will split the patch into two or more pieces to be 
easier to review.
>> +/**
>>    * struct vb2_ops - driver-specific callbacks
>>    *
>>    * @queue_setup:	called from VIDIOC_REQBUFS and VIDIOC_CREATE_BUFS
>> @@ -328,15 +334,15 @@ struct vb2_ops {
>>   	void (*wait_prepare)(struct vb2_queue *q);
>>   	void (*wait_finish)(struct vb2_queue *q);
>>   
>> -	int (*buf_init)(struct vb2_buffer *vb);
>> -	int (*buf_prepare)(struct vb2_buffer *vb);
>> -	void (*buf_finish)(struct vb2_buffer *vb);
>> -	void (*buf_cleanup)(struct vb2_buffer *vb);
>> +	int (*buf_init)(struct vb2_v4l2_buffer *vb);
>> +	int (*buf_prepare)(struct vb2_v4l2_buffer *vb);
>> +	void (*buf_finish)(struct vb2_v4l2_buffer *vb);
>> +	void (*buf_cleanup)(struct vb2_v4l2_buffer *vb);
>>   
>>   	int (*start_streaming)(struct vb2_queue *q, unsigned int count);
>>   	void (*stop_streaming)(struct vb2_queue *q);
>>   
>> -	void (*buf_queue)(struct vb2_buffer *vb);
>> +	void (*buf_queue)(struct vb2_v4l2_buffer *vb);
>>   };
>>   
>>   struct v4l2_fh;
>> @@ -361,7 +367,7 @@ struct v4l2_fh;
>>    * @drv_priv:	driver private data
>>    * @buf_struct_size: size of the driver-specific buffer structure;
>>    *		"0" indicates the driver doesn't want to use a custom buffer
>> - *		structure type, so sizeof(struct vb2_buffer) will is used
>> + *		structure type, so sizeof(struct vb2_v4l2_buffer) will is used
>>    * @timestamp_flags: Timestamp flags; V4L2_BUF_FLAG_TIMESTAMP_* and
>>    *		V4L2_BUF_FLAG_TSTAMP_SRC_*
>>    * @gfp_flags:	additional gfp flags used when allocating the buffers.
>> @@ -398,7 +404,7 @@ struct vb2_queue {
>>   	unsigned int			io_modes;
>>   	unsigned int			io_flags;
>>   	struct mutex			*lock;
>> -	struct v4l2_fh			*owner;
>> +	void					*owner;
> Again, there's an extra tab here.
OK, I checked it.
>
>>   
>>   	const struct vb2_ops		*ops;
>>   	const struct vb2_mem_ops	*mem_ops;
>> @@ -411,7 +417,7 @@ struct vb2_queue {
>>   /* private: internal use only */
>>   	struct mutex			mmap_lock;
>>   	enum v4l2_memory		memory;
>> -	struct vb2_buffer		*bufs[VIDEO_MAX_FRAME];
>> +	void					*bufs[VIDEO_MAX_FRAME];
> Again, there's an extra tab here.
OK, I checked it.
>
>>   	unsigned int			num_buffers;
>>   
>>   	struct list_head		queued_list;
>> @@ -446,10 +452,10 @@ struct vb2_queue {
>>   #endif
>>   };
>>   
>> -void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no);
>> -void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no);
>> +void *vb2_plane_vaddr(struct vb2_v4l2_buffer *vb, unsigned int plane_no);
>> +void *vb2_plane_cookie(struct vb2_v4l2_buffer *vb, unsigned int plane_no);
>>   
>> -void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state);
>> +void vb2_buffer_done(struct vb2_v4l2_buffer *vb, enum vb2_buffer_state state);
>>   void vb2_discard_done(struct vb2_queue *q);
>>   int vb2_wait_for_all_buffers(struct vb2_queue *q);
>>   
>> @@ -489,7 +495,7 @@ size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
>>    *
>>    * This is called whenever a buffer is dequeued in the thread.
>>    */
>> -typedef int (*vb2_thread_fnc)(struct vb2_buffer *vb, void *priv);
>> +typedef int (*vb2_thread_fnc)(struct vb2_v4l2_buffer *vb, void *priv);
>>   
>>   /**
>>    * vb2_thread_start() - start a thread for the given queue.
>> @@ -566,10 +572,10 @@ static inline void *vb2_get_drv_priv(struct vb2_queue *q)
>>    * @plane_no:	plane number for which payload should be set
>>    * @size:	payload in bytes
>>    */
>> -static inline void vb2_set_plane_payload(struct vb2_buffer *vb,
>> +static inline void vb2_set_plane_payload(struct vb2_v4l2_buffer *vb,
>>   				 unsigned int plane_no, unsigned long size)
>>   {
>> -	if (plane_no < vb->num_planes)
>> +	if (plane_no < vb->vb2.num_planes)
>>   		vb->v4l2_planes[plane_no].bytesused = size;
>>   }
>>   
>> @@ -579,10 +585,10 @@ static inline void vb2_set_plane_payload(struct vb2_buffer *vb,
>>    * @plane_no:	plane number for which payload should be set
>>    * @size:	payload in bytes
>>    */
>> -static inline unsigned long vb2_get_plane_payload(struct vb2_buffer *vb,
>> +static inline unsigned long vb2_get_plane_payload(struct vb2_v4l2_buffer *vb,
>>   				 unsigned int plane_no)
>>   {
>> -	if (plane_no < vb->num_planes)
>> +	if (plane_no < vb->vb2.num_planes)
>>   		return vb->v4l2_planes[plane_no].bytesused;
>>   	return 0;
>>   }
>> @@ -593,9 +599,9 @@ static inline unsigned long vb2_get_plane_payload(struct vb2_buffer *vb,
>>    * @plane_no:	plane number for which size should be returned
>>    */
>>   static inline unsigned long
>> -vb2_plane_size(struct vb2_buffer *vb, unsigned int plane_no)
>> +vb2_plane_size(struct vb2_v4l2_buffer *vb, unsigned int plane_no)
>>   {
>> -	if (plane_no < vb->num_planes)
>> +	if (plane_no < vb->vb2.num_planes)
>>   		return vb->v4l2_planes[plane_no].length;
>>   	return 0;
>>   }
>> @@ -653,4 +659,4 @@ unsigned long vb2_fop_get_unmapped_area(struct file *file, unsigned long addr,
>>   void vb2_ops_wait_prepare(struct vb2_queue *vq);
>>   void vb2_ops_wait_finish(struct vb2_queue *vq);
>>   
>> -#endif /* _MEDIA_VIDEOBUF2_CORE_H */
>> +#endif /* _MEDIA_VIDEOBUF2_V4L2_H */
>> diff --git a/include/media/videobuf2-vmalloc.h b/include/media/videobuf2-vmalloc.h
>> index 93a76b4..a63fe66 100644
>> --- a/include/media/videobuf2-vmalloc.h
>> +++ b/include/media/videobuf2-vmalloc.h
>> @@ -13,7 +13,7 @@
>>   #ifndef _MEDIA_VIDEOBUF2_VMALLOC_H
>>   #define _MEDIA_VIDEOBUF2_VMALLOC_H
>>   
>> -#include <media/videobuf2-core.h>
>> +#include <media/videobuf2-v4l2.h>
>>   
>>   extern const struct vb2_mem_ops vb2_vmalloc_memops;
>>   
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
