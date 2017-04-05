Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:27655 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751040AbdDEFOV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Apr 2017 01:14:21 -0400
Subject: Re: [PATCH] MAINTAINERS: update atmel-isi.c path
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <d8b1734c-a689-bea5-33f3-113b4b7b3247@xs4all.nl>
From: "Wu, Songjun" <Songjun.Wu@microchip.com>
Message-ID: <bea573e5-d759-7f1b-420e-0e178ff57d37@microchip.com>
Date: Wed, 5 Apr 2017 13:13:46 +0800
MIME-Version: 1.0
In-Reply-To: <d8b1734c-a689-bea5-33f3-113b4b7b3247@xs4all.nl>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 4/3/2017 22:54, Hans Verkuil wrote:
> The driver moved to drivers/media/platform/atmel.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> After the atmel-isi v6 patch series this atmel-isi entry is no longer correct.
> Fixed.
> 
> Songjun, I don't think Ludovic is still maintainer of this driver. Should that
> be changed to you? (And no, I'm not planning to maintain this driver going forward :-) )
> 
Hi Hans,

It's OK, you can change the maintainer of this driver to me.
Thank you for this valuable work.

> Regards,
> 
> 	Hans
> ---
>   MAINTAINERS | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 93500928ca4f..08d41f8e5d33 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2224,7 +2224,7 @@ ATMEL ISI DRIVER
>   M:	Ludovic Desroches <ludovic.desroches@microchip.com>
>   L:	linux-media@vger.kernel.org
>   S:	Supported
> -F:	drivers/media/platform/soc_camera/atmel-isi.c
> +F:	drivers/media/platform/atmel/atmel-isi.c
>   F:	include/media/atmel-isi.h
> 
>   ATMEL LCDFB DRIVER
> 
