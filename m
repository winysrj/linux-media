Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59417 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659Ab2IMKQm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 06:16:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 API PATCH 25/28] Set vfl_dir for all display or m2m drivers.
Date: Thu, 13 Sep 2012 04:37:27 +0200
Message-ID: <3121560.nicC2eVh8j@avalon>
In-Reply-To: <4b07ee5a399746f4264f852f430dbbcae8a13b32.1347023744.git.hans.verkuil@cisco.com>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl> <4b07ee5a399746f4264f852f430dbbcae8a13b32.1347023744.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Friday 07 September 2012 15:29:25 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/pci/ivtv/ivtv-streams.c         |    3 +++
>  drivers/media/pci/zoran/zoran_card.c          |    4 ++++
>  drivers/media/platform/coda.c                 |    1 +
>  drivers/media/platform/davinci/vpbe_display.c |    1 +
>  drivers/media/platform/davinci/vpif_display.c |    1 +
>  drivers/media/platform/m2m-deinterlace.c      |    1 +
>  drivers/media/platform/mem2mem_testdev.c      |    1 +
>  drivers/media/platform/mx2_emmaprp.c          |    1 +
>  drivers/media/platform/omap/omap_vout.c       |    1 +
>  drivers/media/platform/omap3isp/ispvideo.c    |    1 +
>  drivers/media/platform/s5p-fimc/fimc-m2m.c    |    1 +
>  drivers/media/platform/s5p-g2d/g2d.c          |    1 +
>  drivers/media/platform/s5p-jpeg/jpeg-core.c   |    1 +
>  drivers/media/platform/s5p-mfc/s5p_mfc.c      |    1 +
>  drivers/media/platform/s5p-tv/mixer_video.c   |    1 +
>  drivers/media/platform/sh_vou.c               |    1 +
>  drivers/media/usb/uvc/uvc_driver.c            |    2 ++
>  17 files changed, 23 insertions(+)
> 
> diff --git a/drivers/media/pci/ivtv/ivtv-streams.c
> b/drivers/media/pci/ivtv/ivtv-streams.c index f08ec17..1d0e04a 100644
> --- a/drivers/media/pci/ivtv/ivtv-streams.c
> +++ b/drivers/media/pci/ivtv/ivtv-streams.c
> @@ -223,6 +223,9 @@ static int ivtv_prep_dev(struct ivtv *itv, int type)
> 
>  	s->vdev->num = num;
>  	s->vdev->v4l2_dev = &itv->v4l2_dev;
> +	if (ivtv_stream_info[type].buf_type == V4L2_BUF_TYPE_VIDEO_OUTPUT ||
> +	    ivtv_stream_info[type].buf_type == V4L2_BUF_TYPE_VBI_OUTPUT)
> +		s->vdev->vfl_dir = VFL_DIR_TX;

I think drivers should set VFL_DIR_RX explicitly instead of relying on it 
being equal to 0. If we change the value later for any reason this 
implementation would break.

>  	s->vdev->fops = ivtv_stream_info[type].fops;
>  	s->vdev->ctrl_handler = itv->v4l2_dev.ctrl_handler;
>  	s->vdev->release = video_device_release;

-- 
Regards,

Laurent Pinchart

