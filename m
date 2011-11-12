Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms16-1.1blu.de ([89.202.0.34]:50037 "EHLO ms16-1.1blu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308Ab1KLNPF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 08:15:05 -0500
Received: from [79.254.110.251] (helo=hana.gusto)
	by ms16-1.1blu.de with esmtpsa (TLS-1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.69)
	(envelope-from <gusto@guttok.net>)
	id 1RPDQD-0007UZ-GP
	for linux-media@vger.kernel.org; Sat, 12 Nov 2011 14:15:02 +0100
Date: Sat, 12 Nov 2011 14:14:03 +0100
From: Lars Schotte <gusto@guttok.net>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: HVR-4000 may be broken in kernel mods (again) ?
Message-ID: <20111112141403.53708f28@hana.gusto>
In-Reply-To: <CAGoCfiw+yy3Hz=7yvGTYrYQn5VfNh3CrabS_Kxx7G88jcwt9aQ@mail.gmail.com>
References: <CAA7M+FBvP0A7L6o-Fw4CQ2xR2CYqu233L+83BGGOcLooK0bk7w@mail.gmail.com>
	<CAGoCfiw+yy3Hz=7yvGTYrYQn5VfNh3CrabS_Kxx7G88jcwt9aQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

i also have hvr-4000 but havent tried it on recent kernels yet.

i get no lock problems only with dvb-s2 but that is a hardware
limitation, that it is not able to get right parameters. i dont know if
they did something with it. would be about time however.

i am alos curious what he means by "try to use it". i mean did he try
to use it with tzap, or szap, or w_scan, or what? because i dont even
know about mythtv, i only use dvbutils, mplayer, xine and vdr.

On Sat, 12 Nov 2011 07:55:37 -0500
Devin Heitmueller <dheitmueller@kernellabs.com> wrote:

> On Sat, Nov 12, 2011 at 5:33 AM, jonathanjstevens@gmail.com
> <jonathanjstevens@gmail.com> wrote:
> > Description of problem:
> > Support for Hauupauge HVR-4000 appears to be broken (again) in
> > kernel mods. This is a bit of a tale of woe, but this hardware is
> > supposed to have been sorted in stock kernel roundabout 3.0.
> > Stock F16 kernel cannot scan or tune in mythtv, kaffeine, w_scan,
> > or dvbscan. Compiled/Installed latest video-media build still no
> > joy. I used another USB DVB (nova-t) to scan, and using the results
> > obtained from w_scan on this managed to get tzap to FE LOCK.
> > However this only worked with tzap - no other app can get a lock.
> > Have tested with i2c reset patch enabled and not, and also with
> > strobing patch enabled and not (cs88-dvb.c). Also with mythtv
> > kludge (delaying on FE close in dvbutils.cpp). All make no
> > difference. So sad :(
> >
> > Version-Release number of selected component (if applicable):
> > Linux mythtvtuner.home 3.1.0-7.fc16.x86_64 #1 SMP Tue Nov 1
> > 21:10:48 UTC 2011 x86_64 x86_64 x86_64 GNU/Linux
> >
> > How reproducible:
> > Install F16 and try to make use of HVR-4000.
> >
> > Steps to Reproduce:
> > 1. Install F16 on a machine with HVR-4000
> > 2. Try to use it
> > 3. Cry
> > Actual results:
> > Can't scan or tune.
> > Expected results:
> > Can scan and tune and be happy.
> > Additional info:
> > Should mention this machine is also running Xen.
> > If necessary I have a spare machine I can put a HVR-4000 into and
> > can compile whatever you want to try to fix this. Pretty sure this
> > is a problem upstream in video-media, but will report here to try
> > and get some help! Willing to put in the hours this side to get to
> > the bottom of this, sorry I don't have the programming skills to
> > attack it myself. All the problems historically that the HVR-4000
> > has had in v4l were supposed to be fixed in 3.0...
> > Let me know what additional info you might want?
> > Jonathan
> 
> Hi Jonathan,
> 
> It was actually broken for months (including 3.0), and not fixed
> until 3.1.
> 
> I'm assuming you're having problems with dvb-s and dvb-t?  Please
> clarify exactly which standards aren't working for you?
> 
> Also, take Xen out of the picture.  Validate it isn't working in a
> regular system.  Virtualization is definitely a source of problems and
> should be ruled out.
> 
> Any suspicious output in dmesg?
> 
> Devin
> 



-- 
Lars Schotte
@ Hana (F16)
