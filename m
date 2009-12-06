Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:57475 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbZLFMC0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Dec 2009 07:02:26 -0500
Date: 06 Dec 2009 12:58:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: dmitry.torokhov@gmail.com
Cc: awalls@radix.net
Cc: j@jannau.net
Cc: jarod@redhat.com
Cc: jarod@wilsonet.com
Cc: jonsmirl@gmail.com
Cc: khc@pm.waw.pl
Cc: kraxel@redhat.com
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Cc: superm1@ubuntu.com
Message-ID: <BENgwLGXqgB@lirc>
In-Reply-To: <20091204231527.GA3682@core.coreip.homeip.net>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dmitry,

on 04 Dec 09 at 15:15, Dmitry Torokhov wrote:
[...]
>>>>>> http://lirc.sourceforge.net/remotes/lg/6711A20015N
>>>>>>
>>>>>> This is an air-conditioner remote.
>>>>>> The entries that you see in this config file are not really separate
>>>>>> buttons. Instead the remote just sends the current settings for e.g.
>>>>>> temperature encoded in the protocol when you press some up/down key.
>>>>>> You really don't want to map all possible temperature settings to KEY_*
>>>>>> events. For such cases it would be nice to have access at the raw scan
>>>>>> codes from user space to do interpretation of the data.
>>>>>> The default would still be to pass the data to the input layer, but it
>>>>>> won't hurt to have the possibility to access the raw data somehow.
>>>>
>>>>> Interesting. IMHO, the better would be to add an evdev ioctl to return
>>>>> the scancode for such cases, instead of returning the keycode.
>>>>
>>>> That means you would have to set up a pseudo keymap, so that you can get
>>>> the key event which you could than react on with a ioctl. Or are you
>>>> generating KEY_UNKNOWN for every scancode that is not mapped?
>>>> What if different scan codes are mapped to the same key event? How do you
>>>> retrieve the scan code for the key event?
>>>> I don't think it can work this way.
>>>>
>>
>>> EV_MSC/MSC_SCAN.
>>
>> How would I get the 64 bit scan codes that the iMON devices generate?
>> How would I know that the scan code is 64 bit?
>> input_event.value is __s32.
>>

> I suppose we could add MSC_SCAN_END event so that we can transmit
> "scancodes" of arbitrary length. You'd get several MSC_SCAN followed by
> MSC_SCAN_END marker. If you don't get MSC_SCAN_END assume the code is 32
> bit.

And I set a timeout to know that no MSC_SCAN_END will arrive? This is  
broken design IMHO.

Furthermore lircd needs to know the length of the scan code in bits, not  
as a multiple of 32.

> FWIW there is MSC_RAW as well.

It took me some time to convice people that this is not the right way to  
handle raw timing data.

Christoph
