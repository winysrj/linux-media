Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198]:56546 "EHLO
	mta3.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbZFZOhO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 10:37:14 -0400
Received: from host143-65.hauppauge.com
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta3.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KLU00E9AOM337S0@mta3.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Fri, 26 Jun 2009 10:37:16 -0400 (EDT)
Date: Fri, 26 Jun 2009 10:37:14 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: v4l2_subdev GPIO and Pin Control ops (Re: PxDVR3200 H LinuxTV
 v4l-dvb patch : Pull GPIO-20 low for DVB-T)
In-reply-to: <1245928543.4172.13.camel@palomino.walls.org>
To: Andy Walls <awalls@radix.net>, Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Terry Wu <terrywu2009@gmail.com>
Message-id: <4A44DD1A.4030200@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <8992.62.70.2.252.1245760429.squirrel@webmail.xs4all.nl>
 <1245897611.24270.19.camel@palomino.walls.org>
 <200906250839.40916.hverkuil@xs4all.nl>
 <1245928543.4172.13.camel@palomino.walls.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 6/25/09 7:15 AM, Andy Walls wrote:
> On Thu, 2009-06-25 at 08:39 +0200, Hans Verkuil wrote:
>> On Thursday 25 June 2009 04:40:11 Andy Walls wrote:
>>> On Tue, 2009-06-23 at 14:33 +0200, Hans Verkuil wrote:
>>>>> On Tue, 2009-06-23 at 11:39 +0800, Terry Wu wrote:
>>>>>
>>>> There is already an s_gpio in the core ops. It would be simple to add a
>>>> g_gpio as well if needed.
>>> Hans,
>>>
>>> As you probably know
>>>
>>> 	int (*s_gpio)(v4l2_subdev *sd, u32 val);
>>>
>>> is a little too simple for initial setup of GPIO pins.  With the
>>> collection of chips&  cores supported by cx25840 module, setting the
>>> GPIO configuration also requires:
>>>
>>> 	direction: In or Out
>>> 	multiplexed pins: GPIO or some other function
>>>
>>> I could tack on direction as an argument to s_gpio(), but I think that
>>> is a bit inconvenient..  I'd rather have a
>>>
>>> 	int (*s_gpio_config)(v4l2_subdev *sd, u32 dir, u32 initval);
>>>
>>> but that leaves out the method for multiplexed pin/pad configuration.
>>> Perhaps explicity setting a GPIO direction to OUT could be an implicit
>>> indication that a multiplexed pin should be set to it's GPIO function.
>>> However, that doesn't help for GPIO inputs that might have their pins
>>> multiplexed with other functions.
>>>
>>> Here's an idea on how to specify multiplexed pin configuration
>>> information and it could involve pins that multiplex functions other
>>> than GPIO (the CX25843 is quite flexible in this regard):
>>>
>>> 	int (*s_pin_function)(v4l2_subdev *sd, u32 pin_id, u32 function);
>>>
>>> The type checking ends up pretty weak, but I figured it was better than
>>> a 'void *config' that had a subdev specific collection of pin
>>> configuration information.
>>>
>>> Comments?
>> Hi Andy,
>>
>> Is there any driver that needs to setup the multiplex functions? If not, then
>> I would not add support for this at the moment.
>
> Well, the group of GPIO pins in question for the CX23885 are all
> multiplexed with other functions.  We could just initialize the CX23885
> to have those pins set as GPIOs, but I have to check the cx23885 driver
> to make sure that's safe.

I'm in the process of rationalizing the GPIO handing inside the cx23885 driver, 
largely because of the cx23417. The current encoder driver has a hardcoded GPIO 
used on GPIO 15. (legacy from the first HVR1800 implementation, which I'm 
cleaning up).

I would add this to the conversation, the product I'm working on now HVR1850 
needs to switch GPIO's on the fly to enable and disable parts (the ATSC demod) 
via an encoder GPIO pin, depending on the cards operating mode. This isn't a 
one-time operation, it needs to be dynamic.

In effect we have to tri-state / float certain parts depending whether we're in 
analog or digital mode, and depending on which tuner is being used.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
