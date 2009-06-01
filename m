Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:50807 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187AbZFAAay (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2009 20:30:54 -0400
Subject: Re: Some more Zolid Hybrid TV Tuner
From: hermann pitton <hermann-pitton@arcor.de>
To: Sander Pientka <cumulus0007@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <200905311457.32309.cumulus0007@gmail.com>
References: <200905311457.32309.cumulus0007@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 01 Jun 2009 02:20:43 +0200
Message-Id: <1243815643.3927.12.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Sander, you likely need two more weeks to get fried enough, but ...

Am Sonntag, den 31.05.2009, 14:57 +0200 schrieb Sander Pientka: 
> I made a picture of the board's name, maybe it's useful to you: 
> http://imagebin.ca/view/B_0V5y.html. The board name shows the tuner, the DVB 
> demodulator and the video processor.

Don't give up that soon and this is a first step in the right direction.

We see at least a 16MHz crystal, but instead of the names, we already
know, we would prefer to see the chips in question and HOW THEY ARE
CONNECTED.

Keep the board, likely I can provide you with xbay links to first class
hybrid tuners for about 9€ something plus shipping.

Since you seem to be more interested in DVB-T, a photograph showing the
connections from the tda10048 to the saa713x, on the saa7131e package it
might be more helpful to have opinions from the tda10048 people here, 8
combined lines anyway, might help to decide if it operates in TS serial
or parallel mode.

I personally prefer to start with Composite/S-Video inputs on such
stuff, get video and audio muxes right, discover possible antenna
switches for RF inputs (radio too?) and get some idea of gpio switching
on that card.

DVB usually only works on a first attempt, if you have by pure luck a
clone of an already existing card. Since for such new hardware we have
only _one_  entry for reference until now, it seems there is no
reference yet for _you_.

Else, anything about more details prior mentioned applies!
The board status is not documented enough by you and failing scan apps
can mean a lot or nothing. 

BTW, your board has some production date of 2008/05/05.

In such cycles it still means yesterday and first seen ever.

Cheers,
Hermann




