Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:42811 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab1GTLKS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2011 07:10:18 -0400
Date: Wed, 20 Jul 2011 13:12:12 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Luiz Ramos <lramos.prof@yahoo.com.br>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Fix wrong register mask in gspca/sonixj.c
Message-ID: <20110720131212.13a9f8d2@tele>
In-Reply-To: <1311039554.88024.YahooMailClassic@web121815.mail.ne1.yahoo.com>
References: <20110715194448.401bf441@tele>
	<1311039554.88024.YahooMailClassic@web121815.mail.ne1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 18 Jul 2011 18:39:14 -0700 (PDT)
Luiz Ramos <lramos.prof@yahoo.com.br> wrote:
	[snip]
> I noticed that in 640x480 the device worked fine, but in 320x240 and
> 160x120 it didn't (I mean: the image is dark). Or'ing reg17 with 0x04
> in line 2535 (as it's currently done for VGA) is sufficient to make
> the webcam work again. The change could be like that:
	[snip]
> However, the frame rates get limited to 10 fps. Without that change,
> and in 320x240 and 160x120, they reach 20 fps (of darkness).
> 
> I can't see what or'ing that register means, and what's the
> relationship between this and the webcam darkness. It seems that
> these bits control some kind of clock; this can be read in the
> program comments. One other argument in favour of this assumption is
> the fact that the frame rate changes accordingly to the value of
> these bits. But I can't see how this relates to exposure.
> 
> For my purposes, I'll stay with that change; it's sufficient for my
> purposes. If you know what I did, please advise me. :-)

Hi Luiz,

You changed the sensor clock from 24MHz to 12MHz.

The clocks of the sensor and the bridge may have different values.
In 640x480, the bridge clock is 48MHz (reg01) and the sensor clock is
12MHz (reg17: clock / 4). Previously, in 320x240, the bridge clock was
48MHz and the sensor clock 24 MHz (reg17: clock / 2).

I think that the sensor clock must stay the same for a same frame rate.
So, what about changing the bridge clock only, i.e. bridge clock 24MHZ
(reg01) and sensor clock 24MHz (reg17: clock / 1)?

That's what I coded in the last gspca test version (2.13.3) which is
available in my web site (see below). May you try it?

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
