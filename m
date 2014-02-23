Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4691 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaBWLpx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Feb 2014 06:45:53 -0500
Message-ID: <5309DF58.9030004@xs4all.nl>
Date: Sun, 23 Feb 2014 12:45:28 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
CC: laurent.pinchart@ideasonboard.com, k.debski@samsung.com
Subject: Re: [PATCH v5 7/7] v4l: Document timestamp buffer flag behaviour
References: <1392497585-5084-1-git-send-email-sakari.ailus@iki.fi> <1392497585-5084-8-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1392497585-5084-8-git-send-email-sakari.ailus@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/15/2014 09:53 PM, Sakari Ailus wrote:
> Timestamp buffer flags are constant at the moment. Document them so that 1)
> they're always valid and 2) not changed by the drivers. This leaves room to
> extend the functionality later on if needed.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  Documentation/DocBook/media/v4l/io.xml |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> index fbd0c6e..4f76565 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -653,6 +653,16 @@ plane, are stored in struct <structname>v4l2_plane</structname> instead.
>  In that case, struct <structname>v4l2_buffer</structname> contains an array of
>  plane structures.</para>
>  
> +    <para>Dequeued video buffers come with timestamps. These
> +    timestamps can be taken from different clocks and at different
> +    part of the frame, depending on the driver. Please see flags in
> +    the masks <constant>V4L2_BUF_FLAG_TIMESTAMP_MASK</constant> and
> +    <constant>V4L2_BUF_FLAG_TSTAMP_SRC_MASK</constant> in <xref
> +    linkend="buffer-flags">. These flags are guaranteed to be always
> +    valid and will not be changed by the driver autonomously. Changes
> +    in these flags may take place due as a side effect of
> +    &VIDIOC-S-INPUT; or &VIDIOC-S-OUTPUT; however.</para>

There is one exception to this: if the timestamps are copied from the output
buffer to the capture buffer (TIMESTAMP_COPY), then it can change theoretically
for every buffer since it entirely depends on what is being sent to it. The
value comes from userspace and you simply don't have any control over that.

I'm stress testing vb2 in lots of different ways, including timestamp handling.
It's not a pretty sight, I'm afraid. Expect a looong list of patches in the
coming week.

Regards,

	Hans

> +
>      <table frame="none" pgwide="1" id="v4l2-buffer">
>        <title>struct <structname>v4l2_buffer</structname></title>
>        <tgroup cols="4">
> 

