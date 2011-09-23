Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284Ab1IWXnd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 19:43:33 -0400
Message-ID: <4E7D199F.1000908@redhat.com>
Date: Fri, 23 Sep 2011 20:43:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Lawrence Rust <lawrence@softsystem.co.uk>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jarod Wilson <jarod@redhat.com>
Subject: Re: RC6 decoding
References: <1316430722.1656.16.camel@gagarin>
In-Reply-To: <1316430722.1656.16.camel@gagarin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 19-09-2011 08:12, Lawrence Rust escreveu:
> The current decoder for the RC6 IR protocol supports mode 0 (16 bit) and
> mode 6A.  In mode 6A the decoder supports either 32-bit data (for
> Microsoft's MCE RC) or 24 bit.
> 
> I would like to support a Sky/Sky+ standard RC which transmits RC6-6-20
> i.e. 20 bit data.  The transmitted frame format is identical to the 24
> bit form so I'm curious as to what remotes transmit 24 bit data or was
> this an error and it should be 20?
> 
> RC6-6-20 is explained here:
> http://www.guiott.com/wrc/RC6-6.html
> 
> If 24-bit mode is in use, is there a way to select between 20 and 24 bit
> operation?

You'll need to figure out a way to detect between them. It is probably not
hard to detect, and add support for both at the decider.
Maybe you can find something useful here:
	http://www.sbprojects.com/knowledge/ir/rc6.php


> 
> I made the following simple mod to ir-rc6-decoder.c and my Sky/Sky+ RCs
> decode correctly (with a custom keytable):
> 
> --- a/drivers/media/rc/ir-rc6-decoder.c	2011-05-19 06:06:34.000000000 +0200
> +++ b/drivers/media/rc/ir-rc6-decoder.c	2011-09-19 13:02:35.000000000 +0200
> @@ -17,14 +17,14 @@
>  /*
>   * This decoder currently supports:
>   * RC6-0-16	(standard toggle bit in header)
> - * RC6-6A-24	(no toggle bit)
> + * RC6-6A-20	(no toggle bit)
>   * RC6-6A-32	(MCE version with toggle bit in body)
>   */
>  
>  #define RC6_UNIT		444444	/* us */
>  #define RC6_HEADER_NBITS	4	/* not including toggle bit */
>  #define RC6_0_NBITS		16
> -#define RC6_6A_SMALL_NBITS	24
> +#define RC6_6A_SMALL_NBITS	20
>  #define RC6_6A_LARGE_NBITS	32
>  #define RC6_PREFIX_PULSE	(6 * RC6_UNIT)
>  #define RC6_PREFIX_SPACE	(2 * RC6_UNIT)
> @@ -231,7 +231,7 @@ again:
>  				scancode = data->body & ~RC6_6A_MCE_TOGGLE_MASK;
>  			} else {
>  				toggle = 0;
> -				scancode = data->body & 0xffffff;
> +				scancode = data->body;
>  			}
>  
>  			IR_dprintk(1, "RC6(6A) scancode 0x%08x (toggle: %u)\n",
> 
> 

