Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2GKSi9V012345
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 16:28:44 -0400
Received: from mail4.sea5.speakeasy.net (mail4.sea5.speakeasy.net
	[69.17.117.6])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2GKSCOZ010820
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 16:28:12 -0400
Date: Sun, 16 Mar 2008 13:28:06 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Frej Drejhammar <frej.drejhammar@gmail.com>
In-Reply-To: <kod9eemd4.fsf@liva.fdsoft.se>
Message-ID: <Pine.LNX.4.58.0803161258550.20723@shell4.speakeasy.net>
References: <patchbomb.1205671781@liva.fdsoft.se>
	<200803161442.37610.hverkuil@xs4all.nl>
	<kod9eemd4.fsf@liva.fdsoft.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 0 of 2] cx88: Enable additional cx2388x features. Version
 2
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Sun, 16 Mar 2008, Frej Drejhammar wrote:
> Hi Hans,
>
> > 1) Should we really expose these settings to the user? I have my
> > doubts whether the average user would know what to do with this, ...

V4L2 controls aren't some menu a user must wade though when setting up
mythtv.  I don't see the harm in adding them.  There is even software for
windows that will let people mess with these things, so there is a demand.

> That was my initial take on it, therefore the first version of the
> patch just added a module parameter. I reasoned that chroma AGC was
> something you just needed to enable once depending on the quality of
> your video-source. Then Trent Piepho suggested that the functionality
> should really be exposed as controls. I think he has a point, consider
> for example living in a place such as southern Germany where you could
> receive both German PAL and French SECAM broadcasts. If you then also
> used a composite/s-video external video source you would want to be
> able to change the setting depending on your input and the channel you
> tune to.

CAGC came up before and there was a patch.  I had a patch for it, but then
Mauro changed some stuff in the driver around so my method no longer
worked.

One of the things you should do it make the control inactive when in SECAM
mode.  V4L2 has a flag to indicate controls that don't apply to the
device's current mode.

Overall, module parameters for these things is something the V4L1 bttv
driver did because controls didn't exist for V4L1.  Controls are a better
way and we shouldn't use module parameters for video decoding controls.

> > ... and I also wonder whether it makes enough of a difference in
> > picture quality.
>
> For me it does, fiddling with the saturation and hue controls I never
> managed to get neutral color reproduction. The colors were either
> washed out or saturated to look like a fifties technicolor movie. The

CAGC makes a difference for me too.  Some of my channels are over saturated
and some are under saturated and CAGC fixes them.  I don't recall if I
posted pictures last time CAGC came up, but it really does make a
difference.

> color killer does not make a very large impact for black and white
> material (the only time it is needed), frankly I'm not sure if its not
> just the placebo effect. I can live without color killer but
> definitely not without chroma AGC.

I haven't ever been able to notice an effect from color killer.  Maybe if
you had poor reception from a B&W source?  Not much black and white on
broadcast TV these days.

> > 2) Chroma AGC and color killer is also present in other chips
> > (cx2584x, cx23418, possibly other similar Conexant chips). So if we
> > decide on allowing these controls I would prefer making this a
> > standard control, rather than a private one.
>
> A quick grep shows that the bttv-driver also exposes chroma AGC as a
> private control. Cx2584x has chroma AGC enabled by default. Maybe the
> right thing to do is to enable chroma AGC by default for PAL and NTSC?
> Chroma AGC is something you'll find on most VCRs and TVs, and then it
> is on by default.

That's what I would do.  Have a standard control for CAGC and turn it on by
default.

> Personally I'm against dumbing down the driver and not exposing
> features which are useful. An argument against your stance is that the

If I wanted to be told I wasn't worthy to use my hardware, I'd run windows!

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
