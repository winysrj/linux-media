Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42048 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756365Ab2KVTYz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 14:24:55 -0500
Date: Thu, 22 Nov 2012 01:59:00 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v1.2 1/4] v4l: Define video buffer flags for timestamp
 types
Message-ID: <20121121235859.GB31442@valkosipuli.retiisi.org.uk>
References: <1353098995-1319-1-git-send-email-sakari.ailus@iki.fi>
 <1353525202-20062-1-git-send-email-sakari.ailus@iki.fi>
 <201211212353.02256.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201211212353.02256.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, Nov 21, 2012 at 11:53:02PM +0100, Hans Verkuil wrote:
> On Wed November 21 2012 20:13:22 Sakari Ailus wrote:
> > Define video buffer flags for different timestamp types. Everything up to
> > now have used either realtime clock or monotonic clock, without a way to
> > tell which clock the timestamp was taken from.
> > 
> > Also document that the clock source of the timestamp in the timestamp field
> > depends on buffer flags.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks! :-)

> But see my comments below for a separate matter...
> 
> > ---
> > Since v1.1:
> > 
> > - Change the description of the timestamp field; say that the type of the
> >   timestamp is dependent on the flags field.
> > 
> >  Documentation/DocBook/media/v4l/compat.xml |   12 ++++++
> >  Documentation/DocBook/media/v4l/io.xml     |   53 ++++++++++++++++++++++------
> >  Documentation/DocBook/media/v4l/v4l2.xml   |   12 ++++++-
> >  include/uapi/linux/videodev2.h             |    4 ++
> >  4 files changed, 69 insertions(+), 12 deletions(-)
> > 
> > diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
> > index 4fdf6b5..651ca52 100644
> > --- a/Documentation/DocBook/media/v4l/compat.xml
> > +++ b/Documentation/DocBook/media/v4l/compat.xml
> > @@ -2477,6 +2477,18 @@ that used it. It was originally scheduled for removal in 2.6.35.
> >        </orderedlist>
> >      </section>
> >  
> > +    <section>
> > +      <title>V4L2 in Linux 3.8</title>
> > +      <orderedlist>
> > +        <listitem>
> > +	  <para>Added timestamp types to
> > +	  <structfield>flags</structfield> field in
> > +	  <structname>v4l2_buffer</structname>. See <xref
> > +	  linkend="buffer-flags" />.</para>
> > +        </listitem>
> > +      </orderedlist>
> > +    </section>
> > +
> >      <section id="other">
> >        <title>Relation of V4L2 to other Linux multimedia APIs</title>
> >  
> > diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> > index 7e2f3d7..1243fa1 100644
> > --- a/Documentation/DocBook/media/v4l/io.xml
> > +++ b/Documentation/DocBook/media/v4l/io.xml
> > @@ -582,17 +582,19 @@ applications when an output stream.</entry>
> >  	    <entry>struct timeval</entry>
> >  	    <entry><structfield>timestamp</structfield></entry>
> >  	    <entry></entry>
> > -	    <entry><para>For input streams this is the
> > -system time (as returned by the <function>gettimeofday()</function>
> > -function) when the first data byte was captured. For output streams
> > -the data will not be displayed before this time, secondary to the
> > -nominal frame rate determined by the current video standard in
> > -enqueued order. Applications can for example zero this field to
> > -display frames as soon as possible. The driver stores the time at
> > -which the first data byte was actually sent out in the
> > -<structfield>timestamp</structfield> field. This permits
> > -applications to monitor the drift between the video and system
> > -clock.</para></entry>
> > +	    <entry><para>For input streams this is time when the first data
> > +	    byte was captured,
> 
> What should we do with this? In most drivers the timestamp is actually the
> time that the *last* byte was captured. The reality is that the application
> doesn't know whether it is the first or the last.
> 
> One option is to add a new flag for this, or to leave it open. The last
> makes me uncomfortable, since there can be quite a difference between the
> time of the first or last byte, and that definitely has an effect on the
> A/V sync.

Very true. I'd also prefer to have this defined so the information would be
available to the user space.

> This is a separate topic that should be handled in a separate patch, but I
> do think we need to take a closer look at this.

I'm not against one more buffer flag to tell which one it is. :-)

There are hardly any other options than the frame start and frame end.

On the other hand, the FRAME_SYNC event is supported by some drivers and
that can be used to obtain the timestamp from frame start. Not all drivers
support it nor the applications can be expected to use this just to get a
timestamp, though.

> > as returned by the
> > +	    <function>clock_gettime()</function> function for the relevant
> > +	    clock id; see <constant>V4L2_BUF_FLAG_TIMESTAMP_*</constant> in
> > +	    <xref linkend="buffer-flags" />. For output streams the data
> > +	    will not be displayed before this time, secondary to the nominal
> > +	    frame rate determined by the current video standard in enqueued
> > +	    order. Applications can for example zero this field to display
> > +	    frames as soon as possible.
> 
> There is not a single driver that supports this feature. There is also no
> way an application can query the driver whether this feature is supported.
> Personally I don't think this should be the task of a driver anyway: if you
> want to postpone displaying a frame, then just wait before calling QBUF.
> Don't add complicated logic in drivers/vb2 where it needs to hold buffers
> back if the time hasn't been reached yet.

Assuming realtime clock, there could be some interesting interactions with
this and daylight saving time or setting system clock, for example.

I'm definitely not against removing this, especially as no driver uses it.

> What might be much more interesting for output devices is if the timestamp
> field is filled in with the expected display time on return of QBUF. That
> would be very useful for regulating the flow of new frames.
> 
> What do you think?

Fine for me. Sylwester also brought memory-to-memory devices (and
memory-to-memory processing whether the device is classified as such in API
or not) to my attention. For those devices it likely wouldn't matter at all
what's the system time when the frame is processed since the frame wasn't
captured at that time anyway.

In those cases it might makes sense to use timestamp that e.g. comes from
the compressed stream, or pass encoder timestamps that are going to be part
of the compressed stream. I think MPEG-related use cases were briefly
mentioned in the timestamp discussion earlier.

> > The driver stores the time at which
> > +	    the first data byte was actually sent out in the
> > +	    <structfield>timestamp</structfield> field.
> 
> Same problem as with the capture time: does the timestamp refer to the first
> or last byte that's sent out? I think all output drivers set it to the time
> of the last byte (== when the DMA of the frame is finished).

I haven't actually even seen a capture driver that would do otherwise, but
that could be just me not knowing many enough. :-) Would we actually break
something if we changed the definition to say that this is the timestamp
taken when the frame is done?

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
