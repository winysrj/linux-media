Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328Ab0FAIjs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jun 2010 04:39:48 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o518dlZX022315
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 1 Jun 2010 04:39:47 -0400
Message-ID: <4C04C7BF.4020701@redhat.com>
Date: Tue, 01 Jun 2010 10:41:35 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: huzaifas@redhat.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] libv4l1: Move VIDIOCGFBUF into libv4l1
References: <1275293008-3261-1-git-send-email-huzaifas@redhat.com>
In-Reply-To: <1275293008-3261-1-git-send-email-huzaifas@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks, I've applied your patch with one small fix,
The else block at the end of was wrongly indented
(one indent level too much) It is the else for the first if, not the second.
Note the first if has a { at the end of the line, and the second does not,
and the else starts with a }.

Regards,

Hans


On 05/31/2010 10:03 AM, huzaifas@redhat.com wrote:
> From: Huzaifa Sidhpurwala<huzaifas@fedora-12.(none)>
>
> Move VIDIOCGFBUF into libv4l1
>
> Signed-off-by: Huzaifa Sidhpurwala<huzaifas@redhat.com>
> ---
>   lib/libv4l1/libv4l1.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
>   1 files changed, 45 insertions(+), 0 deletions(-)
>
> diff --git a/lib/libv4l1/libv4l1.c b/lib/libv4l1/libv4l1.c
> index e13feba..5b2dc29 100644
> --- a/lib/libv4l1/libv4l1.c
> +++ b/lib/libv4l1/libv4l1.c
> @@ -804,6 +804,51 @@ int v4l1_ioctl(int fd, unsigned long int request, ...)
>   		break;
>   	}
>
> +	case VIDIOCGFBUF: {
> +		struct video_buffer *buffer = arg;
> +		struct v4l2_framebuffer fbuf = { 0, };
> +
> +		result = v4l2_ioctl(fd, VIDIOC_G_FBUF, buffer);
> +		if (result<  0)
> +			break;
> +
> +		buffer->base = fbuf.base;
> +		buffer->height = fbuf.fmt.height;
> +		buffer->width = fbuf.fmt.width;
> +
> +		switch (fbuf.fmt.pixelformat) {
> +		case V4L2_PIX_FMT_RGB332:
> +			buffer->depth = 8;
> +			break;
> +		case V4L2_PIX_FMT_RGB555:
> +			buffer->depth = 15;
> +			break;
> +		case V4L2_PIX_FMT_RGB565:
> +			buffer->depth = 16;
> +			break;
> +		case V4L2_PIX_FMT_BGR24:
> +			buffer->depth = 24;
> +			break;
> +		case V4L2_PIX_FMT_BGR32:
> +			buffer->depth = 32;
> +			break;
> +		default:
> +			buffer->depth = 0;
> +		}
> +
> +		if (fbuf.fmt.bytesperline) {
> +			buffer->bytesperline = fbuf.fmt.bytesperline;
> +			if (!buffer->depth&&  buffer->width)
> +				buffer->depth = ((fbuf.fmt.bytesperline<<3)
> +						+ (buffer->width-1))
> +						/ buffer->width;
> +			} else {
> +				buffer->bytesperline =
> +					(buffer->width * buffer->depth + 7)&  7;
> +				buffer->bytesperline>>= 3;
> +			}
> +	}
> +
>   	default:
>   		/* Pass through libv4l2 for applications which are using v4l2 through
>   		   libv4l1 (this can happen with the v4l1compat.so wrapper preloaded */
