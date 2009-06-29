Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:63969 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbZF2Nr5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2009 09:47:57 -0400
Received: from host143-65.hauppauge.com
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta2.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KM0004U76BXWUQ0@mta2.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Mon, 29 Jun 2009 09:47:59 -0400 (EDT)
Date: Mon, 29 Jun 2009 09:47:58 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: v4l2_subdev GPIO and Pin Control ops (Re: PxDVR3200 H LinuxTV
 v4l-dvb patch : Pull GPIO-20 low for DVB-T)
In-reply-to: <1246040361.3159.37.camel@palomino.walls.org>
To: Andy Walls <awalls@radix.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>,
	Terry Wu <terrywu2009@gmail.com>
Message-id: <4A48C60E.1070303@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <8992.62.70.2.252.1245760429.squirrel@webmail.xs4all.nl>
 <1245897611.24270.19.camel@palomino.walls.org>
 <200906250839.40916.hverkuil@xs4all.nl>
 <1245928543.4172.13.camel@palomino.walls.org>
 <4A44DD1A.4030200@kernellabs.com>
 <1246032766.3159.12.camel@palomino.walls.org>
 <4A44F697.2020008@kernellabs.com> <1246040361.3159.37.camel@palomino.walls.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 6/26/09 2:19 PM, Andy Walls wrote:
> On Fri, 2009-06-26 at 12:25 -0400, Steven Toth wrote:
>> On 6/26/09 12:12 PM, Andy Walls wrote:
>
>>> My plan was to add the necessary support to the cx25840 module for
>>> setting up the cx23885 pin control multiplexers (subdev config time),
>>> the GPIO 23-19 directions (subdev config time), and the GPIO 23-19
>>> output states (dynamically as needed via subdev's .s_gpio call).
>> Ahh. I'm already working on this, the code is partially merged for the GPIO
>> overhaul (a few weeks ago). I'm currently on the next stage. You should see some
>> todo comments in the current cx23885 driver.
>>
>> Doesn't the cx23885 driver already configure the multiplexer pins at config time
>> for the cx25840? Check the -cards.c for the HVR1800 entry.
>
> I'm not talking about the AFE Mux, I was refering to things like, as an
> example, if an external pin could be configured as either GPIO[n] pin or
> an audio sample clock.  The mux setting that handles that.
>
> Regards,
> Andy
>

Ahh, fair enough, thanks Andy.

Give me a little while to resolve some of the missing GPIO pieces then lets 
review. If I still don't have what you need then we can review again and I'd be 
happy to implement any ideas we think make sense.

Some HVR1800 ioctl work is stuck in the queue prior to this, so it could be a 
couple of weeks before I get back to it.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
