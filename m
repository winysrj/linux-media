Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:46624 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab2E1OOi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 10:14:38 -0400
Date: Mon, 28 May 2012 16:14:32 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] [media] firedtv: Port it to use rc_core
Message-ID: <20120528161432.50a6ca45@stein>
In-Reply-To: <20120528160132.2041d761@stein>
References: <1338210875-4620-1-git-send-email-mchehab@redhat.com>
	<1338210875-4620-2-git-send-email-mchehab@redhat.com>
	<20120528160132.2041d761@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On May 28 Stefan Richter wrote:
> > +	idev->phys = "/ir0";		/* FIXME */  
> 
> Something similar to drivers/media/dvb/dvb-usb/dvb-usb-remote.c::
> 
> 	usb_make_path(d->udev, d->rc_phys, sizeof(d->rc_phys));
> 	strlcat(d->rc_phys, "/ir0", sizeof(d->rc_phys));
> 
> should be implemented for this, right?

PS:
The current input device looks like this:

/sys/devices/pci0000:00/0000:00:02.0/0000:02:00.0/0000:03:01.0/0000:04:00.0/fw7/fw7.0/input/input8/device -> ../../../fw7.0

"fw7.0" is dev_name(dev) in fdtv_register_rc() or dev_name(fdtv->device)
in general in firedtv.

The last numeric name before fw7, i.e. 0000:04:00.0, is the name of the PCI
device of the FireWire controller.  fw7 is the name of the FireDTV node;
fw7.0 is the name of the (only) unit within the FireDTV node which
implements the DVB receiver and IR receiver.  What would be needed from
this?

FWIW, usb_make_path() results in "usb-%s-%s" % (usb_device.bus.bus_name,
usb_device.devpath).
-- 
Stefan Richter
-=====-===-- -=-= ===--
http://arcgraph.de/sr/
