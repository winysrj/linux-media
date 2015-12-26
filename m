Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55634 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbbLZLP1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Dec 2015 06:15:27 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: v4l-dvb <linux-media@vger.kernel.org>
Subject: Re: [PATCH] DocBook media: make explicit that standard/timings never change automatically
Date: Sat, 26 Dec 2015 13:14:42 +0200
Message-ID: <4565708.GFDh2EYGGM@avalon>
In-Reply-To: <2176a82408f1a6cf55a94bc25cfe5dc4@xs4all.nl>
References: <2176a82408f1a6cf55a94bc25cfe5dc4@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Thursday 24 December 2015 14:18:10 Hans Verkuil wrote:
> A driver might detect a new standard or DV timings, but it will never
> change to
> those new timings automatically. Instead it will send an event and let
> the application
> take care of it.

Your webmail seriously messes up patches :-/

> Make this explicit in the documentation.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>   .../DocBook/media/v4l/vidioc-query-dv-timings.xml          | 14
> ++++++++++++--
>   Documentation/DocBook/media/v4l/vidioc-querystd.xml        | 10
> ++++++++++
>   2 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml
> b/Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml
> index e9c70a8..eba0293 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml
> @@ -60,9 +60,19 @@ input</refpurpose>
>   automatically, similar to sensing the video standard. To do so,
> applications
>   call <constant>VIDIOC_QUERY_DV_TIMINGS</constant> with a pointer to a
>   &v4l2-dv-timings;. Once the hardware detects the timings, it will fill
> in the
> -timings structure.
> +timings structure.</para>
> 
> -If the timings could not be detected because there was no signal, then
> +<para>Please note that drivers will <emphasis>never</emphasis> switch
> timings automatically
> +if new timings are detected.

As the document is an API specification I'd phrase this as a requirement:

"Note that driver must never switch timings automatically if new timings are 
detected."

(or, if we want to comply with the IEEE Standards Style Manual, s/must 
never/shall not/)

> Instead, drivers will send the
> +<constant>V4L2_EVENT_SOURCE_CHANGE</constant> event (if they support
> this)

Similarly, "drivers should send".

Apart from that and similar comments for VIDIOC_QUERYSTD,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> and expect
> +that userspace will take action by calling
> <constant>VIDIOC_QUERY_DV_TIMINGS</constant>.
> +The reason is that new timings usually mean different buffer sizes as
> well, and you
> +cannot change buffer sizes on the fly. In general, applications that
> receive the
> +Source Change event will have to call
> <constant>VIDIOC_QUERY_DV_TIMINGS</constant>,
> +and if the detected timings are valid they will have to stop streaming,
> set the new
> +timings, allocate new buffers and start streaming again.</para>
> +
> +<para>If the timings could not be detected because there was no signal,
> then
>   <errorcode>ENOLINK</errorcode> is returned. If a signal was detected,
> but
>   it was unstable and the receiver could not lock to the signal, then
>   <errorcode>ENOLCK</errorcode> is returned. If the receiver could lock
> to the signal,
> diff --git a/Documentation/DocBook/media/v4l/vidioc-querystd.xml
> b/Documentation/DocBook/media/v4l/vidioc-querystd.xml
> index 2223485..8efa917 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-querystd.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-querystd.xml
> @@ -59,6 +59,16 @@ then the driver will return V4L2_STD_UNKNOWN. When
> detection is not
>   possible or fails, the set must contain all standards supported by the
>   current video input or output.</para>
> 
> +<para>Please note that drivers will <emphasis>never</emphasis> switch
> the video standard
> +automatically if a new video standard is detected. Instead, drivers
> will send the
> +<constant>V4L2_EVENT_SOURCE_CHANGE</constant> event (if they support
> this) and expect
> +that userspace will take action by calling
> <constant>VIDIOC_QUERYSTD</constant>.
> +The reason is that a new video standard can mean different buffer sizes
> as well, and you
> +cannot change buffer sizes on the fly. In general, applications that
> receive the
> +Source Change event will have to call
> <constant>VIDIOC_QUERYSTD</constant>,
> +and if the detected video standard is valid they will have to stop
> streaming, set the new
> +standard, allocate new buffers and start streaming again.</para>
> +
>     </refsect1>
> 
>     <refsect1>

-- 
Regards,

Laurent Pinchart

