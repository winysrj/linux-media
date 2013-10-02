Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45521 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855Ab3JBSjG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Oct 2013 14:39:06 -0400
Date: Wed, 2 Oct 2013 11:39:05 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Xenia Ragiadakou <burzalodowa@gmail.com>,
	linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: New USB core API to change interval and max packet size
Message-ID: <20131002183905.GG15395@xanatos>
References: <20131001204554.GB15395@xanatos>
 <Pine.LNX.4.44L0.1310021007110.1293-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1310021007110.1293-100000@iolanthe.rowland.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 02, 2013 at 10:22:52AM -0400, Alan Stern wrote:
> On Tue, 1 Oct 2013, Sarah Sharp wrote:
> 
> > > When you say a new API, what do you mean? New functions in usbcore
> > > to be used by usb device drivers?
> > 
> > Yes.  You would export the function in the USB core, and put a prototype
> > in a USB include file (probably in include/linux/usb.h).  Let's say that
> > function is called usb_change_ep_bandwidth.
> > 
> > Drivers could call into that function when they needed to change either
> > the bInterval or wMaxPacketSize of a particular endpoint.  This could be
> > during the driver's probe function, or before switching alternate
> > interface settings, or even after the alt setting is in place, but
> > userspace dictates the driver use a different bandwidth.
> > 
> > Drivers should pass usb_change_ep_bandwidth a pointer to the endpoint
> > they need to change, along with the bInterval and wMaxPacketSize values
> > they would like the endpoint to have.  Those values could be stored as
> > new values in struct usb_host_endpoint.
> > 
> > usb_change_ep_bandwidth would then call into the xHCI driver to drop the
> > endpoint, re-add it, and then issue a bandwidth change.  The xHCI driver
> > would have to be changed to look at the new fields in usb_host_endpoint,
> > and set up the endpoint contexts with the interval and packet size from
> > those fields, instead of the endpoint descriptor.
> > 
> > We should probably set the new values in usb_host_endpoint to zero after
> > the driver unbinds from the device.  Not sure if they should be reset
> > after the driver switches interfaces.  I would have to see the use cases
> > in the driver.
> 
> We should consider this before rushing into a new API.

Yes, I agree. :)  That's why I'd like to see some cases in the media
drivers code where it could benefit from changing the interval or
maxpacket size, so that we can see what use cases we have.  Mauro, can
you point is to places in drivers that would need this?

> In particular, do we want to go around changing single endpoints, one 
> at a time?  Or do we want to change all the endpoints in an interface 
> at once?
> 
> Given that a change to one endpoint may require the entire schedule to 
> be recomputed, it seems to make more sense to do all of them at once.  
> For example, drivers could call a routine to set the desired endpoint 
> parameters, and then the new parameters could take effect when the 
> driver calls usb_set_interface().

I think it makes sense to change several endpoints, and then ask the
host to recompute the schedule.  Perhaps the driver could issue several
calls to usb_change_ep_bandwidth and then ask the USB core to update the
host's schedule?

I'm not sure that usb_set_interface() is the right function for the new
parameters to take effect.  What if the driver is trying to modify the
current alt setting?  Would they need to call usb_set_interface() again?

> In any case, the question about what to do when the interface setting
> gets switched never really arises.  Each usb_host_endpoint structure is
> referenced from only one altsetting.  If the driver wants the new 
> parameters applied to an endpoint in several altsettings, it will have 
> to change each altsetting separately.

Ok, so it sounds like we want to keep the changes the endpoints across
alt setting changes.  But we still want to reset the values after the
driver unbinds, correct?

Sarah Sharp
