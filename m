Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2644 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab3H1PTn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Aug 2013 11:19:43 -0400
Message-ID: <521E14F6.7010900@xs4all.nl>
Date: Wed, 28 Aug 2013 17:19:18 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	k.debski@samsung.com
Subject: Re: [PATCH v4.1 1/3] v4l: Document timestamp behaviour to correspond
 to reality
References: <201308281413.31649.hverkuil@xs4all.nl> <1377703438-21026-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1377703438-21026-1-git-send-email-sakari.ailus@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/28/2013 05:23 PM, Sakari Ailus wrote:
> Document that monotonic timestamps are taken after the corresponding frame
> has been received, not when the reception has begun. This corresponds to the
> reality of current drivers: the timestamp is naturally taken when the
> hardware triggers an interrupt to tell the driver to handle the received
> frame.
> 
> Remove the note on timestamp accuracy as it is fairly subjective what is
> actually an unstable timestamp.
> 
> Also remove explanation that output buffer timestamps can be used to delay
> outputting a frame.
> 
> Remove the footnote saying we always use realtime clock.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
> since v4:
> - Fixes according to Hans's comments.
> 
>  Documentation/DocBook/media/v4l/io.xml |   47 ++++++--------------------------
>  1 file changed, 8 insertions(+), 39 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> index 2c4c068..9720606 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -654,38 +654,11 @@ plane, are stored in struct <structname>v4l2_plane</structname> instead.
>  In that case, struct <structname>v4l2_buffer</structname> contains an array of
>  plane structures.</para>
>  
> -      <para>Nominally timestamps refer to the first data byte transmitted.
> -In practice however the wide range of hardware covered by the V4L2 API
> -limits timestamp accuracy. Often an interrupt routine will
> -sample the system clock shortly after the field or frame was stored
> -completely in memory. So applications must expect a constant
> -difference up to one field or frame period plus a small (few scan
> -lines) random error. The delay and error can be much
> -larger due to compression or transmission over an external bus when
> -the frames are not properly stamped by the sender. This is frequently
> -the case with USB cameras. Here timestamps refer to the instant the
> -field or frame was received by the driver, not the capture time. These
> -devices identify by not enumerating any video standards, see <xref
> -linkend="standard" />.</para>
> -
> -      <para>Similar limitations apply to output timestamps. Typically
> -the video hardware locks to a clock controlling the video timing, the
> -horizontal and vertical synchronization pulses. At some point in the
> -line sequence, possibly the vertical blanking, an interrupt routine
> -samples the system clock, compares against the timestamp and programs
> -the hardware to repeat the previous field or frame, or to display the
> -buffer contents.</para>
> -
> -      <para>Apart of limitations of the video device and natural
> -inaccuracies of all clocks, it should be noted system time itself is
> -not perfectly stable. It can be affected by power saving cycles,
> -warped to insert leap seconds, or even turned back or forth by the
> -system administrator affecting long term measurements. <footnote>
> -	  <para>Since no other Linux multimedia
> -API supports unadjusted time it would be foolish to introduce here. We
> -must use a universally supported clock to synchronize different media,
> -hence time of day.</para>
> -	</footnote></para>
> +      <para>For timestamp types that are sampled from the system clock
> +(V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC) it is guaranteed that the timestamp is
> +taken after the complete frame has been received (or transmitted in
> +case of video output devices). For other kinds of
> +timestamps this may vary depending on the driver.</para>
>  
>      <table frame="none" pgwide="1" id="v4l2-buffer">
>        <title>struct <structname>v4l2_buffer</structname></title>
> @@ -745,13 +718,9 @@ applications when an output stream.</entry>
>  	    byte was captured, as returned by the
>  	    <function>clock_gettime()</function> function for the relevant
>  	    clock id; see <constant>V4L2_BUF_FLAG_TIMESTAMP_*</constant> in
> -	    <xref linkend="buffer-flags" />. For output streams the data
> -	    will not be displayed before this time, secondary to the nominal
> -	    frame rate determined by the current video standard in enqueued
> -	    order. Applications can for example zero this field to display
> -	    frames as soon as possible. The driver stores the time at which
> -	    the first data byte was actually sent out in the
> -	    <structfield>timestamp</structfield> field. This permits
> +	    <xref linkend="buffer-flags" />. For output streams the driver
> +	    stores the time at which the last data byte was actually sent out
> +	    in the  <structfield>timestamp</structfield> field. This permits
>  	    applications to monitor the drift between the video and system
>  	    clock.</para></entry>
>  	  </row>
> 

