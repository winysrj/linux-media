Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1141 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756591Ab2KVTOn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 14:14:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v1.2 1/4] v4l: Define video buffer flags for timestamp types
Date: Wed, 21 Nov 2012 23:53:02 +0100
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
References: <1353098995-1319-1-git-send-email-sakari.ailus@iki.fi> <1353525202-20062-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1353525202-20062-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211212353.02256.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed November 21 2012 20:13:22 Sakari Ailus wrote:
> Define video buffer flags for different timestamp types. Everything up to
> now have used either realtime clock or monotonic clock, without a way to
> tell which clock the timestamp was taken from.
> 
> Also document that the clock source of the timestamp in the timestamp field
> depends on buffer flags.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

But see my comments below for a separate matter...

> ---
> Since v1.1:
> 
> - Change the description of the timestamp field; say that the type of the
>   timestamp is dependent on the flags field.
> 
>  Documentation/DocBook/media/v4l/compat.xml |   12 ++++++
>  Documentation/DocBook/media/v4l/io.xml     |   53 ++++++++++++++++++++++------
>  Documentation/DocBook/media/v4l/v4l2.xml   |   12 ++++++-
>  include/uapi/linux/videodev2.h             |    4 ++
>  4 files changed, 69 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
> index 4fdf6b5..651ca52 100644
> --- a/Documentation/DocBook/media/v4l/compat.xml
> +++ b/Documentation/DocBook/media/v4l/compat.xml
> @@ -2477,6 +2477,18 @@ that used it. It was originally scheduled for removal in 2.6.35.
>        </orderedlist>
>      </section>
>  
> +    <section>
> +      <title>V4L2 in Linux 3.8</title>
> +      <orderedlist>
> +        <listitem>
> +	  <para>Added timestamp types to
> +	  <structfield>flags</structfield> field in
> +	  <structname>v4l2_buffer</structname>. See <xref
> +	  linkend="buffer-flags" />.</para>
> +        </listitem>
> +      </orderedlist>
> +    </section>
> +
>      <section id="other">
>        <title>Relation of V4L2 to other Linux multimedia APIs</title>
>  
> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> index 7e2f3d7..1243fa1 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -582,17 +582,19 @@ applications when an output stream.</entry>
>  	    <entry>struct timeval</entry>
>  	    <entry><structfield>timestamp</structfield></entry>
>  	    <entry></entry>
> -	    <entry><para>For input streams this is the
> -system time (as returned by the <function>gettimeofday()</function>
> -function) when the first data byte was captured. For output streams
> -the data will not be displayed before this time, secondary to the
> -nominal frame rate determined by the current video standard in
> -enqueued order. Applications can for example zero this field to
> -display frames as soon as possible. The driver stores the time at
> -which the first data byte was actually sent out in the
> -<structfield>timestamp</structfield> field. This permits
> -applications to monitor the drift between the video and system
> -clock.</para></entry>
> +	    <entry><para>For input streams this is time when the first data
> +	    byte was captured,

What should we do with this? In most drivers the timestamp is actually the
time that the *last* byte was captured. The reality is that the application
doesn't know whether it is the first or the last.

One option is to add a new flag for this, or to leave it open. The last
makes me uncomfortable, since there can be quite a difference between the
time of the first or last byte, and that definitely has an effect on the
A/V sync.

This is a separate topic that should be handled in a separate patch, but I
do think we need to take a closer look at this.

> as returned by the
> +	    <function>clock_gettime()</function> function for the relevant
> +	    clock id; see <constant>V4L2_BUF_FLAG_TIMESTAMP_*</constant> in
> +	    <xref linkend="buffer-flags" />. For output streams the data
> +	    will not be displayed before this time, secondary to the nominal
> +	    frame rate determined by the current video standard in enqueued
> +	    order. Applications can for example zero this field to display
> +	    frames as soon as possible.

There is not a single driver that supports this feature. There is also no
way an application can query the driver whether this feature is supported.
Personally I don't think this should be the task of a driver anyway: if you
want to postpone displaying a frame, then just wait before calling QBUF.
Don't add complicated logic in drivers/vb2 where it needs to hold buffers
back if the time hasn't been reached yet.

What might be much more interesting for output devices is if the timestamp
field is filled in with the expected display time on return of QBUF. That
would be very useful for regulating the flow of new frames.

What do you think?

> The driver stores the time at which
> +	    the first data byte was actually sent out in the
> +	    <structfield>timestamp</structfield> field.

Same problem as with the capture time: does the timestamp refer to the first
or last byte that's sent out? I think all output drivers set it to the time
of the last byte (== when the DMA of the frame is finished).

Regards,

	Hans

> This permits
> +	    applications to monitor the drift between the video and system
> +	    clock.</para></entry>
>  	  </row>
>  	  <row>
>  	    <entry>&v4l2-timecode;</entry>
> @@ -938,6 +940,35 @@ Typically applications shall use this flag for output buffers if the data
>  in this buffer has not been created by the CPU but by some DMA-capable unit,
>  in which case caches have not been used.</entry>
>  	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_MASK</constant></entry>
> +	    <entry>0xe000</entry>
> +	    <entry>Mask for timestamp types below. To test the
> +	    timestamp type, mask out bits not belonging to timestamp
> +	    type by performing a logical and operation with buffer
> +	    flags and timestamp mask.</entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN</constant></entry>
> +	    <entry>0x0000</entry>
> +	    <entry>Unknown timestamp type. This type is used by
> +	    drivers before Linux 3.8 and may be either monotonic (see
> +	    below) or realtime (wall clock). Monotonic clock has been
> +	    favoured in embedded systems whereas most of the drivers
> +	    use the realtime clock. Either kinds of timestamps are
> +	    available in user space via
> +	    <function>clock_gettime(2)</function> using clock IDs
> +	    <constant>CLOCK_MONOTONIC</constant> and
> +	    <constant>CLOCK_REALTIME</constant>, respectively.</entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC</constant></entry>
> +	    <entry>0x2000</entry>
> +	    <entry>The buffer timestamp has been taken from the
> +	    <constant>CLOCK_MONOTONIC</constant> clock. To access the
> +	    same clock outside V4L2, use
> +	    <function>clock_gettime(2)</function> .</entry>
> +	  </row>
>  	</tbody>
>        </tgroup>
>      </table>
> diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
> index 10ccde9..8b6f29e 100644
> --- a/Documentation/DocBook/media/v4l/v4l2.xml
> +++ b/Documentation/DocBook/media/v4l/v4l2.xml
> @@ -140,6 +140,16 @@ structs, ioctls) must be noted in more detail in the history chapter
>  applications. -->
>  
>        <revision>
> +	<revnumber>3.8</revnumber>
> +	<date>2012-11-16</date>
> +	<authorinitials>sa</authorinitials>
> +	<revremark>Added timestamp types to
> +	<structname>v4l2_buffer</structname>, see <xref
> +	linkend="buffer-flags" />.
> +	</revremark>
> +      </revision>
> +
> +      <revision>
>  	<revnumber>3.6</revnumber>
>  	<date>2012-07-02</date>
>  	<authorinitials>hv</authorinitials>
> @@ -472,7 +482,7 @@ and discussions on the V4L mailing list.</revremark>
>  </partinfo>
>  
>  <title>Video for Linux Two API Specification</title>
> - <subtitle>Revision 3.6</subtitle>
> + <subtitle>Revision 3.8</subtitle>
>  
>    <chapter id="common">
>      &sub-common;
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 2fff7ff..410ea9f 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -686,6 +686,10 @@ struct v4l2_buffer {
>  /* Cache handling flags */
>  #define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x0800
>  #define V4L2_BUF_FLAG_NO_CACHE_CLEAN		0x1000
> +/* Timestamp type */
> +#define V4L2_BUF_FLAG_TIMESTAMP_MASK		0xe000
> +#define V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN		0x0000
> +#define V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC	0x2000
>  
>  /*
>   *	O V E R L A Y   P R E V I E W
> 
