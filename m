Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f173.google.com ([209.85.216.173]:39821 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbZK2Wsb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 17:48:31 -0500
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc> <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com> <m3aay6y2m1.fsf@intrepid.localdomain> <9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com> <1259450815.3137.19.camel@palomino.walls.org> <m3ocml6ppt.fsf@intrepid.localdomain> <9e4733910911291244p364b328fm3a76ded4e4cd8603@mail.gmail.com> <83224BA3-A5FF-4525-BF20-16A60F865C0A@gmail.com> <9e4733910911291347x4c4cac73h8c64223d0de563e4@mail.gmail.com>
Message-Id: <E50C6702-FDCB-4473-813D-53A87064BAF7@gmail.com>
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jon Smirl <jonsmirl@gmail.com>
In-Reply-To: <9e4733910911291347x4c4cac73h8c64223d0de563e4@mail.gmail.com>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (iPhone Mail 7C144)
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
Date: Sun, 29 Nov 2009 14:48:11 -0800
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Andy Walls <awalls@radix.net>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	"j@jannau.net" <j@jannau.net>,
	"jarod@redhat.com" <jarod@redhat.com>,
	"jarod@wilsonet.com" <jarod@wilsonet.com>,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"maximlevitsky@gmail.com" <maximlevitsky@gmail.com>,
	"mchehab@redhat.com" <mchehab@redhat.com>,
	"stefanr@s5r6.in-berlin.de" <stefanr@s5r6.in-berlin.de>,
	"superm1@ubuntu.com" <superm1@ubuntu.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Nov 29, 2009, at 1:47 PM, Jon Smirl <jonsmirl@gmail.com> wrote:

> On Sun, Nov 29, 2009 at 4:29 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
>> On Nov 29, 2009, at 12:44 PM, Jon Smirl <jonsmirl@gmail.com> wrote:
>>
>>> On Sun, Nov 29, 2009 at 3:27 PM, Krzysztof Halasa <khc@pm.waw.pl>  
>>> wrote:
>>>>
>>>> 1. Do we agree that a lirc (-style) kernel-user interface is  
>>>> needed at
>>>>  least?
>>>>
>>>> 2. Is there any problem with lirc kernel-user interface?
>>>
>>> Can you consider sending the raw IR data as a new evdev message type
>>> instead of creating a new device protocol?
>>
>> No, I think it would be wrong. Such events are ill-suited for  
>> consumption by
>> regular applications and would introduce the "looping" interface I  
>> described
>> in my other email.
>
> Regular applications are going to ignore these messages. The only
> consumer for them is the LIRC daemon. Which is just going to process
> them and re-inject the events back into evdev again in a different
> form.
>
> IR is an input device, what make it so special that it needs to by
> pass this subsystem and implement its own private communications
> scheme?

So are HID devices (both USB and BT), PS/2 and so on. You are not  
arguing for sending unprocessed data from these devices through evdev.

>
>>> evdev protects the messages in a transaction to stop incomplete
>>> messages from being read.
>>
>> If such property is desired we can add it to the new lirc-like  
>> interface,
>> can't we?
>
> Why do you want to redesign evdev instead of using it?
>

I just said why in my previous email: looping is a mark of badly  
designed interface.

-- 
Dmitry
