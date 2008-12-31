Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Wed, 31 Dec 2008 10:50:36 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
Message-ID: <20081231105036.2f9e6e76@pedra.chehab.org>
In-Reply-To: <495B5CE6.9010902@cadsoft.de>
References: <49293640.10808@cadsoft.de> <492A53C4.5030509@makhutov.org>
	<492DC5F5.3060501@gmx.de> <494FC15C.6020400@gmx.de>
	<495355F1.8020406@helmutauer.de>
	<1230219306.2336.25.camel@pc10.localdom.local>
	<20081231091321.55035a64@pedra.chehab.org>
	<495B5CE6.9010902@cadsoft.de>
Mime-Version: 1.0
Cc: linux-dvb-maintainer@linuxtv.org, linux-dvb@linuxtv.org,
	Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] [PATCH] Add missing S2 caps flag to S2API
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi Kaus,
On Wed, 31 Dec 2008 12:52:06 +0100
Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de> wrote:

> > "//" for comments shouldn't happen, since it violates C99 syntax that it is used
> > on kernel.   
> 
> I just used the same comment characters as the other lines that were
> already there ;-)

Yes, I know. We need to sanitize the file ;)

I'll write a separate patch fixing this after merging yours.
> 
> Klaus

You just forgot to send me a patch description with your SOB and Stoth's ack ;) Except for that, the patch seems sane on my eyes.

Maybe we may commit it as two separate patches:

The first one with the core changes, and the second one with the driver
(cx24116 and stb0899) ones. API changes are important enough to deserve their
own separate commit.

Cheers,
Mauro.

> 
> diff -ru linux/drivers/media/dvb/frontends/cx24116.c linux/drivers/media/dvb/frontends/cx24116.c
> --- linux/drivers/media/dvb/frontends/cx24116.c	2008-11-21 23:00:55.000000000 +0100
> +++ linux/drivers/media/dvb/frontends/cx24116.c	2008-11-23 11:36:31.000000000 +0100
> @@ -1480,6 +1480,7 @@
>  			FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
>  			FE_CAN_FEC_4_5 | FE_CAN_FEC_5_6 | FE_CAN_FEC_6_7 |
>  			FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
> +			FE_CAN_2G_MODULATION |
>  			FE_CAN_QPSK | FE_CAN_RECOVER
>  	},
>  
> diff -ru linux/drivers/media/dvb/frontends/stb0899_drv.c linux/drivers/media/dvb/frontends/stb0899_drv.c
> --- linux/drivers/media/dvb/frontends/stb0899_drv.c	2008-11-21 23:00:55.000000000 +0100
> +++ linux/drivers/media/dvb/frontends/stb0899_drv.c	2008-11-23 11:37:01.000000000 +0100
> @@ -1913,6 +1913,7 @@
>  
>  		.caps 			= FE_CAN_INVERSION_AUTO	|
>  					  FE_CAN_FEC_AUTO	|
> +					  FE_CAN_2G_MODULATION	|
>  					  FE_CAN_QPSK
>  	},
>  
> diff -ru linux/include/linux/dvb/frontend.h linux/include/linux/dvb/frontend.h
> --- linux/include/linux/dvb/frontend.h	2008-11-21 23:00:55.000000000 +0100
> +++ linux/include/linux/dvb/frontend.h	2008-11-23 11:27:21.000000000 +0100
> @@ -63,6 +63,7 @@
>  	FE_CAN_8VSB			= 0x200000,
>  	FE_CAN_16VSB			= 0x400000,
>  	FE_HAS_EXTENDED_CAPS		= 0x800000,   // We need more bitspace for newer APIs, indicate this.
> +	FE_CAN_2G_MODULATION		= 0x10000000, // frontend supports "2nd generation modulation" (DVB-S2)
>  	FE_NEEDS_BENDING		= 0x20000000, // not supported anymore, don't use (frontend requires frequency bending)
>  	FE_CAN_RECOVER			= 0x40000000, // frontend can recover from a cable unplug automatically
>  	FE_CAN_MUTE_TS			= 0x80000000  // frontend can stop spurious TS data output




Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
