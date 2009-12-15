Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f188.google.com ([209.85.222.188]:62580 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757183AbZLONnK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2009 08:43:10 -0500
MIME-Version: 1.0
In-Reply-To: <4B279017.3080303@redhat.com>
References: <BEJgSGGXqgB@lirc> <20091206065512.GA14651@core.coreip.homeip.net>
	 <4B1B99A5.2080903@redhat.com> <m3638k6lju.fsf@intrepid.localdomain>
	 <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>
	 <m3skbn6dv1.fsf@intrepid.localdomain>
	 <20091207184153.GD998@core.coreip.homeip.net>
	 <4B24DABA.9040007@redhat.com> <20091215115011.GB1385@ucw.cz>
	 <4B279017.3080303@redhat.com>
Date: Tue, 15 Dec 2009 08:43:07 -0500
Message-ID: <9e4733910912150543m31938bddv384bd3195bbffcbe@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR
	system?
From: Jon Smirl <jonsmirl@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Pavel Machek <pavel@ucw.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	hermann pitton <hermann-pitton@arcor.de>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 15, 2009 at 8:33 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Pavel Machek wrote:
>>>> That is why I think we should go the other way around - introduce the
>>>> core which receivers could plug into and decoder framework and once it
>>>> is ready register lirc-dev as one of the available decoders.
>>>>
>>> I've committed already some IR restruct code on my linux-next -git tree:
>>>
>>> http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-next.git
>>>
>>> The code there basically moves the input/evdev registering code and
>>> scancode/keycode management code into a separate ir-core module.
>>>
>>> To make my life easy, I've moved the code temporarily into drivers/media/IR.
>>> This way, it helps me to move V4L specific code outside ir-core and to later
>>> use it for DVB. After having it done, probably the better is to move it to
>>> be under /drivers or /drivers/input.
>>
>> Well, -next is for stuff to be merged into 2.6.34. You are quite an
>> optimist.
>>                                                                       Pavel
>
> Well, we need those changes anyway for the in-kernel drivers, and I'm not seeing
> on the current patches any reason for not having them for 2.6.34.
>
> I've added all the ir-core patches I did so far at linux-next. This helps people
> to review and contribute.
>
> The patches are already working with the in-kernel em28xx driver, allowing to
> replace the keycode table and the protocol used by the hardware IR decoder.
> I tested here by replacing an RC-5 based IR table (Hauppauge Grey) by a NEC
> based IR table (Terratec Cinergy XS remote controller).
>
> The current Remote Controller core module (ir-core) is currently doing:
>
>        - Implementation of the existing EVIO[G|S]KEYCODE, expanding/feeing memory
> dynamically, based on the needed size for scancode/keycode table;
>
>        - scancodes can be up to 16 bits currently;
>
>        - sysfs is registering /sys/class/irrcv and creating one branch for each
> different RC receiver, numbering from irrcv0 to irrcv255;
>
>        - one irrcv note is created: current_protocol;
>
>        - reading /sys/class/irrcv/irrcv*/current_protocol returns the protocol
> currently used by the driver;
>
>        - writing to /sys/class/irrcv/irrcv*/current_protocol changes the protocol
> to a new one, by calling a callback, asking the driver to change the protocol. If
> the protocol is not support, it returns -EINVAL;
>
>        - all V4L drivers are already using ir-core;
>
>        - em28xx driver is implementing current_protocol show/store support.
>
> TODO:

I'd add a pulse based receiver like a MSMCE to make sure the core API is right.
MSME has transmit hardware too.

What about creating multiple evdev devices with their own keymaps off
from a single receiver? That's a key part of making multi-function
remotes work.


>        1) Port DVB drivers to use ir-core, removing the duplicated (and incomplete
>          - as table size can't change on DVB's implementation) code that exists there;
>
>        2) add current_protocol support on other drivers;
>
>        3) link the corresponding input/evdev interfaces with /sys/class/irrcv/irrcv*;
>
>        4) make the keytable.c application aware of the sysfs vars;
>
>        5) add an attribute to uniquely identify a remote controller;
>
>        6) write or convert an existing application to load IR tables at runtime;
>
>        7) get the complete 16-bit scancodes used by V4L drivers;
>
>        8) add decoder/lirc_dev glue to ir-core;
>
>        9) add lirc_dev module and in-kernel decoders;
>
>        10) extend keycode table replacement to support big/variable sized scancodes;
>
>        11) rename IR->RC;
>
>        12) redesign or remove ir-common module. It currently handles in-kernel
>            keycode tables and a few helper routines for raw pulse/space decode;
>
>        13) move drivers/media/IR to a better place;
>
>
> comments:
>
>        Tasks (1) to (6) for sure can happen to 2.6.34, depending on people's spare
> time for it;
>
>        (7) is probably the more complex task, since it requires to re-test all in-kernel
> supported remote controlle scancode/keycode tables, to get the complete IR keycode
> and rewrite the getkeycode functions that are currently masking the IR code into 7 bits.
> We'll need users help on this task, but this can be done gradually, like I did with
> two RC keytables on em28xx driver, while preserving the other keytables as-is.
>
>        (8) I suggest that this glue will be submitted together with lirc_dev patch
> series, as the biggest client for it is lirc. In principle, kfifo seems the better
> interface for lirc_dev -> decoders interface. For the decoders -> RC core interface,
> there's an interface already used on V4L drivers, provided by ir-common, using evdev
> kernel API. This may need some review.
>
>        (9) depends on lirc API discusions. My proposal is that people submit an RFC
> with the lirc API reviewed to the ML's, for people to ack/nack/comment. After that,
> re-submit the lirc_dev module integrating it into ir-core and with the reviewed API;
>
>        (10) depends on EVIO[G|S]KEYCODE discussions we've already started. I did a proposal
> about it. I'll review, based on the comments and re-submit it;
>
>        (11) if none is against renaming IR as RC, I'll do it on a next patch;
>
>        (12) depends on having lirc_dev added, for the removal of ir-functions.c. With
> respect to the keytables, maybe one interesting alternative is to use a logic close to
> nls tables that exists at fs, allowing to individually insert or remove an IR keytable
> in-kernel.
>
>        (13) has low priority. While not finishing the DVB integration with RC core
> and reviewing the remaining bits of the ir-common module.
>
> Cheers,
> Mauro.
>



-- 
Jon Smirl
jonsmirl@gmail.com
