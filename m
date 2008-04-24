Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3OIwmZs003762
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 14:58:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3OIwaaJ005070
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 14:58:36 -0400
Date: Thu, 24 Apr 2008 15:58:21 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Janne Grunau <janne-dvb@grunau.be>
Message-ID: <20080424155821.0644cc5d@gaivota>
In-Reply-To: <200804242040.32914.janne-dvb@grunau.be>
References: <200804242040.32914.janne-dvb@grunau.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Copy and paste error in em28xx_init_isoc
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

Hi Janne,

On Thu, 24 Apr 2008 20:40:32 +0200
Janne Grunau <janne-dvb@grunau.be> wrote:

> Hi,
> 
> attached patch fixes a copy and paste error in check of kzalloc return 
> value. The check block was copied from the previous allocation but the 
> variable wasn't exchanged.

Thanks for the patch.

> diff -r 64a50d51c60b linux/drivers/media/video/em28xx/em28xx-core.c
> --- a/linux/drivers/media/video/em28xx/em28xx-core.c	Wed Apr 23 13:57:47 2008 +0200
> +++ b/linux/drivers/media/video/em28xx/em28xx-core.c	Thu Apr 24 20:40:23 2008 +0200
> @@ -659,9 +659,9 @@ int em28xx_init_isoc(struct em28xx *dev,
>  
>  	dev->isoc_ctl.transfer_buffer = kzalloc(sizeof(void *)*num_bufs,
>  					      GFP_KERNEL);
> -	if (!dev->isoc_ctl.urb) {
> +	if (!dev->isoc_ctl.transfer_buffer) {

Yes, this is clearly a copy-and-paste error.

>  		em28xx_errdev("cannot allocate memory for usbtransfer\n");
> -		kfree(dev->isoc_ctl.urb);
> +		kfree(dev->isoc_ctl.transfer_buffer);

This, however, were right. isoc_ctl.urb is allocated, and should be freed.
However, transfer_buffer is NULL, so it doesn't need kfree.

Could you please re-generate the patch and send me again?

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
