Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:48487 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbZK1TbI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 14:31:08 -0500
Message-ID: <4B117A4C.1070304@s5r6.in-berlin.de>
Date: Sat, 28 Nov 2009 20:30:20 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Maxim Levitsky <maximlevitsky@gmail.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <christoph@bartelmus.de>,
	jarod@wilsonet.com, awalls@radix.net, dmitry.torokhov@gmail.com,
	j@jannau.net, jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR 	system?
References: <9e4733910911270757j648e39ecl7487b7e6c43db828@mail.gmail.com>	 <4B104971.4020800@s5r6.in-berlin.de>	 <1259370501.11155.14.camel@maxim-laptop>	 <m37hta28w9.fsf@intrepid.localdomain>	 <1259419368.18747.0.camel@maxim-laptop>	 <m3zl66y8mo.fsf@intrepid.localdomain>	 <1259422559.18747.6.camel@maxim-laptop>	 <9e4733910911280845y5cf06836l1640e9fc8b1740cf@mail.gmail.com>	 <1259433959.3658.0.camel@maxim-laptop> <9e4733910911281056s77e9bc8frd9200a81ebab8d7e@mail.gmail.com>
In-Reply-To: <9e4733910911281056s77e9bc8frd9200a81ebab8d7e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jon Smirl wrote:
> If these drivers are for specific USB devices it is straight forward
> to turn them into kernel based drivers. If we are going for plug and
> play this needs to happen. All USB device drivers can be implemented
> in user space, but that doesn't mean you want to do that. Putting
> device drivers in the kernel subjects them to code inspection, they
> get shipped everywhere, they autoload when the device is inserted,
> they participate in suspend/resume, etc.

Huh?  Userspace implementations /can/ be code-reviewed (but they can't
crash your machine), they /can/ be and are shipped everywhere, they /do/
auto-load when the device is inserted.  And if there should be an issue
with power management (is there any?), then improve the ABI and libusb
can surely be improved.  I don't see why a device with a userspace
driver cannot be included in power management.
-- 
Stefan Richter
-=====-==--= =-== ===--
http://arcgraph.de/sr/
