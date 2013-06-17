Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51221 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab3FQTyA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 15:54:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] V4L2: add documentation for V4L2 clock helpers and asynchronous probing
Date: Mon, 17 Jun 2013 21:54:13 +0200
Message-ID: <3036701.8xleOKapCa@avalon>
In-Reply-To: <Pine.LNX.4.64.1306170801590.22409@axis700.grange>
References: <Pine.LNX.4.64.1306170801590.22409@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thank you for the patch. Overall it looks pretty good, please see below for 
some small comments. If you've been wondering why your stock of comas is so 
low, wonder no more: I've found them :-D

On Monday 17 June 2013 08:04:10 Guennadi Liakhovetski wrote:
> Add documentation for the V4L2 clock and V4L2 asynchronous probing APIs
> to v4l2-framework.txt.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>
> ---
> 
> Hopefully we can commit the actual patches now, while we refine the
> documentation.
> 
>  Documentation/video4linux/v4l2-framework.txt |   62 ++++++++++++++++++++++-
>  1 files changed, 60 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/video4linux/v4l2-framework.txt
> b/Documentation/video4linux/v4l2-framework.txt index a300b28..159a83a
> 100644
> --- a/Documentation/video4linux/v4l2-framework.txt
> +++ b/Documentation/video4linux/v4l2-framework.txt
> @@ -326,8 +326,27 @@ that width, height and the media bus pixel code are
> equal on both source and sink of the link. Subdev drivers are also free to
> use this function to perform the checks mentioned above in addition to
> their own checks.
> 
> -A device (bridge) driver needs to register the v4l2_subdev with the
> -v4l2_device:
> +There are currently two ways to register subdevices with the V4L2 core. The
> +first (traditional) possibility is to have subdevices registered by bridge
> +drivers. This can be done, when the bridge driver has the complete

s/done, /done/

> +information about subdevices, connected to it and knows exactly when to

s/subdevices,/subdevices/

> +register them. This is typically the case for internal subdevices, like
> +video data processing units within SoCs or complex pluggable boards,
> +camera sensors in USB cameras or connected to SoCs, which pass information
> +about them to bridge drivers, usually in their platform data.
> +
> +There are however also situations, where subdevices have to be registered

s/situations,/situations/

> +asynchronously to bridge devices. An example of such a configuration is
> +Device Tree based systems, on which information about subdevices is made

s/systems,/systems/

> +available to the system indpendently from the bridge devices, e.g. when

s/indpendently/independently/

> +subdevices are defined in DT as I2C device nodes. The API, used in this

s/API,/API/

> +second case is described further below.
> +
> +Using one or the other registration method only affects the probing
> +process, the run-time bridge-subdevice interaction is in both cases the
> same.
> +
> +In the synchronous case a device (bridge) driver needs to register the
> +v4l2_subdev with the v4l2_device:
> 
>  	int err = v4l2_device_register_subdev(v4l2_dev, sd);
> 
> @@ -394,6 +413,25 @@ controlled through GPIO pins. This distinction is only
> relevant when setting up the device, but once the subdev is registered it
> is completely transparent.
> 
> 
> +In the asynchronous case subdevices register themselves using the
> +v4l2_async_register_subdev() function. Unregistration is performed, using

s/performed,/performed/

> +the v4l2_async_unregister_subdev() call. Subdevices registered this way
> +are stored on a global list of subdevices, ready to be picked up by bridge

s/on/in/

> +drivers.
> +
> +Bridge drivers in turn have to register a notifier object with an array of
> +subdevice descriptors, that the bridge device needs for its operation. This

s/descriptors,/descriptors/

> +is performed using the v4l2_async_notifier_register() call. To unregister
> +the notifier the driver has to call v4l2_async_notifier_unregister(). The
> +former of the two functions takes two arguments: a pointer to struct
> +v4l2_device and a pointer to struct v4l2_async_notifier. The latter
> +contains a pointer to an array of pointers to subdevice descriptors of
> +type struct v4l2_async_subdev type.

Isn't it the other way around ?

> +The V4L2 core will then use these descriptors to match asynchronously
> +registered subdevices to them. If a match is detected the .bound() notifier
> +callback is called. After all subdevices have been located the .complete()
> +callback is called. When a subdevice is removed from the system the
> +.unbind() method is called. All three callbacks are optional.
> +
> +
>  V4L2 sub-device userspace API
>  -----------------------------
> 
> @@ -1061,3 +1099,23 @@ available event type is 'class base + 1'.
> 
>  An example on how the V4L2 events may be used can be found in the OMAP
>  3 ISP driver (drivers/media/platform/omap3isp).
> +
> +
> +V4L2 clocks
> +-----------
> +
> +Many subdevices, like camera sensors, TV decoders and encoders, need a
> +clock signal to be supplied by the system. Often this clock is supplied by
> +the respective bridge device. The Linux kernel provides a Common Clock
> +Framework for this purpose, however, it is not (yet) available on all
> +architectures. Besides, the nature of the multi-functional (clock, data +
> +synchronisation, I2C control) connection of subdevices to the system might
> +impose special requirements on the clock API usage. For these reasons a
> +V4L2 clock helper API has been developed and is provided to bridge and
> +subdevice drivers.

What special requirements are those ? I've always thought that the purpose of 
the V4L2 clock API was to provide an API on platforms where CCF wasn't 
available yet, and that it should then be removed.

> +The API consists of two parts: two functions to register and unregister a
> +V4L2 clock source: v4l2_clk_register() and v4l2_clk_unregister() and calls
> +to control a clock object, similar to respective generic clock API calls:
> +v4l2_clk_get(), v4l2_clk_put(), v4l2_clk_enable(), v4l2_clk_disable(),
> +v4l2_clk_get_rate(), and v4l2_clk_set_rate(). Clock suppliers have to
> +provide clock operations, that will be called when clock users invoke

s/operations,/operations/

> respective API methods.

-- 
Regards,

Laurent Pinchart

