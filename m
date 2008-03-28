Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2SIZYMJ020520
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 14:35:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2SIZLiA028231
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 14:35:22 -0400
Date: Fri, 28 Mar 2008 15:34:42 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Brandon Philips <brandon@ifup.org>
Message-ID: <20080328153442.58b2c108@gaivota>
In-Reply-To: <304e0a371d12f77e1575.1206699518@localhost>
References: <patchbomb.1206699511@localhost>
	<304e0a371d12f77e1575.1206699518@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Subject: Re: [PATCH 7 of 9] vivi: Simplify the vivi driver and avoid
 deadlocks
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

Hi Brandon,

I'll try to test the patch series. They seems fine to my eyes, on a first look.
I have just some comments about patch 7/9.

> Also, is anyone using videobuf-vmalloc besides vivi?  The current videobuf API
> feels over extended trying to take on the task of a second backend type.

The only current driver at the tree using videobuf-vmalloc is vivi.
There's another driver using it at tm6000 driver, not merged yet [1].

On Fri, 28 Mar 2008 03:18:38 -0700
Brandon Philips <brandon@ifup.org> wrote:

> --- a/linux/drivers/media/video/vivi.c
> +++ b/linux/drivers/media/video/vivi.c
> @@ -5,6 +5,7 @@
>   *      Mauro Carvalho Chehab <mchehab--a.t--infradead.org>
>   *      Ted Walther <ted--a.t--enumera.com>
>   *      John Sokol <sokol--a.t--videotechnology.com>
> + *      Brandon Philips <brandon@ifup.org>

This is under copyright (2006), as if you were one of the authors of the
original driver. Also, I prefer if you add a short line bellow your copyright
for the job you've done on the driver. Something like:

+ *
+ *  Copyright (c) 2008 by Brandon Philips <brandon@ifup.org>
+ *       - Fix bad locks and cleans up streaming code

> -static int restart_video_queue(struct vivi_dmaqueue *dma_q)
> -{
...
> -}

While the restart and timeout code is not needed on vivi driver, IMO, we should
keep it, since the main reason for this driver is to be a reference code. 

This kind of code is important on real drivers, since the IRQ's may not be called
for some reason. On cx88 and on saa7134, this happens on several situations[2]. 

Without a timeout, the driver will wait forever to receive a buffer.

This task is also needed by tm6000 driver, for the same reasons.

[1] Available at: http://linuxtv.org/hg/~mchehab/tm6010

[2] For example, I suffered an issue yesterday with my machine, that I believe
to be caused by an excess of power consumption. The effect is that cx88 weren't
generating DMA interrupts, if I loaded my machine with 3 pci boards. The
removal of one board made the cx88 board to work again. I'll test today again
with a newer power supply. Without the timeout code, the player would just
hang, waiting forever for some data at the video buffer.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
