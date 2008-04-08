Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m38FSAiT000557
	for <video4linux-list@redhat.com>; Tue, 8 Apr 2008 11:28:10 -0400
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.177])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m38FRvrR021477
	for <video4linux-list@redhat.com>; Tue, 8 Apr 2008 11:27:57 -0400
Received: by py-out-1112.google.com with SMTP id a29so2196168pyi.0
	for <video4linux-list@redhat.com>; Tue, 08 Apr 2008 08:27:57 -0700 (PDT)
Date: Tue, 8 Apr 2008 07:58:26 -0700
From: Brandon Philips <brandon@ifup.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080408145826.GA17398@plankton.public.utexas.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Cc: v4l <video4linux-list@redhat.com>
Subject: changeset: 7516:e59033a1b38f summary: videobuf-vmalloc: fix
	STREAMOFF/STREAMON
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

From: http://linuxtv.org/hg/~mchehab/em28xx-vb

> diff --git a/linux/drivers/media/video/videobuf-vmalloc.c b/linux/drivers/media/video/videobuf-vmalloc.c
> --- a/linux/drivers/media/video/videobuf-vmalloc.c
> +++ b/linux/drivers/media/video/videobuf-vmalloc.c
> @@ -78,6 +79,18 @@ videobuf_vm_close(struct vm_area_struct 
>  
>  			if (q->bufs[i]->map != map)
>  				continue;
> +
> +			mem = q->bufs[i]->priv;
> +			if (mem) {
> +				/* This callback is called only if kernel has
> +				   allocated memory and this memory is mmapped.
> +				   In this case, memory should be freed,
> +				   in order to do memory unmap.
> +				 */
> +				MAGIC_CHECK(mem->magic, MAGIC_VMAL_MEM);
> +				vfree(mem->vmalloc);
> +				mem->vmalloc = NULL;
> +			}

Will this work?  The code only holds the vb_lock but the drivers protect
the vmalloc area with a spinlock.  I don't think we can free this
without the spinlock too or the driver will be copying to a free'd area.

It seems we need a reference count on the buffers to do this right.

Cheers,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
