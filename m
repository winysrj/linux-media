Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:47091 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578AbZLCS4O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 13:56:14 -0500
MIME-Version: 1.0
In-Reply-To: <20091203175531.GB776@core.coreip.homeip.net>
References: <BDodf9W1qgB@lirc> <4B14EDE3.5050201@redhat.com>
	 <4B1524DD.3080708@redhat.com> <4B153617.8070608@redhat.com>
	 <A6D5FF84-2DB8-4543-ACCB-287305CA0739@wilsonet.com>
	 <4B17AA6A.9060702@redhat.com>
	 <20091203175531.GB776@core.coreip.homeip.net>
Date: Thu, 3 Dec 2009 13:56:18 -0500
Message-ID: <9e4733910912031056q5881da57o6d400e9e7e49eb0f@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR
	system?
From: Jon Smirl <jonsmirl@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 3, 2009 at 12:55 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Thu, Dec 03, 2009 at 01:09:14PM +0100, Gerd Hoffmann wrote:
>> On 12/03/09 05:29, Jarod Wilson wrote:
>>> On Dec 1, 2009, at 10:28 AM, Gerd Hoffmann wrote:
>>>
>>>>> Anyway, we shouldn't postpone lirc drivers addition due to that.
>>>>> There are still lots of work to do before we'll be able to split
>>>>> the tables from the kernel drivers.
>>>>
>>>> Indeed.  The sysfs bits are future work for both lirc and evdev
>>>> drivers.  There is no reason to make the lirc merge wait for it.
>>>
>>> At this point, my plan is to try to finish cleaning up lirc_dev and
>>> lirc_mceusb at least over the weekend while at FUDCon up in Toronto,
>>> and resubmit them next week.
>>
>> Good plan IMHO.  Having lirc_dev merged quickly allows in-kernel drivers
>> start supporting lirc.
>
> No, please, wait just a minute. I know it is tempting to just merge
> lirc_dev and start working, but can we first agree on the overall
> subsystem structure before doing so. It is still quite inclear to me.
>
> The open questions (for me at least):

Great list, good starting point for evaluating the design alternatives.

Have the various use cases all been enumerated?

> - do we create a new class infrastructure for all receivers or only for
>  ones plugged into lirc_dev? Remember that classifying objects affects
>  how udev and friemds see them and may either help or hurt writing PnP
>  rules.
>
> - do we intend to support in-kernel sotfware decoders? What is the
>  structure? Do we organize them as a module to be used by driver
>  directly or the driver "streams" the data to IR core and the core
>  applies decoders (in the same fashion input events from drivers flow
>  into input core and then distributed to all bound interfaces for
>  processing/conversion/transmission to userspace)?
>
> - how do we control which decoder should handle particular
>  receiver/remote? Is it driver's decision, decoder's decision, user's
>  or all of the above?
>
> - do we allow to have several decoders active at once for a receiver?
>
> - who decides that we want to utilize lirc_dev? Driver's themselves, IR
>  core (looking at the driver/device "capabilities"), something else?

Is the lirc device protocol documented? The lirc device only allows a
single app to read from it, it that ok? What about the problem the
mouse driver had with reading partial messages in one read and by the
time you came back around to read the second half the first read was
overwritten? That led to the transactions in evdev.

>
> - do we recognize and create input devices "on-fly" or require user
>  intervention? Semantics for splitting into several input/event
>  devices?

Complete on-the-fly is not going to do what you want it to. For
example Sony TVs use three variations of the Sony protocol in a single
TV.

A slick solution would have unknown IR events trigger a mapping
definition app via udev. The mapping app would ask you to hit a few
more keys until it locates the corresponding device profile in the IR
database. Then it could write a script which will load create a new
evdev device for this device and load the keycode map for it at boot.

The big IR profile database from All-In-One is published. For this
application you'd need to add entries mapping each IR code to a Linux
keycode. This is the same problem you have with scancodes and various
languages on keyboards. I'll bet the guys at http://www.openremote.org
would help with this.

>
> Could anyone please draw me a picture, starting with a "receiver"
> piece of hardware. I am not concerned much with how exactly receiver is
> plugged into a particular subsystem (DVB/V4L etc) since it would be
> _their_ implementation detail, but with the flow in/out of that
> "receiver" device.
>
> Now as far as input core goes I see very limited number of changes that
> may be needed:
>
> - Allow to extend size of "scancode" in EVIOC{S,G}KEYCODE if we are
>  unable to limit ourselves to 32 bits (keeping compatibility of course)
>
> - Maybe adding new ioctl to "zap" the keymap table
>
> - Adding more key EV_KEY/KEY_* definitons, if needed

Aren't EV_IR events needed so that an app for building keymaps can be written?
Normal apps would not use EV_IR events.

-- 
Jon Smirl
jonsmirl@gmail.com
