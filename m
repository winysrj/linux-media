Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45739 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab1JHNm6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Oct 2011 09:42:58 -0400
Received: by wyg34 with SMTP id 34so4681527wyg.19
        for <linux-media@vger.kernel.org>; Sat, 08 Oct 2011 06:42:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4e904f71.ce66e30a.69f3.ffff9870@mx.google.com>
References: <4e83369f.5d6de30a.485b.ffffdc29@mx.google.com>
	<CAL9G6WWK-Fas4Yx2q2gPpLvo5T2SxVVNFtvSXeD7j07JbX2srw@mail.gmail.com>
	<CAATJ+fvHQgVMVp1uwxxci61qdCdxG89qK0ja-=jo4JRyGW52cw@mail.gmail.com>
	<4e8b8099.95d1e30a.4bee.0501@mx.google.com>
	<CAATJ+fvs5OXBS9VREpZM=tY+z+n97Pf42uJFqLXbh58GVZ_reA@mail.gmail.com>
	<CAL9G6WWUv+jKY7LkcJMpwMTvV+A-fzwHYJNgpbAkOiQfPoj5ng@mail.gmail.com>
	<CAATJ+fu2W=o_xhsoghK1756ZGCw2g0W_95iYC8OX04AK8jAHLg@mail.gmail.com>
	<4e8f6b0b.c90fe30a.4a1d.26bb@mx.google.com>
	<CAATJ+fvQA4zAcGq+D0+k+OHb8Xsrda5=DATWXbzEO5z=0rWZfw@mail.gmail.com>
	<CAL9G6WWMw3npqjt0WHGhyjaW5Mu=1jA5Y_QduSr3KudZTKLgBw@mail.gmail.com>
	<4e904f71.ce66e30a.69f3.ffff9870@mx.google.com>
Date: Sat, 8 Oct 2011 15:42:57 +0200
Message-ID: <CAL9G6WX4jNXcEtzmzO0+sK=5ujM+8+L38MAY7YEKtwqe6muaJw@mail.gmail.com>
Subject: Re: [PATCH] af9013 Extended monitoring in set_frontend.
From: Josu Lazkano <josu.lazkano@gmail.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: Jason Hecker <jwhecker@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/10/8 Malcolm Priestley <tvboxspy@gmail.com>:
> On Sat, 2011-10-08 at 15:13 +0200, Josu Lazkano wrote:
>> 2011/10/8 Jason Hecker <jwhecker@gmail.com>:
>> >> Try this patch, it should stop start up corruption on the same frontend.
>> >
>> > Thanks. �I'll try it today.
>> >
>> > Have you been able to reproduce any of the corruption issues I and
>> > others are having?
>> >
>> > I noticed last night some recordings on the same card had different
>> > levels of corruption depending on the order of tuning
>> >
>> > Tuner A then tuner B : Tuner A was heavily corrupted. �Tuner B was a fine.
>> > Tuner B then tuner A: Tuner A had a small corruption every few seconds
>> > and the show was watchable, Tuner B was fine.
>> >
>>
>> Thanks again, I try the patch and it works well last nigh. This
>> morning one tuner is getting pixeled images and the other can not
>> LOCK.
>>
>> This is the kernel messages:
>>
>> # tail /var/log/messages
>> Oct �8 14:16:06 htpc kernel: [45025.328902] mxl5005s I2C write failed
>> Oct �8 14:16:06 htpc kernel: [45025.333147] mxl5005s I2C write failed
>> Oct �8 14:16:06 htpc kernel: [45025.333637] mxl5005s I2C write failed
>> Oct �8 14:16:06 htpc kernel: [45025.490524] mxl5005s I2C write failed
>> Oct �8 14:16:06 htpc kernel: [45025.491014] mxl5005s I2C write failed
>> Oct �8 14:16:08 htpc kernel: [45027.642858] mxl5005s I2C write failed
>> Oct �8 14:16:08 htpc kernel: [45027.647477] mxl5005s I2C write failed
>> Oct �8 14:16:08 htpc kernel: [45027.647970] mxl5005s I2C write failed
>> Oct �8 14:16:09 htpc kernel: [45027.806477] mxl5005s I2C write failed
>> Oct �8 14:16:09 htpc kernel: [45027.806969] mxl5005s I2C write failed
>>
>> I try to increase the signal timeout from 1000 to 2000 ms and the
>> tuning timeout from 3000 to 6000 ms on mythbackend.
>>
> I have left these at the default settings
>
> Which kernels are you all running?
>
> uname -rv
>
> I think replicate your systems on my test pc.
>
>

Hello again, this is my kernel:

$ uname -rv
2.6.32-5-686 #1 SMP Fri Sep 9 20:51:05 UTC 2011

This is a Debian Squeeze system.

Regards.

-- 
Josu Lazkano
