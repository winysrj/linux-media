Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:37166 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab0EEDvG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 May 2010 23:51:06 -0400
Received: by bwz25 with SMTP id 25so2648458bwz.28
        for <linux-media@vger.kernel.org>; Tue, 04 May 2010 20:51:02 -0700 (PDT)
Date: Wed, 5 May 2010 13:54:11 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] tm6000, moving cards name defines
Message-ID: <20100505135411.7131059c@glory.loctelecom.ru>
In-Reply-To: <4BDDA900.9000903@infradead.org>
References: <20100414173102.58b0f184@glory.loctelecom.ru>
	<4BDDA900.9000903@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 02 May 2010 13:32:00 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> Dmitri Belimov wrote:
> > Hi
> > 
> > Move TV cards name defines to better place header file.
> 
> I prefer if we can keep having all board-specific stuff inside
> tm6000-cards.

We need know type of tuner and type of TV card inside tm6000-dvb
You know other way?

With my best regards, Dmitry.

> Cheers,
> Mauro
> > 
> > diff -r 7c0b887911cf linux/drivers/staging/tm6000/tm6000-cards.c
> > --- a/linux/drivers/staging/tm6000/tm6000-cards.c	Mon Apr 05
> > 22:56:43 2010 -0400 +++
> > b/linux/drivers/staging/tm6000/tm6000-cards.c	Wed Apr 14
> > 11:18:03 2010 +1000 @@ -35,22 +35,6 @@ #include "tuner-xc2028.h"
> >  #include "xc5000.h"
> >  
> > -#define TM6000_BOARD_UNKNOWN			0
> > -#define TM5600_BOARD_GENERIC			1
> > -#define TM6000_BOARD_GENERIC			2
> > -#define TM6010_BOARD_GENERIC			3
> > -#define TM5600_BOARD_10MOONS_UT821		4
> > -#define TM5600_BOARD_10MOONS_UT330		5
> > -#define TM6000_BOARD_ADSTECH_DUAL_TV		6
> > -#define TM6000_BOARD_FREECOM_AND_SIMILAR	7
> > -#define TM6000_BOARD_ADSTECH_MINI_DUAL_TV	8
> > -#define TM6010_BOARD_HAUPPAUGE_900H		9
> > -#define TM6010_BOARD_BEHOLD_WANDER		10
> > -#define TM6010_BOARD_BEHOLD_VOYAGER		11
> > -#define TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE	12
> > -#define TM6010_BOARD_TWINHAN_TU501		13
> > -
> > -#define TM6000_MAXBOARDS        16
> >  static unsigned int card[]     = {[0 ... (TM6000_MAXBOARDS - 1)] =
> > UNSET }; 
> >  module_param_array(card,  int, NULL, 0444);
> > diff -r 7c0b887911cf linux/drivers/staging/tm6000/tm6000.h
> > --- a/linux/drivers/staging/tm6000/tm6000.h	Mon Apr 05
> > 22:56:43 2010 -0400 +++
> > b/linux/drivers/staging/tm6000/tm6000.h	Wed Apr 14 11:18:03
> > 2010 +1000 @@ -41,6 +41,23 @@ #include "dmxdev.h"
> >  
> >  #define TM6000_VERSION KERNEL_VERSION(0, 0, 2)
> > +
> > +#define TM6000_BOARD_UNKNOWN			0
> > +#define TM5600_BOARD_GENERIC			1
> > +#define TM6000_BOARD_GENERIC			2
> > +#define TM6010_BOARD_GENERIC			3
> > +#define TM5600_BOARD_10MOONS_UT821		4
> > +#define TM5600_BOARD_10MOONS_UT330		5
> > +#define TM6000_BOARD_ADSTECH_DUAL_TV		6
> > +#define TM6000_BOARD_FREECOM_AND_SIMILAR	7
> > +#define TM6000_BOARD_ADSTECH_MINI_DUAL_TV	8
> > +#define TM6010_BOARD_HAUPPAUGE_900H		9
> > +#define TM6010_BOARD_BEHOLD_WANDER		10
> > +#define TM6010_BOARD_BEHOLD_VOYAGER		11
> > +#define TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE	12
> > +#define TM6010_BOARD_TWINHAN_TU501		13
> > +
> > +#define TM6000_MAXBOARDS        16
> >  
> >  /* Inputs */
> >  
> > 
> > Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov
> > <d.belimov@gmail.com>
> > 
> > With my best regards, Dmitry.
> > 
> 
> 
> -- 
> 
> Cheers,
> Mauro
