Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3386 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab3DVG5H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 02:57:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFCv3 02/10] [media] videodev2.h: Remove the unused old V4L1 buffer types
Date: Mon, 22 Apr 2013 08:56:42 +0200
References: <1366570839-662-1-git-send-email-mchehab@redhat.com> <1366570839-662-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366570839-662-3-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304220856.42854.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun April 21 2013 21:00:31 Mauro Carvalho Chehab wrote:
> Those aren't used anywhere for a long time. Drop it.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  include/uapi/linux/videodev2.h | 21 ---------------------
>  1 file changed, 21 deletions(-)
> 
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 4aa24c3..5d8ee92 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -72,27 +72,6 @@
>  #define VIDEO_MAX_FRAME               32
>  #define VIDEO_MAX_PLANES               8
>  
> -#ifndef __KERNEL__
> -
> -/* These defines are V4L1 specific and should not be used with the V4L2 API!
> -   They will be removed from this header in the future. */
> -
> -#define VID_TYPE_CAPTURE	1	/* Can capture */
> -#define VID_TYPE_TUNER		2	/* Can tune */
> -#define VID_TYPE_TELETEXT	4	/* Does teletext */
> -#define VID_TYPE_OVERLAY	8	/* Overlay onto frame buffer */
> -#define VID_TYPE_CHROMAKEY	16	/* Overlay by chromakey */
> -#define VID_TYPE_CLIPPING	32	/* Can clip */
> -#define VID_TYPE_FRAMERAM	64	/* Uses the frame buffer memory */
> -#define VID_TYPE_SCALES		128	/* Scalable */
> -#define VID_TYPE_MONOCHROME	256	/* Monochrome only */
> -#define VID_TYPE_SUBCAPTURE	512	/* Can capture subareas of the image */
> -#define VID_TYPE_MPEG_DECODER	1024	/* Can decode MPEG streams */
> -#define VID_TYPE_MPEG_ENCODER	2048	/* Can encode MPEG streams */
> -#define VID_TYPE_MJPEG_DECODER	4096	/* Can decode MJPEG streams */
> -#define VID_TYPE_MJPEG_ENCODER	8192	/* Can encode MJPEG streams */
> -#endif
> -
>  /*
>   *	M I S C E L L A N E O U S
>   */
> 
