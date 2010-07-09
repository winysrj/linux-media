Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:44887 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756248Ab0GINSb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Jul 2010 09:18:31 -0400
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
In-Reply-To: <4C32D4BE.9030005@kernel.org>
References: <1277759063-24607-1-git-send-email-tj@kernel.org>
	 <1277759063-24607-3-git-send-email-tj@kernel.org>
	 <1278349860.2229.9.camel@localhost>  <4C32D4BE.9030005@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Jul 2010 09:15:34 -0400
Message-ID: <1278681334.3385.0.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2010-07-06 at 09:01 +0200, Tejun Heo wrote:
> On 07/05/2010 07:11 PM, Andy Walls wrote:
> > Assuming the new kthread_worker implementation is OK, this change for
> > ivtv looks good.
> > 
> > Reviewed-by: Andy Walls <awalls@md.metrocast.net>
> > Acked-by: Andy Walls <awalls@md.metrocast.net>
> 
> May I route this patch through wq branch?  As it's not clear how this
> whole patchset will end up, I think it would be better to keep things
> isolated in this branch.

Yes, I think that is the best way to do things.

Regards,
Andy


