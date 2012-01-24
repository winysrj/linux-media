Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:59153 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754799Ab2AXSdi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jan 2012 13:33:38 -0500
Date: Tue, 24 Jan 2012 13:33:37 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Greg KH <greg@kroah.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Sebastian Ott <sebott@linux.vnet.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Michael Buesch <m@bues.ch>,
	Joerg Roedel <joerg.roedel@amd.com>,
	<linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-pcmcia@lists.infradead.org>,
	<linux-s390@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>,
	<xen-devel@lists.xensource.com>,
	Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] Get rid of get_driver() and put_driver()
Message-ID: <Pine.LNX.4.44L0.1201241158540.1200-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greg:

This patch series removes the get_driver() and put_driver() routines
from the kernel.

Those routines don't do anything useful.  Their comments say that they
increment and decrement the driver's reference count, just like
get_device()/put_device() and a lot of other utility routines.  But a
struct driver is _not_ like a struct device!  It resembles a piece of
code more than a piece of data -- it acts as an encapsulation of a
driver.  Incrementing its refcount doesn't have much meaning because a
driver's lifetime isn't determined by the structure's refcount; it's
determined by when the driver's module gets unloaded.

What really matters for a driver is whether or not it is registered.  
Drivers expect, for example, that none of their methods will be called
after driver_unregister() returns.  It doesn't matter if some other
thread still holds a reference to the driver structure; that reference
mustn't be used for accessing the driver code after unregistration.  
get_driver() does not do any checking for this.

People may have been misled by the kerneldoc into thinking that the
references obtained by get_driver() do somehow pin the driver structure
in memory.  This simply isn't true; all it pins is the associated
private structure.  Code that needs to pin a driver must do it some
other way (probably by calling try_module_get()).

In short, these routines don't do anything useful and they can actively 
mislead people.  Removing them won't introduce any bugs that aren't 
already present.  There is no reason to keep them.

Alan Stern

