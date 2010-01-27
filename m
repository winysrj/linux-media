Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55143 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752576Ab0A0UMZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 15:12:25 -0500
Date: Wed, 27 Jan 2010 21:12:00 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?ISO-8859-15?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
cc: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] soc_camera: match signedness of soc_camera_limit_side()
In-Reply-To: <4B609AD4.605@freemail.hu>
Message-ID: <Pine.LNX.4.64.1001272109470.5073@axis700.grange>
References: <4B5AFD11.6000907@freemail.hu> <Pine.LNX.4.64.1001271645440.5073@axis700.grange>
 <4B6081D4.5070501@freemail.hu> <Pine.LNX.4.64.1001271915400.5073@axis700.grange>
 <4B609AD4.605@freemail.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

You didn't reply to my most important objection:

On Wed, 27 Jan 2010, Németh Márton wrote:

> diff -r 31eaa9423f98 linux/include/media/soc_camera.h
> --- a/linux/include/media/soc_camera.h	Mon Jan 25 15:04:15 2010 -0200
> +++ b/linux/include/media/soc_camera.h	Wed Jan 27 20:49:57 2010 +0100
> @@ -264,9 +264,8 @@
>  		common_flags;
>  }
> 
> -static inline void soc_camera_limit_side(unsigned int *start,
> -		unsigned int *length, unsigned int start_min,
> -		unsigned int length_min, unsigned int length_max)
> +static inline void soc_camera_limit_side(int *start, int *length,
> +		int start_min, int length_min, int length_max)
>  {
>  	if (*length < length_min)
>  		*length = length_min;

I still do not believe this function will work equally well with signed 
parameters, as it works with unsigned ones.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
