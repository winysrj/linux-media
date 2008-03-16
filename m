Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2GFAabj021003
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 11:10:36 -0400
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.189])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2GFA4qK032569
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 11:10:05 -0400
Received: by nf-out-0910.google.com with SMTP id g13so1796043nfb.21
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 08:10:04 -0700 (PDT)
To: Hans Verkuil <hverkuil@xs4all.nl>
From: Frej Drejhammar <frej.drejhammar@gmail.com>
In-Reply-To: <200803161442.37610.hverkuil@xs4all.nl> (Hans Verkuil's message
	of "Sun, 16 Mar 2008 14:42:37 +0100")
References: <patchbomb.1205671781@liva.fdsoft.se>
	<200803161442.37610.hverkuil@xs4all.nl>
Date: Sun, 16 Mar 2008 16:09:59 +0100
Message-ID: <kod9eemd4.fsf@liva.fdsoft.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com, Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH 0 of 2] cx88: Enable additional cx2388x features.
	Version 2
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

Hi Hans,

> 1) Should we really expose these settings to the user? I have my
> doubts whether the average user would know what to do with this, ...

That was my initial take on it, therefore the first version of the
patch just added a module parameter. I reasoned that chroma AGC was
something you just needed to enable once depending on the quality of
your video-source. Then Trent Piepho suggested that the functionality
should really be exposed as controls. I think he has a point, consider
for example living in a place such as southern Germany where you could
receive both German PAL and French SECAM broadcasts. If you then also
used a composite/s-video external video source you would want to be
able to change the setting depending on your input and the channel you
tune to.

> ... and I also wonder whether it makes enough of a difference in
> picture quality.

For me it does, fiddling with the saturation and hue controls I never
managed to get neutral color reproduction. The colors were either
washed out or saturated to look like a fifties technicolor movie. The
color killer does not make a very large impact for black and white
material (the only time it is needed), frankly I'm not sure if its not
just the placebo effect. I can live without color killer but
definitely not without chroma AGC.

> Note that a change like 'Chroma AGC must be disabled if SECAM is
> used' is a bug fix and should clearly go in.

But rather pointless as it currently cannot be enabled...

> 2) Chroma AGC and color killer is also present in other chips
> (cx2584x, cx23418, possibly other similar Conexant chips). So if we
> decide on allowing these controls I would prefer making this a
> standard control, rather than a private one.

A quick grep shows that the bttv-driver also exposes chroma AGC as a
private control. Cx2584x has chroma AGC enabled by default. Maybe the
right thing to do is to enable chroma AGC by default for PAL and NTSC?
Chroma AGC is something you'll find on most VCRs and TVs, and then it
is on by default.

> Personally I think these controls are too low-level, but that's just
> my opinion. Most chips contains a whole array of similar tweaks that
> you can do, and exposing them all is not the way to go.

Personally I'm against dumbing down the driver and not exposing
features which are useful. An argument against your stance is that the
V4L2-spec defines V4L2_CID_AUTOGAIN, V4L2_CID_AUTO_WHITE_BALANCE and
V4L2_CID_HUE_AUTO (half of the functionality of chroma AGC) which are
similar functions. Also consider the MPEG controls, most of which are
fairly obscure if you are not familiar with the MPEG specs.

Regards,

--Frej

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
