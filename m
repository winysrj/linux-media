Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f194.google.com ([209.85.221.194]:49663 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbZK1S4T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 13:56:19 -0500
MIME-Version: 1.0
In-Reply-To: <1259433959.3658.0.camel@maxim-laptop>
References: <9e4733910911270757j648e39ecl7487b7e6c43db828@mail.gmail.com>
	 <4B104971.4020800@s5r6.in-berlin.de>
	 <1259370501.11155.14.camel@maxim-laptop>
	 <m37hta28w9.fsf@intrepid.localdomain>
	 <1259419368.18747.0.camel@maxim-laptop>
	 <m3zl66y8mo.fsf@intrepid.localdomain>
	 <1259422559.18747.6.camel@maxim-laptop>
	 <9e4733910911280845y5cf06836l1640e9fc8b1740cf@mail.gmail.com>
	 <1259433959.3658.0.camel@maxim-laptop>
Date: Sat, 28 Nov 2009 13:56:25 -0500
Message-ID: <9e4733910911281056s77e9bc8frd9200a81ebab8d7e@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR
	system?
From: Jon Smirl <jonsmirl@gmail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Christoph Bartelmus <christoph@bartelmus.de>,
	jarod@wilsonet.com, awalls@radix.net, dmitry.torokhov@gmail.com,
	j@jannau.net, jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 28, 2009 at 1:45 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> On Sat, 2009-11-28 at 11:45 -0500, Jon Smirl wrote:
>> What are other examples of user space IR drivers?
>>
>
> many libusb based drivers?

If these drivers are for specific USB devices it is straight forward
to turn them into kernel based drivers. If we are going for plug and
play this needs to happen. All USB device drivers can be implemented
in user space, but that doesn't mean you want to do that. Putting
device drivers in the kernel subjects them to code inspection, they
get shipped everywhere, they autoload when the device is inserted,
they participate in suspend/resume, etc.

If these are generic USB serial devices being used to implement IR
that's the hobbyist model and the driver should stay in user space and
use event injection.

If a ft232 has been used to build a USB IR receiver you should program
a specific USB ID into it rather than leaving the generic one in. FTDI
will assign you a specific USB ID out of their ID space for free,  you
don't need to pay to get one from the USB forum. Once you put a
specific ID into the ft232 it will trigger the load of the correct
in-kernel driver.


>
> Regards,
> Maxim Levitsky
>
>



-- 
Jon Smirl
jonsmirl@gmail.com
