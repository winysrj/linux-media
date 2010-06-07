Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932234Ab0FGHjh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Jun 2010 03:39:37 -0400
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o577da23001612
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 7 Jun 2010 03:39:37 -0400
Message-ID: <4C0CA2A9.2030606@redhat.com>
Date: Mon, 07 Jun 2010 09:41:29 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: huzaifas@redhat.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] libv4l1: move VIDIOCGFREQ and VIDIOCSFREQ to libv4l1
References: <1275636220-21975-1-git-send-email-huzaifas@redhat.com>
In-Reply-To: <1275636220-21975-1-git-send-email-huzaifas@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Looks good, applied

Thanks!

Regards,

Hans

On 06/04/2010 09:23 AM, huzaifas@redhat.com wrote:
> From: Huzaifa Sidhpurwala<huzaifas@redhat.com>
>
> move VIDIOCGFREQ and VIDIOCSFREQ to libv4l1
>
> Signed-of-by: Huzaifa Sidhpurwala<huzaifas@redhat.com>
> ---
>   lib/libv4l1/libv4l1.c |   28 ++++++++++++++++++++++++++++
>   1 files changed, 28 insertions(+), 0 deletions(-)
>
> diff --git a/lib/libv4l1/libv4l1.c b/lib/libv4l1/libv4l1.c
> index 081ed0a..579f13b 100644
> --- a/lib/libv4l1/libv4l1.c
> +++ b/lib/libv4l1/libv4l1.c
> @@ -939,6 +939,34 @@ int v4l1_ioctl(int fd, unsigned long int request, ...)
>   		break;
>   	}
>
> +	case VIDIOCSFREQ: {
> +		unsigned long *freq = arg;
> +		struct v4l2_frequency freq2 = { 0, };
> +
> +		result = v4l2_ioctl(fd, VIDIOC_G_FREQUENCY,&freq2);
> +		if (result<  0)
> +			break;
> +
> +		freq2.frequency = *freq;
> +
> +		result = v4l2_ioctl(fd, VIDIOC_S_FREQUENCY,&freq2);
> +
> +		break;
> +	}
> +
> +	case VIDIOCGFREQ: {
> +		unsigned long *freq = arg;
> +		struct v4l2_frequency freq2 = { 0, };
> +
> +		freq2.tuner = 0;
> +		result = v4l2_ioctl(fd, VIDIOC_G_FREQUENCY,&freq2);
> +		if (result<  0)
> +			break;
> +		if (0 == result)
> +			*freq = freq2.frequency;
> +
> +		break;
> +	}
>   	default:
>   		/* Pass through libv4l2 for applications which are using v4l2 through
>   		   libv4l1 (this can happen with the v4l1compat.so wrapper preloaded */
