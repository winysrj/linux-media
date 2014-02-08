Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1231 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaBHMdd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Feb 2014 07:33:33 -0500
Message-ID: <52F623EF.3020003@xs4all.nl>
Date: Sat, 08 Feb 2014 13:32:47 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, k.debski@samsung.com,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v4.2 4/4] v4l: Document timestamp buffer flag behaviour
References: <1393149.6OyBNhdFTt@avalon> <1391813548-818-1-git-send-email-sakari.ailus@iki.fi> <1391813548-818-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1391813548-818-2-git-send-email-sakari.ailus@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/07/2014 11:52 PM, Sakari Ailus wrote:
> Timestamp buffer flags are constant at the moment. Document them so that 1)
> they're always valid and 2) not changed by the drivers. This leaves room to
> extend the functionality later on if needed.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  Documentation/DocBook/media/v4l/io.xml |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> index 451626f..f523725 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -654,6 +654,14 @@ plane, are stored in struct <structname>v4l2_plane</structname> instead.
>  In that case, struct <structname>v4l2_buffer</structname> contains an array of
>  plane structures.</para>
>  
> +    <para>Buffers that have been dequeued come with timestamps. These
> +    timestamps can be taken from different clocks and at different part of
> +    the frame, depending on the driver. Please see flags in the masks
> +    <constant>V4L2_BUF_FLAG_TIMESTAMP_MASK</constant> and
> +    <constant>V4L2_BUF_FLAG_TSTAMP_SRC_MASK</constant> in <xref
> +    linkend="buffer-flags">. These flags are guaranteed to be always valid
> +    and will not be changed by the driver.</para>

That's a bit too strong. Different inputs or outputs may have different timestamp
sources. Also add a note that the SOE does not apply to outputs (there is no
exposure there after all). For EOF the formulation for outputs should be:
"..last pixel of the frame has been transmitted."

For the COPY mode I think the SRC_MASK bits should be copied as well. That should
be stated in the documentation.

Regards,

	Hans

> +
>      <table frame="none" pgwide="1" id="v4l2-buffer">
>        <title>struct <structname>v4l2_buffer</structname></title>
>        <tgroup cols="4">
> 

