Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbZK3L5L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2009 06:57:11 -0500
Message-ID: <4B13B2FA.4050600@redhat.com>
Date: Mon, 30 Nov 2009 09:56:42 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Ray Lee <ray-lk@madrabbit.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jon Smirl <jonsmirl@gmail.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	stefanr@s5r6.in-berlin.de, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc>	 <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>	 <m3aay6y2m1.fsf@intrepid.localdomain>	 <9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com>	 <1259469121.3125.28.camel@palomino.walls.org>	 <20091129124011.4d8a6080@lxorguk.ukuu.org.uk>	 <1259515703.3284.11.camel@maxim-laptop>	 <2c0942db0911290949p89ae64bjc3c7501c2de6930c@mail.gmail.com> <1259537732.5231.11.camel@palomino.walls.org>
In-Reply-To: <1259537732.5231.11.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> On Sun, 2009-11-29 at 09:49 -0800, Ray Lee wrote:
>> On Sun, Nov 29, 2009 at 9:28 AM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
>>> This has zero advantages besides good developer feeling that "My system
>>> has one less daemon..."
>> Surely it's clear that having an unnecessary daemon is introducing
>> another point of failure?
> 
> A failure in a userspace IR daemon is worst case loss of IR
> functionality.
> 
> A failure in kernel space can oops or panic the machine.

If IR is the only interface between the user and the system (like in a TV
or a Set Top Box), both will give you the same practical result: the system
will be broken, if you got a crash at the IR driver.

> Userspace is much more flexible.

Why? The flexibility about the same on both kernelspace and userspace,
except for the boot time.

A kernelspace input device driver can start working since boot time.
On the other hand, an userspace device driver will be available only 
after mounting the filesystems and starting the deamons 
(e. g. after running inittab). 

So, you cannot catch a key that would be affecting the boot 
(for example to ask the kernel to run a different runlevel or entering
on some administrative mode).

After the boot, and providing that the kernel has the proper
API's, a pure userspace driver can behave just like a kernelspace
driver and vice-versa. The only difference may be in terms of device
transfer rate (not relevant for input devices) and latency.

Cheers,
Mauro.

