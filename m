Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:45970 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761681AbZAPKeN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2009 05:34:13 -0500
Subject: Re: Fw: [PATCH] E506r-composite-input
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Tim Farrington <timf@iinet.au>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20090115233528.7f458d34@pedra.chehab.org>
References: <20090115233528.7f458d34@pedra.chehab.org>
Content-Type: text/plain
Date: Fri, 16 Jan 2009 11:34:24 +0100
Message-Id: <1232102064.2695.12.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Donnerstag, den 15.01.2009, 23:35 -0200 schrieb Mauro Carvalho
Chehab:
> Message sent to the wrong address... it is not *-owner ;)
> 
> Forwarded message:
> 
> Date: Thu, 15 Jan 2009 21:58:55 +0900
> From: Tim Farrington <timf@iinet.net.au>
> To: Mauro Carvalho Chehab <mchehab@infradead.org>,
> linux-media-owner@vger.kernel.org
> Subject: [PATCH] E506r-composite-input
> 
> 
> Make correction to composite input plus svideo input
> to Avermedia E506R
> 
> Signed-off-by: Tim Farrington timf@iinet.net.au
> 
> 
> 
> 
> 
> 
> 
> Cheers,
> Mauro
> 
> 
> 
> 
> 
> 
> 
> Unterschied
> zwischen
> Dateien-Anlage
> (E506r_composite.patch)
> 
> Only in .: E506r_composite.patch
> diff
> -upr ./linux/drivers/media/video/saa7134/saa7134-cards.c ../a/v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c
> --- ./linux/drivers/media/video/saa7134/saa7134-cards.c 2009-01-15
> 21:42:05.000000000 +0900
> +++ ../a/v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c      2009-01-15 21:45:29.000000000 +0900
> @@ -4362,13 +4362,13 @@ struct saa7134_board saa7134_boards[] = 
>                          .amux = TV,
>                          .tv   = 1,
>                  }, {
> -                        .name = name_comp,
> -                        .vmux = 0,
> +                        .name = name_comp1,
> +                        .vmux = 3,
>                          .amux = LINE1,
>                  }, {
>                          .name = name_svideo,
>                          .vmux = 8,
> -                        .amux = LINE1,
> +                        .amux = LINE2,
>                  } },
>                  .radio = {
>                          .name = name_radio,
> 

Mauro, I was never sure about why that patch, which introduced name_comp
was accepted very, very late in the drivers history. It previously
always started the enumeration with name_comp1.

If it should have any sense at all, I thought it was to avoid ambiguity
on such devices which have only one Composite input.

Tim, are you sure that Composite amux is LINE1 and S-Video LINE2?

It would be the first and only card ever seen with different amux for
those inputs and should be noted as unusual case. I doubt it has two
different audio-in connectors.

Cheers,
Hermann


