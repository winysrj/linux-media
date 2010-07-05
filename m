Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:39740 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752035Ab0GERMW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Jul 2010 13:12:22 -0400
Subject: Re: [PATCH 02/35] ivtv: use kthread_worker instead of workqueue
From: Andy Walls <awalls@md.metrocast.net>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu,
	linux-kernel@vger.kernel.org, jeff@garzik.org,
	akpm@linux-foundation.org, rusty@rustcorp.com.au,
	cl@linux-foundation.org, dhowells@redhat.com,
	arjan@linux.intel.com, oleg@redhat.com, axboe@kernel.dk,
	fweisbec@gmail.com, dwalker@codeaurora.org,
	stefanr@s5r6.in-berlin.de, florian@mickler.org,
	andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com,
	ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
In-Reply-To: <1277759063-24607-3-git-send-email-tj@kernel.org>
References: <1277759063-24607-1-git-send-email-tj@kernel.org>
	 <1277759063-24607-3-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Jul 2010 13:11:00 -0400
Message-ID: <1278349860.2229.9.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-06-28 at 23:03 +0200, Tejun Heo wrote:
> Upcoming workqueue updates will no longer guarantee fixed workqueue to
> worker kthread association, so giving RT priority to the irq worker
> won't work.  Use kthread_worker which guarantees specific kthread
> association instead.  This also makes setting the priority cleaner.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Andy Walls <awalls@md.metrocast.net>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: ivtv-devel@ivtvdriver.org
> Cc: linux-media@vger.kernel.org


Assuming the new kthread_worker implementation is OK, this change for
ivtv looks good.

Reviewed-by: Andy Walls <awalls@md.metrocast.net>
Acked-by: Andy Walls <awalls@md.metrocast.net>

Regards,
Andy

>  drivers/media/video/ivtv/ivtv-driver.c |   26 ++++++++++++++++----------
>  drivers/media/video/ivtv/ivtv-driver.h |    8 ++++----
>  drivers/media/video/ivtv/ivtv-irq.c    |   15 +++------------
>  drivers/media/video/ivtv/ivtv-irq.h    |    2 +-
>  4 files changed, 24 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/media/video/ivtv/ivtv-driver.c b/drivers/media/video/ivtv/ivtv-driver.c
> index 1b79475..49e0b1c 100644
> --- a/drivers/media/video/ivtv/ivtv-driver.c
> +++ b/drivers/media/video/ivtv/ivtv-driver.c


