Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54283 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab1LJB7g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2011 20:59:36 -0500
Received: by ghbz2 with SMTP id z2so3036029ghb.19
        for <linux-media@vger.kernel.org>; Fri, 09 Dec 2011 17:59:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EE2B7BC.9090501@linuxtv.org>
References: <1323454852-7426-1-git-send-email-mchehab@redhat.com>
	<4EE252E5.2050204@iki.fi>
	<4EE25A3C.9040404@redhat.com>
	<4EE25CB4.3000501@iki.fi>
	<4EE287A9.3000502@redhat.com>
	<CAGoCfiyE8JhX5fT_SYjb6_X5Mkjx1Vx34_pKYaTjXu+muWxxwg@mail.gmail.com>
	<4EE29BA6.1030909@redhat.com>
	<4EE29D1A.6010900@redhat.com>
	<4EE2B7BC.9090501@linuxtv.org>
Date: Fri, 9 Dec 2011 20:59:34 -0500
Message-ID: <CAGoCfizNCqHv1iwrFNTdOxpawVB3NzJnOF=U4hn8CXZQne=Vkw@mail.gmail.com>
Subject: Re: [PATCH] DVB: dvb_frontend: fix delayed thread exit
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 9, 2011 at 8:37 PM, Andreas Oberritter <obi@linuxtv.org> wrote:
> On 10.12.2011 00:43, Mauro Carvalho Chehab wrote:
>> On 09-12-2011 21:37, Mauro Carvalho Chehab wrote:
>>> On 09-12-2011 20:33, Devin Heitmueller wrote:
>>>> On Fri, Dec 9, 2011 at 5:11 PM, Mauro Carvalho Chehab
>>>> <mchehab@redhat.com> wrote:
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
>>                         int mferetry = (dvb_mfe_wait_time << 1);
>>
>>                         mutex_unlock (&adapter->mfe_lock);
>>                         while (mferetry-- && (mfedev->users != -1 ||
>>                                         mfepriv->thread != NULL)) {
>>                                 if(msleep_interruptible(500)) {
>>                                         if(signal_pending(current))
>>                                                 return -EINTR;
>>                                 }
>>                         }
>
> I haven't looked at the mfe code, but in case it's waiting for the
> frontend thread to exit, there's a problem that causes the thread
> not to exit immediately. Here's a patch that's been sitting in my
> queue for a while:
>
> ---
>
> Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
>
> diff --git a/linux/drivers/media/dvb/dvb-core/dvb_frontend.c b/linux/drivers/media/dvb/dvb-core/dvb_frontend.c
> index 7784d74..6823c2b 100644
> --- a/linux/drivers/media/dvb/dvb-core/dvb_frontend.c   2011-09-07 12:32:24.000000000 +0200
> +++ a/linux/drivers/media/dvb/dvb-core/dvb_frontend.c   2011-09-13 15:55:48.865742791 +0200
> @@ -514,7 +514,7 @@
>                return 1;
>
>        if (fepriv->dvbdev->writers == 1)
> -               if (time_after(jiffies, fepriv->release_jiffies +
> +               if (time_after_eq(jiffies, fepriv->release_jiffies +
>                                  dvb_shutdown_timeout * HZ))
>                        return 1;
>
> @@ -2070,12 +2070,15 @@
>
>        dprintk ("%s\n", __func__);
>
> -       if ((file->f_flags & O_ACCMODE) != O_RDONLY)
> +       if ((file->f_flags & O_ACCMODE) != O_RDONLY) {
>                fepriv->release_jiffies = jiffies;
> +               mb();
> +       }
>
>        ret = dvb_generic_release (inode, file);
>
>        if (dvbdev->users == -1) {
> +               wake_up(&fepriv->wait_queue);
>                if (fepriv->exit != DVB_FE_NO_EXIT) {
>                        fops_put(file->f_op);
>                        file->f_op = NULL;

This patch needs to have a much better explanation of exactly what it
does and what problem it solves.  We have a history of race conditions
in dvb_frontend.c, and it's patches like this with virtually no
details just makes it worse.

I'm not arguing the actual merits of the code change - it *may* be
correct.  But without the appropriate background there is no real way
of knowing...

Mauro, this patch should be NACK'd and resubmitted with a detailed
explanation of the current behavior, what the problem is, and how the
code changes proposed solve that problem.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
