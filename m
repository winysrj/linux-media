Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59582 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbaBTX3I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Feb 2014 18:29:08 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	k.debski@samsung.com
Subject: Re: [PATCH v5.1 3/7] v4l: Add timestamp source flags, mask and document them
Date: Fri, 21 Feb 2014 00:30:21 +0100
Message-ID: <1806212.4rVLkqN7y6@avalon>
In-Reply-To: <53066763.3070000@xs4all.nl>
References: <20140217232931.GW15635@valkosipuli.retiisi.org.uk> <1392925276-20412-1-git-send-email-sakari.ailus@iki.fi> <53066763.3070000@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 20 February 2014 21:36:51 Hans Verkuil wrote:
> On 02/20/2014 08:41 PM, Sakari Ailus wrote:
> > Some devices do not produce timestamps that correspond to the end of the
> > frame. The user space should be informed on the matter. This patch
> > achieves
> > that by adding buffer flags (and a mask) for timestamp sources since more
> > possible timestamping points are expected than just two.
> > 
> > A three-bit mask is defined (V4L2_BUF_FLAG_TSTAMP_SRC_MASK) and two of the
> > eight possible values is are defined V4L2_BUF_FLAG_TSTAMP_SRC_EOF for end
> > of frame (value zero) V4L2_BUF_FLAG_TSTAMP_SRC_SOE for start of exposure
> > (next value).
> 
> Sorry, but I still have two small notes:
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> > since v5:
> > - Add a note on software generated timestamp inaccuracy.
> > 
> >  Documentation/DocBook/media/v4l/io.xml   |   38 +++++++++++++++++++++----
> >  drivers/media/v4l2-core/videobuf2-core.c |    4 +++-
> >  include/media/videobuf2-core.h           |    2 ++
> >  include/uapi/linux/videodev2.h           |    4 ++++
> >  4 files changed, 41 insertions(+), 7 deletions(-)
> > 
> > diff --git a/Documentation/DocBook/media/v4l/io.xml
> > b/Documentation/DocBook/media/v4l/io.xml index 46d24b3..22b87bc 100644
> > --- a/Documentation/DocBook/media/v4l/io.xml
> > +++ b/Documentation/DocBook/media/v4l/io.xml
> > @@ -653,12 +653,6 @@ plane, are stored in struct
> > <structname>v4l2_plane</structname> instead.> 
> >  In that case, struct <structname>v4l2_buffer</structname> contains an
> >  array of plane structures.</para>
> > 
> > -      <para>For timestamp types that are sampled from the system clock
> > -(V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC) it is guaranteed that the timestamp
> > is
> > -taken after the complete frame has been received (or transmitted in
> > -case of video output devices). For other kinds of
> > -timestamps this may vary depending on the driver.</para>
> > -
> > 
> >      <table frame="none" pgwide="1" id="v4l2-buffer">
> >      
> >        <title>struct <structname>v4l2_buffer</structname></title>
> >        <tgroup cols="4">
> > 
> > @@ -1119,6 +1113,38 @@ in which case caches have not been used.</entry>
> >  	    <entry>The CAPTURE buffer timestamp has been taken from the
> >  	    corresponding OUTPUT buffer. This flag applies only to mem2mem
> >  	    devices.</entry>
> >  	  </row>
> > +	  <row>
> > +	    <entry><constant>V4L2_BUF_FLAG_TSTAMP_SRC_MASK</constant></entry>
> > +	    <entry>0x00070000</entry>
> > +	    <entry>Mask for timestamp sources below. The timestamp source
> > +	    defines the point of time the timestamp is taken in relation to
> > +	    the frame. Logical and operation between the
> > +	    <structfield>flags</structfield> field and
> > +	    <constant>V4L2_BUF_FLAG_TSTAMP_SRC_MASK</constant> produces the
> > +	    value of the timestamp source.</entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry><constant>V4L2_BUF_FLAG_TSTAMP_SRC_EOF</constant></entry>
> > +	    <entry>0x00000000</entry>
> > +	    <entry>End Of Frame. The buffer timestamp has been taken
> > +	    when the last pixel of the frame has been received or the
> > +	    last pixel of the frame has been transmitted. In practice,
> > +	    software generated timestamps will typically be read from
> > +	    the clock a small amount of time after the last pixel has
> > +	    been received, depending on the system and other activity
> 
> s/been received/been received or transmitted/
> 
> > +	    in it.</entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry><constant>V4L2_BUF_FLAG_TSTAMP_SRC_SOE</constant></entry>
> > +	    <entry>0x00010000</entry>
> > +	    <entry>Start Of Exposure. The buffer timestamp has been
> > +	    taken when the exposure of the frame has begun. In
> > +	    practice, software generated timestamps will typically be
> > +	    read from the clock a small amount of time after the last
> > +	    pixel has been received, depending on the system and other
> > +	    activity in it. This is only valid for buffer type
> > +	    <constant>V4L2_BUF_TYPE_VIDEO_CAPTURE</constant>.</entry>
> 
> I would move the last sentence up to just before "In practice...". The
> way it is now it looks like an afterthought.
> 
> I am also not sure whether the whole "In practice" sentence is valid
> here. Certainly the bit about "the last pixel" isn't since this is the
> "SOE" case and not the End Of Frame. In the case of the UVC driver (and
> that's the only one using this timestamp source) the timestamps come from
> the hardware as I understand it, so the "software generated" bit doesn't
> apply.
> 
> I would actually be inclined to drop it altogether for this particular
> timestamp source. But it's up to Laurent.

What do you mean, drop what altogether ?

> > +	  </row>
> >  	</tbody>
> >        </tgroup>
> >      </table>

-- 
Regards,

Laurent Pinchart

