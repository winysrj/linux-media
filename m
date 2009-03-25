Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4705 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099AbZCYHM0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2009 03:12:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: =?utf-8?q?N=C3=A9meth_M=C3=A1rton?= <nm127@freemail.hu>
Subject: Re: [PATCH] uvcvideo: add zero fill for VIDIOC_ENUM_FMT
Date: Wed, 25 Mar 2009 08:12:38 +0100
Cc: Laurent Pinchart <laurent.pinchart@skynet.be>,
	linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <49C9D652.5040104@freemail.hu>
In-Reply-To: <49C9D652.5040104@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903250812.38051.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 25 March 2009 07:59:30 Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
>
> When enumerating formats with VIDIOC_ENUM_FMT the uvcvideo driver does
> not fill the reserved fields of the struct v4l2_fmtdesc with zeros as
> required by V4L2 API revision 0.24 [1]. Add the missing initializations.
>
> The patch was tested with v4l-test 0.10 [2] with CNF7129 webcam found on
> EeePC 901.

Or even better, Laurent, why not move to video_ioctl2? That will take care 
of such things for you. The next step I'm going to take in the 
implementation of the v4l2 framework is to move all drivers over to 
v4l2_device and v4l2_ioctl2, so it would certainly help me if you could 
convert uvcvideo. This is a typical example why using video_ioctl2 is a 
good (tm) idea!

Regards,

	Hans

>
> References:
> [1] V4L2 API specification, revision 0.24
>     http://v4l2spec.bytesex.org/spec/r8367.htm
>
> [2] v4l-test: Test environment for Video For Linux Two API
>     http://v4l-test.sourceforge.net/
>
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> ---
> --- linux-2.6.29/drivers/media/video/uvc/uvc_v4l2.c.orig	2009-03-24
> 00:12:14.000000000 +0100 +++
> linux-2.6.29/drivers/media/video/uvc/uvc_v4l2.c	2009-03-25
> 07:24:42.000000000 +0100 @@ -673,11 +673,19 @@ static long
> uvc_v4l2_do_ioctl(struct fil
>  	{
>  		struct v4l2_fmtdesc *fmt = arg;
>  		struct uvc_format *format;
> +		__u32 index;
> +		enum v4l2_buf_type type;
>
>  		if (fmt->type != video->streaming->type ||
>  		    fmt->index >= video->streaming->nformats)
>  			return -EINVAL;
>
> +		index = fmt->index;
> +		type = fmt->type;
> +		memset(fmt, 0, sizeof(*fmt));
> +		fmt->index = index;
> +		fmt->type = type;
> +
>  		format = &video->streaming->format[fmt->index];
>  		fmt->flags = 0;
>  		if (format->flags & UVC_FMT_FLAG_COMPRESSED)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
