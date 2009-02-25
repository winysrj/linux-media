Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.lie-comtel.li ([217.173.238.80]:60987 "EHLO
	smtp0.lie-comtel.li" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbZBYDDg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 22:03:36 -0500
Message-ID: <49A4B4FC.9030209@kaiser-linux.li>
Date: Wed, 25 Feb 2009 04:03:24 +0100
From: Thomas Kaiser <v4l@kaiser-linux.li>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: kilgota@banach.math.auburn.edu,
	Adam Baker <linux@baker-net.org.uk>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	Olivier Lorin <o.lorin@laposte.net>,
	Trent Piepho <xyzzy@speakeasy.org>, linux-omap@vger.kernel.org
Subject: Re: [RFC] How to pass camera Orientation to userspace
References: <200902180030.52729.linux@baker-net.org.uk> <200902211253.58061.hverkuil@xs4all.nl> <20090223080715.0c97774e@pedra.chehab.org> <200902232237.32362.linux@baker-net.org.uk> <alpine.LNX.2.00.0902231730410.13397@banach.math.auburn.edu> <alpine.LRH.2.00.0902241723090.6831@pedra.chehab.org> <alpine.LNX.2.00.0902241449020.15189@banach.math.auburn.edu> <alpine.LRH.2.00.0902242153490.6831@pedra.chehab.org>
In-Reply-To: <alpine.LRH.2.00.0902242153490.6831@pedra.chehab.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> Also an overview is often very helpful. Also trying to visualize what 
>> might be needed in the future is helpful. All of this can be extremely 
>> helpful. But not everyone can see or imagine every possible thing. For 
>> example, it seems that some of the best minds in the business are 
>> stunned when confronted with the fact that some manufacturer of cheap 
>> electronics in Taiwan has produced a lot of mass-market cameras with 
>> the sensors turned upside down, along with some other cameras having 
>> the same USB ID with different sensors, which act a bit differently. 
>> Clearly, if such a thing happened once it can happen again. So how to 
>> deal with such a
>> problem?

Actually, this happens and is happening!

Just step back a get an other view.

These consumer products are manly produced for the Windoz audience.

After introduction of Win XP the consumer where told that USB device 
will run out of the box in Win XP, which is sometimes true, but .....

But on all (Windowz) Webcams (are Linux Webcams available?) I buy, I 
find a sticker which tells me to first insert the driver CD before 
connecting the cam to the PC. When you do, like instructed, your cam 
works like you expected!

Evan the USB ID is the same like the other webcam from the other vendor, 
you are (more or less) forced to install the driver from this particular 
vendor, you get a new driver! Doesn't matter if the sensor is mounted 
upside down, the "new" driver takes care about this. So, it looks like 
the cam in the Windowz World just works because you were forced to 
install the driver from the CD.

So I guess the Windoz diver just knows more then the USB ID.

In the Linux World most of the drive are re-engineered, we don't know 
how to detect how the sensor is mounted, do we?

Actually, what I try to say, is that only the cam can know how the 
sensor is mounted. Thus, the kernel module has to provide this 
information to user space (by query the hardware).

The "pivot" is an other thing.

Thomas
