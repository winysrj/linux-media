Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:52654 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751239AbdJEM1G (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Oct 2017 08:27:06 -0400
Date: Thu, 5 Oct 2017 09:26:51 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v5 1/7] media: add glossary.rst with a glossary of terms
 used at V4L2 spec
Message-ID: <20171005092651.0d1a1f90@recife.lan>
In-Reply-To: <20171005082107.i76vntyg5ku5hqr7@valkosipuli.retiisi.org.uk>
References: <cover.1503924361.git.mchehab@s-opensource.com>
        <65af989db9cc5479b863657add04940ae6de9d5c.1503924361.git.mchehab@s-opensource.com>
        <20170829074748.yldwq2gktgefzuaa@valkosipuli.retiisi.org.uk>
        <20170829100750.6852b64f@recife.lan>
        <20171005082107.i76vntyg5ku5hqr7@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 5 Oct 2017 11:21:07 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> My apologies for the late reply.
> 
> On Tue, Aug 29, 2017 at 10:07:50AM -0300, Mauro Carvalho Chehab wrote:
> > Em Tue, 29 Aug 2017 10:47:48 +0300
> > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> >   
> > > Hi Mauro,
> > > 
> > > Thanks for the update. A few comments below.
> > > 
> > > On Mon, Aug 28, 2017 at 09:53:55AM -0300, Mauro Carvalho Chehab wrote:  
> > > > Add a glossary of terms for V4L2, as several concepts are complex
> > > > enough to cause misunderstandings.
> > > > 
> > > > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > > > ---
> > > >  Documentation/media/uapi/v4l/glossary.rst | 147 ++++++++++++++++++++++++++++++
> > > >  Documentation/media/uapi/v4l/v4l2.rst     |   1 +
> > > >  2 files changed, 148 insertions(+)
> > > >  create mode 100644 Documentation/media/uapi/v4l/glossary.rst
> > > > 
> > > > diff --git a/Documentation/media/uapi/v4l/glossary.rst b/Documentation/media/uapi/v4l/glossary.rst
> > > > new file mode 100644
> > > > index 000000000000..0b6ab5adec81
> > > > --- /dev/null
> > > > +++ b/Documentation/media/uapi/v4l/glossary.rst
> > > > @@ -0,0 +1,147 @@
> > > > +========
> > > > +Glossary
> > > > +========
> > > > +
> > > > +.. note::
> > > > +
> > > > +   This goal of section is to standardize the terms used within the V4L2
> > > > +   documentation. It is written incrementally as they are standardized in
> > > > +   the V4L2 documentation. So, it is a Work In Progress.    
> > > 
> > > I'd leave the WiP part out.  
> > 
> > IMO, it is important to mention it, as the glossary, right now, covers
> > only what's used on the first two sections of the API book. There are
> > a lot more to be covered.  
> 
> Works for me.
> 
> >   
> > >   
> > > > +
> > > > +.. Please keep the glossary entries in alphabetical order
> > > > +
> > > > +.. glossary::
> > > > +
> > > > +    Bridge driver
> > > > +	The same as V4L2 main driver.    
> > > 
> > > I've understood bridges being essentially a bus receiver + DMA. Most ISPs
> > > contain both but have more than that. How about:
> > > 
> > > A driver for a bus (e.g. parallel, CSI-2) receiver and DMA. Bridge drivers
> > > typically act as V4L2 main drivers.  
> > 
> > No, only on some drivers the bridge driver has DMA. A vast amount of
> > drivers (USB ones) don't implement any DMA inside the driver, as it is
> > up to the USB host driver to implement support for DMA.
> > 
> > There are even some USB host drivers that don't always use DMA for I/O 
> > transfers, using direct I/O if the message is smaller than a threshold
> > or not multiple of the bus word. This is pretty common on SoC USB host
> > drivers.
> > 
> > In any case, for the effect of this spec, and for all discussions we
> > ever had about it, bridge driver == V4L2 main driver. I don't
> > see any reason why to distinguish between them.  
> 
> I think you should precisely define what a bridge driver means. Generally
> ISP drivers aren't referred to as bridge drivers albeit they, too, function
> as V4L2 main drivers.

It would be more productive if you could reply to the v7 of this patch
series with your suggestion for such definition.

IMHO, a bridge driver is a driver for a piece of hardware that allows
sending/receiving I2C control messages to a media hardware component,
but I'm likely ok with any other definition you have in mind.

> 
> >   
> > >   
> > > > +
> > > > +    Device Node
> > > > +	A character device node in the file system used to control and do
> > > > +	input/output data transfers from/to a Kernel driver.
> > > > +
> > > > +    Digital Signal Processor - DSP
> > > > +	A specialized microprocessor, with its architecture optimized for
> > > > +	the operational needs of digital signal processing.
> > > > +
> > > > +    Driver
> > > > +	The part of the Linux Kernel that implements support
> > > > +	for a hardware component.
> > > > +
> > > > +    Field-programmable Gate Array - FPGA
> > > > +	A field-programmable gate array (FPGA) is an integrated circuit
> > > > +	designed to be configured by a customer or a designer after
> > > > +	manufacturing.
> > > > +
> > > > +	See https://en.wikipedia.org/wiki/Field-programmable_gate_array.
> > > > +
> > > > +    Hardware component
> > > > +	A subset of the media hardware. For example an I²C or SPI device,
> > > > +	or an IP block inside an SoC or FPGA.
> > > > +
> > > > +    Hardware peripheral
> > > > +	A group of hardware components that together make a larger
> > > > +	user-facing functional peripheral. For instance the SoC ISP IP
> > > > +	cores and external camera sensors together make a
> > > > +	camera hardware peripheral.
> > > > +
> > > > +	Also known as peripheral.    
> > > 
> > > Aren't peripherals usually understood to be devices that you can plug into
> > > a computer? Such as a printer, or a... floppy drive?  
> > 
> > That is the common sense, although, technically, peripherals are any
> > I/O component. It is "peripheral" in the sense that it is not part of
> > the CPU's internal circuits. Instead, it is a data that should be sent
> > in or out the CPU. 
> > 
> > On such concept, even an I/O hardware integrated inside a SoC is a
> > peripheral.
> > 
> > Yet, Hans argued already against using it. I opened a separate
> > thread for us to discuss about it.
> >   
> > > I certainly wouldn't call this a peripheral. How about "aggregate device"?
> > > We haven't used that before, but I think it relatively well catches the
> > > meaning without being excessively elaborate.  
> > 
> > "aggregate device" means nothing to me ;-) I propose "media hardware" instead.  
> 
> Hardware is substance such as milk. You can't say "a milk".
> 
> Media hardware as such does not include suggestion that the components have
> something common that defines them. Aggregate device would. We don't use
> the term now because we haven't had one that refers to the entire device
> that consists of, well, devices. It'd explicitly refer a device consists of
> several devices rather than adding one more term used somewhat vaguely.
> 
> I wonder what Hans / Laurent think. (Cc Laurent.)

Hans was OK with "media hardware".

> 
> >   
> > >   
> > > > +
> > > > +    Hardware peripheral control
> > > > +	Type of control for a hardware peripheral supported by V4L2 drivers.
> > > > +
> > > > +	See :ref:`v4l2_hardware_control`.
> > > > +
> > > > +    Inter-Integrated Circuit - I²C
> > > > +	A  multi-master, multi-slave, packet switched, single-ended,
> > > > +	serial computer bus used to control V4L2 sub-devices.
> > > > +
> > > > +	See http://www.nxp.com/docs/en/user-guide/UM10204.pdf.
> > > > +
> > > > +    Integrated circuit - IC
> > > > +	A set of electronic circuits on one small flat piece of
> > > > +	semiconductor material, normally silicon.
> > > > +
> > > > +	Also known as chip.
> > > > +
> > > > +    IP block
> > > > +	The same as IP core.
> > > > +
> > > > +    Intelectual property core - IP core
> > > > +	In electronic design a semiconductor intellectual property core,
> > > > +	is a reusable unit of logic, cell, or integrated circuit layout
> > > > +	design that is the intellectual property of one party.
> > > > +	IP cores may be licensed to another party or can be owned
> > > > +	and used by a single party alone.
> > > > +
> > > > +	See https://en.wikipedia.org/wiki/Semiconductor_intellectual_property_core).
> > > > +
> > > > +    Image processor - ISP    
> > > 
> > > "Image signal processor"  
> > 
> > OK.
> >   
> > >   
> > > > +	A specialized digital signal processor used for image processing
> > > > +	in digital cameras, mobile phones or other devices.    
> > > 
> > > Traditional ISPs aren't programmable in the sense that you could execute
> > > code in them. Instead, they implement a set of image processing algorithms
> > > the parameters of which you can specify.  
> > 
> > That definition came directly from Wikipedia :-)  
> 
> I wonder whether the person (or persons) who wrote the article have worked
> on such hardware that is typically supported in V4L2. :-)

:-)


> > > How about:
> > > 
> > > A specialised processor that implements a set of algorithms for processing
> > > image data. ISPs may implement algorithms for lens shading correction,
> > > demosaic, scaling and pixel format conversion as well as produce statistics
> > > for the use of the control algorithms (e.g. automatic exposure, white
> > > balance and focus).  
> > 
> > Works for me.
> >   
> > >   
> > > > +
> > > > +    Peripheral
> > > > +	The same as hardware peripheral.    
> > > 
> > > Peripheral generally is a very seldom used term nowadays, perhaps because
> > > mostly you don't need to explicitly refer to external devices. I'd just
> > > leave it out.  
> > 
> > Let's discuss the usage of "peripheral" x "V4L2 hardware" x "media hardware".
> > 
> > Once we reach a consensus, I'll replace for whatever term we agree.
> >   
> > >   
> > > > +
> > > > +    Media Controller
> > > > +	An API used to identify the hardware components and (optionally)
> > > > +	change the links between hardware components.    
> > > 
> > > IMO glossary is not where optional and mandatory parts of APIs should be
> > > discussed. Just the scope. I.e. I'd leave "(optionally)" out. Change ->
> > > configure.  
> > 
> > IMO, glossary should provide a summary of all terms used, specially
> > the ones that are defined at the API itself.  
> 
> Yes, but that's orthogonal to what I wrote above.
> 
> >   
> > > The links are also between media entities, not hardware components. It is
> > > not uncommon that a driver for a hardware component exposes several
> > > sub-devices for the same component.  
> > 
> > The concept of entities, links, interfaces, etc should be added at
> > the glossary, but IMHO it is out of the current scope: this glossary
> > is only at the V4L2 part of the spec, with doesn't cover MC.
> > 
> > I'm OK if you want to expand it to cover the entire uAPI book, but
> > I don't have any time for doing it myself.
> > 
> > So, I would prefer to keep the definition here as simple as possible.
> > What about:
> > 
> > 	An API designed to expose and control devices and sub-devices
> > 	relationships to applications.
> > 
> > (that's basically a quick summary of what's written at 
> > media-controller-intro.rst)  
> 
> Works for me. I think it'd be useful to improve that in the future, but I
> think the glossary will be quite useful to define the terms used. During
> the review of the set it's become apparent that different people understand
> the terms we use regularly a bit differently.
> 
> >   
> > >   
> > > > +
> > > > +	See :ref:`media_controller`.
> > > > +
> > > > +    MC-centric
> > > > +	V4L2 hardware that requires a Media controller.
> > > > +
> > > > +	See :ref:`v4l2_hardware_control`.
> > > > +
> > > > +    Microprocessor
> > > > +	An electronic circuitry that carries out the instructions
> > > > +	of a computer program by performing the basic arithmetic, logical,
> > > > +	control and input/output (I/O) operations specified by the
> > > > +	instructions on a single integrated circuit.
> > > > +
> > > > +    SMBus
> > > > +	A subset of I²C, with defines a stricter usage of the bus.
> > > > +
> > > > +    Serial Peripheral Interface Bus - SPI    
> > > 
> > > We don't have "Bus" in I²C, I'd leave it out here, too.  
> > 
> > I2C is a serial bus (and it is implemented as a bus inside the Kernel).
> > Take a look at Documentation/i2c/summary.  
> 
> I don't disagree with that, but at the same time this is not related to my
> suggestion.
> 
> "Bus" is not part of the abbreviation SPI, therefore we should not suggest
> that here.

Ah, so you proposal here is just to replace:

	Serial Peripheral Interface Bus - SPI    

To
	Serial Peripheral Interface - SPI    

Right? If so, it sounds OK.

> 
> >   
> > > > +	Synchronous serial communication interface specification used for
> > > > +	short distance communication, primarily in embedded systems.
> > > > +
> > > > +    System on a Chip - SoC
> > > > +	An integrated circuit that integrates all components of a computer
> > > > +	or other electronic systems.
> > > > +
> > > > +    Sub-device hardware components
> > > > +	Hardware components that aren't controlled by the
> > > > +	V4L2 main driver.
> > > > +
> > > > +    V4L2 device node
> > > > +	A device node that is associated to a V4L2 main driver,
> > > > +	as specified in :ref:`v4l2_device_naming`.    
> > > 
> > > This will be confusing. Many sub-device nodes are exposed by so-called main
> > > drivers.  
> > 
> > The sub-device nodes are not listed at v4l2_device_naming chapter. Also,
> > as I mentioned, I'm adding a notice there explicitly excluding them
> > from "V4L2 device node".
> > 
> > Btw, I don't know why (and where) a main driver would also be
> > exporting a sub-device. That seems to be a violation of the subdev API.
> >   
> > > I'd understand this as any device node type that is exposed by V4L2. In
> > > general there should not be limitation on this, although video device nodes
> > > are effectively only exposed by main drivers.  
> > 
> > The goal of the glossary (and other changes in this series) is to
> > differentiate what is:
> > 
> > 	- V4L2 device node - e. g. /dev/video, /dev/radio, /dev/swradio,
> > 	  /dev/vbi, /dev/v4l-touch (and only those)
> > 	- V4L2 sub-device node - e. g. /dev/v4l-subdev.
> > 
> > If you think this is not enough, we could repeat the above info, although,
> > IMHO, it is better to add refs to the right chapters, in order to avoid
> > the need of touching the glossary every time we add a new V4L2 device
> > node.  
> 
> Yes, it'd easily become quite long. Yes, I think the reference is good for
> now.
> 
> >   
> > >   
> > > > +
> > > > +    V4L2 hardware
> > > > +	A hardware used to on a media device supported by the V4L2
> > > > +	subsystem.
> > > > +
> > > > +    V4L2 hardware control
> > > > +	The type of hardware control that a device supports.
> > > > +
> > > > +	See :ref:`v4l2_hardware_control`.
> > > > +
> > > > +    V4L2 main driver
> > > > +	The V4L2 device driver that implements the main logic to talk with
> > > > +	the V4L2 hardware.
> > > > +
> > > > +	Also known as bridge driver.    
> > > 
> > > Is UVC driver a bridge driver? How about instead:  
> > 
> > Yes, sure: UVC driver is a bridge driver/main driver. It is the UVC driver
> > that sends/receives data from the USB bus and send to the sensors.
> > It also sends data via URB to the USB host driver, with, in turn send it
> > to send to CPU (usually via DMA - although some USB drivers actually 
> > implement direct I/O for short messages).
> >   
> > > Bridge and ISP drivers typically are V4L2 main drivers.  
> > 
> > We don't have a concept of an "ISP driver". Adding it sounds very  
> 
> I think we do have that roughly as much as we do have bridge driver. We
> definitely also support devices that are called ISPs, therefore we do have
> ISP drivers.

We have drivers for things implemented via ISP. However, right now,
there's no distinction at the driver if the functionality is implemented
on software (ISP) or in hardware. 

> 
> > confusing, as an ISP hardware may actually implement different
> > functions - so it ends by being supported by multiple drivers.  
> 
> Typically ISPs are controlled by a single driver as the sub-blocks in an
> ISP usually can only be found in that very ISP.

I'm almost sure that this is not true for Exynos drivers. There are
m2m drivers and normal drivers for the same ISP (doing different things,
like format conversion, scaling, etc).

> 
> >   
> > > > +
> > > > +	See :ref:`v4l2_hardware_control`.
> > > > +
> > > > +    V4L2 sub-device
> > > > +	Part of the media hardware that it is implemented by a device
> > > > +	driver that is not part of the main V4L2 driver.    
> > > 
> > > How about:
> > > 
> > > V4L2 abstraction for a hardware component which is functionally or
> > > physically separate from the DMA engine.  
> > 
> > That's actually not true. On vdev-centric devices, common ISP
> > controls (bright, color, saturation, etc) are actually implemented
> > by the main V4L2 driver.
> > 
> > Also, on USB drivers, the DMA engine is actually not implemented
> > by the main driver, but by the USB host driver.  
> 
> Right, that's true indeed. 
> 



Thanks,
Mauro
