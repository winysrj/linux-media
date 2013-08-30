Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:38196 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab3H3MIJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 08:08:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Dinesh Ram <dinram@cisco.com>
Subject: Re: [PATCH 6/6] si4713 : Added MAINTAINERS entry for radio-usb-si4713 driver
Date: Fri, 30 Aug 2013 14:07:52 +0200
Cc: linux-media@vger.kernel.org, dinesh.ram@cern.ch
References: <1377862104-15429-1-git-send-email-dinram@cisco.com> <3c4c1fcee2e6d52919548289aa87316ca1dfa8f7.1377861337.git.dinram@cisco.com>
In-Reply-To: <3c4c1fcee2e6d52919548289aa87316ca1dfa8f7.1377861337.git.dinram@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201308301407.52758.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri 30 August 2013 13:28:24 Dinesh Ram wrote:
> Hans Verkuil <hverkuil@xs4all.nl> will maintain the USB driver for si4713
> 
> Signed-off-by: Dinesh Ram <dinram@cisco.com>
> ---
>  MAINTAINERS | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b2618ce..ddd4d5f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7412,7 +7412,7 @@ L:	linux-media@vger.kernel.org
>  T:	git git://linuxtv.org/media_tree.git
>  W:	http://linuxtv.org
>  S:	Odd Fixes
> -F:	drivers/media/radio/si4713-i2c.?
> +F:	drivers/media/radio/si4713/si4713.?
>  
>  SI4713 FM RADIO TRANSMITTER PLATFORM DRIVER
>  M:	Eduardo Valentin <edubezval@gmail.com>
> @@ -7420,7 +7420,15 @@ L:	linux-media@vger.kernel.org
>  T:	git git://linuxtv.org/media_tree.git
>  W:	http://linuxtv.org
>  S:	Odd Fixes
> -F:	drivers/media/radio/radio-si4713.h
> +F:	drivers/media/radio/si4713/radio-platform-si4713.c
> +
> +KEENE FM RADIO TRANSMITTER DRIVER

You forgot to update the driver description! This is the SiLabs si4713 EVB
driver, not Keene.

Can you make a v2 of this patch fixing this?

Regards,

	Hans

> +M:	Hans Verkuil <hverkuil@xs4all.nl>
> +L:	linux-media@vger.kernel.org
> +T:	git git://linuxtv.org/media_tree.git
> +W:	http://linuxtv.org
> +S:	Maintained
> +F:	drivers/media/radio/si4713/radio-usb-si4713.c
>  
>  SIANO DVB DRIVER
>  M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
> 
