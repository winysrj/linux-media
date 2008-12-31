Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f18.google.com ([209.85.218.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gregoire.favre@gmail.com>) id 1LI1OT-00074L-Dc
	for linux-dvb@linuxtv.org; Wed, 31 Dec 2008 14:45:53 +0100
Received: by bwz11 with SMTP id 11so12217743bwz.17
	for <linux-dvb@linuxtv.org>; Wed, 31 Dec 2008 05:45:18 -0800 (PST)
Date: Wed, 31 Dec 2008 14:45:15 +0100
To: linux-dvb@linuxtv.org
Message-ID: <20081231134515.GA3559@gmail.com>
References: <49293640.10808@cadsoft.de> <492A53C4.5030509@makhutov.org>
	<492DC5F5.3060501@gmx.de> <494FC15C.6020400@gmx.de>
	<495355F1.8020406@helmutauer.de>
	<1230219306.2336.25.camel@pc10.localdom.local>
	<20081231091321.55035a64@pedra.chehab.org>
	<495B5CE6.9010902@cadsoft.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <495B5CE6.9010902@cadsoft.de>
From: Gregoire Favre <gregoire.favre@gmail.com>
Subject: Re: [linux-dvb] [PATCH] Add missing S2 caps flag to S2API
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Wed, Dec 31, 2008 at 12:52:06PM +0100, Klaus Schmidinger wrote:

Then vdr-1.7.2 should also be patched :-)

> I just used the same comment characters as the other lines that were
> already there ;-)
> =

> Klaus

> diff -ru linux/drivers/media/dvb/frontends/cx24116.c linux/drivers/media/=
dvb/frontends/cx24116.c
> --- linux/drivers/media/dvb/frontends/cx24116.c	2008-11-21 23:00:55.00000=
0000 +0100
> +++ linux/drivers/media/dvb/frontends/cx24116.c	2008-11-23 11:36:31.00000=
0000 +0100
> @@ -1480,6 +1480,7 @@
>  			FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
>  			FE_CAN_FEC_4_5 | FE_CAN_FEC_5_6 | FE_CAN_FEC_6_7 |
>  			FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
> +			FE_CAN_2G_MODULATION |
>  			FE_CAN_QPSK | FE_CAN_RECOVER
>  	},
>  =

> diff -ru linux/drivers/media/dvb/frontends/stb0899_drv.c linux/drivers/me=
dia/dvb/frontends/stb0899_drv.c
> --- linux/drivers/media/dvb/frontends/stb0899_drv.c	2008-11-21 23:00:55.0=
00000000 +0100
> +++ linux/drivers/media/dvb/frontends/stb0899_drv.c	2008-11-23 11:37:01.0=
00000000 +0100
> @@ -1913,6 +1913,7 @@
>  =

>  		.caps 			=3D FE_CAN_INVERSION_AUTO	|
>  					  FE_CAN_FEC_AUTO	|
> +					  FE_CAN_2G_MODULATION	|
>  					  FE_CAN_QPSK
>  	},
>  =

> diff -ru linux/include/linux/dvb/frontend.h linux/include/linux/dvb/front=
end.h
> --- linux/include/linux/dvb/frontend.h	2008-11-21 23:00:55.000000000 +0100
> +++ linux/include/linux/dvb/frontend.h	2008-11-23 11:27:21.000000000 +0100
> @@ -63,6 +63,7 @@
>  	FE_CAN_8VSB			=3D 0x200000,
>  	FE_CAN_16VSB			=3D 0x400000,
>  	FE_HAS_EXTENDED_CAPS		=3D 0x800000,   // We need more bitspace for newe=
r APIs, indicate this.
> +	FE_CAN_2G_MODULATION		=3D 0x10000000, // frontend supports "2nd generat=
ion modulation" (DVB-S2)
>  	FE_NEEDS_BENDING		=3D 0x20000000, // not supported anymore, don't use (=
frontend requires frequency bending)
>  	FE_CAN_RECOVER			=3D 0x40000000, // frontend can recover from a cable u=
nplug automatically
>  	FE_CAN_MUTE_TS			=3D 0x80000000  // frontend can stop spurious TS data =
output


-- =

Gr=E9goire FAVRE http://gregoire.favre.googlepages.com http://www.gnupg.org
               http://picasaweb.google.com/Gregoire.Favre

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
