Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:47885 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab3AKB0b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 20:26:31 -0500
Received: by mail-ee0-f47.google.com with SMTP id e52so593224eek.20
        for <linux-media@vger.kernel.org>; Thu, 10 Jan 2013 17:26:30 -0800 (PST)
Message-ID: <50EF6A44.5070703@gmail.com>
Date: Fri, 11 Jan 2013 02:26:28 +0100
From: thomas schorpp <thomas.schorpp@gmail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Soby Mathew <soby.linuxtv@gmail.com>, linux-media@vger.kernel.org
Subject: Re: global mutex in dvb_usercopy (dvbdev.c)
References: <CAGzWAsgZGu8_JTrE1GvnpbR+W92fvRycfFhAX2NbZ9VZqorJ6w@mail.gmail.com> <20130109213043.GB7500@zorro.zusammrottung.local> <50EE223B.80204@gmail.com> <20130110122506.08494aae@redhat.com>
In-Reply-To: <20130110122506.08494aae@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10.01.2013 15:25, Mauro Carvalho Chehab wrote:
> Em Thu, 10 Jan 2013 03:06:51 +0100
> thomas schorpp <thomas.schorpp@gmail.com> escreveu:
>
>> On 09.01.2013 22:30, Nikolaus Schulz wrote:
>>> On Tue, Jan 08, 2013 at 12:05:47PM +0530, Soby Mathew wrote:
>>>> Hi Everyone,
>>>>       I have a doubt regarding about the global mutex lock in
>>>> dvb_usercopy(drivers/media/dvb-core/dvbdev.c, line 382) .
>>>>
>>>>
>>>> /* call driver */
>>>> mutex_lock(&dvbdev_mutex);
>>>> if ((err = func(file, cmd, parg)) == -ENOIOCTLCMD)
>>>> err = -EINVAL;
>>>> mutex_unlock(&dvbdev_mutex);
>>>>
>>>>
>>>> Why is this mutex needed? When I check similar functions like
>>>> video_usercopy, this kind of global locking is not present when func()
>>>> is called.
>>>
>>> I cannot say anything about video_usercopy(), but as it happens, there's
>>> a patch[1] queued for Linux 3.9 that will hopefully replace the mutex in
>>> dvb_usercopy() with more fine-grained locking.
>>>
>>> Nikolaus
>>>
>>> [1] http://git.linuxtv.org/media_tree.git/commit/30ad64b8ac539459f8975aa186421ef3db0bb5cb
>>
>> "Unfortunately, frontend ioctls can be blocked by the frontend thread for several seconds; this leads to unacceptable lock contention."
>> Especially the stv0297 signal locking, as it turned out in situations of bad signal input or my cable providers outtage today it has slowed down dvb_ttpci (notable as OSD- output latency and possibly driver buffer overflows of budget source devices) that much that I had to disable tuning with parm --outputonly in vdr-plugin-dvbsddevice.
>>
>> Can anyone confirm that and have a look at the other frontend drivers for tuners needing as much driver control?
>>
>> I will try to apply the patch manually to Linux 3.2 and check with Latencytop tomorrow.
>
> Well, an ioctl's should not block for a long time, if the device is opened
> with O_NONBLOCK. Unfortunately, not all drivers follow this rule, and
> blocks.
>
> The right fix seem to have a logic at stv0297 that would do the signal
> locking in background, or to use the already-existent DVB frontend
> thread, and answering to userspace the last cached result, instead of
> actively talking with the frontend device driver.
>
> Both approaches have advantages and disadvantages. In any case, a change
> like that at dvb core has the potential of causing troubles to userspace,
> although I think it is the better thing to do, at the long term.

Could You or another with write access commit this in http://git.linuxtv.org/media_build.git if applicable, too, please?
I'look into but I'm not yet worked in in kernel threading methods, need to read the O'reilly linux Driver book first about ;-)

y
tom

