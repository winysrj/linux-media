Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:33461 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751878AbdF2HV4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 03:21:56 -0400
Received: by mail-lf0-f42.google.com with SMTP id z78so5825697lff.0
        for <linux-media@vger.kernel.org>; Thu, 29 Jun 2017 00:21:55 -0700 (PDT)
Date: Thu, 29 Jun 2017 09:21:53 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 1/1] docs-rst: media: Document s_stream() core op usage
Message-ID: <20170629072153.GM30481@bigcity.dyn.berto.se>
References: <1498718333-26287-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1498718333-26287-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for your patch.

On 2017-06-29 09:38:53 +0300, Sakari Ailus wrote:
> As we begin to add support for systems with media pipelines controlled by
> more than one device driver, it is essential that we precisely define the
> responsibilities of each component in the stream control and common
> practices.
> 
> Specifically, this patch documents two things:
> 
> 1) streaming control is done per sub-device and sub-device drivers
> themselves are responsible for streaming setup in upstream sub-devices and
> 
> 2) broken frames should be tolerated at streaming stop. It is the
> responsibility of the sub-device driver to stop the transmitter after
> itself if it cannot handle broken frames (and it should be probably be
> done anyway).
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  Documentation/media/kapi/v4l2-subdev.rst | 36 ++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/Documentation/media/kapi/v4l2-subdev.rst b/Documentation/media/kapi/v4l2-subdev.rst
> index e1f0b72..27e371e 100644
> --- a/Documentation/media/kapi/v4l2-subdev.rst
> +++ b/Documentation/media/kapi/v4l2-subdev.rst
> @@ -262,6 +262,42 @@ is called. After all subdevices have been located the .complete() callback is
>  called. When a subdevice is removed from the system the .unbind() method is
>  called. All three callbacks are optional.
>  
> +Streaming control
> +^^^^^^^^^^^^^^^^^
> +
> +Starting and stopping the stream are somewhat complex operations that
> +often require walking the media graph to enable streaming on
> +sub-devices which the pipeline consists of. This involves interaction
> +between multiple drivers, sometimes more than two.
> +
> +The ``.s_stream()`` core op is responsible for starting and stopping

.s_stream() is a video or audio op not a core op right? But at the same 
time it's all part of the v4l2 core :-) Apart from this nit-pick which 
I'm fine to leave as is at your leisure.

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> +the stream on the sub-device it is called on. Additionally, if there
> +are sub-devices further up in the pipeline, i.e. connected to that
> +sub-device's sink pads through enabled links, the sub-device driver
> +must call the ``.s_stream()`` core op of all such sub-devices. The
> +sub-device driver is thus in control of whether the upstream
> +sub-devices start (or stop) streaming before or after the sub-device
> +itself is set up for streaming.
> +
> +.. note::
> +
> +   As the ``.s_stream()`` callback is called recursively through the
> +   sub-devices along the pipeline, it is important to keep the
> +   recursion as short as possible. To this end, drivers are encouraged
> +   not to internally call ``.s_stream()`` recursively in order to make
> +   only a single additional recursion per driver in the pipeline. This
> +   greatly reduces stack usage.
> +
> +Stopping the transmitter
> +^^^^^^^^^^^^^^^^^^^^^^^^
> +
> +A transmitter stops sending the stream of images as a result of
> +calling the ``.s_stream()`` callback. Some transmitters may stop the
> +stream at a frame boundary whereas others stop immediately,
> +effectively leaving the current frame unfinished. The receiver driver
> +should not make assumptions either way, but function properly in both
> +cases.
> +
>  V4L2 sub-device userspace API
>  -----------------------------
>  
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
