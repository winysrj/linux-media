Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:44955 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab0FJGtJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jun 2010 02:49:09 -0400
Received: by ey-out-2122.google.com with SMTP id 25so343268eya.19
        for <linux-media@vger.kernel.org>; Wed, 09 Jun 2010 23:49:08 -0700 (PDT)
Date: Thu, 10 Jun 2010 08:48:45 +0200 (CEST)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
cc: linux-media@vger.kernel.org
Subject: Re: Is anybody working on TechniSat CableStar Combo HD CI USB
 device?
In-Reply-To: <87eighygoy.fsf@nemi.mork.no>
Message-ID: <alpine.DEB.2.01.1006090014310.17071@localhost.localdomain>
References: <20100607070123.GA28216@wozi.local> <4C0D4E18.30507@vanbest.org> <20100608062621.GA4053@wozi.local> <291a60d4cc2cd21b923d74bd86856c6b.squirrel@www.vanbest.eu> <AANLkTik0KfaObIY7Hwki-_uuIU6m3KgsaaiNa5u4WnSu@mail.gmail.com>
 <87eighygoy.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue (Tuesday) 08.Jun (June) 2010, 12:14,  Bjørn Mork wrote:

> Markus Rechberger <mrechberger@gmail.com> writes:
> 
> > Trident is also still improving the quality of their driver and
> > firmware, it very much makes
> > sense that they handle their driver especially since those DRX drivers
> > are very complex
> > (basically too complex for being handled by the community, the drivers
> > would just
> > end up somewhere unmaintained).
> 
> Ouch.  That makes me wonder about the state of the Windows drivers for
> those devices...  Better stay away from them, I guess.

Just to throw this out there, the 'doze support for one such
Micronas-based device I have -- the Linux kernel support for which
either does not exist or cannot be publicly distributed -- is less
than optimal in my experience, which may have nothing to do with
reality.

While I was able to make a flawless test recording for a few
minutes of one medium-bitrate lower-resolution high-definition
programme to mislead me into thinking that I'd have success with
a full-length programme, for some reason it turned out that my use
of the device under 'doze for an extended time on a borrowed 'doze
box suffered fairly frequent problems manifested each as a short
dropout of the recording.

This could also be pilot error, as I remain willfully ignorant of
'doze and its details, but if a machine with CPU horsepower over
eight times that (neglecting other acceleration) of my workhorse
that routinely makes four simultaneous flawless recordings
including some at higher resolution/bitrate, is unable to keep up
with the bitstream, then something has got to be seriously wrong,
in my opinion.

A later recording of a higher bitrate (excellent quality standard-
definition video source) stream again exhibited the same problem.
Perhaps 'doze can't keep up writing to its own native filesystem
as it approaches being full, or if I can't keep my hands away from
configuring it to be user-hostile as I prefer.

And of course there's the factor of intermediate hardware to be
considered -- my device is connected via a USB interface which has
caused major filesystem corruption over time with the particular
Linux kernel I was using, despite of working flawlessly with a
different video card.  And 'doze...  *shiver*

Anyway, I'd be happy to learn that others have had success with
the same device, although for me it's no longer a priority to have
it working, to say nothing of working perfectly.  My testing of
the device has been relatively minimal, using it where other tuner
cards lack support.


barry bouwsma
