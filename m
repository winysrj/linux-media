Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f184.google.com ([209.85.222.184]:50395 "EHLO
	mail-pz0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452AbZLCRzd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 12:55:33 -0500
Date: Thu, 3 Dec 2009 09:55:31 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jonsmirl@gmail.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
	IR  system?
Message-ID: <20091203175531.GB776@core.coreip.homeip.net>
References: <BDodf9W1qgB@lirc> <4B14EDE3.5050201@redhat.com> <4B1524DD.3080708@redhat.com> <4B153617.8070608@redhat.com> <A6D5FF84-2DB8-4543-ACCB-287305CA0739@wilsonet.com> <4B17AA6A.9060702@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B17AA6A.9060702@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 03, 2009 at 01:09:14PM +0100, Gerd Hoffmann wrote:
> On 12/03/09 05:29, Jarod Wilson wrote:
>> On Dec 1, 2009, at 10:28 AM, Gerd Hoffmann wrote:
>>
>>>> Anyway, we shouldn't postpone lirc drivers addition due to that.
>>>> There are still lots of work to do before we'll be able to split
>>>> the tables from the kernel drivers.
>>>
>>> Indeed.  The sysfs bits are future work for both lirc and evdev
>>> drivers.  There is no reason to make the lirc merge wait for it.
>>
>> At this point, my plan is to try to finish cleaning up lirc_dev and
>> lirc_mceusb at least over the weekend while at FUDCon up in Toronto,
>> and resubmit them next week.
>
> Good plan IMHO.  Having lirc_dev merged quickly allows in-kernel drivers  
> start supporting lirc.

No, please, wait just a minute. I know it is tempting to just merge
lirc_dev and start working, but can we first agree on the overall
subsystem structure before doing so. It is still quite inclear to me.

The open questions (for me at least):

- do we create a new class infrastructure for all receivers or only for
  ones plugged into lirc_dev? Remember that classifying objects affects
  how udev and friemds see them and may either help or hurt writing PnP
  rules.

- do we intend to support in-kernel sotfware decoders? What is the
  structure? Do we organize them as a module to be used by driver
  directly or the driver "streams" the data to IR core and the core
  applies decoders (in the same fashion input events from drivers flow
  into input core and then distributed to all bound interfaces for
  processing/conversion/transmission to userspace)?

- how do we control which decoder should handle particular
  receiver/remote? Is it driver's decision, decoder's decision, user's
  or all of the above?

- do we allow to have several decorers active at once for a receiver?

- who decides that we want to utilize lirc_dev? Driver's themselves, IR
  core (looking at the driver/device "capabilities"), something else?

- do we recognize and create input devices "on-fly" or require user
  intervention? Semantics for splitting into several input/event
  devices?

Could anyone please draw me a picture, starting with a "receiver"
piece of hardware. I am not concerned much with how exactly receiver is
plugged into a particular subsystem (DVB/V4L etc) since it would be
_their_ implementation detail, but with the flow in/out of that
"receiver" device.

Now as far as input core goes I see very limited number of changes that
may be needed:

- Allow to extend size of "scancode" in EVIOC{S,G}KEYCODE if we are
  unable to limit ourselves to 32 bits (keeping compatibility of course)

- Maybe adding new ioctl to "zap" the keymap table

- Adding more key EV_KEY/KEY_* definitons, if needed

Thanks.

-- 
Dmitry
