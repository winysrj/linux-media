Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:32952 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbcFIJio (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jun 2016 05:38:44 -0400
Date: Thu, 9 Jun 2016 06:38:38 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Max Kellermann <max@duempel.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/6] drivers/media/dvb-core/en50221: postpone release
 until file is closed
Message-ID: <20160609063838.0ac83d84@recife.lan>
In-Reply-To: <145856702263.21117.11870746253652920203.stgit@woodpecker.blarg.de>
References: <145856701730.21117.7759662061999658129.stgit@woodpecker.blarg.de>
	<145856702263.21117.11870746253652920203.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 21 Mar 2016 14:30:22 +0100
Max Kellermann <max@duempel.org> escreveu:

> Fixes use-after-free bug which occurs when I disconnect my DVB-S
> received while VDR is running.

I guess that the best way to fix it is to use a kref() that would be also
incremented at open() and decremented at release(). 

This works better than adding other non-standard ways to manage data livetime
cycle.

Regards,
Mauro

> 
> Signed-off-by: Max Kellermann <max@duempel.org>
> ---
>  drivers/media/dvb-core/dvb_ca_en50221.c |   23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
> index e33364c..dfc686a 100644
> --- a/drivers/media/dvb-core/dvb_ca_en50221.c
> +++ b/drivers/media/dvb-core/dvb_ca_en50221.c
> @@ -148,6 +148,9 @@ struct dvb_ca_private {
>  	/* Flag indicating if the CA device is open */
>  	unsigned int open:1;
>  
> +	/* Flag indicating if the CA device is released */
> +	unsigned int released:1;
> +
>  	/* Flag indicating the thread should wake up now */
>  	unsigned int wakeup:1;
>  
> @@ -1392,6 +1395,11 @@ static int dvb_ca_en50221_io_read_condition(struct dvb_ca_private *ca,
>  	int found = 0;
>  	u8 hdr[2];
>  
> +	if (ca->released) {
> +		*result = -ENODEV;
> +		return 1;
> +	}
> +
>  	slot = ca->next_read_slot;
>  	while ((slot_count < ca->slot_count) && (!found)) {
>  		if (ca->slot_info[slot].slot_state != DVB_CA_SLOTSTATE_RUNNING)
> @@ -1595,6 +1603,9 @@ static int dvb_ca_en50221_io_release(struct inode *inode, struct file *file)
>  
>  	err = dvb_generic_release(inode, file);
>  
> +	if (ca->released)
> +		dvb_ca_private_free(ca);
> +
>  	module_put(ca->pub->owner);
>  
>  	return err;
> @@ -1701,6 +1712,7 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
>  	}
>  	init_waitqueue_head(&ca->wait_queue);
>  	ca->open = 0;
> +	ca->released = 0;
>  	ca->wakeup = 0;
>  	ca->next_read_slot = 0;
>  	pubca->private = ca;
> @@ -1765,12 +1777,21 @@ void dvb_ca_en50221_release(struct dvb_ca_en50221 *pubca)
>  
>  	dprintk("%s\n", __func__);
>  
> +	BUG_ON(ca->released);
> +
>  	/* shutdown the thread if there was one */
>  	kthread_stop(ca->thread);
>  
>  	for (i = 0; i < ca->slot_count; i++) {
>  		dvb_ca_en50221_slot_shutdown(ca, i);
>  	}
> -	dvb_ca_private_free(ca);
> +
> +	if (ca->open) {
> +		ca->released = 1;
> +		mb();
> +		wake_up_interruptible(&ca->wait_queue);
> +	} else
> +		dvb_ca_private_free(ca);
> +
>  	pubca->private = NULL;
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Thanks,
Mauro
