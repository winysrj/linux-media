Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58560 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbaBQAzB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Feb 2014 19:55:01 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	k.debski@samsung.com
Subject: Re: [PATCH v5 7/7] v4l: Document timestamp buffer flag behaviour
Date: Mon, 17 Feb 2014 01:56:08 +0100
Message-ID: <1640658.PZi431b47s@avalon>
In-Reply-To: <52FFD60B.4080308@xs4all.nl>
References: <1392497585-5084-1-git-send-email-sakari.ailus@iki.fi> <1392497585-5084-8-git-send-email-sakari.ailus@iki.fi> <52FFD60B.4080308@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Saturday 15 February 2014 22:03:07 Hans Verkuil wrote:
> On 02/15/2014 09:53 PM, Sakari Ailus wrote:
> > Timestamp buffer flags are constant at the moment. Document them so that
> > 1) they're always valid and 2) not changed by the drivers. This leaves
> > room to extend the functionality later on if needed.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> > 
> >  Documentation/DocBook/media/v4l/io.xml |   10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/Documentation/DocBook/media/v4l/io.xml
> > b/Documentation/DocBook/media/v4l/io.xml index fbd0c6e..4f76565 100644
> > --- a/Documentation/DocBook/media/v4l/io.xml
> > +++ b/Documentation/DocBook/media/v4l/io.xml
> > @@ -653,6 +653,16 @@ plane, are stored in struct
> > <structname>v4l2_plane</structname> instead.> 
> >  In that case, struct <structname>v4l2_buffer</structname> contains an
> >  array of plane structures.</para>
> > 
> > +    <para>Dequeued video buffers come with timestamps. These
> > +    timestamps can be taken from different clocks and at different
> > +    part of the frame, depending on the driver. Please see flags in
> 
> s/part/parts/
> 
> But I think I would write it somewhat differently:
> 
> "The driver decides at which part of the frame and with which clock
> the timestamp is taken."
> 
> > +    the masks <constant>V4L2_BUF_FLAG_TIMESTAMP_MASK</constant> and
> > +    <constant>V4L2_BUF_FLAG_TSTAMP_SRC_MASK</constant> in <xref
> > +    linkend="buffer-flags">. These flags are guaranteed to be always
> > +    valid and will not be changed by the driver autonomously.

This sentence sounds a bit confusing to me. What about

"These flags are always valid and are constant across all buffers during the 
whole video stream."

> > Changes
> > +    in these flags may take place due as a side effect of
> 
> s/due//
> 
> > +    &VIDIOC-S-INPUT; or &VIDIOC-S-OUTPUT; however.</para>
> > +
> >      <table frame="none" pgwide="1" id="v4l2-buffer">
> >        <title>struct <structname>v4l2_buffer</structname></title>
> >        <tgroup cols="4">

-- 
Regards,

Laurent Pinchart

