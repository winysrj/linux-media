Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:53327 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753226Ab3JBOWw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Oct 2013 10:22:52 -0400
Date: Wed, 2 Oct 2013 10:22:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: Xenia Ragiadakou <burzalodowa@gmail.com>,
	<linux-usb@vger.kernel.org>, <linux-input@vger.kernel.org>,
	<linux-media@vger.kernel.org>
Subject: Re: New USB core API to change interval and max packet size
In-Reply-To: <20131001204554.GB15395@xanatos>
Message-ID: <Pine.LNX.4.44L0.1310021007110.1293-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 1 Oct 2013, Sarah Sharp wrote:

> > When you say a new API, what do you mean? New functions in usbcore
> > to be used by usb device drivers?
> 
> Yes.  You would export the function in the USB core, and put a prototype
> in a USB include file (probably in include/linux/usb.h).  Let's say that
> function is called usb_change_ep_bandwidth.
> 
> Drivers could call into that function when they needed to change either
> the bInterval or wMaxPacketSize of a particular endpoint.  This could be
> during the driver's probe function, or before switching alternate
> interface settings, or even after the alt setting is in place, but
> userspace dictates the driver use a different bandwidth.
> 
> Drivers should pass usb_change_ep_bandwidth a pointer to the endpoint
> they need to change, along with the bInterval and wMaxPacketSize values
> they would like the endpoint to have.  Those values could be stored as
> new values in struct usb_host_endpoint.
> 
> usb_change_ep_bandwidth would then call into the xHCI driver to drop the
> endpoint, re-add it, and then issue a bandwidth change.  The xHCI driver
> would have to be changed to look at the new fields in usb_host_endpoint,
> and set up the endpoint contexts with the interval and packet size from
> those fields, instead of the endpoint descriptor.
> 
> We should probably set the new values in usb_host_endpoint to zero after
> the driver unbinds from the device.  Not sure if they should be reset
> after the driver switches interfaces.  I would have to see the use cases
> in the driver.

We should consider this before rushing into a new API.

In particular, do we want to go around changing single endpoints, one 
at a time?  Or do we want to change all the endpoints in an interface 
at once?

Given that a change to one endpoint may require the entire schedule to 
be recomputed, it seems to make more sense to do all of them at once.  
For example, drivers could call a routine to set the desired endpoint 
parameters, and then the new parameters could take effect when the 
driver calls usb_set_interface().

In any case, the question about what to do when the interface setting
gets switched never really arises.  Each usb_host_endpoint structure is
referenced from only one altsetting.  If the driver wants the new 
parameters applied to an endpoint in several altsettings, it will have 
to change each altsetting separately.

Alan Stern

