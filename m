Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:37216 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbZLKJdO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2009 04:33:14 -0500
Subject: Re: [linux-dvb] Hauppauge PVR-150 Vertical sync issue?
From: Andy Walls <awalls@radix.net>
To: Robert Longfield <robert.longfield@gmail.com>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
In-Reply-To: <34373e030912100856r2ba80741yca8f79c84ee730e3@mail.gmail.com>
References: <34373e030911241005r7f499297y1a84a93e0696f550@mail.gmail.com>
	 <1259106230.3069.16.camel@palomino.walls.org>
	 <34373e030912100856r2ba80741yca8f79c84ee730e3@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 11 Dec 2009 04:32:22 -0500
Message-Id: <1260523942.3087.21.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-12-10 at 11:56 -0500, Robert Longfield wrote:
> Ok I've been able to do some troubleshooting with some interesting results.
> I removed the one splitter being used, connected to the main cable
> coming into the house, isolated the grounds with no change in sync
> issues.
> I pulled the pvr-150 card out of the linux machine and put it into my
> window box, hooked it up to the original setup splitter and no ground
> isolation and the video is crystal clear with no sync issues.
> 
> I can only come up with a few possible problems, but I am sure there are more.
> Could this be a driver issue on my linux box?

Given your results, yes it is most likely a linux driver issue.  The
suspects would be the cx25840 module, or the modules for the analog
tuner.

What analog tuner assembly type does the tveeprom module show for your
card in dmesg?

Also what video standard are you capturing: NTSC or something else?


> Could a bad or failing PCI slot cause this problem?

No.  A *very* busy PCI bus may cause some I2C transactions that set up
the tuner or CX25843 to fail, but it is more likely simply a suboptimal
tuner or CX25843 configuration issue.


> However the sync
> problem is not on every channel.
> 
> I'm going to try moving the linux box across the house to see if there
> is a source of EMI near by, but since the windows box doesn't have
> this issue I assume this is a problem with the linux box.

I suppose you could try a linux liveCD in the Windows box and use

	$ cat /dev/video0 > foo.mpg

to capture video.  Then move foo.mpg to a USB flash disk and play back
foo.mpg where ever it is convenient.  If foo.mpg shows artifacts then
you can be somewhat sure of a linux driver issue.


> -Rob
> 
> On Tue, Nov 24, 2009 at 6:43 PM, Andy Walls <awalls@radix.net> wrote:
> > On Tue, 2009-11-24 at 13:05 -0500, Robert Longfield wrote:
> >> I have a PVR-150 card running on mythbuntu 9 and it appears that my
> >> card is suffering a vertical (and possibly a horizontal) sync issue.
> >>
> >> The video jumps around, shifts from side to side, up and down and when
> >> it shifts the video wraps. I'm including a link to a screen shot
> >> showing the vertical sync problem
> >>
> >> http://imagebin.ca/view/6fS-14Yi.html
> >
> > It looks like you have strong singal reflections in your cable due to
> > impedance mismatches, a bad splitter, a bad cable or connector, etc.
> >
> > Please read:
> >
> > http://www.ivtvdriver.org/index.php/Howto:Improve_signal_quality
> >
> > and take steps to ensure you've got a good cabling plant in your home.
> >
> > Regards,
> > Andy
> >
> >> This is pretty tame to what happens sometimes. I haven't noticed this
> >> on all channels as we are mostly using this to record shows for my
> >> son.
> >>
> >> Here is my setup. Pentium 4 2 Ghz with a gig of ram. 40 gig OS drive,
> >> 150 gig drive for recording, 250 gig drive for backup and storage, a
> >> dvd-burner.
> >> The 150 gig drive is on a Promise Ultra133 TX2 card but exhibits no
> >> issues on reads or writes.
> >> I have cable connected to the internal tuner of my PVR-150 card and
> >> S-video from an Nvidia card (running Nvidea drivers) out to the TV.
> >>
> >> I don't know what else I can provide to help out but let me know and
> >> I'll get it.
> >>
> >> Thanks,
> >> -Rob


