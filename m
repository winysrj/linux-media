Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932275Ab0ECIDY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 May 2010 04:03:24 -0400
Message-ID: <4BDE8341.4030203@redhat.com>
Date: Mon, 03 May 2010 05:03:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: stefan.ringel@arcor.de
CC: linux-media@vger.kernel.org, d.belimov@gmail.com
Subject: Re: [PATCH] tm6000: bugfix analog init for tm6010
References: <1272543887-6344-1-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1272543887-6344-1-git-send-email-stefan.ringel@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

stefan.ringel@arcor.de wrote:
> From: Stefan Ringel <stefan.ringel@arcor.de>
> 
> - change values in function tm6000_set_fourcc_format
> - disable digital source
> - add vbi and audio init
> 
> Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
> ---
>  drivers/staging/tm6000/tm6000-core.c |   97 ++++++++++++++++++++++++++++++++-
>  1 files changed, 94 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
> index 0b4dc64..860553f 100644
> --- a/drivers/staging/tm6000/tm6000-core.c
> +++ b/drivers/staging/tm6000/tm6000-core.c
> @@ -157,9 +157,9 @@ void tm6000_set_fourcc_format(struct tm6000_core *dev)
>  {
>  	if (dev->dev_type == TM6010) {
>  		if (dev->fourcc == V4L2_PIX_FMT_UYVY)
> -			tm6000_set_reg(dev, TM6010_REQ07_RC1_TRESHOLD, 0xfc);
> +			tm6000_set_reg(dev, TM6010_REQ07_RC1_TRESHOLD, 0xd0);
>  		else
> -			tm6000_set_reg(dev, TM6010_REQ07_RC1_TRESHOLD, 0xfd);
> +			tm6000_set_reg(dev, TM6010_REQ07_RC1_TRESHOLD, 0x90);
>  	} else {
>  		if (dev->fourcc == V4L2_PIX_FMT_UYVY)
>  			tm6000_set_reg(dev, TM6010_REQ07_RC1_TRESHOLD, 0xd0);

This is wrong: At least on my tests here, this change is inverting the colors.

Anyway, I just committed a patch fixing it. The write on tm6010 should be on
register 0xcc, and not 0xc1. A copy-and-paste error. I'm lucky that I still
had my original appointments and USB dumps from when I added that code.

I've changed the patch a little bit to touch only on the bits that seem to be
related to video format, as it seems that the same register is also used to 
enable digital and audio outputs.

-- 

Cheers,
Mauro
