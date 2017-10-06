Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59008 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750815AbdJFIPm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Oct 2017 04:15:42 -0400
Date: Fri, 6 Oct 2017 11:15:38 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v5 1/7] media: add glossary.rst with a glossary of terms
 used at V4L2 spec
Message-ID: <20171006081534.aomp7ymloe5y5m6a@valkosipuli.retiisi.org.uk>
References: <cover.1503924361.git.mchehab@s-opensource.com>
 <65af989db9cc5479b863657add04940ae6de9d5c.1503924361.git.mchehab@s-opensource.com>
 <20170829074748.yldwq2gktgefzuaa@valkosipuli.retiisi.org.uk>
 <20170829100750.6852b64f@recife.lan>
 <20171005082107.i76vntyg5ku5hqr7@valkosipuli.retiisi.org.uk>
 <20171005092651.0d1a1f90@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171005092651.0d1a1f90@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thu, Oct 05, 2017 at 09:26:51AM -0300, Mauro Carvalho Chehab wrote:
> > > > > +
> > > > > +	See :ref:`media_controller`.
> > > > > +
> > > > > +    MC-centric
> > > > > +	V4L2 hardware that requires a Media controller.
> > > > > +
> > > > > +	See :ref:`v4l2_hardware_control`.
> > > > > +
> > > > > +    Microprocessor
> > > > > +	An electronic circuitry that carries out the instructions
> > > > > +	of a computer program by performing the basic arithmetic, logical,
> > > > > +	control and input/output (I/O) operations specified by the
> > > > > +	instructions on a single integrated circuit.
> > > > > +
> > > > > +    SMBus
> > > > > +	A subset of I²C, with defines a stricter usage of the bus.
> > > > > +
> > > > > +    Serial Peripheral Interface Bus - SPI    
> > > > 
> > > > We don't have "Bus" in I²C, I'd leave it out here, too.  
> > > 
> > > I2C is a serial bus (and it is implemented as a bus inside the Kernel).
> > > Take a look at Documentation/i2c/summary.  
> > 
> > I don't disagree with that, but at the same time this is not related to my
> > suggestion.
> > 
> > "Bus" is not part of the abbreviation SPI, therefore we should not suggest
> > that here.
> 
> Ah, so you proposal here is just to replace:
> 
> 	Serial Peripheral Interface Bus - SPI    
> 
> To
> 	Serial Peripheral Interface - SPI    
> 
> Right? If so, it sounds OK.

Yes, please. That's exactly what I had in mind.

...

> > > > > +    V4L2 hardware
> > > > > +	A hardware used to on a media device supported by the V4L2
> > > > > +	subsystem.
> > > > > +
> > > > > +    V4L2 hardware control
> > > > > +	The type of hardware control that a device supports.
> > > > > +
> > > > > +	See :ref:`v4l2_hardware_control`.
> > > > > +
> > > > > +    V4L2 main driver
> > > > > +	The V4L2 device driver that implements the main logic to talk with
> > > > > +	the V4L2 hardware.
> > > > > +
> > > > > +	Also known as bridge driver.    
> > > > 
> > > > Is UVC driver a bridge driver? How about instead:  
> > > 
> > > Yes, sure: UVC driver is a bridge driver/main driver. It is the UVC driver
> > > that sends/receives data from the USB bus and send to the sensors.
> > > It also sends data via URB to the USB host driver, with, in turn send it
> > > to send to CPU (usually via DMA - although some USB drivers actually 
> > > implement direct I/O for short messages).
> > >   
> > > > Bridge and ISP drivers typically are V4L2 main drivers.  
> > > 
> > > We don't have a concept of an "ISP driver". Adding it sounds very  
> > 
> > I think we do have that roughly as much as we do have bridge driver. We
> > definitely also support devices that are called ISPs, therefore we do have
> > ISP drivers.
> 
> We have drivers for things implemented via ISP. However, right now,
> there's no distinction at the driver if the functionality is implemented
> on software (ISP) or in hardware. 
> 
> > 
> > > confusing, as an ISP hardware may actually implement different
> > > functions - so it ends by being supported by multiple drivers.  
> > 
> > Typically ISPs are controlled by a single driver as the sub-blocks in an
> > ISP usually can only be found in that very ISP.
> 
> I'm almost sure that this is not true for Exynos drivers. There are
> m2m drivers and normal drivers for the same ISP (doing different things,
> like format conversion, scaling, etc).

I don't know the Exynos hardware. There are exceptions but they tend to be
increasingly rare as extra memory hops hurt performance and increase power
consumption in common use cases.

If there is a split to multiple devices, then usually the first device is
CSI-2 receiver plus DMA (bridge) and the second is the ISP (i.e. where the
processing happens).

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
