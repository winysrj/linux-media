Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6IMmPCC025214
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 18:48:25 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6IMmDNI022072
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 18:48:13 -0400
Date: Sat, 19 Jul 2008 00:48:08 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <20080718222713.GA18822@linux-sh.org>
Message-ID: <Pine.LNX.4.64.0807190046260.32334@axis700.grange>
References: <20080714120204.4806.87287.sendpatchset@rx1.opensource.se>
	<20080714120249.4806.66136.sendpatchset@rx1.opensource.se>
	<Pine.LNX.4.64.0807180918160.13569@axis700.grange>
	<aec7e5c30807180107g6d2f55fdh917da10963f3df20@mail.gmail.com>
	<Pine.LNX.4.64.0807181015470.14224@axis700.grange>
	<20080718214644.GB21846@linux-sh.org>
	<Pine.LNX.4.64.0807190009550.32334@axis700.grange>
	<20080718222713.GA18822@linux-sh.org>
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

> If you have an IORESOURCE_MEM resource in your platform device, the
> iomem_resource pointer gets referenced, just as with
> request_mem_region(), and they both go through __request_region(). The
> only difference is that request_mem_region() doesn't permit nesting,
> while insert_resource() does. There's nothing else going on here.

Indeed, I was so used to request_mem_region() that I didn't think about it 
in terms of "struct resource" management. I stand corrected.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
