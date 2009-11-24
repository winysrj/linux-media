Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:34335 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757281AbZKXBKL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 20:10:11 -0500
Subject: Re: [PATCH] Multifrontend support for saa7134
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <maurochehab@gmail.com>
Cc: =?UTF-8?Q?Luk=C3=A1=C5=A1?= Karas <lukas.karas@centrum.cz>,
	linux-media@vger.kernel.org, Petr Fiala <petr.fiala@gmail.com>
In-Reply-To: <4B0AB281.4080802@gmail.com>
References: <200910312121.21926.lukas.karas@centrum.cz>
	 <4B0AB281.4080802@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Nov 2009 02:08:16 +0100
Message-Id: <1259024896.5511.19.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Am Montag, den 23.11.2009, 14:04 -0200 schrieb Mauro Carvalho Chehab:
> Hi Lukáš/Hermann,
> 
> Any news about this patch? I'll mark it as RFC at the patchwork, since it seems that this is not finished yet. Please let me know if you make some progress.
> 
> > @@ -1352,6 +1353,7 @@ struct saa7134_board saa7134_boards[] =
> >  		.tuner_addr     = ADDR_UNSET,
> >  		.radio_addr     = ADDR_UNSET,
> >  		 .mpeg           = SAA7134_MPEG_DVB,
> > +		 .num_frontends  = 1,
> >  		 .inputs         = {{
> >  			 .name = name_tv,
> >  			 .vmux = 1,
> 
> Just one suggestion here: it is a way better to assume that an "uninitialized" value (e. g. num_frontends = 0) for num_frontends to mean that just one frontend exists. This saves space at the initialization segment
> of the module and avoids the risk of someone forget to add num_frontends=0.
> 
> cheers,
> Mauro.

I currently don't have time to work on it and Lukáš' time is also
limited.

We stay in contact and I can provide a device not yet working for me to
him, if he wants. I'll keep you posted. You can have one too ;)

Currently the hardware reset in saa7134-dvb.c seems to break tda8275a
hybrid tuners on my saa7131e devices for DVB-T. This is not restricted
to the devices with multiple frontends, but also hits such with single
frontend only. The TRIO has two tda8275a, they are not in use as hybrid
tuners and don't need extra initialization again, that might be the
difference.

We should avoid such saa7133 hardware reset on those cards not needing
it in any case, means all with single frontend.

ON DVB-S is also a regression visible, in one of two cases needs a
second tuning attempt now and it also seems to be related to the
hardware reset, since without works fine like previously.

Patch is not ready yet for inclusion.

Cheers,
Hermann




