Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3675 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab3A1Jzi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 04:55:38 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 1/1] v4l: Document timestamp behaviour to correspond to reality
Date: Mon, 28 Jan 2013 10:55:14 +0100
Cc: linux-media@vger.kernel.org, k.debski@samsung.com,
	laurent.pinchart@ideasonboard.com
References: <1359137009-23921-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1359137009-23921-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301281055.14085.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri January 25 2013 19:03:29 Sakari Ailus wrote:
> Document that monotonic timestamps are taken after the corresponding frame
> has been received, not when the reception has begun. This corresponds to the
> reality of current drivers: the timestamp is naturally taken when the
> hardware triggers an interrupt to tell the driver to handle the received
> frame.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  Documentation/DocBook/media/v4l/io.xml |   27 ++++++++++++++-------------
>  1 files changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> index 2c4646d..3b8bf61 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -654,19 +654,20 @@ plane, are stored in struct <structname>v4l2_plane</structname> instead.
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
> +      <para>On timestamp types that are sampled from the system clock
> +(V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC) it is guaranteed that the timestamp is
> +taken after the complete frame has been received.

add: " (or transmitted for video output devices)"

> For other kinds of
> +timestamps this may vary depending on the driver. In practice however the
> +wide range of hardware covered by the V4L2 API limits timestamp accuracy.
> +Often an interrupt routine will sample the system clock shortly after the
> +field or frame was stored completely in memory. So applications must expect
> +a constant difference up to one field or frame period plus a small (few scan
> +lines) random error. The delay and error can be much larger due to
> +compression or transmission over an external bus when the frames are not
> +properly stamped by the sender. This is frequently the case with USB
> +cameras. Here timestamps refer to the instant the field or frame was
> +received by the driver, not the capture time. These devices identify by not
> +enumerating any video standards, see <xref linkend="standard" />.</para>

I'm not sure if there is any reliable way at the moment to identify such
devices. At least in the past (that may not be true anymore) some webcam
drivers *did* implement S_STD.

There are also devices where one input is a webcam and another input is a
composite (TV) input (the vino driver for old SGIs is one of those).

The best method I know is to check the capabilities field returned by
ENUMINPUT for the current input and see if any of the STD/DV_TIMINGS/PRESETS
caps are set. If not, then it is a camera. Of course, this assumes there are
no more webcam drivers that use S_STD.

I would much prefer to add a proper webcam input type to ENUMINPUT, but I'm
afraid that would break apps.

>  
>        <para>Similar limitations apply to output timestamps. Typically
>  the video hardware locks to a clock controlling the video timing, the
> 

This paragraph on output timestamps can be deleted IMHO.

And the paragraph after that can probably be removed completely as well
that we no longer use gettimeofday:

"Apart of limitations of the video device and natural inaccuracies of
all clocks, it should be noted system time itself is not perfectly stable.
It can be affected by power saving cycles, warped to insert leap seconds,
or even turned back or forth by the system administrator affecting long
term measurements."

Ditto for the footnote at the end of that paragraph.

The timestamp field documentation is wrong as well for output types. No
driver uses the timestamp field as input (i.e. delaying frames until that
timestamp has been reached). It also says that the timestamp is the time at
which the first data byte was sent out, that should be the last data byte.

Regards,

	Hans
