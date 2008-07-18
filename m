Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6INF0BX004561
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 19:15:00 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6INEm5K001251
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 19:14:49 -0400
Date: Sat, 19 Jul 2008 00:14:42 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <20080718214644.GB21846@linux-sh.org>
Message-ID: <Pine.LNX.4.64.0807190009550.32334@axis700.grange>
References: <20080714120204.4806.87287.sendpatchset@rx1.opensource.se>
	<20080714120249.4806.66136.sendpatchset@rx1.opensource.se>
	<Pine.LNX.4.64.0807180918160.13569@axis700.grange>
	<aec7e5c30807180107g6d2f55fdh917da10963f3df20@mail.gmail.com>
	<Pine.LNX.4.64.0807181015470.14224@axis700.grange>
	<20080718214644.GB21846@linux-sh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, linux-sh@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	paulius.zaleckas@teltonika.lt, akpm@linux-foundation.org
Subject: Re: [PATCH 05/06] sh_mobile_ceu_camera: Add SuperH Mobile CEU driver
 V3
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Sat, 19 Jul 2008, Paul Mundt wrote:

> On Fri, Jul 18, 2008 at 10:23:14AM +0200, Guennadi Liakhovetski wrote:
> > On Fri, 18 Jul 2008, Magnus Damm wrote:
> > > Regarding request_mem_region() - I used to add that here and there,
> > > but I think the platform driver layer should handle that for us
> > > automatically these days. I'm not 100% sure though. =)
> > 
> > I had a short look and didn't find anything like that there... So, you 
> > might want to double-check and add if needed.
> > 
> It's a bit obscured, but it's certainly handled generically these days.
> 
> Look at drivers/base/platform.c:platform_device_add(). The resource type
> is checked there and handed off to insert_resource().
> platform_device_add() is likewise wrapped in to from
> platform_device_register(), so everyone claims the resources
> unconditionally.

Sorry, I still don't qite follow. _Resources_ get accounted with the 
platform_device_add() / platform_device_del(), and are searched by 
platform_get_resource(), but even this doesn't lock the resource like 
some other "get" methods. I can see that. But we are talking not about 
"struct resource" accounting, but about memory regions. And I don't see 
this done anywhere in platform-device / resource handling.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
