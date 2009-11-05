Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:36213
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbZKED20 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2009 22:28:26 -0500
Subject: Re: [PATCH 0/3 v2] linux infrared remote control drivers
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <1257379629.3074.13.camel@palomino.walls.org>
Date: Wed, 4 Nov 2009 22:28:26 -0500
Cc: Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Content-Transfer-Encoding: 7bit
Message-Id: <2958557D-F4C1-43AC-B004-7C18C5632CC0@wilsonet.com>
References: <200910200956.33391.jarod@redhat.com> <C5A8E7EC-81D6-49AA-A65F-9F5D3DED1690@wilsonet.com> <1257379629.3074.13.camel@palomino.walls.org>
To: Andy Walls <awalls@radix.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Nov 4, 2009, at 7:07 PM, Andy Walls wrote:

> On Wed, 2009-11-04 at 17:56 -0500, Jarod Wilson wrote:
>> On Oct 20, 2009, at 9:56 AM, Jarod Wilson wrote:
>>
>>> This here is a second go at submitting linux infrared remote control
>>> (lirc) drivers for kernel inclusion, with a much smaller patch set
>>> that
>>> includes only the core lirc driver and two device drivers, all three
>>> of
>>> which have been heavily updated since the last submission, based on
>>> feedback received.
>>
>> Hm. Submitting this while the vast majority of people who might  
>> review
>> it were at the Japan Linux Symposium seems like it might have been a
>> bad idea. Or does no feedback mean its all good and ready to be
>> merged? ;)
>
> Silence is concurrence. :)
>
> Actually I will note, that lirc_dev.h uses kfifo:
>
> http://git.wilsonet.com/linux-2.6-lirc.git/?a=blob_plain;f=drivers/input/lirc/lirc_dev.h;hb=f47f5e852d08f174c303d0ed53649733190014f7
>
> but it least it appear to be nicely wrappered in that file. Moving  
> to a
> new kfifo implementation should be fairly easy, if the kfifo change
> makes it in first.

Yeah, been keeping an eye on your own kfifo usage discussion w/lirc's  
usage in mind... Thank you for blazing that trail. ;)

-- 
Jarod Wilson
jarod@wilsonet.com



