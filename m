Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:42084 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755319Ab3JMXlf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Oct 2013 19:41:35 -0400
Message-ID: <1381707800.1875.63.camel@palomino.walls.org>
Subject: Re: ivtv 1.4.2/1.4.3 broken in recent kernels?
From: Andy Walls <awalls@md.metrocast.net>
To: Rajil Saraswat <rajil.s@gmail.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 13 Oct 2013 19:43:20 -0400
In-Reply-To: <CAFoaQoAaGhDycKfGhD2m-OSsbhxtxjbbWfj5uidJ0zMpEWQNtw@mail.gmail.com>
References: <CAFoaQoAK85BVE=eJG+JPrUT5wffnx4hD2N_xeG6cGbs-Vw6xOg@mail.gmail.com>
	 <1381371651.1889.21.camel@palomino.walls.org>
	 <CAFoaQoBiLUK=XeuW31RcSeaGaX3VB6LmAYdT9BoLsz9wxReYHQ@mail.gmail.com>
	 <1381620192.22245.18.camel@palomino.walls.org>
	 <1381668541.2209.14.camel@palomino.walls.org>
	 <CAFoaQoAaGhDycKfGhD2m-OSsbhxtxjbbWfj5uidJ0zMpEWQNtw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2013-10-13 at 20:14 +0100, Rajil Saraswat wrote:
> > OK, I just tested with my Wii game console connected to the PVR-500 unit
> > #2, Fedora 17, kernel 3.6.10-2.fc17.x86_64.
> >
> > 1. With the unit set to 'Input 2, Composite 1', cx25840 'Composite 3':
> > Good video, good audio
> >
> > 2. With the unit set to 'Input 4, Composite 2', cx25840 'Composite 4':
> > No video, distorted audio.
> >
> 
> This is what i used to changed the input
> 
> v4l2-ctl -d /dev/video1 --set-input 4
> 
> With this 2.6.35 gives me perfect video/audio. Kernel 3.10.7 on the
> other hand gives good video but distorted audio. On this cards primary
> input (/dev/video0), i use the radio so i cant use input 2 of this
> card. My composite cable is connected to the 'extra-input' card which
> should be composite 2.
> 
> My understanding is input 4 is #2 composite, and input 2 is #1
> composite. Is that not right?

For my PVR-500, it doesn't appear to be.  Here's how I believ it is
wired up:

PVR-500 Left/First half (aka Unit #1)
Tuner TV Composite out          ---> CX25843 Analog Input 7    --+ 
SVideo 1    (rear bracket)      ---> CX25843 Analog Inputs 1,5 --+
Composite 1 (rear bracket)      ---> CX25843 Analog Input 3    --+-- CX25843 VIP out --> CX23416 VIP In
SVideo 2    (white connector)   ---> CX25843 Analog Inputs 2,6 --+
Composite 2 (white connector)   ---> CX25843 Analog Input 4    --+

Tuner SIF audio out           ---> CX25843 Analog Input 8    --------------------------------+  
                                                                                             |  
Tuner TV mono-audio out       ---> WM8775 AIN1 L,R --+                                       |  
Audio 1 L,R (rear bracket)    ---> WM8775 AIN2 L,R --+- WM8775 I2S out --> CX25843 I2S 1 In -+-> CX25843 I2S out --> CX23416 I2S In
Audio 2 L,R (white connector) ---> WM8775 AIN3 L,R --+
Tuner FM audio out L,R        ---> WM8775 AIN4 L,R --+


PVR-500 Right/Second half (aka Unit #2)
Tuner TV Composite out          ---> CX25843 Analog Input 7    --+ 
SVideo 1    (white connector)   ---> CX25843 Analog Inputs 1,5 --+
Composite 1 (white connector)   ---> CX25843 Analog Input 3    --+-- CX25843 VIP out --> CX23416 VIP In

Tuner SIF audio out           ---> CX25843 Analog Input 8    --------------------------------+  
                                                                                             |  
Tuner TV mono-audio out       ---> WM8775 AIN1 L,R --+                                       |  
Audio 1 L,R (white connector) ---> WM8775 AIN2 L,R --+- WM8775 I2S out --> CX25843 I2S 1 In -+-> CX25843 I2S out --> CX23416 I2S In

So for my PVR-500,
unit #1 Composite 1 is on the card's bracket.
unit #1 Composite 2 is on the white connector.
unit #2 Composite 1 is on the white connector.
unit #2 Composite 2 is not available


> This is what i tried in kernel 2.6.35:
> 
> 1. v4l2-ctl -d /dev/video1 --set-input 2
> Video input set to 2 (Composite 1: ok)
> No video
> 
> 2. v4l2-ctl -d /dev/video1 --set-input 4
> Video input set to 4 (Composite 2: ok)
> Good video

If /dev/video1 referes to unit #2 of your PVR-500 (according to v4l2-ctl
-d /dev/video1 --log-status) then it appears your unit is wired
differently than mine.


> As i mentioned in kernel 2.6.35, mythtv/mplayer give me both good
> video/audio if i use 2 above.

$ git diff --color v2.6.35 v2.6.37 drivers/media/video/wm8775.c

Shows me no really good reason why the wm8775 driver should have broken.

$ git diff --color v2.6.35 v2.6.37 drivers/media/video/cx25840/*[ch]

Show a few conceptually simple changes to the cx25840 driver.  Something
may have broken, but I doubt it.

$ git diff --color v2.6.35 v2.6.37 drivers/media/video/cx2341x.c

Shows changes to the control handling.  The ones regarding audio
sampling frequency may be at fault.

$ git diff --color v2.6.35 v2.6.37 drivers/media/video/ivtv/ivtv*[ch]

Shows changes to the irq handling and the control handling.  Again the
controls realted to audio mode and audio sampling rate stand out as
potential causes.

None of the above changes would explain to me why audio on input 3 of
the WM8775 works (for me) but audio on input 4 of the WM8775 does not
work (for you).

I'll have to try additional tests with unit #1 of my PVR-500 later this
week.

> > AFAICT:
> > You're using the wrong input.
> > You weren't checking the video, only the audio.
> 
> What inputs do you think i should use with v4l2-ctl?

I have no recommendation at the moment.

If you can do a git bisect please try.
There are 11,117 commits to bisect: that's 15 steps.  Each
bisect/compile/install/test iteration I would estimate takes about 2
hours.

If I can reproduce your problem on a PVR-150 or on unit #1 of my
PVR-500, then I can try to bisect.  But I have no idea when I would have
time to perform the bisection.


> >> > Unfortunately, i cannot do a git bisect since it is a remote system
> >> > with a slow internet connection.
> >
> > Is this system for personal or professional use?  I don't know of any
> > home users who have remote sites.
> 
> Your know one user now!. Yes it is for personal use. It was for my old
> folks who live in another country and i manage their mythtv/htpc
> remotely.

Ah.

-Regards,
Andy

> -Rajil


