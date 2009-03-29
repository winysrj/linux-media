Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail12.sea5.speakeasy.net ([69.17.117.14]:44025 "EHLO
	mail12.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbZC2HjZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 03:39:25 -0400
Date: Sun, 29 Mar 2009 00:39:22 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Vanessa Ezekowitz <vanessaezekowitz@gmail.com>
cc: linux-media@vger.kernel.org
Subject: Re: Kworld ATSC 120 audio capture bug
In-Reply-To: <200903282203.25789.vanessaezekowitz@gmail.com>
Message-ID: <Pine.LNX.4.58.0903290030330.28292@shell2.speakeasy.net>
References: <200903282203.25789.vanessaezekowitz@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 28 Mar 2009, Vanessa Ezekowitz wrote:
> While setting up to rip an old movie from a video tape (one which is not available on any other media), I ran into a bug in the cx88 driver..
>
> As in the past, I can initialize the card into analog mode after a reboot, and view video feeds from over-the-air analog TV (what little remains anyway), composite video in, and svideo in just fine.  Audio for the TV also works fine via the cx88-alsa driver, as usual.
>
> However, for some reason, switching to either composite or svideo input does *not* switch the audio input to the two RCA jacks on the harness like it should.  Instead, when I switch to composite mode I get the TV audio from the last channel I tuned to, plus a little crackling or static (probably feedback from the VCR I have connected to that input), and plain white noise when I switch to Svideo mode.

Because of the way the ADC on cx88 chip works it can't record sound from a
audio line in.  It can only record sound that comes from a tv tuner.
Typically the audio line in on a cx88 card is only a pass-through to the
line out connector on the card.  There is usually a mux that switches the
line out from TV audio to the line.  You'd connect the line out from the
cx88 card to your sound card's line in and listen/record with the sound
card.

Now, it is possible for a cx88 card to have an external ADC chip, in which
case that ADC can be used to record line level audio.  Only a few (one?)
cx88 cards have this and I don't know if yours does.  So maybe this broke
for your card, but I think it's more likely what you're remembering is
recording with your sound card.
