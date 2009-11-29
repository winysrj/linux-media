Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:50755 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbZK2MHB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 07:07:01 -0500
Date: 29 Nov 2009 12:50:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: mchehab@redhat.com
Cc: awalls@radix.net
Cc: dmitry.torokhov@gmail.com
Cc: j@jannau.net
Cc: jarod@redhat.com
Cc: jarod@wilsonet.com
Cc: jonsmirl@gmail.com
Cc: khc@pm.waw.pl
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: lirc@bartelmus.de
Cc: superm1@ubuntu.com
Message-ID: <BDodf9W1qgB@lirc>
In-Reply-To: <4B1107B3.3000009@redhat.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

on 28 Nov 09 at 09:21, Mauro Carvalho Chehab wrote:
> Hi Christoph,
>
> Christoph Bartelmus wrote:

>>> Maybe we decide to take the existing LIRC system as is and not
>>> integrate it into the input subsystem. But I think there is a window
>>> here to update the LIRC design to use the latest kernel features.
>>
>> If it ain't broke, don't fix it.
[...]
> So, even not being broken, the subsystem internal media API's changed
> a lot during the last years, and there are still several new changes
> on our TODO list.
>
> So, I'd say that if we can do it better, then let's do it.

I'm not against improving things.
If there are feature request that cannot be handled with an interface, it  
has to be extended or redesigned. But currently the LIRC interface  
supports all features that came up until now since many years.
I just don't want to change a working interface just because it could be  
also implemented in a different way, but having no other visible advantage  
than using more recent kernel features.

[...]
>> For devices that do the decoding in hardware, the only thing that I don't
>> like about the current kernel implementation is the fact that there are
>> mapping tables in the kernel source. I'm not aware of any tools that let
>> you change them without writing some keymaps manually.
[...]
> Still, I prefer first to migrate all drivers to use the full scancode and
> re-generate the keymaps before such step.

Good to see that this is in the works.

[...]
>> With the approach that you
>> suggested for the in-kernel decoder, this device simply will not work for
>> anything but RC-5. The devil is in all the details.

> I haven't seen such limitations on his proposal. We currently have in-kernel
> decoders for NEC, pulse-distance, RC4 protocols, and some variants. If
> non-RC5 decoders are missing, we need for sure to add them.

That was not my point. If you point a NEC remote at the Igor USB device,  
you won't be able to use a NEC decoder because the device will swallow  
half of the bits. LIRC won't care unless the resulting scancodes are  
identical.
Granted, this is an esoteric arguement, because this device is utter  
garbage.

[...]
>> If we decide to do the
>> decoding in-kernel, how long do you think this solution will need to
>> become really stable and mainline? Currently I don't even see any
>> consensus on the interface yet. But maybe you will prove me wrong and it's
>> just that easy to get it all working.

> The timeframe to go to mainline will basically depend on taking a decision
> about the API and on people having time to work on it.
>
> Providing that we agree on what we'll do, I don't see why not
> adding it on staging for 2.6.33 and targeting to have
> everything done for 2.6.34 or 2.6.35.

The problem that I see here is just that even when we have very talented  
people working on this, that put together all resources, we won't be able  
to cover all the corner cases with all the different receivers and remote  
control protocols out there. It will still require lots of fine-tuning  
which was done in LIRC over the years.

>> I also understand that people want to avoid dependency on external
>> userspace tools. All I can tell you is that the lirc tools already do
>> support everything you need for IR control. And as it includes a lot of
>> drivers that are implemented in userspace already, LIRC will just continue
>> to do it's work even when there is an alternative in-kernel.

> The point is that for simple usage, like an user plugging his new USB stick
> he just bought, he should be able to use the shipped IR without needing to
> configure anything or manually calling any daemon. This currently works
> with the existing drivers and it is a feature that needs to be kept.

Admittedly, LIRC is way behind when it comes to plug'n'play.

Christoph
