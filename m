Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:16808 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbZFUOUI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Jun 2009 10:20:08 -0400
Received: by yw-out-2324.google.com with SMTP id 5so1574015ywb.1
        for <linux-media@vger.kernel.org>; Sun, 21 Jun 2009 07:20:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090621134901.0AB9CBE407E@ws1-9.us4.outblaze.com>
References: <20090621134901.0AB9CBE407E@ws1-9.us4.outblaze.com>
Date: Sun, 21 Jun 2009 10:20:09 -0400
Message-ID: <829197380906210720x41ee05b5n6754ebc8223b13cb@mail.gmail.com>
Subject: Re: [linux-dvb] Can't use my Pinnacle HDTV USB stick
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 21, 2009 at 9:49 AM, Paul Guzowski<guzowskip@linuxmail.org> wrote:
> George,
>
> I can appreciate your frustration because I went through the same struggle a
> while back.  Fortunately, persistence and a lot  of help from the great
> people on this forum helped me finally solve the problems I was having.  I
> have had enough time to study your message line by line and compare it with
> my own but will offer a few words on what I did.
>
> I am using the same stick to capture cable channel three from my cable
> set-top box.  I had a lot of struggles in the process of getting it to work
> beginning with Ubuntu 8.04 but it has worked flawlessly through all the
> upgrades to Ubuntu 9.04.  I do know there were and maybe still are two
> different sets of firmware for the 800e and I had both or parts of both
> installed at the same time and that was causing a problem.
>
> Once I got the hardware, firmware, and drivers sorted out,  I think I tried
> just about every video/tv software program available for linux and couldn't
> get any of the full-featured ones with GUIs to work though I admit I didn't
> try very hard with MythTV.   When I tried to scan for a signal either from
> the basic cable coming out of the wall or from the RF-out on the back of my
> set-top box, I could not get anything with any of the pre-built frequency
> scanning tables and I never succeeded to find a channel configuration file
> for my cable company's (Brighthouse Networks, panhandle of Florida) signal.
>
> I finally found a reference somewhere to using mplayer from the command line
> and feeding it several specific arguments.  Once I got it to work, I put the
> following in a launcher for easy activation:
>
> mplayer -vo xv tv:// -tv
> driver=v4l2:alsa:immediatemode=0:adevice=hw.1,0:norm=ntsc:chanlist=us-cable:channel=3
>
> Admittedly, all this does is put whatever is selected on my cable box in a
> window with sound on my desktop.  The only thing I can do is resize the
> window or turn it off but I can control the volume or change the channel
> with the cable box remote so it does the basics I need.  I haven't tried the
> fancy programs since upgrading to 9.04 nor have I tried mencoder but I would
> like to eventually be able to record the signal for delayed viewing (i.e.
> use my computer as a PVR).
>
> Hope this helps.
>
> Paul in NW Florida

Hello Paul,

The bulk of the problems you had are usability issues with userland
applications rather than issues with the drivers themselves.  When it
comes to Linux TV applications, the US is much worse off in terms of
digital support than Europe and other parts of the world.  Much of
this is a result of the fact that so much of this country uses cable
rather than terrestrial broadcasting, combined with the significantly
worse situation with regards to the DRM found in US digital cable
systems which effectively prevents people from accessing digital cable
on a PC.

I can count the list of developers on one hand who work on US based
ATSC and QAM drivers.  Even fewer actively contribute to application
support for these standards.  The documentation is lousy, and those
who go through the trouble to figure out how to get their stuff to
work do not contribute back the information into the wiki.

There are just too many devices out there, too many applications out
there, and two few developers willing to dedicate the time and energy
to do the work.  The fact that there is also no way for developers to
even recover their costs just further discourages doing new work (a
challenge I've had given I've now spent hundreds of dollars on devices
and tools and that money is long gone)...

I'll get off my soapbox now.  :-)

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
