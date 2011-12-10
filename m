Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab1LJLM0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Dec 2011 06:12:26 -0500
Message-ID: <4EE33E8C.3000101@redhat.com>
Date: Sat, 10 Dec 2011 09:12:12 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH] DVB: dvb_frontend: fix delayed thread exit
References: <1323454852-7426-1-git-send-email-mchehab@redhat.com> <4EE252E5.2050204@iki.fi> <4EE25A3C.9040404@redhat.com> <4EE25CB4.3000501@iki.fi> <4EE287A9.3000502@redhat.com> <CAGoCfiyE8JhX5fT_SYjb6_X5Mkjx1Vx34_pKYaTjXu+muWxxwg@mail.gmail.com> <4EE29BA6.1030909@redhat.com> <4EE29D1A.6010900@redhat.com> <4EE2B7BC.9090501@linuxtv.org>
In-Reply-To: <4EE2B7BC.9090501@linuxtv.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09-12-2011 23:37, Andreas Oberritter wrote:
> On 10.12.2011 00:43, Mauro Carvalho Chehab wrote:
>> On 09-12-2011 21:37, Mauro Carvalho Chehab wrote:
>>> On 09-12-2011 20:33, Devin Heitmueller wrote:
>>>> On Fri, Dec 9, 2011 at 5:11 PM, Mauro Carvalho Chehab
>>>> <mchehab@redhat.com>  wrote:
>>>>>> Could someone explain reason for that?
>>>>>
>>>>>
>>>>> I dunno, but I think this needs to be fixed, at least when the frontend
>>>>> is opened with O_NONBLOCK.
>>>>
>>>> Are you doing the drx-k firmware load on dvb_init()? That could
>>>> easily take 4 seconds.
>>>
>>> No. The firmware were opened previously.
>>
>> Maybe the delay is due to this part of dvb_frontend.c:
>>
>> static int dvb_mfe_wait_time = 5;
>> ...
>>                          int mferetry = (dvb_mfe_wait_time<<  1);
>>
>>                          mutex_unlock (&adapter->mfe_lock);
>>                          while (mferetry--&&  (mfedev->users != -1 ||
>>                                          mfepriv->thread != NULL)) {
>>                                  if(msleep_interruptible(500)) {
>>                                          if(signal_pending(current))
>>                                                  return -EINTR;
>>                                  }
>>                          }
>
> I haven't looked at the mfe code, but in case it's waiting for the
> frontend thread to exit, there's a problem that causes the thread
> not to exit immediately. Here's a patch that's been sitting in my
> queue for a while:
>
> ---
>
> Signed-off-by: Andreas Oberritter<obi@linuxtv.org>

Andreas,

Thanks for the patch!

Devin,

> diff --git a/linux/drivers/media/dvb/dvb-core/dvb_frontend.c b/linux/drivers/media/dvb/dvb-core/dvb_frontend.c
> index 7784d74..6823c2b 100644
> --- a/linux/drivers/media/dvb/dvb-core/dvb_frontend.c	2011-09-07 12:32:24.000000000 +0200
> +++ a/linux/drivers/media/dvb/dvb-core/dvb_frontend.c	2011-09-13 15:55:48.865742791 +0200
> @@ -514,7 +514,7 @@
>   		return 1;
>
>   	if (fepriv->dvbdev->writers == 1)
> -		if (time_after(jiffies, fepriv->release_jiffies +
> +		if (time_after_eq(jiffies, fepriv->release_jiffies +
>   				  dvb_shutdown_timeout * HZ))

The only change here is that it will now use dvb_shutdown_timeout instead of
(dvb_shutdown_timeout * HZ + 1).

This makes sense.

>   			return 1;
>
> @@ -2070,12 +2070,15 @@
>
>   	dprintk ("%s\n", __func__);
>
> -	if ((file->f_flags&  O_ACCMODE) != O_RDONLY)
> +	if ((file->f_flags&  O_ACCMODE) != O_RDONLY) {
>   		fepriv->release_jiffies = jiffies;
> +		mb();

This is just a memory barrier to warrant that all CPU's will consider the new value for release_jiffies.
Probably Andreas added it because he noticed some race condition.

In any case, this won't cause any regressions.

> +	}
>
>   	ret = dvb_generic_release (inode, file);
>
>   	if (dvbdev->users == -1) {
> +		wake_up(&fepriv->wait_queue);

This is the only hook that changes the core behavior.

>   		if (fepriv->exit != DVB_FE_NO_EXIT) {
>   			fops_put(file->f_op);
>   			file->f_op = NULL;

With this change, the current code at dvb_frontend_release() wil; be:

         ret = dvb_generic_release (inode, file);

      	if (dvbdev->users == -1) {
		wake_up(&fepriv->wait_queue);
                 if (fepriv->exit != DVB_FE_NO_EXIT) {
                        	fops_put(file->f_op);
                         file->f_op = NULL;
                         wake_up(&dvbdev->wait_queue);
                 }
                	if (fe->ops.ts_bus_ctrl)
                         fe->ops.ts_bus_ctrl(fe, 0);
         }

The addition of a wake_up there is that the wake_up thread will be called
also when fepriv->exit == DVB_FE_NO_EXIT. This seems to make sense, as
dvb_frontend_thread() explicitly tests for it at:

                 wait_event_interruptible_timeout(fepriv->wait_queue,
                         dvb_frontend_should_wakeup(fe) || kthread_should_stop()
                                 || freezing(current),
                         fepriv->delay);

as dvb_frontend_should_wakeup(fe) is defined (after applying this patch) as:

static int dvb_frontend_is_exiting(struct dvb_frontend *fe)
{
         struct dvb_frontend_private *fepriv = fe->frontend_priv;

         if (fepriv->exit != DVB_FE_NO_EXIT)
                 return 1;

         if (fepriv->dvbdev->writers == 1)
                 if (time_after_eq(jiffies, fepriv->release_jiffies +
                                   dvb_shutdown_timeout * HZ))
                        	return 1;

        	return 0;
}

static int dvb_frontend_should_wakeup(struct dvb_frontend *fe)
{
         struct dvb_frontend_private *fepriv = fe->frontend_priv;

         if (fepriv->wakeup) {
                 fepriv->wakeup = 0;
                 return 1;
         }
	return dvb_frontend_is_exiting(fe);
}

So, this code makes sense to me. Btw, a wait queue can wait even without
an explicit call, since it is just something like [1]:

	do schedule() while (!condition);

So, all this patch would hurt would be to increase the chance for us to
detect a bug that it is already there.

Devin,

I'll do some tests here with a few devices, but, in principle, I don't see
any reason why not applying this patch. So, except if I detect something wrong
on my tests, of if you you point us for a regression caused by this change,
I'll apply it.

Of course, it would be nice if Andreas could add some comments, but if he doesn't,
I can write something. It won't be the first patch that the maintainer would
need to insert some description.

Regards,
Mauro.

[1] The actual implementation is a more complex than that loop. In this
specific case, as it uses the interruptible version, any signal would
also wake this thread.
