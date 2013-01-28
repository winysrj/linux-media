Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46130 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750978Ab3A1XCZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 18:02:25 -0500
Date: Tue, 29 Jan 2013 01:02:20 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	k.debski@samsung.com
Subject: Re: [PATCH 1/1] v4l: Document timestamp behaviour to correspond to
 reality
Message-ID: <20130128230220.GI18639@valkosipuli.retiisi.org.uk>
References: <1359137009-23921-1-git-send-email-sakari.ailus@iki.fi>
 <201301281055.14085.hverkuil@xs4all.nl>
 <3003277.ZHAgxXzzuq@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3003277.ZHAgxXzzuq@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, Jan 28, 2013 at 08:56:21PM +0100, Laurent Pinchart wrote:
> On Monday 28 January 2013 10:55:14 Hans Verkuil wrote:
> > On Fri January 25 2013 19:03:29 Sakari Ailus wrote:
> > > Document that monotonic timestamps are taken after the corresponding frame
> > > has been received, not when the reception has begun. This corresponds to
> > > the reality of current drivers: the timestamp is naturally taken when the
> > > hardware triggers an interrupt to tell the driver to handle the received
> > > frame.
> > > 
> > > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > > ---
> > > 
> > >  Documentation/DocBook/media/v4l/io.xml |   27 ++++++++++++++-------------
> > >  1 files changed, 14 insertions(+), 13 deletions(-)
> > > 
> > > diff --git a/Documentation/DocBook/media/v4l/io.xml
> > > b/Documentation/DocBook/media/v4l/io.xml index 2c4646d..3b8bf61 100644
> > > --- a/Documentation/DocBook/media/v4l/io.xml
> > > +++ b/Documentation/DocBook/media/v4l/io.xml
> > > @@ -654,19 +654,20 @@ plane, are stored in struct
> > > <structname>v4l2_plane</structname> instead.> 
> > >  In that case, struct <structname>v4l2_buffer</structname> contains an
> > >  array of plane structures.</para>
> > > 
> > > -      <para>Nominally timestamps refer to the first data byte
> > > transmitted.
> > > -In practice however the wide range of hardware covered by the V4L2 API
> > > -limits timestamp accuracy. Often an interrupt routine will
> > > -sample the system clock shortly after the field or frame was stored
> > > -completely in memory. So applications must expect a constant
> > > -difference up to one field or frame period plus a small (few scan
> > > -lines) random error. The delay and error can be much
> > > -larger due to compression or transmission over an external bus when
> > > -the frames are not properly stamped by the sender. This is frequently
> > > -the case with USB cameras. Here timestamps refer to the instant the
> > > -field or frame was received by the driver, not the capture time. These
> > > -devices identify by not enumerating any video standards, see <xref
> > > -linkend="standard" />.</para>
> > > +      <para>On timestamp types that are sampled from the system clock
> > > +(V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC) it is guaranteed that the timestamp
> > > +is taken after the complete frame has been received.
> > 
> > add: " (or transmitted for video output devices)"
> 
> The uvcvideo driver currently uses monotonic timestamps corresponding to the 
> start of the frame :-)

Ah, I had almost forgotten this! :-) What would you think about changing it?
:-) I guess uvc is a little special since it receives packets, not frames.

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
