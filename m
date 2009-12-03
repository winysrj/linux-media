Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755076AbZLCVKq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2009 16:10:46 -0500
Message-ID: <4B18292C.6070303@redhat.com>
Date: Thu, 03 Dec 2009 19:10:04 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Jarod Wilson <jarod@wilsonet.com>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jonsmirl@gmail.com, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
References: <BDodf9W1qgB@lirc> <4B14EDE3.5050201@redhat.com> <4B1524DD.3080708@redhat.com> <4B153617.8070608@redhat.com> <A6D5FF84-2DB8-4543-ACCB-287305CA0739@wilsonet.com> <4B17AA6A.9060702@redhat.com>
In-Reply-To: <4B17AA6A.9060702@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gerd Hoffmann wrote:

> One final pass over the lirc interface would be good, taking the chance
> to fixup anything before the ABI is set in stone with the mainline
> merge.  Things to look at:
> 
>   (1) Make sure ioctl structs are 32/64 bit invariant.
>   (2) Maybe add some reserved fields to allow extending later
>       without breaking the ABI.
>   (3) Someone suggested a 'commit' ioctl which would activate
>       the parameters set in (multiple) previous ioctls.  Makes sense?

A better approach is to create an ioctl that can send a group of value/attribute pairs
at the same time. We used this estrategy for V4L extended controls to do things like
setting an mpeg encoder (were we need to adjust several parameters at the same time,
and adding all of them on one struct would be hard, since you can't specify all
of them sa the same time). The same strategy is also used by DVB API to allow it
to use any arbitrary protocol. It was conceived to support DVB-S2.

>   (4) Add a ioctl to enable/disable evdev event submission for
>       evdev/lirc hybrid drivers.

Yes, all above makes sense.
> 
>> I'm still on the fence over what to do about lirc_imon. The driver
>> supports essentially 3 generations of devices. First-gen is very old
>> imon parts that don't do onboard decoding. Second-gen is the devices
>> that all got (insanely stupidly) tagged with the exact same usb
>> device ID (0x15c2:0xffdc), some of which have an attached VFD, some
>> with an attached LCD, some with neither, some that are actually RF
>> parts, but all (I think) of which do onboard decoding. Third-gen is
>> the latest stuff, which is all pretty sane, unique device IDs for
>> unique devices, onboard decoding, etc.
> 
> Do have second-gen and third-gen devices have a 'raw mode'?  If so, then
> there should be a lirc interface for raw data access.
> 
>> So the lirc_imon I submitted supports all device types, with the
>> onboard decode devices defaulting to operating as pure input devices,
>> but an option to pass hex values out via the lirc interface (which is
>> how they've historically been used -- the pure input stuff I hacked
>> together just a few weeks ago), to prevent functional setups from
>> being broken for those who prefer the lirc way.
> 
> Hmm.  I'd tend to limit the lirc interface to the 'raw samples' case.

> Historically it has also been used to pass decoded data (i.e. rc5) from
> devices with onboard decoding, but for that in-kernel mapping + input
> layer really fits better.

I agree.

> 
>> What I'm debating is whether this should be split into two drivers,
>> one for the older devices that don't do onboard decoding (which would
>> use the lirc_dev interface) called 'lirc_imon' or 'lirc_imon_legacy',
>> and one that is a pure input driver, not unlike the ati_remote{,2}
>> drivers, with no lirc_dev dependency at all, probably called simply
>> 'imon'.
> 
> i.e. lirc_imon would support first+second gen, and imon third-gen
> devices, without overlap?
> 
>> But if I split it out, there may end up being a
>> fair amount of code duplication,
> 
> You could try to split common code into a third module used by the other
> two.  Or have one module for all devices which is a evdev/lirc hybrid.
> 
Splitting it into a core driver and two different drivers for raw/non-raw
device makes sense to me.

An alternative would be to have just one module, but splitting the code into
3 parts. This allows an easier understanding, IMHO.

Cheers,
Mauro.
