Return-path: <mchehab@gaivota>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3561 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab0L3PVg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 10:21:36 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [media] ivtv-i2c: Fix two wanrings
Date: Thu, 30 Dec 2010 16:21:21 +0100
References: <20101230130041.71357141@gaivota>
In-Reply-To: <20101230130041.71357141@gaivota>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012301621.21746.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Thursday, December 30, 2010 16:00:41 Mauro Carvalho Chehab wrote:
> Fix two gcc warnings:
> 
> drivers/media/video/ivtv/ivtv-i2c.c:170: warning: cast from pointer to integer of different size
> drivers/media/video/ivtv/ivtv-i2c.c:171: warning: cast from pointer to integer of different size
> $ gcc --version
> gcc (GCC) 4.1.2 20080704 (Red Hat 4.1.2-48)
> 
> They seem bogus, but, as the original code also has problems with
> LE/BE, just change its implementation to be clear.

Definitely not bogus:

unsigned char keybuf[4];

..

*ir_key = (u32) keybuf;

Here keybuf == &keybuf[0]. So you put the address of keybuf in *ir_key. Which is
indeed of a different size in the case of a 64-bit architecture.

What you probably meant to do is:

*ir_key = *(u32 *)keybuf;

Note that the code in your patch assumes that keybuf is in big-endian order. I assume
that's what it should be?

Regards,

	Hans

> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
> index 2bed430..e103b8f 100644
> --- a/drivers/media/video/ivtv/ivtv-i2c.c
> +++ b/drivers/media/video/ivtv/ivtv-i2c.c
> @@ -167,8 +167,8 @@ static int get_key_adaptec(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
>  	keybuf[2] &= 0x7f;
>  	keybuf[3] |= 0x80;
>  
> -	*ir_key = (u32) keybuf;
> -	*ir_raw = (u32) keybuf;
> +	*ir_key = keybuf[3] | keybuf[2] << 8 | keybuf[1] << 16 |keybuf[0] << 24;
> +	*ir_raw = *ir_key;
>  
>  	return 1;
>  }
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
