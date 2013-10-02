Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:53855 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753827Ab3JBTIJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Oct 2013 15:08:09 -0400
Date: Wed, 2 Oct 2013 15:08:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: Xenia Ragiadakou <burzalodowa@gmail.com>,
	<linux-usb@vger.kernel.org>, <linux-input@vger.kernel.org>,
	<linux-media@vger.kernel.org>
Subject: Re: New USB core API to change interval and max packet size
In-Reply-To: <20131002183905.GG15395@xanatos>
Message-ID: <Pine.LNX.4.44L0.1310021449240.1293-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2 Oct 2013, Sarah Sharp wrote:

> > In particular, do we want to go around changing single endpoints, one 
> > at a time?  Or do we want to change all the endpoints in an interface 
> > at once?
> > 
> > Given that a change to one endpoint may require the entire schedule to 
> > be recomputed, it seems to make more sense to do all of them at once.  
> > For example, drivers could call a routine to set the desired endpoint 
> > parameters, and then the new parameters could take effect when the 
> > driver calls usb_set_interface().
> 
> I think it makes sense to change several endpoints, and then ask the
> host to recompute the schedule.  Perhaps the driver could issue several
> calls to usb_change_ep_bandwidth and then ask the USB core to update the
> host's schedule?

That's what I had in mind.  Note that usb_set_interface() already
updates the schedule.

> I'm not sure that usb_set_interface() is the right function for the new
> parameters to take effect.  What if the driver is trying to modify the
> current alt setting?  Would they need to call usb_set_interface() again?

Yes.  I can see two disadvantages:

	You don't want to call usb_set_interface() if there are any 
	transfers in progress for endpoints in that interface -- even 
	endpoints whose bandwidth you aren't trying to change.  The
	transfers would get shut down.

	usb_set_interface() communicates with the device, which isn't
	necessary if you're merely updating the host's schedule.

The alternatives are either a separate function to do the schedule
update, or else pass usb_change_ep_bandwidth() an array or list of
endpoint info and have it do all the updates at once.  I think a
separate function would be easier for drivers to use.

> > In any case, the question about what to do when the interface setting
> > gets switched never really arises.  Each usb_host_endpoint structure is
> > referenced from only one altsetting.  If the driver wants the new 
> > parameters applied to an endpoint in several altsettings, it will have 
> > to change each altsetting separately.
> 
> Ok, so it sounds like we want to keep the changes the endpoints across
> alt setting changes.

No, just the opposite.  That was the point I was trying to make.  Any
changes to ep5 in altsetting 0 (for example) will have no effect on ep1
in altsetting 1, because the two altsettings reference the endpoint by
two separate usb_host_endpoint structures.

Furthermore, it generally doesn't make sense to apply a single change 
across multiple altsettings.  An isochronous endpoint, for example, 
might have maxpacket = 500 in one altsetting and 900 in another.  When 
you reduce the 500 to 400, that doesn't mean you also want to reduce 
the 900 to 400.

>  But we still want to reset the values after the
> driver unbinds, correct?

Absolutely.  When the next driver binds, it should get the default
values (i.e., the ones stored in the descriptors).  This would be
analogous to the way we currently set each interface back to altsetting
0 when a driver unbinds.

Alan Stern

