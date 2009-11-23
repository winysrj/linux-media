Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:38691
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbZKWTR3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 14:17:29 -0500
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <4B0AC65C.806@redhat.com>
Date: Mon, 23 Nov 2009 14:17:29 -0500
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Jarod Wilson <jarod@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Content-Transfer-Encoding: 8BIT
Message-Id: <BDC6A41E-67C0-4952-94E9-D405C7209394@wilsonet.com>
References: <200910200956.33391.jarod@redhat.com>	<200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com>	<4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain> <4B0AC65C.806@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm a bit short on time to write up a more complete reply to anything in this thread at the moment, but a few quick notes interspersed below.


On Nov 23, 2009, at 12:29 PM, Mauro Carvalho Chehab wrote:

> Krzysztof Halasa wrote:
>> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
...
>>> Considering the common case
>>> where the lirc driver will be associated with a media input device, the
>>> IR type can be detected automatically on kernel. However, advanced users may
>>> opt to use other IR types than what's provided with the device they
>>> bought.
>> 
>> I think most users would want to do that, though I don't have hard
>> numbers of course. Why use a number of RCs simultaneously while one will
>> do?
> 
> If you're building a dedicated hardware to act as a MCE, it makes sense to
> use just one IR to control your TV and your hardware, but the common usage
> is to add a TV board or stick to your desktop to see TV. For this,
> the standard IR fits well.

The main use case that I have personal experience using IR and capture devices is with MythTV. Its not at all uncommon for a MythTV user to have a setup where the capture devices are attached to a completely different system from the system where the IR part needs to be. MythTV is client-server -- the backend server does the video capture via the capture devices, and the frontend client plays back the video, and its the frontend client that you navigate via an IR remote control. There are quite a few available IR options that are NOT tied to a video capture device at all -- the mceusb and imon drivers submitted in my patch series are actually two such beasts.

And particularly with the mceusb receivers, because they support damn near every IR protocol under the sun at any carrier frequency, using a remote other than the bundled one is quite common. Most people's set top boxes and/or televisions and/or AV receivers come with a remote capable of controlling multiple devices, and many bundled remotes are, quite frankly, utter garbage. I use a Logitech Harmony 880 universal remote myself.


>>> It should also be noticed that not all the already-existing IR drivers
>>> on kernel can provide a lirc interface, since several devices have
>>> their own IR decoding chips inside the hardware.
>> 
>> Right. I think they shouldn't use lirc interface, so it doesn't matter.
> 
> If you see patch 3/3, of the lirc submission series, you'll notice a driver
> that has hardware decoding, but, due to lirc interface, the driver generates
> pseudo pulse/space code for it to work via lirc interface.

Historically, this is true. But the version I submitted actually defaults to operating as a pure input layer device for all the imon devices that do onboard decoding. There are older imon devices that don't do onboard decoding, and I retained "legacy", if you will, lirc interface support in this pass of the driver for the onboard decode devices for those that want to keep things running as they always have (via a modparam).

More replyification later tonight...

-- 
Jarod Wilson
jarod@wilsonet.com



