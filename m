Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:39816 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab1IBVaT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2011 17:30:19 -0400
Date: Sat, 3 Sep 2011 00:30:11 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Alain VOLMAT <alain.volmat@st.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	laurent.pinchart@ideasonboard.com
Subject: Re: Questions regarding Devices/Subdevices/MediaController usage
 in case of a SoC
Message-ID: <20110902213010.GF13242@valkosipuli.localdomain>
References: <E27519AE45311C49887BE8C438E68FAA0100DBB53E71@SAFEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E27519AE45311C49887BE8C438E68FAA0100DBB53E71@SAFEX1MAIL1.st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 02, 2011 at 11:38:06AM +0200, Alain VOLMAT wrote:
> Hi,

Hi Alain,

> I'm writing you in order to have some advices in the design of the V4L2
> driver for a rather complex device. It is mainly related to
> device/subdev/media controller.
> 
> This driver would target SoCs which usually handle inputs (capture
> devices, for ex LinuxDVB, HDMI capture), several layers of graphical or
> video planes and outputs such as HDMI/analog. Basically we have 3 levels,
> capture devices data being pushed onto planes and planes being mixed on
> outputs. Moreover it is also possible to input or output datas from
> several points of the device.

Do you have a graphical representation of the flow of data inside the device
and memory inputs / outputs?

> The idea is to take advantage of the new MediaController in order to be
> able to define internal data path by linking capture devices to layers and
> layers to outputs. Since MediaController allows to link pads of entities
> together, our understanding is that we need to have 1 subdevice per
> hardware resource. That is if we have 2 planes, we will have 2 subdevices
> handling them. Same for outputs and capture. Is our understanding correct
> ?

I think this dependes a little what are the capabilities of those hardware
resources. If they contain several steps of complex image processing this
might be the case. For example, the following diagram contains the OMAP 3
ISP media controller graph:

<URL:http://www.ideasonboard.org/media/omap3isp.ps>

The graph represents a digital camera with sensor, lens and flash. The ISP
(image signal processor) consists of several subdevs in the graph.

> A second point is now about the number of devices. I think we have 2 ways
> #of doing that, and I would like to get your opinions about those 2 ways.
> #1 Single device: I could think of a single device which expose several
> inputs and outputs. We could enumerate them with VIDIOC_ENUM* and select
> them using VIDIOC_S_*. After the selection, data exchange could be done
> upon specifying a proper buffer type. The merit of such model is that an
> application using such device would only have to access the single
> available /dev/video0 for everything, without having to know if video0 is
> for capture, video1 output and so on.
> 
> #2 Multiple device: In such case, each video device would only provide a
> single (or small amount of similar) input or output. So several video
> device nodes would be available to the application. Looking at some other
> drivers around such as the OMAP4 ISP or Samsung S5P, it seems to be the

I believe you refer to OMAP 3, not 4?

> preferred way to go, is that correct ? This way also fit more in the V4L2
> model of device type (Video capture device, video output device) since way
> #1 would at last create a single big device which implement a mix of all
> those devices.

In general, V4L2 device nodes should represent memory input / output for the
device, or a DMA engine. The devices you are referring to above offer
possibilities to write the data to memory in several points in the pipeline.
Based on what you're writing above, it sounds like to me that your device
should likely expose several V4L2 device nodes.

> As far as the media controller is concerned, since all those resources are
> not sharable, it seems proper to have only a single media entry point in

The interface to user space should also be such that it doesn't place
artificial limitations on what data paths can be used: the same driver
should be usable without changes in all situations. Of course one might not
implement each and every feature right away.

> order to setup the SoC and internal data path (and not abstract media to
> match their video device counterpart)

I'm afraid I don't know enough to comment this. It would be quite helpful if
you can provide more detailed information on the hardware.

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
