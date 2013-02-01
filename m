Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36490 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757724Ab3BAWZI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Feb 2013 17:25:08 -0500
Date: Sat, 2 Feb 2013 00:25:02 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, k.debski@samsung.com,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 1/1] v4l: Document timestamp behaviour to correspond to
 reality
Message-ID: <20130201222501.GJ18639@valkosipuli.retiisi.org.uk>
References: <1359137009-23921-1-git-send-email-sakari.ailus@iki.fi>
 <201301281055.14085.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201301281055.14085.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for your comments.

On Mon, Jan 28, 2013 at 10:55:14AM +0100, Hans Verkuil wrote:
> On Fri January 25 2013 19:03:29 Sakari Ailus wrote:
> > Document that monotonic timestamps are taken after the corresponding frame
> > has been received, not when the reception has begun. This corresponds to the
> > reality of current drivers: the timestamp is naturally taken when the
> > hardware triggers an interrupt to tell the driver to handle the received
> > frame.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  Documentation/DocBook/media/v4l/io.xml |   27 ++++++++++++++-------------
> >  1 files changed, 14 insertions(+), 13 deletions(-)
> > 
> > diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> > index 2c4646d..3b8bf61 100644
> > --- a/Documentation/DocBook/media/v4l/io.xml
> > +++ b/Documentation/DocBook/media/v4l/io.xml
> > @@ -654,19 +654,20 @@ plane, are stored in struct <structname>v4l2_plane</structname> instead.
> >  In that case, struct <structname>v4l2_buffer</structname> contains an array of
> >  plane structures.</para>
> >  
> > -      <para>Nominally timestamps refer to the first data byte transmitted.
> > -In practice however the wide range of hardware covered by the V4L2 API
> > -limits timestamp accuracy. Often an interrupt routine will
> > -sample the system clock shortly after the field or frame was stored
> > -completely in memory. So applications must expect a constant
> > -difference up to one field or frame period plus a small (few scan
> > -lines) random error. The delay and error can be much
> > -larger due to compression or transmission over an external bus when
> > -the frames are not properly stamped by the sender. This is frequently
> > -the case with USB cameras. Here timestamps refer to the instant the
> > -field or frame was received by the driver, not the capture time. These
> > -devices identify by not enumerating any video standards, see <xref
> > -linkend="standard" />.</para>
> > +      <para>On timestamp types that are sampled from the system clock
> > +(V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC) it is guaranteed that the timestamp is
> > +taken after the complete frame has been received.
> 
> add: " (or transmitted for video output devices)"

Ack.

> > For other kinds of
> > +timestamps this may vary depending on the driver. In practice however the
> > +wide range of hardware covered by the V4L2 API limits timestamp accuracy.
> > +Often an interrupt routine will sample the system clock shortly after the
> > +field or frame was stored completely in memory. So applications must expect
> > +a constant difference up to one field or frame period plus a small (few scan
> > +lines) random error. The delay and error can be much larger due to
> > +compression or transmission over an external bus when the frames are not
> > +properly stamped by the sender. This is frequently the case with USB
> > +cameras. Here timestamps refer to the instant the field or frame was
> > +received by the driver, not the capture time. These devices identify by not
> > +enumerating any video standards, see <xref linkend="standard" />.</para>
> 
> I'm not sure if there is any reliable way at the moment to identify such
> devices. At least in the past (that may not be true anymore) some webcam
> drivers *did* implement S_STD.

via-camera, for instance, does. I can add removal to the patchset.

> There are also devices where one input is a webcam and another input is a
> composite (TV) input (the vino driver for old SGIs is one of those).

True. One may well connect an TV tuner to the parallel interface of the OMAP
3 ISP, and a camera sensor to the CSI-2 receiver.

> The best method I know is to check the capabilities field returned by
> ENUMINPUT for the current input and see if any of the STD/DV_TIMINGS/PRESETS
> caps are set. If not, then it is a camera. Of course, this assumes there are
> no more webcam drivers that use S_STD.

I wonder if timestamp jitter is a real issue. These devices, I presume, have
no large buffers where the data could be stored to cause jitter without
losing frames.

> I would much prefer to add a proper webcam input type to ENUMINPUT, but I'm
> afraid that would break apps.

How much jitter is enough so that we should say the timestamps are unstable?

> >  
> >        <para>Similar limitations apply to output timestamps. Typically
> >  the video hardware locks to a clock controlling the video timing, the
> > 
> 
> This paragraph on output timestamps can be deleted IMHO.

Thanks for reminding me. I think it doesn't deserve to be put into a
separate patch.

> And the paragraph after that can probably be removed completely as well
> that we no longer use gettimeofday:
> 
> "Apart of limitations of the video device and natural inaccuracies of
> all clocks, it should be noted system time itself is not perfectly stable.
> It can be affected by power saving cycles, warped to insert leap seconds,
> or even turned back or forth by the system administrator affecting long
> term measurements."
> 
> Ditto for the footnote at the end of that paragraph.
> 
> The timestamp field documentation is wrong as well for output types. No
> driver uses the timestamp field as input (i.e. delaying frames until that
> timestamp has been reached). It also says that the timestamp is the time at
> which the first data byte was sent out, that should be the last data byte.

Agreed.

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
