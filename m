Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:38643 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S942349AbcJSOjV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 10:39:21 -0400
Message-ID: <1476870150.3054.28.camel@pengutronix.de>
Subject: Re: [PATCH 1/1] doc-rst: v4l: Add documentation on CSI-2 bus
 configuration
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se
Date: Wed, 19 Oct 2016 11:42:30 +0200
In-Reply-To: <1476802974-28119-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1476802974-28119-1-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Dienstag, den 18.10.2016, 18:02 +0300 schrieb Sakari Ailus:
> Document the interface between the CSI-2 transmitter and receiver drivers.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Hi folks,
> 
> We've got multiple CSI-2 tranmitter and receiver drivers currently in the
> kernel. Some receivers require information on dynamic bus parameters and
> some of the transmitter drivers implement that. It's time to document what
> is expected of both so we will not end up with multiple non-interoperable
> implementations.
> 
> Regards,
> Sakari
> 
>  Documentation/media/kapi/csi2.rst  | 35 +++++++++++++++++++++++++++++++++++
>  Documentation/media/media_kapi.rst |  1 +
>  2 files changed, 36 insertions(+)
>  create mode 100644 Documentation/media/kapi/csi2.rst
> 
> diff --git a/Documentation/media/kapi/csi2.rst b/Documentation/media/kapi/csi2.rst
> new file mode 100644
> index 0000000..856a509
> --- /dev/null
> +++ b/Documentation/media/kapi/csi2.rst
> @@ -0,0 +1,35 @@
> +MIPI CSI-2
> +==========
> +
> +CSI-2 is a data bus intended for transferring images from cameras to
> +the host SoC. It is defined by the `MIPI alliance`_.
> +
> +.. _`MIPI alliance`: http://www.mipi.org/
> +
> +Transmitter drivers
> +-------------------
> +
> +CSI-2 transmitter, such as a sensor or a TV tuner, drivers need to
> +provide the CSI-2 receiver with information on the CSI-2 bus
> +configuration. These include the V4L2_CID_LINK_FREQ control and
> +(:c:type:`v4l2_subdev_video_ops`->s_stream() callback). Both must be
> +present on the sub-device represents the CSI-2 transmitter. The
> +V4L2_CID_LINK_FREQ control is used to tell the receiver driver the
> +frequency (and not the symbol rate) of the link and the
> +:c:type:`v4l2_subdev_video_ops`->s_stream() callback provides an
> +ability to start and stop the stream.
> +
> +The transmitter drivers must configure the CSI-2 transmitter to *LP-11
> +mode* whenever the transmitter is powered on but not active. Some
> +transmitters do this automatically but some have to be explicitly
> +programmed to do so.
> +
> +Receiver drivers
> +----------------
> +
> +Before the receiver driver may enable the CSI-2 transmitter by using
> +the :c:type:`v4l2_subdev_video_ops`->s_stream(), it must have powered
> +the transmitter up by using the
> +:c:type:`v4l2_subdev_core_ops`->s_power() callback. This may take
> +place either indirectly by using :c:func:`v4l2_pipeline_pm_use` or
> +directly.
> diff --git a/Documentation/media/media_kapi.rst b/Documentation/media/media_kapi.rst
> index f282ca2..bc06389 100644
> --- a/Documentation/media/media_kapi.rst
> +++ b/Documentation/media/media_kapi.rst
> @@ -33,3 +33,4 @@ For more details see the file COPYING in the source distribution of Linux.
>      kapi/rc-core
>      kapi/mc-core
>      kapi/cec-core
> +    kapi/csi2

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

so far. Should this document also include a suggestion on how exactly to
calculate the number of lanes to use from the pixel rate and link
frequency?

regards
Philipp


