Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:42237 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758024Ab3AJCHH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2013 21:07:07 -0500
Received: by mail-ee0-f44.google.com with SMTP id l10so16790eei.17
        for <linux-media@vger.kernel.org>; Wed, 09 Jan 2013 18:07:06 -0800 (PST)
Message-ID: <50EE223B.80204@gmail.com>
Date: Thu, 10 Jan 2013 03:06:51 +0100
From: thomas schorpp <thomas.schorpp@gmail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
To: Soby Mathew <soby.linuxtv@gmail.com>, linux-media@vger.kernel.org
Subject: Re: global mutex in dvb_usercopy (dvbdev.c)
References: <CAGzWAsgZGu8_JTrE1GvnpbR+W92fvRycfFhAX2NbZ9VZqorJ6w@mail.gmail.com> <20130109213043.GB7500@zorro.zusammrottung.local>
In-Reply-To: <20130109213043.GB7500@zorro.zusammrottung.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09.01.2013 22:30, Nikolaus Schulz wrote:
> On Tue, Jan 08, 2013 at 12:05:47PM +0530, Soby Mathew wrote:
>> Hi Everyone,
>>      I have a doubt regarding about the global mutex lock in
>> dvb_usercopy(drivers/media/dvb-core/dvbdev.c, line 382) .
>>
>>
>> /* call driver */
>> mutex_lock(&dvbdev_mutex);
>> if ((err = func(file, cmd, parg)) == -ENOIOCTLCMD)
>> err = -EINVAL;
>> mutex_unlock(&dvbdev_mutex);
>>
>>
>> Why is this mutex needed? When I check similar functions like
>> video_usercopy, this kind of global locking is not present when func()
>> is called.
>
> I cannot say anything about video_usercopy(), but as it happens, there's
> a patch[1] queued for Linux 3.9 that will hopefully replace the mutex in
> dvb_usercopy() with more fine-grained locking.
>
> Nikolaus
>
> [1] http://git.linuxtv.org/media_tree.git/commit/30ad64b8ac539459f8975aa186421ef3db0bb5cb

"Unfortunately, frontend ioctls can be blocked by the frontend thread for several seconds; this leads to unacceptable lock contention."
Especially the stv0297 signal locking, as it turned out in situations of bad signal input or my cable providers outtage today it has slowed down dvb_ttpci (notable as OSD- output latency and possibly driver buffer overflows of budget source devices) that much that I had to disable tuning with parm --outputonly in vdr-plugin-dvbsddevice.

Can anyone confirm that and have a look at the other frontend drivers for tuners needing as much driver control?

I will try to apply the patch manually to Linux 3.2 and check with Latencytop tomorrow.

y
tom





