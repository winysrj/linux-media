Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:57771 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab1CCHZa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2011 02:25:30 -0500
Date: Thu, 3 Mar 2011 08:25:24 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: isp or soc-camera for image co-processors
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384DF0A71A63@EAPEX1MAIL1.st.com>
Message-ID: <Pine.LNX.4.64.1103030807450.31639@axis700.grange>
References: <D5ECB3C7A6F99444980976A8C6D896384DEFA5983D@EAPEX1MAIL1.st.com>
 <201103011041.03424.laurent.pinchart@ideasonboard.com>
 <D5ECB3C7A6F99444980976A8C6D896384DEFA598FC@EAPEX1MAIL1.st.com>
 <201103011110.06258.laurent.pinchart@ideasonboard.com>
 <D5ECB3C7A6F99444980976A8C6D896384DEFA5998E@EAPEX1MAIL1.st.com>
 <4D6E2233.6090602@maxwell.research.nokia.com>
 <D5ECB3C7A6F99444980976A8C6D896384DF0A71A63@EAPEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bhupesh

On Thu, 3 Mar 2011, Bhupesh SHARMA wrote:

> Hi Sakari, Laurent and Guennadi,
> 
> > -----Original Message-----
> > From: Sakari Ailus [mailto:sakari.ailus@maxwell.research.nokia.com]
> > Sent: Wednesday, March 02, 2011 4:26 PM
> > To: Bhupesh SHARMA
> > Cc: Laurent Pinchart; Guennadi Liakhovetski; linux-
> > media@vger.kernel.org
> > Subject: Re: isp or soc-camera for image co-processors
> > 
> > Hi Bhupesh and Laurent,
> > 
> > Bhupesh SHARMA wrote:
> > ...
> > >> Try to configure your mailer to use spaces instead of tabs, or to
> > make
> > >> tabs 8
> > >> spaces wide. It should then look good. Replies will usually mess the
> > >> diagrams
> > >> up though.
> > >
> > > Ok, I will try it :)
> > 
> > Attachments are usually safe as well.
> 
> Please find attached a top level diagram of the system.
> One thing to note here is that the soc itself has a camera
> interface IP that supports ITU interface. As the co-processor
> supports both ITU and CSI-2 interface, it should not be a problem
> to connect the two via ITU interface.
> 
> > ...
> > 
> > >>> Are there are reference drivers that I can use for my study?
> > >>
> > >> The OMAP3 ISP driver.
> > >
> > > Thanks, I will go through the same.
> > 
> > The major difference in this to OMAP 3 is that the OMAP 3 does have
> > access to host side memory but the co-processor doesn't --- as it's a
> > CSI-2 link.
> > 
> > Additional CSI-2 receiver (and a driver for it) is required on the host
> > side. This receiver likely is not dependent on the co-processor so the
> > driver shouldn't be either.
> > 
> > For example, using this co-processor should well be possible with the
> > OMAP 3 ISP, in theory at least. What would be needed in this case is...
> > support for multiple complex Media device drivers under a single Media
> > device --- both drivers would be accessible through the same media
> > device.
> > 
> > The co-processor would mostly look like a sensor for the OMAP 3 ISP
> > driver. Its internal topology would be more complex, though.
> > 
> > Just a few ideas; what do you think of this? :-)
> 
> Yes, but I think I need to explain the system design better :
> One, there is an camera interface IP within the SOC as well which 
> has an internal buffer to store a line of image data and dma capabilities
> to send this data to system ddr.
> 
> So, co-processor has no access to system MMU or buffers inside the main SoC,
> but it has internal buffer to store data. It is connected via either a ITU or
> CSI-2 interface to the SoC. This is the primary and major difference between our
> architecture and OMAP 3 ISP.
> 
> As I read more the OMAP 3 TRM, I wonder whether SoC framework fits better
> in our case, as we have three separate entities to consider here:
> 	- Camera Host inside the SoC
> 	- Camera Co-processor connected with host via CSI-2/ITU (data interface)
> 	  and I2C/CCI (control interface)
> 	- Camera sensor connected to the co-processor via CSI-2 (data interface)
> 	  and I2C/CCI (control interface)
> What are your views?
> Guennadi can you also pitch in with your thoughts..

The soc-camera interface used to provide two things: (1) a standard API 
between "camera hosts" (video interfaces on SoCs) amd "camera clients" 
(camera sensors, TV decoders,...), and (2) a number of helper functions to 
handle format enumeration, simplify control handling (this is being 
replaced by a more generic API), and provide a bus-configuration 
framework. It also takes over file operations and a couple other common 
functions. Currently, given the v4l2-subdev API, the new control framework 
and the approaching Media Controller API there is not much left, that the 
soc-camera framework is still _adding_ to the standard v4l2 functionality, 
maybe just format enumeration and bus-parameter negotiation.

Further, soc-camera is not very well suited for multi-component designs 
with more than 2 components. It is possible, like I've done with the CSI2 
interface on sh-mobile, but you inherit the limitation of the current v4l2 
API: all these components are controlled over just one device node in the 
user-space, so, it becomes difficult to let the user configure conponents 
separately. This problem is eliminated by the Media Controller API, which 
gives you access to each subdevice separately from the user-space.

At some point in the future soc-camera will also be converted to the MC 
API, but until that's done, using it for complex designs like yours will 
remain difficult, at least because you'll only get one device node for 
your user-space applications. I think, the MC API provides more important 
advantages to your situation, than the soc-camera framework. Of course, if 
you want to use any of its functionality, feel free to become creative and 
combine the two or even do the soc-camera to MC porting yourself;)

Thanks
Guennadi

> 
> I fear that neither soc-camera  nor media framework have support
> for 3 entities listed above, as of now.
> 
> > >>> Unfortunately the data-sheet of the co-processor cannot be made
> > >> public
> > >>> as of yet.
> > >>
> > >> Can you publish a block diagram of the co-processor internals ?
> > >
> > > I will check internally to see if I can send a block-diagram
> > > of the co-processor internals to you. The internals seem similar to
> > 
> > I'd be very interested in this as well, thank you.
> 
> I have raised a request internally to enquire about the same :)
> 
> > > OMAP ISP (which I can see from the public TRM). However, our
> > > co-processor doesn't have the circular buffer and MMU that ISP seem
> > to
> > > have (and some other features).
> > >
> > > In the meantime I copy the features of the co-processor here for your
> > review:
> > >
> > > Input / Output interfaces of co-processor:
> > > ==========================================
> > > - Sensor interfaces: 2 x MIPI CSI-2 receivers (1 x dual-lane up to
> > 1.6 Gbit/s
> > >  and 1 x single lane up to 800 Mbit/s)
> > > - Host interface: MIPI CSI-2 dual lane transmitter (up to 1.6 Gbit/s)
> > or ITU
> > >  (8-bit CCIR interface, up to 100 MHz) - all with independent
> > variable
> > >  transmitter clock (PLL)
> > > - Control interface: CCI (up to 400 kHz) or SPI
> > >
> > > Sensor support:
> > > ===============
> > > - Supports two MIPI compliant sensors of up to 8 Megapixel resolution
> > >  (one sensor streaming at a time)
> > > - Support for auto-focus (AF), extended depth of field (EDOF) and
> > wide dynamic
> > >  range (WDR)sensors
> > >
> > > Internal Features:
> > > ==================
> > > - Versatile clock manager and internal buffer to accommodate a wide
> > range of data rates
> > >   between sensors and the coprocessor and between the coprocessor and
> > the host.
> > > - Synchronized flash gun control with red-eye reduction (pre-flash
> > and main-flash strobes) for
> > >   high-power LED or Xenon strobe light
> > 
> > Does the co-processor have internal memory or can external memory be
> > attached to it for buffer storage?
> > 
> 
> The co-processor has no access to system MMU or buffers inside the main SoC,
> but it has internal buffer to store data.
> 
> Regards,
> Bhupesh
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
