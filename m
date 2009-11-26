Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:55459 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbZKZFbI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 00:31:08 -0500
Date: Wed, 25 Nov 2009 21:31:09 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
	Re: [PATCH 1/3 v2] lirc core device driver infrastructure
Message-ID: <20091126053109.GE23244@core.coreip.homeip.net>
References: <200910200956.33391.jarod@redhat.com> <200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com> <4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain> <20091123173726.GE17813@core.coreip.homeip.net> <4B0B6321.3050001@wilsonet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0B6321.3050001@wilsonet.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 23, 2009 at 11:37:53PM -0500, Jarod Wilson wrote:
> On 11/23/2009 12:37 PM, Dmitry Torokhov wrote:
>> On Mon, Nov 23, 2009 at 03:14:56PM +0100, Krzysztof Halasa wrote:
>>> Mauro Carvalho Chehab<mchehab@redhat.com>  writes:
>>>
>>>> Event input has the advantage that the keystrokes will provide an unique
>>>> representation that is independent of the device.
>>>
>>> This can hardly work as the only means, the remotes have different keys,
>>> the user almost always has to provide customized key<>function mapping.
>>>
>>
>> Is it true? I would expect the remotes to have most of the keys to have
>> well-defined meanings (unless it is one of the programmable remotes)...
>
> Its the cases like programmable universal remotes that really throw  
> things for a loop. That, and people wanting to use random remote X that  
> came with the amp or tv or set top box, with IR receiver Y.

Right, but still the keys usually do have the well-defined meaning, teh
issue is in mapping raw code to the appropriate keycode. This can be
done either by lirc config file (when lirc is used) or by some other
means.

> ...
>>> We need to handle more than one RC at a time, of course.
>>>
>>>> So, the basic question that should be decided is: should we create a new
>>>> userspace API for raw IR pulse/space
>>>
>>> I think so, doing the RCx proto handling in the kernel (but without
>>> RCx raw code<>  key mapping in this case due to multiple controllers
>>> etc.). Though it could probably use the input layer as well(?).
>>>
>>
>> I think if the data is used to do the primary protocol decoding then it
>> should be a separate interface that is processed by someone and then fed
>> into input subsystem (either in-kernel or through uinput).
>>
>> Again, I would prefer to keep EV_KEY/KEY_* as the primary event type for
>> keys and buttons on all devices.
>
> Current lircd actually inter-operates with the input subsystem quite  
> well for any and all supported remotes if their keys are mapped in their  
> respective lircd.conf file using standard input subsystem key names, and  
> the lirc daemon started with the --uinput param. lircd decodes the raw  
> IR, finds the mapping in its config, and happily passes it along to 
> uinput.

Right.

I guess the question is what is the interface we want the regular
userspace (i.e. not lircd) to use. Right now programs has to use 2
intercfaces - one lirc for dealing with remotes that are not using
the standard event interface and evdev for remotes using it as well
as the rest of the input devices.

-- 
Dmitry
