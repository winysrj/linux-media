Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758570Ab0DAQon (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Apr 2010 12:44:43 -0400
Message-ID: <4BB4A9E2.9090706@redhat.com>
Date: Thu, 01 Apr 2010 11:12:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: V4L-DVB drivers and BKL
References: <201004011001.10500.hverkuil@xs4all.nl> <201004011123.31080.laurent.pinchart@ideasonboard.com> <201004011311.51505.hverkuil@xs4all.nl> <201004011411.02344.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201004011411.02344.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Hi Hans,
> 
> On Thursday 01 April 2010 13:11:51 Hans Verkuil wrote:
>> On Thursday 01 April 2010 11:23:30 Laurent Pinchart wrote:
>>> On Thursday 01 April 2010 10:01:10 Hans Verkuil wrote:
>>>> Hi all,
>>>>
>>>> I just read on LWN that the core kernel guys are putting more effort
>>>> into removing the BKL. We are still using it in our own drivers,
>>>> mostly V4L.
>>>>
>>>> I added a BKL column to my driver list:
>>>>
>>>> http://www.linuxtv.org/wiki/index.php/V4L_framework_progress#Bridge_Dri
>>>> vers
>>>>
>>>> If you 'own' one of these drivers that still use BKL, then it would be
>>>> nice if you can try and remove the use of the BKL from those drivers.
>>>>
>>>> The other part that needs to be done is to move from using the .ioctl
>>>> file op to using .unlocked_ioctl. Very few drivers do that, but I
>>>> suspect almost no driver actually needs to use .ioctl.
>>> What about something like this patch as a first step ?
>> That doesn't fix anything. You just move the BKL from one place to another.
>> I don't see any benefit from that.
> 
> Removing the BKL is a long-term project that basically pushes the BKL from 
> core code to subsystems and drivers, and then replace it on a case by case 
> basis. This patch (along with a replacement of lock_kernel/unlock_kernel by a 
> V4L-specific lock) goes into that direction and removes the BKL usage from V4L 
> ioctls. The V4L lock would then need to be pushed into individual drivers. 

True, but, as almost all V4L drivers share a "common ancestor", fixing the
problems for one will also fix for the others.

One typical problem that I see is that some drivers register too soon: they
first register, then initialize some things. I've seen (and fixed) some race 
conditions due to that. Just moving the register to the end solves this issue.

One (far from perfect) solution, would be to add a mutex protecting the entire
ioctl loop inside the drivers, and the open/close methods. This can later be
optimized by a mutex that will just protect the operations that can actually
cause problems if happening in parallel.

-- 

Cheers,
Mauro
