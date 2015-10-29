Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:34411 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756619AbbJ2C2A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Oct 2015 22:28:00 -0400
Subject: Re: [RFC PATCH v7 2/7] media: videobuf2: Move timestamp to vb2_buffer
To: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	pawel@osciak.com
References: <1444976863-3657-1-git-send-email-jh1009.sung@samsung.com>
 <1444976863-3657-3-git-send-email-jh1009.sung@samsung.com>
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56318418.8070501@xs4all.nl>
Date: Thu, 29 Oct 2015 11:27:36 +0900
MIME-Version: 1.0
In-Reply-To: <1444976863-3657-3-git-send-email-jh1009.sung@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/16/2015 15:27, Junghak Sung wrote:
> Move timestamp from struct vb2_v4l2_buffer to struct vb2_buffer
> for common use. This patch includes all device drivers' changes
> related with this restructuring.
> 
> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
> Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
> Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>
> ---
>  drivers/input/touchscreen/sur40.c                  |    2 +-
>  drivers/media/dvb-frontends/rtl2832_sdr.c          |    2 +-
>  drivers/media/pci/cobalt/cobalt-irq.c              |    2 +-
>  drivers/media/pci/cx23885/cx23885-core.c           |    2 +-
>  drivers/media/pci/cx23885/cx23885-video.c          |    2 +-
>  drivers/media/pci/cx25821/cx25821-video.c          |    2 +-
>  drivers/media/pci/cx88/cx88-core.c                 |    2 +-
>  drivers/media/pci/dt3155/dt3155.c                  |    2 +-
>  drivers/media/pci/netup_unidvb/netup_unidvb_core.c |    2 +-
>  drivers/media/pci/saa7134/saa7134-core.c           |    2 +-
>  drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |    4 ++--
>  drivers/media/pci/solo6x10/solo6x10-v4l2.c         |    2 +-
>  drivers/media/pci/sta2x11/sta2x11_vip.c            |    2 +-
>  drivers/media/pci/tw68/tw68-video.c                |    2 +-
>  drivers/media/platform/am437x/am437x-vpfe.c        |    2 +-
>  drivers/media/platform/blackfin/bfin_capture.c     |    2 +-
>  drivers/media/platform/coda/coda-bit.c             |    6 +++---
>  drivers/media/platform/davinci/vpbe_display.c      |    2 +-
>  drivers/media/platform/davinci/vpif_capture.c      |    2 +-
>  drivers/media/platform/davinci/vpif_display.c      |    4 ++--
>  drivers/media/platform/exynos-gsc/gsc-m2m.c        |    4 ++--
>  drivers/media/platform/exynos4-is/fimc-capture.c   |    2 +-
>  drivers/media/platform/exynos4-is/fimc-isp-video.c |    2 +-
>  drivers/media/platform/exynos4-is/fimc-lite.c      |    2 +-
>  drivers/media/platform/exynos4-is/fimc-m2m.c       |    2 +-
>  drivers/media/platform/m2m-deinterlace.c           |    2 +-
>  drivers/media/platform/marvell-ccic/mcam-core.c    |    2 +-
>  drivers/media/platform/mx2_emmaprp.c               |    2 +-
>  drivers/media/platform/omap3isp/ispvideo.c         |    2 +-
>  drivers/media/platform/rcar_jpu.c                  |    2 +-
>  drivers/media/platform/s3c-camif/camif-capture.c   |    2 +-
>  drivers/media/platform/s5p-g2d/g2d.c               |    2 +-
>  drivers/media/platform/s5p-jpeg/jpeg-core.c        |    4 ++--
>  drivers/media/platform/s5p-mfc/s5p_mfc.c           |    4 ++--
>  drivers/media/platform/sh_veu.c                    |    2 +-
>  drivers/media/platform/sh_vou.c                    |    2 +-
>  drivers/media/platform/soc_camera/atmel-isi.c      |    2 +-
>  drivers/media/platform/soc_camera/mx2_camera.c     |    2 +-
>  drivers/media/platform/soc_camera/mx3_camera.c     |    2 +-
>  drivers/media/platform/soc_camera/rcar_vin.c       |    2 +-
>  .../platform/soc_camera/sh_mobile_ceu_camera.c     |    2 +-
>  drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |    4 ++--
>  drivers/media/platform/ti-vpe/vpe.c                |    2 +-
>  drivers/media/platform/vim2m.c                     |    2 +-
>  drivers/media/platform/vivid/vivid-kthread-cap.c   |    6 +++---
>  drivers/media/platform/vivid/vivid-kthread-out.c   |    8 ++++----
>  drivers/media/platform/vivid/vivid-sdr-cap.c       |    5 +++--
>  drivers/media/platform/vivid/vivid-vbi-cap.c       |    8 ++++----
>  drivers/media/platform/vsp1/vsp1_video.c           |    2 +-
>  drivers/media/platform/xilinx/xilinx-dma.c         |    2 +-
>  drivers/media/usb/airspy/airspy.c                  |    2 +-
>  drivers/media/usb/au0828/au0828-video.c            |    2 +-
>  drivers/media/usb/em28xx/em28xx-video.c            |    2 +-
>  drivers/media/usb/go7007/go7007-driver.c           |    2 +-
>  drivers/media/usb/hackrf/hackrf.c                  |    2 +-
>  drivers/media/usb/pwc/pwc-if.c                     |    2 +-
>  drivers/media/usb/s2255/s2255drv.c                 |    2 +-
>  drivers/media/usb/stk1160/stk1160-video.c          |    2 +-
>  drivers/media/usb/usbtv/usbtv-video.c              |    2 +-
>  drivers/media/usb/uvc/uvc_video.c                  |   12 ++++++------
>  drivers/media/v4l2-core/videobuf2-v4l2.c           |    8 ++++----
>  drivers/staging/media/davinci_vpfe/vpfe_video.c    |    2 +-
>  drivers/staging/media/omap4iss/iss_video.c         |    2 +-
>  drivers/usb/gadget/function/uvc_queue.c            |    2 +-
>  include/media/videobuf2-core.h                     |    2 ++
>  include/media/videobuf2-v4l2.h                     |    2 --
>  include/trace/events/v4l2.h                        |    2 +-
>  include/trace/events/vb2.h                         |    7 +++++--
>  68 files changed, 98 insertions(+), 94 deletions(-)
> 

<snip>

> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 647ebfe..f1e7169 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -211,6 +211,7 @@ struct vb2_queue;
>   * @num_planes:		number of planes in the buffer
>   *			on an internal driver queue
>   * @planes:		private per-plane information; do not change
> + * @timestamp:		frame timestamp
>   */
>  struct vb2_buffer {
>  	struct vb2_queue	*vb2_queue;
> @@ -219,6 +220,7 @@ struct vb2_buffer {
>  	unsigned int		memory;
>  	unsigned int		num_planes;
>  	struct vb2_plane	planes[VB2_MAX_PLANES];
> +	struct timeval		timestamp;

This should become a u64 timestamp that's filled using ktime_get_ns().
In the v4l2 code this should be converted to a timeval when v4l2_buffer
is filled. Using ktime_get_ns() is the recommended method to do timestamping
without having to worry about the y2038 problem and this should be used in
vb2 core.

v4l2_set_timestamp should be updated accordingly.

Regards,

	Hans

>  
>  	/* private: internal use only
>  	 *
> diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
> index 5abab1e..110062e 100644
> --- a/include/media/videobuf2-v4l2.h
> +++ b/include/media/videobuf2-v4l2.h
> @@ -28,7 +28,6 @@
>   * @vb2_buf:	video buffer 2
>   * @flags:	buffer informational flags
>   * @field:	enum v4l2_field; field order of the image in the buffer
> - * @timestamp:	frame timestamp
>   * @timecode:	frame timecode
>   * @sequence:	sequence count of this frame
>   * Should contain enough information to be able to cover all the fields
> @@ -39,7 +38,6 @@ struct vb2_v4l2_buffer {
>  
>  	__u32			flags;
>  	__u32			field;
> -	struct timeval		timestamp;
>  	struct v4l2_timecode	timecode;
>  	__u32			sequence;
>  };
> diff --git a/include/trace/events/v4l2.h b/include/trace/events/v4l2.h
> index 04ef89b..5b57d0a 100644
> --- a/include/trace/events/v4l2.h
> +++ b/include/trace/events/v4l2.h
> @@ -204,7 +204,7 @@ DECLARE_EVENT_CLASS(vb2_v4l2_event_class,
>  		__entry->minor = owner ? owner->vdev->minor : -1;
>  		__entry->flags = vbuf->flags;
>  		__entry->field = vbuf->field;
> -		__entry->timestamp = timeval_to_ns(&vbuf->timestamp);
> +		__entry->timestamp = timeval_to_ns(&vb->timestamp);
>  		__entry->timecode_type = vbuf->timecode.type;
>  		__entry->timecode_flags = vbuf->timecode.flags;
>  		__entry->timecode_frames = vbuf->timecode.frames;
> diff --git a/include/trace/events/vb2.h b/include/trace/events/vb2.h
> index bfeceeb..35c1589 100644
> --- a/include/trace/events/vb2.h
> +++ b/include/trace/events/vb2.h
> @@ -18,6 +18,7 @@ DECLARE_EVENT_CLASS(vb2_event_class,
>  		__field(u32, index)
>  		__field(u32, type)
>  		__field(u32, bytesused)
> +		__field(s64, timestamp)
>  	),
>  
>  	TP_fast_assign(
> @@ -28,14 +29,16 @@ DECLARE_EVENT_CLASS(vb2_event_class,
>  		__entry->index = vb->index;
>  		__entry->type = vb->type;
>  		__entry->bytesused = vb->planes[0].bytesused;
> +		__entry->timestamp = timeval_to_ns(&vb->timestamp);
>  	),
>  
>  	TP_printk("owner = %p, queued = %u, owned_by_drv = %d, index = %u, "
> -		  "type = %u, bytesused = %u", __entry->owner,
> +		  "type = %u, bytesused = %u, timestamp = %llu", __entry->owner,
>  		  __entry->queued_count,
>  		  __entry->owned_by_drv_count,
>  		  __entry->index, __entry->type,
> -		  __entry->bytesused
> +		  __entry->bytesused,
> +		  __entry->timestamp
>  	)
>  )
>  
> 
