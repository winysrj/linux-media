Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:37205 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbZGKQP7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jul 2009 12:15:59 -0400
Subject: Re: [ivtv-devel] Fwd: [UNKNOWN IVTV CARD] (cx23416) AverMedia
 M113-C
From: Andy Walls <awalls@radix.net>
To: Discussion list for development of the IVTV driver
	<ivtv-devel@ivtvdriver.org>
Cc: Ravi A <asvravi@gmail.com>, linux-media@vger.kernel.org
In-Reply-To: <1247185979.3166.35.camel@palomino.walls.org>
References: <9b563c170906211531g6417d6f7y6950fadb49de6802@mail.gmail.com>
	 <9b563c170907051351n5c8ba9dbm1ef491c55b55619f@mail.gmail.com>
	 <9b563c170907060322u21deb059xa890abef840a364@mail.gmail.com>
	 <1246930237.3151.33.camel@palomino.walls.org>
	 <9b563c170907071542m71fbd262y2b61dd2ff56ec8c0@mail.gmail.com>
	 <1247013473.3141.21.camel@palomino.walls.org>
	 <9b563c170907091034n77fd8a21y5bf54d88dd4d2ac2@mail.gmail.com>
	 <1247185979.3166.35.camel@palomino.walls.org>
Content-Type: text/plain
Date: Sat, 11 Jul 2009 12:13:29 -0400
Message-Id: <1247328809.6864.6.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-07-09 at 20:32 -0400, Andy Walls wrote:
> On Thu, 2009-07-09 at 23:04 +0530, Ravi A wrote:
> > On Wed, Jul 8, 2009 at 6:07 AM, Andy Walls<awalls@radix.net> wrote:



> > >> - Audio - it came up briefly, but missing again now. I may need to
> > >> check all the other system settings for this one.
> > >
> > > Hmmm.  You may want to try and capture the MPEG stream to a file:
> > >
> > >  $ cat /dev/video0 > foo.mpg
> > >
> > > and then playback the file on a machine with a known good sound setup to
> > > make sure the CX25841/CX23416 is capturing the sound properly.
> > >
> > > Also, set the driver to use a 48 ksps audio sample rate and not 32 ksps.
> > > The cx25840 module drives the CX2584x chip's audio PLL out of its valid
> > > operating range for 32 ksps audio.  Most newer CX25843 chips don't seem
> > > to care being told to operate too slow, but the audio PLL in some
> > > CX2584x cores stop oscillating under that condition.
> > >
> > 
> > I captured it using vlc and played back on a windows laptop :) The
> > sound was too low and seemed very choppy (maybe not unlike that due to
> > a PLL operating at the edge of its hold range!). You can notice it in
> > the video clip I linked above.
> > Although I did not explicitly set the sample rate, mplayer reported
> > 48ksps for the captured stream.
> 
> 48 ksps is the default.  VLC might change it for the capture.  When VLC,
> or any other app, is capturing, you can use v4l2-ctl -d /dev/video0
> --log-status to see how the capture is configured.  (v4l2 device nodes
> are multiple open.)
> 
> I'll look into what I might be able to do in the CX25840 driver about
> fixing the PLL clocks.

Ravi,

I have added a change here:

http://linuxtv.org/hg/~awalls/ivtv

to the cx25840 module.  The change ensures that the Video and Aux PLLs
for CX2584x chips run close to 400 MHz, the center frequency of the
VCOs.  The change is essentially what the cx18 driver does for it's
integrated A/V core.

Please see if you get reliable audio with the CX25841 on your board with
this change.

Regards,
Andy

> The volume is controllable with the controls available with v4l2-ctl.
> 
> Regards,
> Andy
> 
> > 
> > Thanks!
> > Ravi
> > 


