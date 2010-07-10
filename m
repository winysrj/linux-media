Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755305Ab0GJOML (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Jul 2010 10:12:11 -0400
Message-ID: <4C387FC3.8030508@redhat.com>
Date: Sat, 10 Jul 2010 11:12:19 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: linux-media@vger.kernel.org, linuxtv-commits@linuxtv.org
Subject: Re: [git:v4l-dvb/other] V4L/DVB: ivtv: use kthread_worker instead
 of workqueue
References: <E1OVyBy-0007oJ-03@www.linuxtv.org>	 <1278765186.2273.6.camel@localhost>  <4C386D62.4060202@redhat.com> <1278767236.2273.33.camel@localhost>
In-Reply-To: <1278767236.2273.33.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 10-07-2010 10:07, Andy Walls escreveu:
> On Sat, 2010-07-10 at 09:53 -0300, Mauro Carvalho Chehab wrote:
>> Em 10-07-2010 09:33, Andy Walls escreveu:
>>> On Tue, 2010-07-06 at 03:51 +0200, Mauro Carvalho Chehab wrote:
>>>> This is an automatic generated email to let you know that the following patch were queued at the 
>>>> http://git.linuxtv.org/v4l-dvb.git tree:
>>>>
>>>> Subject: V4L/DVB: ivtv: use kthread_worker instead of workqueue
>>>> Author:  Tejun Heo <tj@kernel.org>
>>>> Date:    Mon Jun 28 18:03:50 2010 -0300
>>>>
>>>> Upcoming workqueue updates will no longer guarantee fixed workqueue to
>>>> worker kthread association, so giving RT priority to the irq worker
>>>> won't work.  Use kthread_worker which guarantees specific kthread
>>>> association instead.  This also makes setting the priority cleaner.
>>>>
>>>> Signed-off-by: Tejun Heo <tj@kernel.org>
>>>> Reviewed-by: Andy Walls <awalls@md.metrocast.net>
>>>> Acked-by: Andy Walls <awalls@md.metrocast.net>
>>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>>
>>> Mauro,
>>>
>>> Please revert this or keep it from going upstream.
>>
>> I already did it locally at commit 635c644cdd1557a69e99bda0dcadaf006b66d432.
>> I just forgot to push it to the linuxtv repository ;)
>> I just updated upstream with this patch and another set of commits I did here.
>>
> 
> :(
> 
> Hmmm.  I should really read my personal email more frequently than every
> few days.
> 
> Is there anything you need me to do to help fix this? Provide my SOB on
> a reversion patch?  Submit a reversion patch with an explanation and my
> SOB?
> 
> Let me know.  I should be available most of today (EDT timezone).

For linux-next, I'll probably just send both patches, since it makes my life easier, but
my intention is to just remove the two patches at the next submission window.
So, feel free to ping me just after 2.6.35 launch, if you want me to remember about that ;)

Cheers,
Mauro.
