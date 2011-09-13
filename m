Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:57580 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750798Ab1IMJHh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 05:07:37 -0400
From: Alain VOLMAT <alain.volmat@st.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 13 Sep 2011 11:07:02 +0200
Subject: RE: Questions regarding Devices/Subdevices/MediaController usage in
 case of a SoC
Message-ID: <E27519AE45311C49887BE8C438E68FAA0100DBC9948B@SAFEX1MAIL1.st.com>
References: <E27519AE45311C49887BE8C438E68FAA0100DBB53E71@SAFEX1MAIL1.st.com>
 <20110902213010.GF13242@valkosipuli.localdomain>
 <201109051210.19288.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201109051210.19288.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari, Hi Laurent,

Thanks for your replies. Sorry for taking so much time.

I don't have perfect graphs to explain our device but the following links helps a little.
Device as this one are targeted:    http://www.st.com/internet/imag_video/product/251021.jsp
Corresponding circuit diagram:      http://www.st.com/internet/com/TECHNICAL_RESOURCES/TECHNICAL_DIAGRAM/CIRCUIT_DIAGRAM/circuit_diagram_17848.pdf

Although the audio part will have to be addressed also at some point, I'm now focusing on the video part so it is the area above the ST-Bus INTERCONNECT.
Basically we have several kind of inputs (memory, HDMI, analog, frontends) and several kind of outputs (memory, graphic plane, video plane, dual ..)

Currently those kind of devices are already supported at some level via LinuxDVB/V4L2 drivers (those drivers are actually already available on the web) but they do not offer enough flexibility.
As you know those kind of devices can have several data path which were not easily configurable via LinuxDVB/V4L2 and that's the reason why we are now trying to move to a Subdev/Media Controller based implementation.
I actually discovered recently the presentation about the OMAP2+ Display Subsystem (DSS) (http://elinux.org/images/8/83/Elc2011_semwal.pdf). It is quite similar to what we have to do except that in case of the DSS, as the name says, it is about the display part only.
One difference with the DSS is that in our case, we do not feed directly the GFX/OVLs from the userspace (as framebuffer or video device) but they can ALSO be feed via data decoded by the hardware, coming from data pushed via LinuxDVB. To give you an example, we can pushed streams to be decoded via LinuxDVB, they are decoded, will receive all the necessary processing before "going out" as V4L2 capture devices (all this is done within the kernel and in some cases might never even come back to user space before being displayed on the display panel).
So going back to the graph of the DSS, in our case, in front of the GFX/OVLs, we'll have another set of subdevices that correspond to our decoders "capture device". And even before that (but not available as a subdevice/media controller entity), we have LinuxDVB inputs.

I will post you a graph to explain that more easily but need to have a bit more of internal paper work for that.

> In general, V4L2 device nodes should represent memory input / output for the
> device, or a DMA engine. The devices you are referring to above offer
> possibilities to write the data to memory in several points in the pipeline.
> Based on what you're writing above, it sounds like to me that your device
> should likely expose several V4L2 device nodes.

Ok, yes, since we can output / input data at various part of the device, we will have several device nodes.

Concerning the media controller, since we have 1 entity for each resource we can use, we should be able to have a whole bunch of entities(sub devices), attached to several video devices and to a single media device.

Talking now a bit more about legacy applications (application that are using V4L2 and thus need to have some "default" data path but do not know anything about the media controller), what is the intended way to handle them ? Should we have a "platform configuration" application that configure data path via the media controller in order to make those application happy ?
I kind of understood that there were some idea of plugin for libv4l in order to configure the media controller. Are there any useful document about this plugin thing are should I just dig into libv4l source code to have a better understanding of that ?

Regards,

Alain Volmat

-----Original Message-----
From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com] 
Sent: Monday, September 05, 2011 12:10 PM
To: Sakari Ailus
Cc: Alain VOLMAT; linux-media@vger.kernel.org
Subject: Re: Questions regarding Devices/Subdevices/MediaController usage in case of a SoC

Hi,

On Friday 02 September 2011 23:30:11 Sakari Ailus wrote:
> On Fri, Sep 02, 2011 at 11:38:06AM +0200, Alain VOLMAT wrote:
> > I'm writing you in order to have some advices in the design of the V4L2
> > driver for a rather complex device. It is mainly related to
> > device/subdev/media controller.
> > 
> > This driver would target SoCs which usually handle inputs (capture
> > devices, for ex LinuxDVB, HDMI capture), several layers of graphical or
> > video planes and outputs such as HDMI/analog. Basically we have 3 levels,
> > capture devices data being pushed onto planes and planes being mixed on
> > outputs. Moreover it is also possible to input or output datas from
> > several points of the device.
> 
> Do you have a graphical representation of the flow of data inside the
> device and memory inputs / outputs?

I second Sakari's request here. It would be much easier to advice you with a 
block diagram of your hardware.

> > The idea is to take advantage of the new MediaController in order to be
> > able to define internal data path by linking capture devices to layers
> > and layers to outputs. Since MediaController allows to link pads of
> > entities together, our understanding is that we need to have 1 subdevice
> > per hardware resource. That is if we have 2 planes, we will have 2
> > subdevices handling them. Same for outputs and capture. Is our
> > understanding correct ?
> 
> I think this dependes a little what are the capabilities of those hardware
> resources. If they contain several steps of complex image processing this
> might be the case. For example, the following diagram contains the OMAP 3
> ISP media controller graph:
> 
> <URL:http://www.ideasonboard.org/media/omap3isp.ps>
> 
> The graph represents a digital camera with sensor, lens and flash. The ISP
> (image signal processor) consists of several subdevs in the graph.
> 
> > A second point is now about the number of devices. I think we have 2 ways
> > #of doing that, and I would like to get your opinions about those 2 ways.
> > #1 Single device: I could think of a single device which expose several
> > inputs and outputs. We could enumerate them with VIDIOC_ENUM* and select
> > them using VIDIOC_S_*. After the selection, data exchange could be done
> > upon specifying a proper buffer type. The merit of such model is that an
> > application using such device would only have to access the single
> > available /dev/video0 for everything, without having to know if video0 is
> > for capture, video1 output and so on.
> > 
> > #2 Multiple device: In such case, each video device would only provide a
> > single (or small amount of similar) input or output. So several video
> > device nodes would be available to the application. Looking at some other
> > drivers around such as the OMAP4 ISP or Samsung S5P, it seems to be the
> 
> I believe you refer to OMAP 3, not 4?
> 
> > preferred way to go, is that correct ? This way also fit more in the V4L2
> > model of device type (Video capture device, video output device) since
> > way #1 would at last create a single big device which implement a mix of
> > all those devices.
> 
> In general, V4L2 device nodes should represent memory input / output for
> the device, or a DMA engine. The devices you are referring to above offer
> possibilities to write the data to memory in several points in the
> pipeline. Based on what you're writing above, it sounds like to me that
> your device should likely expose several V4L2 device nodes.

This is my opinion as well.

> > As far as the media controller is concerned, since all those resources
> > are not sharable, it seems proper to have only a single media entry
> > point in
> 
> The interface to user space should also be such that it doesn't place
> artificial limitations on what data paths can be used: the same driver
> should be usable without changes in all situations. Of course one might not
> implement each and every feature right away.
> 
> > order to setup the SoC and internal data path (and not abstract media to
> > match their video device counterpart)
> 
> I'm afraid I don't know enough to comment this. It would be quite helpful
> if you can provide more detailed information on the hardware.

-- 
Regards,

Laurent Pinchart
