Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3761 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab2B1MmS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Feb 2012 07:42:18 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFCv1 PATCH 0/6] Improved/New timings API
Date: Tue, 28 Feb 2012 13:42:13 +0100
Cc: linux-media@vger.kernel.org
References: <1328263566-21620-1-git-send-email-hverkuil@xs4all.nl> <201202241054.46924.hverkuil@xs4all.nl> <4F4CB6C4.2070008@redhat.com>
In-Reply-To: <4F4CB6C4.2070008@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201202281342.13066.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, February 28, 2012 12:13:08 Mauro Carvalho Chehab wrote:
> Em 24-02-2012 07:54, Hans Verkuil escreveu:
> > On Friday, February 03, 2012 11:06:00 Hans Verkuil wrote:
> >> Hi all,
> >>
> >> This is an implementation of this RFC:
> >>
> >> http://www.mail-archive.com/linux-media@vger.kernel.org/msg38168.html
> > 
> > Mauro,
> > 
> > I'd greatly appreciate it if you can review this API.
> 
> API Reviewed.
> 
> > I've verified that it works well with CVT and GTF timings (the code for that
> > is in the test-timings branch in the git repo below).
> > 
> > One thing that might change slightly is the description of this flag:
> > 
> >            <entry>V4L2_DV_FL_DIVIDE_CLOCK_BY_1_001</entry>
> >            <entry>CEA-861 specific: only valid for video transmitters, the flag is cleared
> >   by receivers. It is also only valid for formats with the V4L2_DV_FL_NTSC_COMPATIBLE flag
> >   set, for other formats the flag will be cleared by the driver.
> > 
> >   If the application sets this flag, then the pixelclock used to set up the transmitter is
> >   divided by 1.001 to make it compatible with NTSC framerates. If the transmitter
> >   can't generate such frequencies, then the flag will also be cleared.
> >            </entry>
> > 
> > Currently it is only valid for transmitters, but I've seen newer receivers
> > that should be able to detect this small difference in pixelclock frequency.
> 
> A 1000/1001 time shift is generally detected well by the receiver, as the PLL's
> are generally able to lock. However, depending on how this frequency is used
> internally at the receiver, it can cause a miss-sample at chroma, causing a
> weird effect: the vertical borders have the color shifting between to values. 
> This is noticed mostly on high-contrast borders.

I think you are talking about SDTV receivers (i.e. saa7115-type receivers).
It's a different story for HDMI/DisplayPort/DVI-D/etc. type receivers. There
the pixelclock is coming from the transmitter, so it is all digital.

In those cases the determination of whether the framerate is 60 Hz or 59.94 Hz
has to be based on the detected pixelclock frequency. At least for the several
receivers I have experience with the frequency precision is quite coarse
(around .25 MHz), which is insufficient to see the difference between 148.5 MHz
for 60 Hz full HD and 148.35 MHz for 59.94 full HD.

Newer receivers have better precision, but it is still a hint at best.

> > I haven't tested (yet) whether they can actually do this, and it would have
> > to be considered a hint only since this minute pixelclock difference falls
> > within the CEA861-defined pixelclock variation. But if they can do this, then
> > that would be a really nice feature.
> 
> You'll likely be able to notice if they're actually detecting, if you display a
> standard color bar and look at the borders, and see if the colors are steady
> at the borders.

True for analog inputs, but not for digital inputs like HDMI etc.

It's actually an interesting experiment to see what happens when I try to
feed 59.94 Hz 1080p video over an analog component input. Something to try
next week. I don't think this changes anything regarding this API, but it is
useful to know how this is handled.

Thanks for your review, I'll take care of your comments and start working on
a final version.

Regards,

	Hans
