Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1793 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbaCANnI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Mar 2014 08:43:08 -0500
Message-ID: <5311E3D2.6000108@xs4all.nl>
Date: Sat, 01 Mar 2014 14:42:42 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
CC: k.debski@samsung.com, laurent.pinchart@ideasonboard.com
Subject: Re: [PATH v6 10/10] v4l: Document timestamp buffer flag behaviour
References: <1393679828-25878-1-git-send-email-sakari.ailus@iki.fi> <1393679828-25878-11-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1393679828-25878-11-git-send-email-sakari.ailus@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

On 03/01/2014 02:17 PM, Sakari Ailus wrote:
> Timestamp buffer flags are constant at the moment. Document them so that 1)
> they're always valid and 2) not changed by the drivers. This leaves room to
> extend the functionality later on if needed.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  Documentation/DocBook/media/v4l/io.xml |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> index d44401c..1bffb1c 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -653,6 +653,20 @@ plane, are stored in struct <structname>v4l2_plane</structname> instead.
>  In that case, struct <structname>v4l2_buffer</structname> contains an array of
>  plane structures.</para>
>  
> +    <para>Dequeued video buffers come with timestamps. The driver
> +    decides at which part of the frame and with which clock the
> +    timestamp is taken. Please see flags in the masks
> +    <constant>V4L2_BUF_FLAG_TIMESTAMP_MASK</constant> and
> +    <constant>V4L2_BUF_FLAG_TSTAMP_SRC_MASK</constant> in <xref
> +    linkend="buffer-flags">. These flags are always valid and constant
> +    across all buffers during the whole video stream. Changes in these
> +    flags may take place as a side effect of &VIDIOC-S-INPUT; or
> +    &VIDIOC-S-OUTPUT; however. The
> +    <constant>V4L2_BUF_FLAG_TIMESTAMP_COPY</constant> timestamp type
> +    which is used by e.g. on mem-to-mem devices is an exception to the
> +    rule: the timestamp source flags are copied from the OUTPUT video
> +    buffer to the CAPTURE video buffer.</para>
> +
>      <table frame="none" pgwide="1" id="v4l2-buffer">
>        <title>struct <structname>v4l2_buffer</structname></title>
>        <tgroup cols="4">
> 
