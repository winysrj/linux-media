Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1896 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbaBTU0I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Feb 2014 15:26:08 -0500
Message-ID: <530664CB.6000408@xs4all.nl>
Date: Thu, 20 Feb 2014 21:25:47 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
CC: laurent.pinchart@ideasonboard.com, k.debski@samsung.com
Subject: Re: [PATCH v5.1 7/7] v4l: Document timestamp buffer flag behaviour
References: <20140217233305.GY15635@valkosipuli.retiisi.org.uk> <1392925376-20562-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1392925376-20562-1-git-send-email-sakari.ailus@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/20/2014 08:42 PM, Sakari Ailus wrote:
> Timestamp buffer flags are constant at the moment. Document them so that 1)
> they're always valid and 2) not changed by the drivers. This leaves room to
> extend the functionality later on if needed.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
> since v5:
> - Clarify timestamp source flag behaviour.
> 
>  Documentation/DocBook/media/v4l/io.xml |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> index 22b87bc..a69e12a 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -653,6 +653,16 @@ plane, are stored in struct <structname>v4l2_plane</structname> instead.
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
> +    &VIDIOC-S-OUTPUT; however.</para>
> +
>      <table frame="none" pgwide="1" id="v4l2-buffer">
>        <title>struct <structname>v4l2_buffer</structname></title>
>        <tgroup cols="4">
> 

