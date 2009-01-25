Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:45592 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbZAYWTE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2009 17:19:04 -0500
Subject: Re: [linux-dvb] Tuning a pvrusb2 device.  Every attempt has failed.
From: Andy Walls <awalls@radix.net>
To: "A. F. Cano" <afc@shibaya.lonestar.org>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20090125214637.GA11948@shibaya.lonestar.org>
References: <20090123015815.GA22113@shibaya.lonestar.org>
	 <497CB355.3030408@rogers.com> <20090125214637.GA11948@shibaya.lonestar.org>
Content-Type: text/plain
Date: Sun, 25 Jan 2009 17:18:56 -0500
Message-Id: <1232921936.3087.16.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-01-25 at 16:46 -0500, A. F. Cano wrote:
> On Sun, Jan 25, 2009 at 01:45:41PM -0500, CityK wrote:
> > A. F. Cano wrote:
> > > Still trying to get the OnAir Creator to work.  It is properly recognized
> > > by the pvrusb2 driver, but I can't seem to get any further.  I'm now
> > > trying to scan the digital channels.
> > >   
> > 
> > While you seem to be trying to scan for OTA channels, I would like
> > confirmation that this is indeed the case of what you are attempting, as
> > opposed to searching for digital cable channels.
> 
> Yes.  The RF input is hooked up to an 11ft Winegard roof antenna, mounted on
> a stand behind me, properly oriented according to antennaweb.com for the
> local stations, and with a UHF pre-amp for good measure.  It is inside, but
> a foot below the reasonably high ceiling, so it doesn't interfere with moving
> around.  With this setup I have succeeded in receiving barely visible
> analog channels when the Creator is set up as a v4l device using /dev/video0.
> Yes, the reception sucks, but I want to make sure that it is not something
> more fundamental before I go to the trouble of mounting the antenna on the
> roof.

My experience is that if reception sucks for an analog channel, digital
stations on a physcial channel freq near that same analog channel freq,
in the same direction, will not be available to you.

Ground the coax shield, a point on the cable close to the antenna, to
your home's green wire ground - eliminates EMI (in the cable at least)
in the VHF & UHF band from your PC and other household items. (But your
antenna's right there inside to pick it up of course...)

Also try turning off or turning down the UHF pre-amp to see if you may
be overdirving the Creator's front end (If it's really overdriven, you
may see other analog channels showing up on top of the one you're
watching.)

If you see a herring bone interference pattern on any analog VHF
channel, you likely have a strong FM broadcast interferer in the antenna
beam - set the pre-amp's FM trap to filter him out (if it has an FM
trap).



> Right now, the unit is set up (in mythtv) as a DVB DTV receiver.  I have
> observed that the red led seems to be on when configured in digital mode,
> as it is right now.
> 
> > > ...
> > 
> > If you are mistakenly searching for digital cable channels using the OTA
> > settings, that would explain a number of the observations you have
> > described.
> 
> I'm not sure how to change the cable vs. ota setting.  Doesn't the digital
> tuner determine what it is plugged into?

No.  Generally one must tell a digital tuner what to expect/look for.


>   As far as mythtv, it thinks the
> attached device is a DVB/DTV receiver.  Kaffeine has been told to use the
> us ATSC frequencies, with the results I pointed out earlier.

I love MythTV as an end app, but I find it useless as a troubleshooting
tool - too many variables.

I like to use the dvb apps (femon, scan, dvbtraffic, etc), ivtv-tune,
v4l2-ctl, and mplayer for troubleshooting.

Regards,
Andy

> A.


