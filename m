Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:37748 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753521Ab0CVBQi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Mar 2010 21:16:38 -0400
Subject: Re: Add AverTV Studio 509UA
From: hermann pitton <hermann-pitton@arcor.de>
To: =?UTF-8?Q?=D0=95=D0=B2=D0=B3=D0=B5=D0=BD=D0=B8=D0=B9_?=
	 =?UTF-8?Q?=D0=91=D0=B0=D1=86=D0=BC=D0=B0=D0=BD?=
	<evgenbatsman@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1269211942.3339.33.camel@localhost>
References: <6137756e1003191132t45bb29ddra5e9344f84faf86@mail.gmail.com>
	 <1269045493.5275.3.camel@pc07.localdom.local>
	 <6137756e1003200708v5486c0aah1074361be42e1d64@mail.gmail.com>
	 <1269211942.3339.33.camel@localhost>
Content-Type: text/plain
Date: Mon, 22 Mar 2010 02:16:26 +0100
Message-Id: <1269220586.4189.25.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> 
> I think best would be to create two patches.
> 
> 1/2 adds the new tuner. (tuner-types.c/tuner.h/tveeprom.c)
> 2/2 adds the new Avermedia card.
> 
> Else it looks fine.

To add some for the record here for those eventually later on it.

We have seen over so many years now, that hundreds of "new" can tuners
did appear and, IIRC, we got them all with any combination of previous
chips.

The filters, mainly the SAW filters did make a difference to the
original products they follow all in what ever combination concerning
quality.

However, a main annoyance was, that lots of such clones did appear and
some did start to use extra radio tuners on cheap silicon on separate
addresses, hard to track, since hidden under some welded shielding.

This was with all such clones all over Asia and the extra silicon radio
tuner was always Philips/NXP in the beginning.

What is new now, I think, and first seen, is that the last can tuner
flagship MK5 series has a FQ non radio variant on a AverMedia using some
extra silicon from Philips/NXP/Trident _themselves_ to make some extra
profit against a FM MK5 they have.

I would call this a management disaster, but my education might be
outdated.

Cheers,
Hermann






