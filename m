Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43050 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab3A1XlR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 18:41:17 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	k.debski@samsung.com
Subject: Re: [PATCH 1/1] v4l: Document timestamp behaviour to correspond to reality
Date: Tue, 29 Jan 2013 00:41:19 +0100
Message-ID: <1526397.gXtUumoOUz@avalon>
In-Reply-To: <20130128230220.GI18639@valkosipuli.retiisi.org.uk>
References: <1359137009-23921-1-git-send-email-sakari.ailus@iki.fi> <3003277.ZHAgxXzzuq@avalon> <20130128230220.GI18639@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday 29 January 2013 01:02:20 Sakari Ailus wrote:
> On Mon, Jan 28, 2013 at 08:56:21PM +0100, Laurent Pinchart wrote:
> > On Monday 28 January 2013 10:55:14 Hans Verkuil wrote:
> > > On Fri January 25 2013 19:03:29 Sakari Ailus wrote:
> > > > Document that monotonic timestamps are taken after the corresponding
> > > > frame has been received, not when the reception has begun. This
> > > > corresponds to the reality of current drivers: the timestamp is
> > > > naturally taken when the hardware triggers an interrupt to tell the
> > > > driver to handle the received frame.
> > > > 
> > > > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > > > ---
> > > > 
> > > >  Documentation/DocBook/media/v4l/io.xml |   27
> > > >  ++++++++++++++-------------
> > > >  1 files changed, 14 insertions(+), 13 deletions(-)
> > > > 
> > > > diff --git a/Documentation/DocBook/media/v4l/io.xml
> > > > b/Documentation/DocBook/media/v4l/io.xml index 2c4646d..3b8bf61 100644
> > > > --- a/Documentation/DocBook/media/v4l/io.xml
> > > > +++ b/Documentation/DocBook/media/v4l/io.xml
> > > > @@ -654,19 +654,20 @@ plane, are stored in struct
> > > > <structname>v4l2_plane</structname> instead.>
> > > > 
> > > >  In that case, struct <structname>v4l2_buffer</structname> contains an
> > > >  array of plane structures.</para>
> > > > 
> > > > -      <para>Nominally timestamps refer to the first data byte
> > > > transmitted.
> > > > -In practice however the wide range of hardware covered by the V4L2
> > > > API
> > > > -limits timestamp accuracy. Often an interrupt routine will
> > > > -sample the system clock shortly after the field or frame was stored
> > > > -completely in memory. So applications must expect a constant
> > > > -difference up to one field or frame period plus a small (few scan
> > > > -lines) random error. The delay and error can be much
> > > > -larger due to compression or transmission over an external bus when
> > > > -the frames are not properly stamped by the sender. This is frequently
> > > > -the case with USB cameras. Here timestamps refer to the instant the
> > > > -field or frame was received by the driver, not the capture time.
> > > > These
> > > > -devices identify by not enumerating any video standards, see <xref
> > > > -linkend="standard" />.</para>
> > > > +      <para>On timestamp types that are sampled from the system clock
> > > > +(V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC) it is guaranteed that the
> > > > timestamp
> > > > +is taken after the complete frame has been received.
> > > 
> > > add: " (or transmitted for video output devices)"
> > 
> > The uvcvideo driver currently uses monotonic timestamps corresponding to
> > the start of the frame :-)
> 
> Ah, I had almost forgotten this! :-) What would you think about changing it?
> :-) I guess uvc is a little special since it receives packets, not frames.

The driver used to timestamp frames when it received the last packet. It now 
uses the hardware timestamps, sampled by the device when the frame is 
captured, and translates it to the monotonic clock.

The translation should ideally be performed in userspace, with the driver 
exporting hardware timestamps, but until this gets implemented I don't want to 
remove support for translating the hardware timestamps from the driver.

-- 
Regards,

Laurent Pinchart

