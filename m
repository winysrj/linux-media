Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:50024 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753988Ab0FXX5M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jun 2010 19:57:12 -0400
Subject: Re: [PATCH] Terratec Cinergy 250 PCI support
From: hermann pitton <hermann-pitton@arcor.de>
To: Jean-Michel Grimaldi <jm@via.ecp.fr>
Cc: linux-media@vger.kernel.org
In-Reply-To: <AANLkTim5-Cc-ijE1U7M1DWSF8hcj8svSH30a0YVM4qv9@mail.gmail.com>
References: <AANLkTim5-Cc-ijE1U7M1DWSF8hcj8svSH30a0YVM4qv9@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 25 Jun 2010 01:43:58 +0200
Message-Id: <1277423038.4742.9.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Jean-Michel,

Am Freitag, den 25.06.2010, 00:42 +0200 schrieb Jean-Michel Grimaldi:
> Hi, I have a Terratec Cinergy 250 PCI video card, and a small
> modification in saa7134-cards.c is needed for it to work. I built the
> patch on 2.6.34 version (I sent the modification to the maintainer in
> early 2009 but got no feedback):
> 
> -- saa7134-cards.old.c	2010-06-25 00:31:16.000000000 +0200
> +++ saa7134-cards.new.c	2010-06-25 00:30:52.000000000 +0200
> @@ -2833,7 +2833,7 @@
>  			.tv   = 1,
>  		},{
>  			.name = name_svideo,  /* NOT tested */
> -			.vmux = 8,
> +			.vmux = 3,
>  			.amux = LINE1,
>  		}},
>  		.radio = {
> 
> Thanks for taking it into account in future kernels.
> 

hm, don't know who missed it. After Gerd, the main mover on saa7134 was
Hartmut, also /me and some well known others cared.

Official maintainer these days is Mauro.

For latest DVB stuff, you also will meet Mike Krufky.

I'm sorry, but your patch is still wrong.

You do have only a Composite signal. S-Video, with separated chroma and
luma, can only be on vmux 5-9.

NACKED-by: hermann pitton <hermann-pitton@arcor.de>

Cheers,
Hermann



