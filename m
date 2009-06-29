Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:55298 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951AbZF2BUY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Jun 2009 21:20:24 -0400
Subject: RE: Bah! How do I change channels?
From: hermann pitton <hermann-pitton@arcor.de>
To: George Adams <g_adams27@hotmail.com>
Cc: dheitmueller@kernellabs.com, awalls@radix.net,
	video4linux-list@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <1246161203.4027.11.camel@pc07.localdom.local>
References: <COL103-W53A73F78F552D9FD9BAA2A88350@phx.gbl>
	 <1246017001.4755.4.camel@palomino.walls.org>
	 <829197380906260642m2cd87ae5qd6487dc5eae91e51@mail.gmail.com>
	 <COL103-W513258452EA45C7700193888320@phx.gbl>
	 <1246153145.13091.5.camel@pc07.localdom.local>
	 <COL103-W4295D8AA447AA893CA010888330@phx.gbl>
	 <1246161203.4027.11.camel@pc07.localdom.local>
Content-Type: text/plain
Date: Mon, 29 Jun 2009 03:19:17 +0200
Message-Id: <1246238357.5780.25.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Sonntag, den 28.06.2009, 05:53 +0200 schrieb hermann pitton:
> Hi,
> 
> Am Samstag, den 27.06.2009, 22:36 -0400 schrieb George Adams:
> > A final wrapup (and again, thanks all of you - I'm indebted to you for your help):
> >  
> > after booting:
> >  
> > > v4l2-ctl -F
> > Frequency: 9076 (567.250000 MHz)
> >  
> > > ivtv-tune -c 3
> > /dev/video0: 61.250 MHz
> > > v4l2-ctl -F
> > Frequency: 980 (61.250000 MHz)
> >  
> > > v4l2-ctl -f 61.25
> > Frequency set to 980 (61.250000 MHz)
> > > v4l2-ctl -F           
> > Frequency: 980 (61.250000 MHz)
> >  
> > > v4lctl setchannel 3
> > > v4l2-ctl -F      
> > Frequency: 0 (0.000000 MHz)
> >  
> > Conclusion: I'll stick with ivtv-tune or v4l2-ctl and ignore the misbehaving v4lctl
> >  
> > Hermann: Thanks, but I think you're mistaking the v4lctl "setstation" command (which relies on .xawtv) and the "setchannel" command (which does not, at least according to the man page.)
> 
> I can for sure tell, that, if I rename/remove my .xawtv, "setchannel"
> does not work anymore and I see exactly what you reported initially.
> 
> That can be looked up in the code and it also should not matter that I
> have a dual install of xawtv-3.95 and 4x since both start to exist.

for the record: The above is true for a FlyVideo3000 (card=2) on the
saa7134 driver. It has a hardwired analog IF demod chip and no extras
for PM on the PLL chip.

It gets more interesting with tuners with some tda988x and further.

The rest is the well known history ;)

Cheers,
Hermann


> > 
> > 
> > ----------------------------------------
> > > Subject: RE: Bah! How do I change channels?
> > > From: hermann-pitton@arcor.de
> > > To: g_adams27@hotmail.com
> > > CC: dheitmueller@kernellabs.com; awalls@radix.net; video4linux-list@redhat.com; linux-media@vger.kernel.org
> > > Date: Sun, 28 Jun 2009 03:39:05 +0200
> > >
> > > Hi,
> > >
> > > Am Samstag, den 27.06.2009, 00:25 -0400 schrieb George Adams:
> > >> Thanks again to both of you for your help. I gave the no_poweroff flag a try, but didn't see any difference. I also tried a "setchannel 3" during the middle of the encoding session, and also saw no change.
> > >
> > > hm, I'm late on the party, but for Gerd's v4lctl try to RTFM.
> > >
> > > The "setchannel" options reads from .xawtv.
> > >
> > > For me it still works, but issues with tda827x silicon tuners are known
> > > walking the ioctls.
> > >
> > > Cheers,
> > > Hermann
> > >
> > >
> > >> But I think I've found the problem:
> > >>
> > >>> v4lctl setnorm NTSC; v4lctl setfreqtab us-bcast; v4lctl -v 1 setchannel 3
> > >> vid-open: trying: v4l2-old...
> > >> vid-open: failed: v4l2-old
> > >> vid-open: trying: v4l2...
> > >> v4l2: open
> > >> v4l2: device info:
> > >> em28xx 0.1.1 / Pinnacle PCTV HD Pro Stick @ usb-0000:00:1a.7-1
> > >> vid-open: ok: v4l2
> > >> freq: reading /usr/share/xawtv/Index.map
> > >> v4l2: tuner cap:
> > >> v4l2: tuner rxs:
> > >> v4l2: tuner cur: MONO
> > >> cmd: "setchannel" "3"
> > >> v4l2: freq: 0.000
> > >> v4l2: close
> > >>
> > >>
> > >> What? freq: 0.000 ? After finding the ivtv package and compiling its utils, I confirm it with this:
> > >>
> > >>> v4l2-ctl -F
> > >> Frequency: 0 (0.000000 MHz)
> > >>
> > >>> ivtv-tune -c 3
> > >> /dev/video0: 61.250 MHz
> > >>
> > >>> v4l2-ctl -F
> > >> Frequency: 980 (61.250000 MHz)
> > >>
> > >>> v4lctl setchannel 3
> > >>
> > >>> v4l2-ctl -F
> > >> Frequency: 0 (0.000000 MHz)
> > >>
> > >>
> > >> So mysteriously, it seems like v4lctl is just plain not working. And ivtv-tune, on the other hand, is working just fine. After I do that and start Helix Producer, I see channel 3 just like I had hoped.
> > >>
> > >> (strangely, v4lctl can do other things fine, like change the norm from NTSC to PAL. It just can't change the channel.)
> > >>
> > >> So, sorry that it went off in rabbit trails of the device powering down and so forth. I wonder what happened to my v4lctl program, though? xawtv itself (running in X) seems to work fine when I tell it to change the channel...
> > >>
> > >>
> > >>
> > >>
> > >>
> > >>
> > >>> Date: Fri, 26 Jun 2009 09:42:06 -0400
> > >>> Subject: Re: Bah! How do I change channels?
> > >>> From: dheitmueller@kernellabs.com
> > >>> To: awalls@radix.net
> > >>> CC: g_adams27@hotmail.com; video4linux-list@redhat.com; linux-media@vger.kernel.org
> > >>>
> > >>> On Fri, Jun 26, 2009 at 7:50 AM, Andy Walls wrote:
> > >>>> I use either v4l2-ctl or ivtv-tune
> > >>>>
> > >>>> $ ivtv-tune -d /dev/video0 -t us-bcast -c 3
> > >>>> /dev/video0: 61.250 MHz
> > >>>>
> > >>>> $ v4l2-ctl -d /dev/video0 -f 61.250
> > >>>> Frequency set to 980 (61.250000 MHz)
> > >>>>
> > >>>>
> > >>>> Regards,
> > >>>> Andy
> > >>>
> > >>> Hello Andy,
> > >>>
> > >>> I had sent George some email off-list with basically the same
> > >>> commands. I think what might be happening here is the tuner gets
> > >>> powered down when not in use, so I think it might be powered down
> > >>> between the v4l-ctl command and the running of the other application.
> > >>>
> > >>> I have sent him a series of commands to try where he modprobes the
> > >>> xc3028 driver with "no_poweroff=1", and we will see if that starts
> > >>> working.
> > >>>
> > >>> Devin
> > >>>
> > >>> --
> > >>> Devin J. Heitmueller - Kernel Labs
> > >>> http://www.kernellabs.com
> 
> 


