Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662AbZLCMJz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2009 07:09:55 -0500
Message-ID: <4B17AA6A.9060702@redhat.com>
Date: Thu, 03 Dec 2009 13:09:14 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
MIME-Version: 1.0
To: Jarod Wilson <jarod@wilsonet.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jonsmirl@gmail.com, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
References: <BDodf9W1qgB@lirc> <4B14EDE3.5050201@redhat.com> <4B1524DD.3080708@redhat.com> <4B153617.8070608@redhat.com> <A6D5FF84-2DB8-4543-ACCB-287305CA0739@wilsonet.com>
In-Reply-To: <A6D5FF84-2DB8-4543-ACCB-287305CA0739@wilsonet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/03/09 05:29, Jarod Wilson wrote:
> On Dec 1, 2009, at 10:28 AM, Gerd Hoffmann wrote:
>
>>> Anyway, we shouldn't postpone lirc drivers addition due to that.
>>> There are still lots of work to do before we'll be able to split
>>> the tables from the kernel drivers.
>>
>> Indeed.  The sysfs bits are future work for both lirc and evdev
>> drivers.  There is no reason to make the lirc merge wait for it.
>
> At this point, my plan is to try to finish cleaning up lirc_dev and
> lirc_mceusb at least over the weekend while at FUDCon up in Toronto,
> and resubmit them next week.

Good plan IMHO.  Having lirc_dev merged quickly allows in-kernel drivers 
start supporting lirc.

One final pass over the lirc interface would be good, taking the chance 
to fixup anything before the ABI is set in stone with the mainline 
merge.  Things to look at:

   (1) Make sure ioctl structs are 32/64 bit invariant.
   (2) Maybe add some reserved fields to allow extending later
       without breaking the ABI.
   (3) Someone suggested a 'commit' ioctl which would activate
       the parameters set in (multiple) previous ioctls.  Makes sense?
   (4) Add a ioctl to enable/disable evdev event submission for
       evdev/lirc hybrid drivers.

> I'm still on the fence over what to do about lirc_imon. The driver
> supports essentially 3 generations of devices. First-gen is very old
> imon parts that don't do onboard decoding. Second-gen is the devices
> that all got (insanely stupidly) tagged with the exact same usb
> device ID (0x15c2:0xffdc), some of which have an attached VFD, some
> with an attached LCD, some with neither, some that are actually RF
> parts, but all (I think) of which do onboard decoding. Third-gen is
> the latest stuff, which is all pretty sane, unique device IDs for
> unique devices, onboard decoding, etc.

Do have second-gen and third-gen devices have a 'raw mode'?  If so, then 
there should be a lirc interface for raw data access.

> So the lirc_imon I submitted supports all device types, with the
> onboard decode devices defaulting to operating as pure input devices,
> but an option to pass hex values out via the lirc interface (which is
> how they've historically been used -- the pure input stuff I hacked
> together just a few weeks ago), to prevent functional setups from
> being broken for those who prefer the lirc way.

Hmm.  I'd tend to limit the lirc interface to the 'raw samples' case.

Historically it has also been used to pass decoded data (i.e. rc5) from 
devices with onboard decoding, but for that in-kernel mapping + input 
layer really fits better.

> What I'm debating is whether this should be split into two drivers,
> one for the older devices that don't do onboard decoding (which would
> use the lirc_dev interface) called 'lirc_imon' or 'lirc_imon_legacy',
> and one that is a pure input driver, not unlike the ati_remote{,2}
> drivers, with no lirc_dev dependency at all, probably called simply
> 'imon'.

i.e. lirc_imon would support first+second gen, and imon third-gen 
devices, without overlap?

 > But if I split it out, there may end up being a
> fair amount of code duplication,

You could try to split common code into a third module used by the other 
two.  Or have one module for all devices which is a evdev/lirc hybrid.

cheers,
   Gerd

