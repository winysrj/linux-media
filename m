Return-path: <mchehab@pedra>
Received: from mga11.intel.com ([192.55.52.93]:48513 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903Ab1DFRFq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Apr 2011 13:05:46 -0400
Date: Wed, 6 Apr 2011 19:05:38 +0200
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
Message-ID: <20110406170537.GB2757@sortiz-mobl>
References: <20110331230522.GI437@ponder.secretlab.ca>
 <20110401112030.GA3447@sortiz-mobl>
 <20110401104756.2f5c6f7a@debxo>
 <BANLkTi=bCd_+f=EG-O=U5VH_ZNjFhxkziQ@mail.gmail.com>
 <20110401235239.GE29397@sortiz-mobl>
 <BANLkTi=bq=OGzXFp7qiBr7x_BnGOWf=DRQ@mail.gmail.com>
 <20110404100314.GC2751@sortiz-mobl>
 <20110405030428.GB29522@ponder.secretlab.ca>
 <20110406152322.GA2757@sortiz-mobl>
 <20110406155805.GA20095@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110406155805.GA20095@suse.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Greg,

On Wed, Apr 06, 2011 at 08:58:05AM -0700, Greg KH wrote:
> On Wed, Apr 06, 2011 at 05:23:23PM +0200, Samuel Ortiz wrote:
> > --- a/include/linux/device.h
> > +++ b/include/linux/device.h
> > @@ -33,6 +33,7 @@ struct class;
> >  struct subsys_private;
> >  struct bus_type;
> >  struct device_node;
> > +struct mfd_cell;
> >  
> >  struct bus_attribute {
> >  	struct attribute	attr;
> > @@ -444,6 +445,8 @@ struct device {
> >  	struct device_node	*of_node; /* associated device tree node */
> >  	const struct of_device_id *of_match; /* matching of_device_id from driver */
> >  
> > +	struct mfd_cell	*mfd_cell; /* MFD cell pointer */
> > +
> 
> What is a "MFD cell pointer" and why is it needed in struct device?
An MFD cell is an MFD instantiated device.
MFD (Multi Function Device) drivers instantiate platform devices. Those
devices drivers sometimes need a platform data pointer, sometimes an MFD
specific pointer, and sometimes both. Also, some of those drivers have been
implemented as MFD sub drivers, while others know nothing about MFD and just
expect a plain platform_data pointer.

We've been faced with the problem of being able to pass both MFD related data
and a platform_data pointer to some of those drivers. Squeezing the MFD bits
in the sub driver platform_data pointer doesn't work for drivers that know
nothing about MFDs. It also adds an additional dependency on the MFD API to
all MFD sub drivers. That prevents any of those drivers to eventually be used
as plain platform device drivers.
So, adding an MFD cell pointer to the device structure allows us to cleanly
pass both pieces of information, while keeping all the MFD sub drivers
independant from the MFD core if they want/can.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
