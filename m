Return-path: <linux-media-owner@vger.kernel.org>
Received: from killer.cirr.com ([192.67.63.5]:55405 "EHLO killer.cirr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254AbZA2EIY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2009 23:08:24 -0500
Received: from afc by tashi.lonestar.org with local (Exim 4.69)
	(envelope-from <afc@shibaya.lonestar.org>)
	id 1LSO5K-0002Yo-Vs
	for linux-media@vger.kernel.org; Wed, 28 Jan 2009 23:00:59 -0500
Date: Wed, 28 Jan 2009 23:00:58 -0500
From: "A. F. Cano" <afc@shibaya.lonestar.org>
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Tuning a pvrusb2 device.  Every attempt has failed.
Message-ID: <20090129040058.GB5361@shibaya.lonestar.org>
References: <20090123015815.GA22113@shibaya.lonestar.org> <497CB355.3030408@rogers.com> <20090125214637.GA11948@shibaya.lonestar.org> <1232921936.3087.16.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232921936.3087.16.camel@palomino.walls.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jan 25, 2009 at 05:18:56PM -0500, Andy Walls wrote:
> ...
> My experience is that if reception sucks for an analog channel, digital
> stations on a physcial channel freq near that same analog channel freq,
> in the same direction, will not be available to you.

It is becoming more and more obvious that the (maybe only?) problem
is lousy reception.  I have taken a couple of small steps and in each
case the situation has improved.

First, I found a better PS for the UHF pre-amp.  The original one had the
power pick-up in a 75 Ohm to 300 Ohm transformer, requiring another one
to go back to the coax cable.  This found a few more channels and improved
the signal strength, but still no picture.  But scan finally reported
some success:

scan /usr/share/dvb/atsc/us-ATSC-center-frequencies-8VSB
scanning /usr/share/dvb/atsc/us-ATSC-center-frequencies-8VSB
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'

After lots of "tuning failed" and "filter timeout" messages I ended up
with this:

dumping lists (3 services)
[0e03]:653028615:8VSB:0:0:3587
[0004]:653028615:8VSB:0:1194:4
[0003]:653028615:8VSB:0:0:3
Done.

> Ground the coax shield, a point on the cable close to the antenna, to
> your home's green wire ground - eliminates EMI (in the cable at least)
> in the VHF & UHF band from your PC and other household items. (But your
> antenna's right there inside to pick it up of course...)

This next step resulted in a few more channels being picked up:

dumping lists (8 services)
[4364]:653028615:8VSB:0:0:17252
[d9ff]:653028615:8VSB:0:0:55807
[ffbf]:653028615:8VSB:0:0:65471
[ffff]:653028615:8VSB:0:0:65535
[c7ff]:653028615:8VSB:0:0:51199
[efff]:653028615:8VSB:0:0:61439
[fff1]:653028615:8VSB:0:0:65521
[bfff]:653028615:8VSB:0:0:49151
Done.

Good call!

> Also try turning off or turning down the UHF pre-amp to see if you may
> be overdirving the Creator's front end (If it's really overdriven, you
> may see other analog channels showing up on top of the one you're
> watching.)

I started the whole process without the UHF pre-amp.  I got absolutely
nothing then.  Unfortunately, mythtv still doesn't display a picture,
but at least it's telling me that it can get a "(L__) Partial Lock".
Sometimes, it even reports the name of the current program.  This is
what I get now:

41 WNBC-DT 17% 3.2dB
42 WXPLUS  16% 3.2dB
44 WNBC4.4 16% 3.2dB
51 WNYW-DT 16% 3.2dB
52 WWOR    18% 3.2dB

> If you see a herring bone interference pattern on any analog VHF
> channel, you likely have a strong FM broadcast interferer in the antenna
> beam - set the pre-amp's FM trap to filter him out (if it has an FM
> trap).

No, no such pattern.  Only random noise in the analog channels that make
the picture almost invisible behind the noise.

I'm actually going to get a Winegard AP-8275 pre-amp.  It does have the
fm trap just in case.  Hopefully the high gain and moving the antenna to
the roof will finally allow me to see some hihg definition pictures...

> ...
> I love MythTV as an end app, but I find it useless as a troubleshooting
> tool - too many variables.

I agree, but MythTV has been the only app so far that has allowed me to
see anything and to control the device to some extent.  However...

> I like to use the dvb apps (femon, scan, dvbtraffic, etc), ivtv-tune,
> v4l2-ctl, and mplayer for troubleshooting.

I'm going to keep trying with these tools.  Thanks for taking the time
to reply.

A.

