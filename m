Return-path: <mchehab@localhost>
Received: from tichy.grunau.be ([85.131.189.73]:35423 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300Ab0IDRf2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Sep 2010 13:35:28 -0400
Date: Sat, 4 Sep 2010 19:29:59 +0200
From: Janne Grunau <j@jannau.net>
To: James MacLaren <jm.maclaren@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: PATCH to hdpvr-video.c solves DMA allocation problems on arm
 processsors.
Message-ID: <20100904172959.GC13521@aniel.lan>
References: <AANLkTim=Gy=hdePJBiA0M_+nvR9Netc2KXPdJCK8ZZi4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim=Gy=hdePJBiA0M_+nvR9Netc2KXPdJCK8ZZi4@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

On Fri, Sep 03, 2010 at 11:19:00AM -0500, James MacLaren wrote:
> I needed to patch hdpvr-video.c to capture on my dockstar arm
> processor.  I see that this patch has been noted on a number of other
> usb drivers on this list.
> 
> diff -Naur hdpvr-video.c hdpvr-video-jmm.c
> 
> --- hdpvr-video.c       2010-08-29 09:28:57.126133063 -0500
> +++ hdpvr-video-jmm.c   2010-09-03 08:41:37.854129338 -0500
> @@ -157,6 +157,7 @@
> 
>                                   mem, dev->bulk_in_size,
>                                   hdpvr_read_bulk_callback, buf);
> 
> +                buf->urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
> // added JMM
>                 buf->status = BUFSTAT_AVAILABLE;
>                 list_add_tail(&buf->buff_list, &dev->free_buff_list);
>         }
> 
> 
> Hopefully this patch can be applied.

yes, it can and should. Please resend the patch without the '// added JMM'
comment and your sign-off

Janne
