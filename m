Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58660 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbbLJKFc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2015 05:05:32 -0500
Date: Thu, 10 Dec 2015 08:05:28 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Maury Markowitz <maury.markowitz@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] us-ATSC-center-frequencies-8VSB: Added channel numbers
 in comments to make the file easier to  use by comparing against local
 channel lists.
Message-ID: <20151210080528.6bc3fb84@recife.lan>
In-Reply-To: <3DC79E44-2C1C-40C8-B9AA-D77614D50C3E@gmail.com>
References: <201512081149525312370@gmail.com>
	<56687B09.4050004@kapsi.fi>
	<3DC79E44-2C1C-40C8-B9AA-D77614D50C3E@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 9 Dec 2015 21:47:10 -0500
Maury Markowitz <maury.markowitz@gmail.com> escreveu:

> This is my first attempt at a patch, so please be gentle.
> 
> Signed-off-by: Maury Markowitz <maury.markowitz@gmail.com>
> 
> ---
>  atsc/us-ATSC-center-frequencies-8VSB | 78 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 78 insertions(+)
> 
> diff --git a/atsc/us-ATSC-center-frequencies-8VSB b/atsc/us-ATSC-center-frequencies-8VSB
> index e744878..abb05fb 100644
> --- a/atsc/us-ATSC-center-frequencies-8VSB
> +++ b/atsc/us-ATSC-center-frequencies-8VSB
> @@ -1,410 +1,488 @@
>  # US ATSC center frequencies, use if in doubt
>  
> +# VHF low-band, channels 2 to 6, no longer used for television broadcasting
> +
> +#channel 2
>  [CHANNEL]

You could, instead, put the channel number inside the [], like:

[CHANNEL 2]

I actually think that this makes the file better readable. Take a look
at this file, for example:
	isdb-t/br-Brazil

(that's basically the basic channeling used on NTSC, except that ISDB-T
 main carrier is not at the center of the channel, so the frequencies
 there have a shift when compared with the analog TV frequencies).

There, I opted to put a notes about the unused frequencies at the
header. This very same file is also used on other Countries in
South and Central America.

>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 57028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 3
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 63028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 4
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 69028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 5
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 79028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 6
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 85028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +# VHF high-band, channels 7 to 13, not common but a few digital stations on it
> +
> +#channel 7
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 177028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 8
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 183028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 9
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 189028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 10
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 195028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 11
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 201028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 12
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 207028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 13
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 213028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +# UHF, channels 14 to 51, most existing stations, almost all digital
> +
> +#channel 14
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 473028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 15
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 479028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 16
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 485028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 17
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 491028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 18
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 497028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 19
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 503028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 20
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 509028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 21
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 515028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 22
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 521028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 23
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 527028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 24
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 533028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 25
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 539028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 26
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 545028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 27
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 551028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 28
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 557028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 29
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 563028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 30
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 569028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 31
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 575028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 32
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 581028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 33
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 587028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 34
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 593028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 35
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 599028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 36
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 605028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 37, not used in USA and Canada due to interference with radio astronomy bands
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 611028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 38
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 617028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 39
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 623028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 40
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 629028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 41
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 635028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 42
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 641028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 43
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 647028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 44
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 653028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 45
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 659028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 46
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 665028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 47
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 671028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 48
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 677028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 49
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 683028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 50
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 689028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 51, no longer used to clear interference with cell bands
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 695028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +# the following frequencies were formerly part of the UHF band before the digital transition
> +# but were sold off to cell carriers and are no longer used for television
> +
> +#channel 52
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 701028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 53
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 707028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 54
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 713028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 55
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 719028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 56
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 725028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 57
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 731028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 58
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 737028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 59
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 743028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 60
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 749028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 61
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 755028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 62
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 761028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 63
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 767028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 64
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 773028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 65
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 779028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 66
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 785028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 67
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 791028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 68
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 797028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +#channel 69
>  [CHANNEL]
>  	DELIVERY_SYSTEM = ATSC
>  	FREQUENCY = 803028615
>  	MODULATION = VSB/8
>  	INVERSION = AUTO
>  
> +# UHF formerly had changes 70 through 83 as well
