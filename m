Return-path: <mchehab@pedra>
Received: from mga14.intel.com ([143.182.124.37]:1646 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756470Ab1DFSrr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Apr 2011 14:47:47 -0400
Date: Wed, 6 Apr 2011 20:47:34 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Greg KH <gregkh@suse.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
	Andres Salomon <dilinger@queued.net>,
	linux-kernel@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	khali@linux-fr.org, ben-linux@fluff.org,
	Peter Korsgaard <jacmet@sunsite.dk>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	David Brownell <dbrownell@users.sourceforge.net>,
	linux-i2c@vger.kernel.org, linux-media@vger.kernel.org,
	netdev@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
	Mocean Laboratories <info@mocean-labs.com>
Subject: Re: [PATCH 07/19] timberdale: mfd_cell is now implicitly available
 to drivers
Message-ID: <20110406184733.GD2757@sortiz-mobl>
References: <20110401104756.2f5c6f7a@debxo>
 <BANLkTi=bCd_+f=EG-O=U5VH_ZNjFhxkziQ@mail.gmail.com>
 <20110401235239.GE29397@sortiz-mobl>
 <BANLkTi=bq=OGzXFp7qiBr7x_BnGOWf=DRQ@mail.gmail.com>
 <20110404100314.GC2751@sortiz-mobl>
 <20110405030428.GB29522@ponder.secretlab.ca>
 <20110406152322.GA2757@sortiz-mobl>
 <20110406155805.GA20095@suse.de>
 <20110406170537.GB2757@sortiz-mobl>
 <20110406175647.GA8048@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110406175647.GA8048@suse.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Apr 06, 2011 at 10:56:47AM -0700, Greg KH wrote:
> On Wed, Apr 06, 2011 at 07:05:38PM +0200, Samuel Ortiz wrote:
> > Hi Greg,
> > 
> > On Wed, Apr 06, 2011 at 08:58:05AM -0700, Greg KH wrote:
> > > On Wed, Apr 06, 2011 at 05:23:23PM +0200, Samuel Ortiz wrote:
> > > > --- a/include/linux/device.h
> > > > +++ b/include/linux/device.h
> > > > @@ -33,6 +33,7 @@ struct class;
> > > >  struct subsys_private;
> > > >  struct bus_type;
> > > >  struct device_node;
> > > > +struct mfd_cell;
> > > >  
> > > >  struct bus_attribute {
> > > >  	struct attribute	attr;
> > > > @@ -444,6 +445,8 @@ struct device {
> > > >  	struct device_node	*of_node; /* associated device tree node */
> > > >  	const struct of_device_id *of_match; /* matching of_device_id from driver */
> > > >  
> > > > +	struct mfd_cell	*mfd_cell; /* MFD cell pointer */
> > > > +
> > > 
> > > What is a "MFD cell pointer" and why is it needed in struct device?
> > An MFD cell is an MFD instantiated device.
> > MFD (Multi Function Device) drivers instantiate platform devices. Those
> > devices drivers sometimes need a platform data pointer, sometimes an MFD
> > specific pointer, and sometimes both. Also, some of those drivers have been
> > implemented as MFD sub drivers, while others know nothing about MFD and just
> > expect a plain platform_data pointer.
> 
> That sounds like a bug in those drivers, why not fix them to properly
> pass in the correct pointer?
Because they're drivers for generic IPs, not MFD ones. By forcing them to use
MFD specific structure and APIs, we make it more difficult for platform code
to instantiate them.
The timberdale MFD for example is built with a Xilinx SPI controller, and a
Micrel ks8842 ethernet switch IP. Forcing those devices into being MFD devices
would mean any platform willing to instantiate them would have to use the MFD
APIs. That sounds a bit artificial to me.
Although there is currently no drivers instantiated by both an MFD driver
and some platform code, Grant complaint about the Xilinx SPI driver moving
from a platform driver to an MFD one makes sense to me. 

> > So, adding an MFD cell pointer to the device structure allows us to cleanly
> > pass both pieces of information, while keeping all the MFD sub drivers
> > independant from the MFD core if they want/can.
> 
> They shouldn't be "independant", 
Excuse my poor spelling.

> make them "dependant" and go from there.
That's what the code currently does.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
