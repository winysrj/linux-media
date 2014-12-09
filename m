Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:49307 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbaLIQBp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Dec 2014 11:01:45 -0500
Message-ID: <54871CDF.2020909@linutronix.de>
Date: Tue, 09 Dec 2014 17:01:35 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
MIME-Version: 1.0
To: 'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>,
	David Laight <David.Laight@ACULAB.COM>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Felipe Balbi <balbi@ti.com>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH] usb: hcd: get/put device and hcd for hcd_buffers()
References: <20141205200357.GA1586@linutronix.de> <20141205211932.GA24249@kroah.com> <063D6719AE5E284EB5DD2968C1650D6D1CA04A1D@AcuExch.aculab.com> <20141209152404.GA29423@kroah.com>
In-Reply-To: <20141209152404.GA29423@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/09/2014 04:24 PM, 'Greg Kroah-Hartman' wrote:
> On Mon, Dec 08, 2014 at 09:44:05AM +0000, David Laight wrote:
>> From: Greg Kroah-Hartman
>>> On Fri, Dec 05, 2014 at 09:03:57PM +0100, Sebastian Andrzej Siewior wrote:
>>>> Consider the following scenario:
>>>> - plugin a webcam
>>>> - play the stream via gst-launch-0.10 v4l2src device=/dev/video0
>>>> - remove the USB-HCD during playback via "rmmod $HCD"
>>>>
>>>> and now wait for the crash
>>>
>>> Which you deserve, why did you ever remove a kernel module?  That's racy
>>> and _never_ recommended, which is why it never happens automatically and
>>> only root can do it.
>>
>> Really drivers and subsystems should have the required locking (etc) to
>> ensure that kernel modules can either be unloaded, or that the unload
>> request itself fails if the device is busy.
>>
>> It shouldn't be considered a 'shoot self in foot' operation.
>> OTOH there are likely to be bugs.
> 
> This is not always the case, sorry, removing a kernel module is a known
> racy condition, and sometimes adding all of the locking required to try
> to make it "safe" just isn't worth it overall, as this is something that
> _only_ a developer does.

I wasn't are of that. rmmod does not mention this. Kconfig does not
mention this and suggest y as default (for MODULE_UNLOAD) . rmmod -f
likely causes problems but this is not the case here. If you want to
avoid rmmod why not mark a driver that it is not safe to remove it? And
why not make it work?

You can unbind the HCD driver from the PCI-device via sysfs and this is
not something not only a developer does. This "unbind" calls the remove
function of the driver and the only difference between unbind and rmmod
is that the module remains inserted (but this is no news for you).

Now, this unbind happens if you choose to pass a PCI-device to a qemu
guest. This is a fairly common use-case for a non-developer since it is
quite easy to setup in virt-manager for instance. All you need is a
hardware with IOMMU support. I used this to get the usb.org testsuite
running in my Windows guest which needs access to EHCI registers). I
could also mention hacking on XHCI and not crashing the physical
machine if something goes south but then I would rise the developer
card again.

I even rmmod & modprobe my mmc controller on my notebook because for
some reason it does not work otherwise after a suspend + resume cycle
(and my motivation to look after this is quite low since I barely use
my notebook at all).

I am really surprised that you as a core developer and maintainer of
the drivers infrastructure say that one should not remove a driver.

> greg k-h

Sebastian
