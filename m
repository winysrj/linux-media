Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:55090 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414AbaLJSZa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Dec 2014 13:25:30 -0500
Date: Wed, 10 Dec 2014 19:25:24 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: 'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>
Cc: David Laight <David.Laight@ACULAB.COM>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Felipe Balbi <balbi@ti.com>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH] usb: hcd: get/put device and hcd for hcd_buffers()
Message-ID: <20141210182524.GA26371@linutronix.de>
References: <20141205200357.GA1586@linutronix.de>
 <20141205211932.GA24249@kroah.com>
 <063D6719AE5E284EB5DD2968C1650D6D1CA04A1D@AcuExch.aculab.com>
 <20141209152404.GA29423@kroah.com>
 <54871CDF.2020909@linutronix.de>
 <20141209165415.GB10260@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141209165415.GB10260@kroah.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* 'Greg Kroah-Hartman' | 2014-12-09 11:54:15 [-0500]:

>> You can unbind the HCD driver from the PCI-device via sysfs and this is
>> not something not only a developer does. This "unbind" calls the remove
>> function of the driver and the only difference between unbind and rmmod
>> is that the module remains inserted (but this is no news for you).
>
>If unbind causes a problem, it's the same problem that could happen if
>the hardware is hot-unplugged (like on a PCI card.)  Stuff like that
>_does_ need to be fixed, and if your test shows this is a problem, I am
>all for fixing that.

so I tried this with unbind and it didn't explode as assumed. On musb,
for some reason the hcd struct never gets cleaned up. The driver free(s)
URB memory after the hcd_pools are gone but since its size is 32KiB it
uses dma_free_coherent() and this seems to work fine (sice the device is
still there).
So tried the same thing with EHCI. EHCI-hcd cleans up its HCD-struct as
expected so I would have to poke at musb and figure out why it does not
happen.
Also, there is another difference: with EHCI I see first removal of
buffers followed by removal of the pools. So it happens after disconnect
but before the HCD pools are gone. I'm not sure why this happens with
EHCI but not with MUSB. It seems that for some reason unbind triggers an
error on /dev/video0 which makes gst-launch close that file. Once all users
are gone, that hcd struct is cleaned up. Again, it works as I would
expect it with EHCI but not with MUSB. 
So maybe, once I learned how MUSB dafeated the userspace notification
about a gone device I might gain the same behavior that EHCI has. Also
not freed hcd struct of musb looks also important :)

>thanks,
>
>greg k-h

Sebastian
