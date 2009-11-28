Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:49867 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbZK1TQQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 14:16:16 -0500
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Christoph Bartelmus <christoph@bartelmus.de>,
	jarod@wilsonet.com, awalls@radix.net, dmitry.torokhov@gmail.com,
	j@jannau.net, jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
In-Reply-To: <9e4733910911281056s77e9bc8frd9200a81ebab8d7e@mail.gmail.com>
References: <9e4733910911270757j648e39ecl7487b7e6c43db828@mail.gmail.com>
	 <4B104971.4020800@s5r6.in-berlin.de>
	 <1259370501.11155.14.camel@maxim-laptop>
	 <m37hta28w9.fsf@intrepid.localdomain>
	 <1259419368.18747.0.camel@maxim-laptop>
	 <m3zl66y8mo.fsf@intrepid.localdomain>
	 <1259422559.18747.6.camel@maxim-laptop>
	 <9e4733910911280845y5cf06836l1640e9fc8b1740cf@mail.gmail.com>
	 <1259433959.3658.0.camel@maxim-laptop>
	 <9e4733910911281056s77e9bc8frd9200a81ebab8d7e@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 28 Nov 2009 21:16:14 +0200
Message-ID: <1259435775.3658.7.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-11-28 at 13:56 -0500, Jon Smirl wrote: 
> On Sat, Nov 28, 2009 at 1:45 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > On Sat, 2009-11-28 at 11:45 -0500, Jon Smirl wrote:
> >> What are other examples of user space IR drivers?
> >>
> >
> > many libusb based drivers?
> 
> If these drivers are for specific USB devices it is straight forward
> to turn them into kernel based drivers. If we are going for plug and
> play this needs to happen. All USB device drivers can be implemented
> in user space, but that doesn't mean you want to do that. Putting
> device drivers in the kernel subjects them to code inspection, they
> get shipped everywhere, they autoload when the device is inserted,
> they participate in suspend/resume, etc.
> 
> If these are generic USB serial devices being used to implement IR
> that's the hobbyist model and the driver should stay in user space and
> use event injection.
> 
> If a ft232 has been used to build a USB IR receiver you should program
> a specific USB ID into it rather than leaving the generic one in. FTDI
> will assign you a specific USB ID out of their ID space for free,  you
> don't need to pay to get one from the USB forum. Once you put a
> specific ID into the ft232 it will trigger the load of the correct
> in-kernel driver.

If we could put *all* lirc drivers in the kernel and put the generic
decoding algorithm, then it might be begin to look a bit more sane.
And write  tool to upload the existing lirc config files to kernel.
This would essentially we same as porting the lirc to the kernel.
I don't see much gains of this, and this way or another, alsa input
won't be possible.

Christoph Bartelmus, Jarod Wilson, what do you think?

Regards,
Maxim Levitsky









