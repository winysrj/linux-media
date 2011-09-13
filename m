Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49950 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab1IMKu0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 06:50:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Alain VOLMAT <alain.volmat@st.com>
Subject: Re: Questions regarding Devices/Subdevices/MediaController usage in case of a SoC
Date: Tue, 13 Sep 2011 12:50:22 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <E27519AE45311C49887BE8C438E68FAA0100DBB53E71@SAFEX1MAIL1.st.com> <201109051210.19288.laurent.pinchart@ideasonboard.com> <E27519AE45311C49887BE8C438E68FAA0100DBC9948B@SAFEX1MAIL1.st.com>
In-Reply-To: <E27519AE45311C49887BE8C438E68FAA0100DBC9948B@SAFEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109131250.22346.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alain,

On Tuesday 13 September 2011 11:07:02 Alain VOLMAT wrote:
> Hi Sakari, Hi Laurent,
> 
> Thanks for your replies. Sorry for taking so much time.
> 
> I don't have perfect graphs to explain our device but the following links
> helps a little. Device as this one are targeted:   
> http://www.st.com/internet/imag_video/product/251021.jsp Corresponding
> circuit diagram:     
> http://www.st.com/internet/com/TECHNICAL_RESOURCES/TECHNICAL_DIAGRAM/CIRCU
> IT_DIAGRAM/circuit_diagram_17848.pdf
> 
> Although the audio part will have to be addressed also at some point, I'm
> now focusing on the video part so it is the area above the ST-Bus
> INTERCONNECT. Basically we have several kind of inputs (memory, HDMI,
> analog, frontends) and several kind of outputs (memory, graphic plane,
> video plane, dual ..)
> 
> Currently those kind of devices are already supported at some level via
> LinuxDVB/V4L2 drivers (those drivers are actually already available on the
> web) but they do not offer enough flexibility. As you know those kind of
> devices can have several data path which were not easily configurable via
> LinuxDVB/V4L2 and that's the reason why we are now trying to move to a
> Subdev/Media Controller based implementation. I actually discovered
> recently the presentation about the OMAP2+ Display Subsystem (DSS)
> (http://elinux.org/images/8/83/Elc2011_semwal.pdf). It is quite similar to
> what we have to do except that in case of the DSS, as the name says, it is
> about the display part only. One difference with the DSS is that in our
> case, we do not feed directly the GFX/OVLs from the userspace (as
> framebuffer or video device) but they can ALSO be feed via data decoded by
> the hardware, coming from data pushed via LinuxDVB. To give you an
> example, we can pushed streams to be decoded via LinuxDVB, they are
> decoded, will receive all the necessary processing before "going out" as
> V4L2 capture devices (all this is done within the kernel and in some cases
> might never even come back to user space before being displayed on the
> display panel). So going back to the graph of the DSS, in our case, in
> front of the GFX/OVLs, we'll have another set of subdevices that
> correspond to our decoders "capture device". And even before that (but not
> available as a subdevice/media controller entity), we have LinuxDVB
> inputs.
> 
> I will post you a graph to explain that more easily but need to have a bit
> more of internal paper work for that.

Thank you for the information. The hardware looks quite complex indeed, and I 
believe using the media controller would be a good solution.

> > In general, V4L2 device nodes should represent memory input / output for
> > the device, or a DMA engine. The devices you are referring to above
> > offer possibilities to write the data to memory in several points in the
> > pipeline. Based on what you're writing above, it sounds like to me that
> > your device should likely expose several V4L2 device nodes.
> 
> Ok, yes, since we can output / input data at various part of the device, we
> will have several device nodes.
> 
> Concerning the media controller, since we have 1 entity for each resource
> we can use, we should be able to have a whole bunch of entities(sub
> devices), attached to several video devices and to a single media device.

That looks good to me.

> Talking now a bit more about legacy applications (application that are
> using V4L2 and thus need to have some "default" data path but do not know
> anything about the media controller), what is the intended way to handle
> them ? Should we have a "platform configuration" application that
> configure data path via the media controller in order to make those
> application happy ? I kind of understood that there were some idea of
> plugin for libv4l in order to configure the media controller.

If you can configure your hardware with a default pipeline at startup that's 
of course good, but as soon as a media controller-aware application will 
modify the pipeline pure V4L2 applications will be stuck.

For that reason implementing pipeline configuration support in a libv4l plugin 
for pure V4L2 applications has my preference. The idea is that high-level V4L2 
applications (such as a popular closed-source video-conferencing application 
that people seem to like for a reason I can't fathom :-)) should work with 
that plugin, and the high-level features they expect should be provided.

> Are there any useful document about this plugin thing are should I just dig
> into libv4l source code to have a better understanding of that ?

Sakari, do you know if the libv4l plugin API is documented ? Do you have a 
link to the OMAP3 ISP libv4l plugin ?

-- 
Regards,

Laurent Pinchart
