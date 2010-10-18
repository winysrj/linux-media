Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:42957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754955Ab0JROaY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 10:30:24 -0400
Message-ID: <4CBC5AC0.0@redhat.com>
Date: Mon, 18 Oct 2010 16:33:36 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Marc Deslauriers <marc.deslauriers@ubuntu.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l-utils: libv4l1: When asked for RGB, return RGB and
 not BGR
References: <1287405872.6471.23.camel@mdlinux>
In-Reply-To: <1287405872.6471.23.camel@mdlinux>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

NACK

The byte ordering in v4l1's VIDEO_PALETTE_RGB24 was never really
clear, but the kernel v4l1 compatibility ioctl handling has
been mapping VIDEO_PALETTE_RGB24 <-> V4L2_PIX_FMT_BGR24
for ever and many v4l1 apps actually expect VIDEO_PALETTE_RGB24
to be BGR24. The only one I know of to get this wrong is camorama
and the solution there is to:
1) not use camorama
2) if you use camorama anyway, fix it, there is a list of patches
    fixing various issues available here:
http://pkgs.fedoraproject.org/gitweb/?p=camorama.git;a=tree

Regards,

Hans


On 10/18/2010 02:44 PM, Marc Deslauriers wrote:
> libv4l1: When asked for RGB, return RGB and not BGR
>
> Signed-off-by: Marc Deslauriers<marc.deslauriers@ubuntu.com>
> ---
>   lib/libv4l1/libv4l1.c |    8 ++++----
>   1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/lib/libv4l1/libv4l1.c b/lib/libv4l1/libv4l1.c
> index cb53899..202f020 100644
> --- a/lib/libv4l1/libv4l1.c
> +++ b/lib/libv4l1/libv4l1.c
> @@ -87,9 +87,9 @@ static unsigned int palette_to_pixelformat(unsigned
> int palette)
>   	case VIDEO_PALETTE_RGB565:
>   		return V4L2_PIX_FMT_RGB565;
>   	case VIDEO_PALETTE_RGB24:
> -		return V4L2_PIX_FMT_BGR24;
> +		return V4L2_PIX_FMT_RGB24;
>   	case VIDEO_PALETTE_RGB32:
> -		return V4L2_PIX_FMT_BGR32;
> +		return V4L2_PIX_FMT_RGB32;
>   	case VIDEO_PALETTE_YUYV:
>   		return V4L2_PIX_FMT_YUYV;
>   	case VIDEO_PALETTE_YUV422:
> @@ -118,9 +118,9 @@ static unsigned int pixelformat_to_palette(unsigned
> int pixelformat)
>   		return VIDEO_PALETTE_RGB555;
>   	case V4L2_PIX_FMT_RGB565:
>   		return VIDEO_PALETTE_RGB565;
> -	case V4L2_PIX_FMT_BGR24:
> +	case V4L2_PIX_FMT_RGB24:
>   		return VIDEO_PALETTE_RGB24;
> -	case V4L2_PIX_FMT_BGR32:
> +	case V4L2_PIX_FMT_RGB32:
>   		return VIDEO_PALETTE_RGB32;
>   	case V4L2_PIX_FMT_YUYV:
>   		return VIDEO_PALETTE_YUYV;
