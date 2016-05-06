Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:35511 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbcEFQdO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 May 2016 12:33:14 -0400
Received: by mail-qg0-f46.google.com with SMTP id f74so58864810qge.2
        for <linux-media@vger.kernel.org>; Fri, 06 May 2016 09:33:14 -0700 (PDT)
Message-ID: <1462552391.3041.1.camel@gmail.com>
Subject: Re: [RFC 08/22] videodev2.h: Add request field to
 v4l2_pix_format_mplane
From: Nicolas Dufresne <nicolas.dufresne@gmail.com>
Reply-To: nicolas@ndufresne.ca
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Date: Fri, 06 May 2016 12:33:11 -0400
In-Reply-To: <1462532011-15527-9-git-send-email-sakari.ailus@linux.intel.com>
References: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
	 <1462532011-15527-9-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le vendredi 06 mai 2016 à 13:53 +0300, Sakari Ailus a écrit :
> From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> 
> Let userspace specify a request ID when getting or setting formats.
> The
> support is limited to the multi-planar API at the moment, extending
> it
> to the single-planar API is possible if needed.
> 
> From a userspace point of view the API change is also minimized and
> doesn't require any new ioctl.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboar
> d.com>
> ---
>  include/uapi/linux/videodev2.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/videodev2.h
> b/include/uapi/linux/videodev2.h
> index ac28299..6260d0e 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -1972,6 +1972,7 @@ struct v4l2_plane_pix_format {
>   * @ycbcr_enc:		enum v4l2_ycbcr_encoding, Y'CbCr
> encoding
>   * @quantization:	enum v4l2_quantization, colorspace
> quantization
>   * @xfer_func:		enum v4l2_xfer_func, colorspace
> transfer function
> + * @request:		request ID
>   */
>  struct v4l2_pix_format_mplane {
>  	__u32				width;
> @@ -1986,7 +1987,8 @@ struct v4l2_pix_format_mplane {
>  	__u8				ycbcr_enc;
>  	__u8				quantization;
>  	__u8				xfer_func;
> -	__u8				reserved[7];
> +	__u8				reserved[3];
> +	__u32				request;

Shouldn't the request member be added before the padding ?

>  } __attribute__ ((packed));
>  
>  /**
