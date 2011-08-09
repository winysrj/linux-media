Return-path: <linux-media-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:44565 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab1HIPEY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Aug 2011 11:04:24 -0400
Message-ID: <4E414C55.5040903@kolumbus.fi>
Date: Tue, 09 Aug 2011 18:03:49 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Hans de Goede <hdegoede@redhat.com>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Greg KH <greg@kroah.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, libusb-devel@lists.sourceforge.net,
	Alexander Graf <agraf@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>, hector@marcansoft.com,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
	pbonzini@redhat.com, Anthony Liguori <aliguori@us.ibm.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Oliver Neukum <oliver@neukum.org>, Felipe Balbi <balbi@ti.com>,
	Clemens Ladisch <clemens@ladisch.de>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	Adam Baker <linux@baker-net.org.uk>
Subject: Re: USB mini-summit at LinuxCon Vancouver
References: <Pine.LNX.4.44L0.1108091016380.1949-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1108091016380.1949-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi

I've been thinking about the Kernel driver side.
Mauro and others emailed requirements on Jun or July.

I'm sorry for this spam: maybe you have thought this already.

A linked list of read/write locks as the solution for these protections could be
a base for the general solution. Locks could be accessed either by name "string name"
or by an integer identifier.

The bridge driver would be the container of the lock list.
Lock take / release handles would be changeable by Bridge driver at driver init.
This way bridge could tune the lock taking actions. Sub devices would not have
to know the details of the bridge device.

When implemented as a library ".ko" module, this could be
used by all related kernel drivers. The locking code would be very general.
Maybe adding a lock list into each PCI bus device would solve the device export problem to KVM too.

If some module wouldn't handle the proper locking yet,
it would not deliver the protection, but it would work as before: no regressions.

The library could also be called so that a driver would ask three locks at the same time.
If the driver would get all three locks, it would return success.
If the driver would not get all three locks, it would not lock any of them (with _trylock case).

I don't have time to implement this feature.

Happy meeting for all of you,
Marko Ristola
