Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:53929
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087AbZKXEc6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 23:32:58 -0500
Message-ID: <4B0B6321.3050001@wilsonet.com>
Date: Mon, 23 Nov 2009 23:37:53 -0500
From: Jarod Wilson <jarod@wilsonet.com>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Krzysztof Halasa <khc@pm.waw.pl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <200910200956.33391.jarod@redhat.com> <200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com> <4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain> <20091123173726.GE17813@core.coreip.homeip.net>
In-Reply-To: <20091123173726.GE17813@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/23/2009 12:37 PM, Dmitry Torokhov wrote:
> On Mon, Nov 23, 2009 at 03:14:56PM +0100, Krzysztof Halasa wrote:
>> Mauro Carvalho Chehab<mchehab@redhat.com>  writes:
>>
>>> Event input has the advantage that the keystrokes will provide an unique
>>> representation that is independent of the device.
>>
>> This can hardly work as the only means, the remotes have different keys,
>> the user almost always has to provide customized key<>function mapping.
>>
>
> Is it true? I would expect the remotes to have most of the keys to have
> well-defined meanings (unless it is one of the programmable remotes)...

Its the cases like programmable universal remotes that really throw 
things for a loop. That, and people wanting to use random remote X that 
came with the amp or tv or set top box, with IR receiver Y.

...
>> We need to handle more than one RC at a time, of course.
>>
>>> So, the basic question that should be decided is: should we create a new
>>> userspace API for raw IR pulse/space
>>
>> I think so, doing the RCx proto handling in the kernel (but without
>> RCx raw code<>  key mapping in this case due to multiple controllers
>> etc.). Though it could probably use the input layer as well(?).
>>
>
> I think if the data is used to do the primary protocol decoding then it
> should be a separate interface that is processed by someone and then fed
> into input subsystem (either in-kernel or through uinput).
>
> Again, I would prefer to keep EV_KEY/KEY_* as the primary event type for
> keys and buttons on all devices.

Current lircd actually inter-operates with the input subsystem quite 
well for any and all supported remotes if their keys are mapped in their 
respective lircd.conf file using standard input subsystem key names, and 
the lirc daemon started with the --uinput param. lircd decodes the raw 
IR, finds the mapping in its config, and happily passes it along to uinput.

-- 
Jarod Wilson
jarod@wilsonet.com
