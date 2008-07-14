Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6EChQfH030358
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 08:43:26 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6EChE8L029341
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 08:43:15 -0400
Date: Mon, 14 Jul 2008 14:43:21 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
In-Reply-To: <487B486A.7040403@teltonika.lt>
Message-ID: <Pine.LNX.4.64.0807141443070.11348@axis700.grange>
References: <20080714120204.4806.87287.sendpatchset@rx1.opensource.se>
	<20080714120213.4806.93867.sendpatchset@rx1.opensource.se>
	<Pine.LNX.4.64.0807141427140.11348@axis700.grange>
	<487B486A.7040403@teltonika.lt>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, linux-sh@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	lethal@linux-sh.org, akpm@linux-foundation.org
Subject: Re: [PATCH 01/06] soc_camera: Move spinlocks
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

On Mon, 14 Jul 2008, Paulius Zaleckas wrote:

> Guennadi Liakhovetski wrote:
> > On Mon, 14 Jul 2008, Magnus Damm wrote:
> > 
> > > This patch moves the spinlock handling from soc_camera.c to the actual
> > > camera host driver. The spinlock alloc/free callbacks are replaced with
> > > code in init_videobuf().
> > 
> > As merits of this move were not quite obvious to me (you lose the
> > possibility to use default lock allocation / freeing in soc_camera.c), I
> > extended your comment as follows:
> > 
> > This patch moves the spinlock handling from soc_camera.c to the actual
> > camera host driver. The spinlock_alloc/free callbacks are replaced with
> > code in init_videobuf(). So far all camera host drivers implement their
> > own spinlock_alloc/free methods anyway, and videobuf_queue_core_init()
> > BUGs on a NULL spinlock argument, so, new camera host drivers will not
> > forget to provide a spinlock when initialising their videobug queues.
>                                                        videobuf

Thanks:-)

Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
