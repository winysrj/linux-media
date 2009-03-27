Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:32155 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752157AbZC0OOV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 10:14:21 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: =?utf-8?q?N=C3=A9meth_M=C3=A1rton?= <nm127@freemail.hu>
Subject: Re: [PATCH] uvcvideo: add zero fill for VIDIOC_ENUM_FMT
Date: Fri, 27 Mar 2009 15:15:27 +0100
Cc: linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <49C9D652.5040104@freemail.hu>
In-Reply-To: <49C9D652.5040104@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903271515.28146.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 25 March 2009 07:59:30 Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
>
> When enumerating formats with VIDIOC_ENUM_FMT the uvcvideo driver does not
> fill the reserved fields of the struct v4l2_fmtdesc with zeros as required
> by V4L2 API revision 0.24 [1]. Add the missing initializations.
>
> The patch was tested with v4l-test 0.10 [2] with CNF7129 webcam found on
> EeePC 901.
>
> References:
> [1] V4L2 API specification, revision 0.24
>     http://v4l2spec.bytesex.org/spec/r8367.htm
>
> [2] v4l-test: Test environment for Video For Linux Two API
>     http://v4l-test.sourceforge.net/
>
> Signed-off-by: Márton Németh <nm127@freemail.hu>

Applied, thanks.

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

Laurent Pinchart

