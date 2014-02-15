Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3286 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaBOVEC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Feb 2014 16:04:02 -0500
Message-ID: <52FFD60B.4080308@xs4all.nl>
Date: Sat, 15 Feb 2014 22:03:07 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	k.debski@samsung.com
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

s/part/parts/

But I think I would write it somewhat differently:

"The driver decides at which part of the frame and with which clock
the timestamp is taken."

> +    the masks <constant>V4L2_BUF_FLAG_TIMESTAMP_MASK</constant> and
> +    <constant>V4L2_BUF_FLAG_TSTAMP_SRC_MASK</constant> in <xref
> +    linkend="buffer-flags">. These flags are guaranteed to be always
> +    valid and will not be changed by the driver autonomously. Changes
> +    in these flags may take place due as a side effect of

s/due//

> +    &VIDIOC-S-INPUT; or &VIDIOC-S-OUTPUT; however.</para>
> +
>      <table frame="none" pgwide="1" id="v4l2-buffer">
>        <title>struct <structname>v4l2_buffer</structname></title>
>        <tgroup cols="4">
> 

Regards,

	Hans
