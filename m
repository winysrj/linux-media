Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:44677 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbZC3Pfz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 11:35:55 -0400
Date: Mon, 30 Mar 2009 08:35:53 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] v4l2-ioctl: Check format for
 S_PARM and G_PARM
In-Reply-To: <200903291331.30045.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.58.0903300814180.28292@shell2.speakeasy.net>
References: <E1LnqiQ-00077f-80@mail.linuxtv.org> <200903291242.36594.hverkuil@xs4all.nl>
 <Pine.LNX.4.58.0903290352480.28292@shell2.speakeasy.net>
 <200903291331.30045.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 29 Mar 2009, Hans Verkuil wrote:
> On Sunday 29 March 2009 13:03:13 Trent Piepho wrote:
> > How does overlay depend on video capture in any way?  It's perfectly
> > reasonable for a driver to support _only_ overlay and not video capture.
> > The zr36067 chip is only designed to support uncompressed data for video
> > overlay for example.  Allowing uncompressed video capture is a hack that
> > the driver didn't have at one point.
>
> Ah. Live and learn. In that case the spec is out of date and needs to be
> updated.

Do you mean there is something in the spec that makes overlay depend on
video capture?  Or that s/g_parm don't mention buffer types other than
video capture and video output?

> > > No, I agree with the spec in that I see no use case for it. Should
> > > there be one, then I'd like to see that in an actual driver
> > > implementation and in that case the spec should be adjusted as well.
> >
> > How about getting the frame rate of video overlay?  Works with bttv.
>
> Hmm, I grepped only on s_parm, not on g_parm.

It would be nice to use s_parm with drivers like bttv to reduce the frame
rate.  With multi-chip capture cards running out of bus bandwidth is a big
problem.  Reducing the frame rate is one way to deal with it.  The bt8x8
and cx2388x chips do have a temporal decimation feature and I've tried to
add support for it but I never got it to work correctly.

> > > In addition, g/s_parm is only used in combination with webcams/sensors
> > > for which overlays and vbi are irrelevant.
> >
> > There are several drivers for non-webcams, like bttv, saa7134, and
> > saa7146, that support g_parm.  Why is returning the frame rate for video
> > capture not valid?  Why does the number of buffers used for read() mode
> > only make sense for webcams?
>
> OK, I'd forgot to check for the usage of g_parm. My bad.

There is also a default g_parm handler in video_ioctl2 that might be used
if the driver doesn't provide one.  I don't know what drivers actually use
it.

> > > > Thinking about it now, I think what makes the most sense is to use
> > > > "capture" for VIDEO_OVERLAY, VBI_CAPTURE, and SLICED_VBI_CAPTURE.
> > > > And use "output" for VBI_OUTPUT, SLICED_VBI_OUTPUT and
> > > > VIDEO_OUTPUT_OVERLAY.
>
> You're absolutely correct. I was too hasty.
>
> Can you update the spec to reflect this?

I'll try, but I hear the doc build system is quite a challenge.

> > > > > I also wonder whether check_fmt shouldn't check for the presence of
> > > > > the s_fmt callbacks instead of try_fmt since try_fmt is an optional
> > > > > ioctl.
> > > >
> > > > I noticed that too.  saa7146 doesn't have a try_fmt call for
> > > > vbi_capture but is apparently supposed to support it.  I sent a
> > > > message about that earlier.
> > >
> > > I saw that. So why not check for s_fmt instead of try_fmt? That would
> > > solve this potential problem.
> >
> > Because that's clearly a change that belongs in another patch.
>
> OK, great.

My patch just called check_fmt() for s/g_parm.  I haven't touched
check_fmt().  But you're right that try_fmt is optional so it makes a bad
test.

Maybe it should use g_fmt?  saa7146 doesn't provide a s_fmt call either for
vbi capture, only g_fmt.  Though maybe this is a bug in saa7146?  It seems
like any driver that provides g_fmt can always just use that same method
for s_fmt as well and be correct.
