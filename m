Return-path: <mchehab@gaivota>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2601 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab0L2LYo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 06:24:44 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Deti Fliegl <deti@fliegl.de>
Subject: Re: [PATCH] [media] dabusb: Move it to staging to be deprecated
Date: Wed, 29 Dec 2010 12:24:25 +0100
Cc: Felipe Sanches <juca@members.fsf.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4D19037B.6060904@redhat.com> <201012291137.49153.hverkuil@xs4all.nl> <4D1B1532.60606@fliegl.de>
In-Reply-To: <4D1B1532.60606@fliegl.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201012291224.25864.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Wednesday, December 29, 2010 12:02:10 Deti Fliegl wrote:
> On 12/29/10 11:37 AM, Hans Verkuil wrote:
> > On Tuesday, December 28, 2010 20:10:17 Felipe Sanches wrote:
> >> Wait!
> >>
> >> It supports the DRBox1 DAB sold by Terratec:
> >> http://www.baycom.de/wiki/index.php/Products::dabusbhw
> >
> > No, it doesn't. The driver in the kernel only supports the prototype board.
> > The driver on baycom.de *does* support the Terratec product, but that's not
> > in the kernel.
> No, it should support the Terratec hardware as well but it's outdated 
> and unstable. Therefor I agreed to remove the driver from the current 
> kernel as I am not willing to continue support for the code.

I don't think it supports the Terratec hardware since the list of USB ids
doesn't include the Terratec products:

static struct usb_device_id dabusb_ids [] = {
        // { USB_DEVICE(0x0547, 0x2131) },      /* An2131 chip, no boot ROM */
        { USB_DEVICE(0x0547, 0x9999) },
        { }                                             /* Terminating entry */
};

So this driver will never be loaded when a Terratec USB device is connected.

Correct?

> >> I've been working on a free firmware for this device:
> >> http://libreplanet.org/wiki/LinuxLibre:USB_DABUSB
> >
> > I don't mind having support for DAB in the kernel, but any DAB API needs to
> > be properly discussed, designed and documented. And it should probably be a
> > part of the V4L2 API (since that already supports analog radio and RDS).
> >
> > By removing this driver from the kernel we open the way for a new DAB API
> > without breaking support for any existing end-users since the current driver
> > doesn't support any sold products.
> >
> > Frankly, I'm quite interested to see support for this and I'd be happy to
> > work with someone on designing an API for it. Sounds interesting :-)
> Attached to this mail you will find our latest sources of the dabusb 
> driver and the 8051 code running on the DR-Box 1 itself. Feel free to 
> continue development or to forget about everything.

Unless someone will pick up this source code and starts to work with us on
designing an API it will probably be forgotten :-(

As far as I can tell (please correct me if I am wrong) the hardware either no
longer available or very hard to get hold off.

I did see that Terratec still sells some DAB receivers, but they are all based
on different hardware.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
