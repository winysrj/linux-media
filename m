Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway04.websitewelcome.com ([67.18.10.5]:32845 "HELO
	gateway04.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751618AbZIXDXm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Sep 2009 23:23:42 -0400
Message-ID: <4ABAADEF.1030309@sensoray.com>
Date: Wed, 23 Sep 2009 16:23:27 -0700
From: dean <dean@sensoray.com>
MIME-Version: 1.0
To: Mike Isely <isely@isely.net>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] s2255drv: Don't conditionalize video buffer completion
 on waiting processes
References: <alpine.DEB.1.10.0909231603210.29815@cnc.isely.net>
In-Reply-To: <alpine.DEB.1.10.0909231603210.29815@cnc.isely.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This seems ok.  This portion of code was based on vivi.c, so that might 
be checked also.



Mike Isely wrote:
> # HG changeset patch
> # User Mike Isely <isely@pobox.com>
> # Date 1253739604 18000
> # Node ID 522a74147753ba59c7f45e368439928090a286f2
> # Parent  e349075171ddf939381fad432c23c1269abc4899
> s2255drv: Don't conditionalize video buffer completion on waiting processes
>
> From: Mike Isely <isely@pobox.com>
>
> The s2255 driver had logic which aborted processing of a video frame
> if there was no process waiting on the video buffer in question.  That
> simply doesn't work when the application is doing things in an
> asynchronous manner.  If the application went to the trouble to queue
> the buffer in the first place, then the driver should always attempt
> to complete it - even if the application at that moment has its
> attention turned elsewhere.  Applications which always blocked waiting
> for I/O on the capture device would not have been affected by this.
> Applications which *mostly* blocked waiting for I/O on the capture
> device probably only would have been somewhat affected (frame lossage,
> at a rate which goes up as the application blocks less).  Applications
> which never blocked on the capture device (e.g. polling only) however
> would never have been able to receive any video frames, since in that
> case this "is anyone waiting on this?" check on the buffer never would
> have evalutated true.  This patch just deletes that harmful check
> against the buffer's wait queue.
>
> Priority: high
>
> Signed-off-by: Mike Isely <isely@pobox.com>
>
> diff -r e349075171dd -r 522a74147753 linux/drivers/media/video/s2255drv.c
> --- a/linux/drivers/media/video/s2255drv.c	Mon Sep 21 10:42:22 2009 -0500
> +++ b/linux/drivers/media/video/s2255drv.c	Wed Sep 23 16:00:04 2009 -0500
> @@ -599,11 +599,6 @@
>  	buf = list_entry(dma_q->active.next,
>  			 struct s2255_buffer, vb.queue);
>  
> -	if (!waitqueue_active(&buf->vb.done)) {
> -		/* no one active */
> -		rc = -1;
> -		goto unlock;
> -	}
>  	list_del(&buf->vb.queue);
>  	do_gettimeofday(&buf->vb.ts);
>  	dprintk(100, "[%p/%d] wakeup\n", buf, buf->vb.i);
>
>
>   

