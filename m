Return-path: <linux-media-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:33046 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbZHXQRm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Aug 2009 12:17:42 -0400
Date: Mon, 24 Aug 2009 09:16:14 -0700
From: Greg KH <greg@kroah.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <j.w.r.degoede@hhs.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: How to handle devices sitting on multiple busses ?
Message-ID: <20090824161614.GA7893@kroah.com>
References: <200908241357.44562.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908241357.44562.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 24, 2009 at 01:57:44PM +0200, Laurent Pinchart wrote:
> Hi Greg,
> 
> while working on video input support for embedded platforms a few developers 
> including myself ran independently into a Linux device model issue. We all 
> came up with hackish solutions that we are not very happy with, and we'd like 
> to fix this in a clean way.
> 
> The problem comes from devices sitting on multiple busses, a situation 
> commonly found with video sensors connected to an embedded System on Chip 
> (SoC). The sensor is controlled through an I2C bus and sends video data on a 
> parallel video bus, connected to a camera controller usually referred as an 
> Image Signal Processor (ISP), Video Processing Front End (VPFE), CCD 
> Controller (CCDC) or simply a bridge.
> 
> The bridge and the I2C master controller on the SoC are completely independent 
> from each other. The I2C master controller is not dedicated to the video 
> function and is often used to communication with non-video I2C devices.
> 
> Unfortunately, on the sensor side, I2C and video bus are not independent. The 
> I2C slave controller usually requires an external clock to be present, and the 
> clock is usually provided on the video bus by the SoC bridge.
> 
> As the bridge and I2C master live their own life in the Linux device tree, 
> they are initialized, suspended, resumed and destroyed independently. The 
> sensor being an I2C slave device, Linux initializes it after the I2C master 
> device is initialized, but doesn't ensure that the bridge is initialized first 
> as well. A similar problem occurs during suspend/resume, as the I2C slave 
> needs to be suspended before and resumed after the video bridge.
> 
> Have you ever encountered such a situation before ?

No, not really.

> Is there a clean way for a device to have multiple parents, or do you
> have plans for such a possibility in the future ?

I do not know of any future plans to support something like this in the
driver core code, sorry.

> I would be willing to give an implementation a try if you can provide
> me with some guidelines.

Hm, I really don't know of any guidelines I can provide, as I've never
thought about this before :)

I really don't know what to suggest at the moment, sorry.

greg k-h
