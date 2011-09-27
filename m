Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:46978 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab1I0HyL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 03:54:11 -0400
Date: Tue, 27 Sep 2011 10:54:06 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Alain VOLMAT <alain.volmat@st.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Questions regarding Devices/Subdevices/MediaController usage
 in case of a SoC
Message-ID: <20110927075214.GB5599@valkosipuli.localdomain>
References: <E27519AE45311C49887BE8C438E68FAA0100DBB53E71@SAFEX1MAIL1.st.com>
 <20110902213010.GF13242@valkosipuli.localdomain>
 <201109051210.19288.laurent.pinchart@ideasonboard.com>
 <E27519AE45311C49887BE8C438E68FAA0100DBC9948B@SAFEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E27519AE45311C49887BE8C438E68FAA0100DBC9948B@SAFEX1MAIL1.st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alain VOLMAT wrote:
> Hi Sakari, Hi Laurent,

Hi Alain,

> Thanks for your replies. Sorry for taking so much time.

The same on my side. I finally had time to take a look again.

> I don't have perfect graphs to explain our device but the following
> links helps a little. Device as this one are targeted:
> http://www.st.com/internet/imag_video/product/251021.jsp 
> Corresponding circuit diagram:
> http://www.st.com/internet/com/TECHNICAL_RESOURCES/TECHNICAL_DIAGRAM/CIRCUIT_DIAGRAM/circuit_diagram_17848.pdf

This looks like a complex device indeed which makes it perfect to be
supported on the Media controller interface. :-)

>  Although the audio part will have to be addressed also at some
> point, I'm now focusing on the video part so it is the area above the
> ST-Bus INTERCONNECT. Basically we have several kind of inputs
> (memory, HDMI, analog, frontends) and several kind of outputs
> (memory, graphic plane, video plane, dual ..)

I agree that's a good approach. One problem at a time.

> Currently those kind of devices are already supported at some level
> via LinuxDVB/V4L2 drivers (those drivers are actually already
> available on the web) but they do not offer enough flexibility. As
> you know those kind of devices can have several data path which were
> not easily configurable via LinuxDVB/V4L2 and that's the reason why
> we are now trying to move to a Subdev/Media Controller based
> implementation. I actually discovered recently the presentation about
> the OMAP2+ Display Subsystem (DSS)
> (http://elinux.org/images/8/83/Elc2011_semwal.pdf). It is quite
> similar to what we have to do except that in case of the DSS, as the
> name says, it is about the display part only. One difference with the
> DSS is that in our case, we do not feed directly the GFX/OVLs from
> the userspace (as framebuffer or video device) but they can ALSO be
> feed via data decoded by the hardware, coming from data pushed via
> LinuxDVB. To give you an example, we can pushed streams to be decoded
> via LinuxDVB, they are decoded, will receive all the necessary
> processing before "going out" as V4L2 capture devices (all this is
> done within the kernel and in some cases might never even come back
> to user space before being displayed on the display panel). So going
> back to the graph of the DSS, in our case, in front of the GFX/OVLs,
> we'll have another set of subdevices that correspond to our decoders
> "capture device". And even before that (but not available as a
> subdevice/media controller entity), we have LinuxDVB inputs.

The media device should include all the hardware devices which may transfer
the image data between them, without going through memory in between. Based
on the graph, it seems that most would belong under a single device.

It might make sense to implement a driver that just handles the pipeline
configuration and interacting with the hardware devices. Laurent might
actually have a better idea on this.

All the actual hardware drivers providing the V4L2 intereface could then
provide the V4L2 subdev to the main driver. Beyond that, it needs to be
defined what kind of interfaces are provided to user space by media
entities that are not V4L2 subdevs. This depends on what kind of user
space APIs, what kind of entity level configuration and what streaming
configuration must be supported.

W2ht else is needed than LinuxDVB besides the V4L2?

> I will post you a graph to explain that more easily but need to have
> a bit more of internal paper work for that.
> 
>> In general, V4L2 device nodes should represent memory input /
>> output for the device, or a DMA engine. The devices you are
>> referring to above offer possibilities to write the data to memory
>> in several points in the pipeline. Based on what you're writing
>> above, it sounds like to me that your device should likely expose
>> several V4L2 device nodes.
> 
> Ok, yes, since we can output / input data at various part of the
> device, we will have several device nodes.
> 
> Concerning the media controller, since we have 1 entity for each
> resource we can use, we should be able to have a whole bunch of
> entities(sub devices), attached to several video devices and to a
> single media device.
> 
> Talking now a bit more about legacy applications (application that
> are using V4L2 and thus need to have some "default" data path but do
> not know anything about the media controller), what is the intended
> way to handle them ? Should we have a "platform configuration"
> application that configure data path via the media controller in
> order to make those application happy ? I kind of understood that
> there were some idea of plugin for libv4l in order to configure the
> media controller. Are there any useful document about this plugin
> thing are should I just dig into libv4l source code to have a better
> understanding of that ?

Such plugin does not exist yet, but a few pieces exist already: libmediactl,
libv4l2subdev and the libv4l plugin patches:

<URL:http://www.mail-archive.com/linux-media@vger.kernel.org/msg31596.html>

Essentially the configuration parsing should be part of the libraries rather
than the media-ctl test program. I'm working on patches to fix that.

Regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
