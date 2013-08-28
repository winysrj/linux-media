Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33836 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753487Ab3H1QHB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Aug 2013 12:07:01 -0400
Date: Wed, 28 Aug 2013 19:06:26 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	k.debski@samsung.com
Subject: Re: [PATCH v4.1 3/3] v4l: Add V4L2_BUF_FLAG_TIMESTAMP_SOF and use it
Message-ID: <20130828160626.GE2835@valkosipuli.retiisi.org.uk>
References: <201308281419.52009.hverkuil@xs4all.nl>
 <1377703495-21112-1-git-send-email-sakari.ailus@iki.fi>
 <521E1779.9030905@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521E1779.9030905@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for your prompt comments.

On Wed, Aug 28, 2013 at 05:30:01PM +0200, Hans Verkuil wrote:
> On 08/28/2013 05:24 PM, Sakari Ailus wrote:
> > Some devices such as the uvc produce timestamps at the beginning of the
> > frame rather than at the end of it. Add a buffer flag
> > (V4L2_BUF_FLAG_TIMESTAMP_SOF) to tell about this.
> > 
> > Also document timestamp_type in struct vb2_queue, and make the uvc set the
> > buffer flag.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> > since v4:
> > - Fixes according to Hans's comments.
> > 
> > - Note in comment the uvc driver will set the SOF flag from now on.
> > 
> > - Change comment of vb2_queue timestamp_type field: this is timestamp flags
> >   rather than just type. I stopped short of renaming the field.
> > 
> >  Documentation/DocBook/media/v4l/io.xml |   19 ++++++++++++++-----
> >  drivers/media/usb/uvc/uvc_queue.c      |    3 ++-
> >  include/media/videobuf2-core.h         |    1 +
> >  include/uapi/linux/videodev2.h         |   10 ++++++++++
> >  4 files changed, 27 insertions(+), 6 deletions(-)
> > 
> > diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> > index 2c155cc..3aee210 100644
> > --- a/Documentation/DocBook/media/v4l/io.xml
> > +++ b/Documentation/DocBook/media/v4l/io.xml
> > @@ -654,11 +654,12 @@ plane, are stored in struct <structname>v4l2_plane</structname> instead.
> >  In that case, struct <structname>v4l2_buffer</structname> contains an array of
> >  plane structures.</para>
> >  
> > -      <para>For timestamp types that are sampled from the system clock
> > -(V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC) it is guaranteed that the timestamp is
> > -taken after the complete frame has been received (or transmitted in
> > -case of video output devices). For other kinds of
> > -timestamps this may vary depending on the driver.</para>
> > +      <para>The timestamp is taken once the complete frame has been
> > +received (or transmitted for output devices) unless
> 
> unless -> unless the
> 
> > +<constant>V4L2_BUF_FLAG_TIMESTAMP_SOF</constant> buffer flag is set.
> > +If <constant>V4L2_BUF_FLAG_TIMESTAMP_SOF</constant> is set, the
> 
> the -> then the

Fixed both.

> > +timestamp is taken when the first pixel of the frame is received
> > +(or transmitted).</para>
> >  
> >      <table frame="none" pgwide="1" id="v4l2-buffer">
> >        <title>struct <structname>v4l2_buffer</structname></title>
> > @@ -1120,6 +1121,14 @@ in which case caches have not been used.</entry>
> >  	    <entry>The CAPTURE buffer timestamp has been taken from the
> >  	    corresponding OUTPUT buffer. This flag applies only to mem2mem devices.</entry>
> >  	  </row>
> > +	  <row>
> > +	    <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_SOF</constant></entry>
> > +	    <entry>0x00010000</entry>
> > +	    <entry>The buffer timestamp has been taken when the first
> 
> I think 'has been' should be 'was' in this context.

Then I wonder if I should change all the other flags, too. :-) "Has been" is
consistent with the documentation of other flags.

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
