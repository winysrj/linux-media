Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:60084 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754566Ab0GJMct (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Jul 2010 08:32:49 -0400
Subject: Re: [git:v4l-dvb/other] V4L/DVB: ivtv: use kthread_worker instead
 of workqueue
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Cc: linuxtv-commits@linuxtv.org, Tejun Heo <tj@kernel.org>
In-Reply-To: <E1OVyBy-0007oJ-03@www.linuxtv.org>
References: <E1OVyBy-0007oJ-03@www.linuxtv.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Jul 2010 08:33:06 -0400
Message-ID: <1278765186.2273.6.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2010-07-06 at 03:51 +0200, Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following patch were queued at the 
> http://git.linuxtv.org/v4l-dvb.git tree:
> 
> Subject: V4L/DVB: ivtv: use kthread_worker instead of workqueue
> Author:  Tejun Heo <tj@kernel.org>
> Date:    Mon Jun 28 18:03:50 2010 -0300
> 
> Upcoming workqueue updates will no longer guarantee fixed workqueue to
> worker kthread association, so giving RT priority to the irq worker
> won't work.  Use kthread_worker which guarantees specific kthread
> association instead.  This also makes setting the priority cleaner.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Andy Walls <awalls@md.metrocast.net>
> Acked-by: Andy Walls <awalls@md.metrocast.net>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Mauro,

Please revert this or keep it from going upstream.

It relies on at least on other patch by Tejun.  If this patch is
committed alone to the ivtv driver, it will break compilation of ivtv.

I'm OK with Tejun getting this patch committed upstream together with
his complete workqueue patchset.  Otherwise we''ll have some
coordination to go through when the workqueue patches go upstream.  That
could be hard for everyone, since my response time lately has been
rather slow.

Regards,
Andy


