Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:37408 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753756Ab2KZAyH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Nov 2012 19:54:07 -0500
Subject: Re: Poor HVR 1600 Video Quality - Feedback for Devin Heitmueller
 2012-11-24
From: Andy Walls <awalls@md.metrocast.net>
To: Bob Lightfoot <boblfoot@gmail.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Date: Sun, 25 Nov 2012 19:54:03 -0500
In-Reply-To: <50B199A9.8050909@gmail.com>
References: <50B1047B.4040901@gmail.com>
	 <CAGoCfiwpj5ua79wOp8_CZfD_O9EOG7PAA4wE3L4n3-d-+FEhVg@mail.gmail.com>
	 <50B199A9.8050909@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1353891244.2496.37.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2012-11-24 at 23:08 -0500, Bob Lightfoot wrote:
> Devin :
>      Let me see if I can answer some of your questions.
> 

> 
> 2.  Links on Google to files related to this issue :
> A. The Main Can on the Tuner Card -
>        https://docs.google.com/open?id=0B95B_9punKEmeHBUNHprMnVNV00
> B. First of the Conextant Chips on Card -
>        https://docs.google.com/open?id=0B95B_9punKEmT2wwbmltSzFWb2c
> C. Second of the Conextant Chips on Card -
>        https://docs.google.com/open?id=0B95B_9punKEmNTdVMENHUFllNzA
> D. A Final ESMT Chip on Card -
>        https://docs.google.com/open?id=0B95B_9punKEmYUd5eWNrWEhudWc

Alright, this is one of the older card models.  They have been working
for quite a long while.

> E. The v4l2-ctl and cat /dev/video2 file made from Svideo1
>        https://docs.google.com/open?id=0B95B_9punKEmUGdJNTI3ZnR2T1k

Looks good.

> F. The v4l2-ctl and cat /dev/video2 file made from Tuner1
>        https://docs.google.com/open?id=0B95B_9punKEmOUhLWjNyRG02NDA

Blech.  Obviously an almost total loss of Horizontal Synchronization.
Vertical Synchronization appears to be OK, under the circumstances. 

FYI,  I normally associate the following conditions with signal level
going into the CX23418's integrated CX25843 A/V decoder:

- Good sound, bad video:     signal strength too low
- Bad/no sound, good video:  signal strength too high

Low video signal strength could explain why H-sync is lost.  However, it
also could be a DC voltage level building up on the CVBS signal trace
between the tuner and the CX23418 causing the CVBS signal (and the
H-sync pulse) to be floated upwards, such that the H-Sync pulse ins't
detected.

So here's what you need to do:

1. provide the output of v4l2-ctl -d /dev/video2 --log-status, so I can
see the analog tuner assembly that your unit has.

2. Test the unit under the previous Linux kernel version with which you
were *sure* the unit worked properly.  Or test with Windows as Devin
suggested.  We're trying to eliminate a bad HVR-1600 card here, so if
you can test it in that very same machine, all the better.

Also, if you can provide us with the two kernel versions, working and
non-working, we can narrow down if a kernel change caused the problem
for you.

3. Test with as few cards in the PC chassis as possible.  This will
eliminate some EMI and power supply problems.  It's a shot in the dark,
but easy enough for you to try.

4. If you do decide to much around in the PC, pull out all the PCI
cards, blow the dust out of all the slots, reseat the cards, and retest.
I am amazed at how often that actually helps with various problems.



I would point you to an email where I added all sorts of extra controls
to the cx18 driver in a patchset, for the express purpose of debugging
sync problems:

http://www.gossamer-threads.com/lists/ivtv/users/40227?do=post_view_threaded#40227

and ask you to fiddle around with them.

Unfortunately the patches, which are still here:

http://linuxtv.org/hg/~awalls/v4l-dvb-ctls/

are very old and don't apply cleanly to newer versions of the cx18
driver. :(


My suspicion is either 

a. you have a marginal CX23418 chip and something on you card or in your
chassis is allowing a DC charge to build up on the CVBS line between the
tuner and the CX23418

or

b. a recent kernel change broke the ananlog tuner configuration for the
tuner on your board.


> 3.  I tested with both the SVideo and Coax Inputs for Analog.  As
> you'll see from the 10 second videos the SVideo works fine but the
> Coax Tuner is a problem.
> 
> 4.  I don't know if I am capturing raw for MPEG compressed for certain
> but I'll go over the test method used to make to two videos and that
> should also answer this question.

It doesn't matter.  It looks like MPEG and not raw YUV, BTW.


> 5. As far as test tools I have used v4l2-ctl, mplayer, vlc and cat
> commands for testing.
> 
> 6.  Commands issued in order were as follows for the SVideo Capture:
>     A. v4l2-ctl --list-devices
>     B. v4l2-ctl -d /dev/video2 --list-inputs
>     C. v4l2-ctl -d /dev/video2 --set-input=1  {Note this is SVideo1}
>     D. v4l2-ctl -d /dev/video2 --list-standards | less
>     E. v4l2-ctl -d /dev/video2 --set-standard=1  {Note this is NTSC}
>     F. mplayer /dev/video2 -cache 8192
>     G. close mplayer after successfully watching video
>     H. cat /dev/video2 > hvr1600-svideo1.mpg
> 
> 7.  Commands issued in order were as follows for the Tuner1 Capture:
>     A. v4l2-ctl --list-devices
>     B. v4l2-ctl -d /dev/video2 --list-inputs
>     C. v4l2-ctl -d /dev/video2 --set-input=0 {Note this is Tuner1}
>     D. v4l2-ctl -d /dev/video2 --list-standards | less
>     E. v4l2-ctl -d /dev/video2 --set-standard=1  {Note this is NTSC}
>     F. v4l2-ctl -d /dev/video2 -f 67.250  {Note this is us-bdcst chan 4}
>     G. mplayer /dev/video2 -cache 8192
>     H. close mplayer after successfully watching video
>     I. cat /dev/video2 > hvr1600-Tuner1.mpg
> 
> 8.  It should be obvious by this point, but I am too much of a
> neophyte to be compiling kernels.  I am running Centos 6 and yum for
> updates for anything I have applied has come through their packaging
> and distribution system.

Centos and other enterprise distros and clone usually run pretty old
kernels.  You may be running into a bug which was found and fixed years
ago.

Have you tried with a modern LiveCD of Fedora or Ubuntu or Knoppix or
something?  (I don't know which one has HVR-1600 support built into a
live CD.)

Regards,
Andy

> NOTES : This SVideo looks good but the Tuner1 is garbage.  I also
> tested the coax input thru my HVR-1850 using xawtv and while it had no
> audio the video was good although slightly greenish.  So I don't
> suspect the coax cable, especially since when connected to a standard
> TV it produces a good picture.
> 
> Hope you can shed an idea or three.
> 
> My end goal it to again record analog video in MythTV.
> 
> Sincerely,
> Bob Lightfoot

