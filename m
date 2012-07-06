Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932454Ab2GFC3l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jul 2012 22:29:41 -0400
Message-ID: <4FF64D91.1090001@redhat.com>
Date: Thu, 05 Jul 2012 23:29:37 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Douglas Bagnall <douglas@paradise.net.nz>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Avoid sysfs oops when an rc_dev's raw device is absent
References: <4FE7AA34.8090304@paradise.net.nz> <4FE7C27B.8060207@paradise.net.nz>
In-Reply-To: <4FE7C27B.8060207@paradise.net.nz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 24-06-2012 22:44, Douglas Bagnall escreveu:
> hi,
> 
> I probably should have sent that in reply to
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/49740
> which is the problem it fixes.
> 
> Some things which might be of interest:
> 
> 1. I innocently followed the instructions on
>     http://www.linuxtv.org/wiki/index.php/Maintaining_Git_trees (i.e.,
>     use v4l-dvb tree on top of linus tree) and spent a while looking at
>     IR/ir-sysfs.c instead of rc/rc-main.c. How stable it seemed! no
>     patches in years! So I added a warning at the top of the wiki page,
>     though a fix from someone who knows would be preferable.

Please help us updating the wiki pages. Unfortunately, almost all developers 
have no time to update wiki pages, and expect community help on that.

> 
> 2. From the above, I ended up reading a lot of ancient history and saw
>     that this was inadvertently sort of fixed for a few weeks in 2010
>     between a08c7c68f702e2a2797a4035b and d8b4b5822f51e2142b731b42.
> 
> 3. I wrote:
> 
>> This patch avoids the NULL dereference, and ignores the issue of how
>> this state of affairs came about in the first place.
> 
> Would, in rc_unregister_device(), putting device_del(&dev->dev) before
> ir_raw_event_unregister(dev) help? I've only been a kernel hacker for
> two hours so I am honestly clueless, but it seems like that might
> avert the race by hiding the structure from sysfs before it is pulled
> apart.

Reverting the order might help on your specific case, but device_del() 
does more than just removing the driver: it also can free some used
structures, with might lead into an OOPS, if the driver is polling for
IR.

So, your patch is likely less risky to cause side effects.

Regards,
Mauro
