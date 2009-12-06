Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933672AbZLFLXK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Dec 2009 06:23:10 -0500
Message-ID: <4B1B9416.809@redhat.com>
Date: Sun, 06 Dec 2009 09:23:02 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Gerd Hoffmann <kraxel@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jonsmirl@gmail.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
References: <BDodf9W1qgB@lirc> <4B14EDE3.5050201@redhat.com> <4B1524DD.3080708@redhat.com> <4B153617.8070608@redhat.com> <A6D5FF84-2DB8-4543-ACCB-287305CA0739@wilsonet.com> <4B17AA6A.9060702@redhat.com> <20091203175531.GB776@core.coreip.homeip.net> <20091203163328.613699e5@pedra> <20091204100642.GD22570@core.coreip.homeip.net> <20091204121234.5144836b@pedra> <20091206071450.GC14651@core.coreip.homeip.net>
In-Reply-To: <20091206071450.GC14651@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitry Torokhov wrote:
> On Fri, Dec 04, 2009 at 12:12:34PM -0200, Mauro Carvalho Chehab wrote:
>>> How related lirc-core to the current lirc code? If it is not the same
>>> maybe we should not call it lirc to avoid confusion.
>> Just for better illustrate what I'm seeing, I broke the IR generic
>> code into two components:
>>
>> 	lirc core - the module that receives raw pulse/space and creates
>> 		    a device to receive raw API pulse/space events;
>>
>> 	IR core - the module that receives scancodes, convert them into
>> 		  keycodes and send via evdev interface.
>>
>> We may change latter the nomenclature, but I'm seeing the core as two different
>> modules, since there are cases where lirc core won't be used (those
>> devices were there's no way to get pulse/space events).
>>
> 
> OK, I think we are close but not exactly close. I believe that what you
> call lirc core will be used always - it is the code that create3s class
> devices, connectes decorers with the data streams, etc. I believe it
> will be utilized even in case of devices using hardware decoders. That
> is why we should probably stop calling it "lirc core" just tso we don't
> confuse it with original lirc.
> 
> Then we have decoders and lirc_dev - which implements original lirc
> interface (or maybe its modified version) and allows lircd to continue
> working.
> 
> Lastly we have what you call IR core which is IR-to-input bridge of
> sorts.

It seems to be just nomenclacure ;)

what I called "IR core" you called "lirc core"
what I called "lirc core" you called "lirc_dev"

What I called IR core is the one that will be used by every IR driver, handling
sysfs, evdev's, calling decoders, etc.

I opted to use the nomenclature Lirc to the part of the IR subsystem that
will create the Lirc interface.

Currently, I almost finished the evdev part of the "IR core", using the current
API to control the dynamic keycode allocation. It is already working fine with
V4L drivers.

Cheers,
Mauro.
