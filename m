Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413Ab1IWWuN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 18:50:13 -0400
Message-ID: <4E7D0D1E.9020900@redhat.com>
Date: Fri, 23 Sep 2011 19:50:06 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: doronc@siano-ms.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH  15/17]DVB:Siano drivers - Bug fix - avoid (rare) dead
 locks causing the driver to hang when module removed.
References: <1316514720.5199.93.camel@Doron-Ubuntu>
In-Reply-To: <1316514720.5199.93.camel@Doron-Ubuntu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-09-2011 07:32, Doron Cohen escreveu:
> Hi,
> This patch step is a  Bug fix - avoid (rare) dead locks causing the
> driver to hang when module removed.
> Thanks,
> Doron Cohen
> 
> -----------------------
> 
>>From ad75d9ce48d440c6db6c5147530f1e23de2fcb28 Mon Sep 17 00:00:00 2001
> From: Doron Cohen <doronc@siano-ms.com>
> Date: Tue, 20 Sep 2011 08:46:52 +0300
> Subject: [PATCH 19/21] Bug fix - waiting for free buffers might have
> caused dead locks. Mechanism changed so locks are released around each
> wait.
> 
> ---
>  drivers/media/dvb/siano/smscoreapi.c |   53
> +++++++++++++++++++++++++++------
>  1 files changed, 43 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/dvb/siano/smscoreapi.c
> b/drivers/media/dvb/siano/smscoreapi.c
> index bb92351..0555a38 100644
> --- a/drivers/media/dvb/siano/smscoreapi.c
> +++ b/drivers/media/dvb/siano/smscoreapi.c
> @@ -1543,26 +1543,59 @@ EXPORT_SYMBOL_GPL(smscore_onresponse);
>   *
>   * @return pointer to descriptor on success, NULL on error.
>   */
> -
> -struct smscore_buffer_t *get_entry(struct smscore_device_t *coredev)
> +struct smscore_buffer_t *smscore_getbuffer(struct smscore_device_t
> *coredev)
>  {
>  	struct smscore_buffer_t *cb = NULL;
>  	unsigned long flags;
>  
> +	DEFINE_WAIT(wait);
> +
> +	spin_lock_irqsave(&coredev->bufferslock, flags);
> +
> +	/* set the current process state to interruptible sleep
> +	 * in case schedule() will be called, this process will go to sleep 
> +	 * and woken up only when a new buffer is available (see
> smscore_putbuffer)
> +	 */
> +	prepare_to_wait(&coredev->buffer_mng_waitq, &wait,
> TASK_INTERRUPTIBLE);
> +
> +	if (list_empty(&coredev->buffers)) {
> +		sms_debug("no avaliable common buffer, need to schedule");
> +
> +		/* 
> +         * before going to sleep, release the lock 
> +         */
> +		spin_unlock_irqrestore(&coredev->bufferslock, flags);
> +
> +		schedule();
> +
> +		sms_debug("wake up after schedule()");
> +
> +		/* 
> +         * acquire the lock again 
> +         */
>  	spin_lock_irqsave(&coredev->bufferslock, flags);
> -	if (!list_empty(&coredev->buffers)) {
> -		cb = (struct smscore_buffer_t *) coredev->buffers.next;
> -		list_del(&cb->entry);
>  	}

The proper fix is not to call schedule(). It is to use a waitqueue. The
current driver has it already. I think you're likely reverting the fix here.
Please take a look at the git history to see how it was solved.

> +
> +	/* 
> +         * in case that schedule() was skipped, set the process state
> to running
> +	 */
> +	finish_wait(&coredev->buffer_mng_waitq, &wait);
> +
> +	/* 
> +         * verify that the list is not empty, since it might have been 
> +	 * emptied during the sleep
> +	 * comment : this sitation can be avoided using
> spin_unlock_irqrestore_exclusive	
> +	 */	
> +	if (list_empty(&coredev->buffers)) {
> +		sms_err("failed to allocate buffer, returning NULL");
>  	spin_unlock_irqrestore(&coredev->bufferslock, flags);
> -	return cb;
> +		return NULL;
>  }
>  
> -struct smscore_buffer_t *smscore_getbuffer(struct smscore_device_t
> *coredev)
> -{
> -	struct smscore_buffer_t *cb = NULL;
> +	cb = (struct smscore_buffer_t *) coredev->buffers.next;
> +	list_del(&cb->entry);
>  
> -	wait_event(coredev->buffer_mng_waitq, (cb = get_entry(coredev)));
> +	spin_unlock_irqrestore(&coredev->bufferslock, flags);
>  
>  	return cb;
>  }

