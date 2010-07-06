Return-path: <linux-media-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:42419 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab0GFHC1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Jul 2010 03:02:27 -0400
Message-ID: <4C32D4BE.9030005@kernel.org>
Date: Tue, 06 Jul 2010 09:01:18 +0200
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: torvalds@linux-foundation.org, mingo@elte.hu,
	linux-kernel@vger.kernel.org, jeff@garzik.org,
	akpm@linux-foundation.org, rusty@rustcorp.com.au,
	cl@linux-foundation.org, dhowells@redhat.com,
	arjan@linux.intel.com, oleg@redhat.com, axboe@kernel.dk,
	fweisbec@gmail.com, dwalker@codeaurora.org,
	stefanr@s5r6.in-berlin.de, florian@mickler.org,
	andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com,
	ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 02/35] ivtv: use kthread_worker instead of workqueue
References: <1277759063-24607-1-git-send-email-tj@kernel.org>	 <1277759063-24607-3-git-send-email-tj@kernel.org> <1278349860.2229.9.camel@localhost>
In-Reply-To: <1278349860.2229.9.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/05/2010 07:11 PM, Andy Walls wrote:
> Assuming the new kthread_worker implementation is OK, this change for
> ivtv looks good.
> 
> Reviewed-by: Andy Walls <awalls@md.metrocast.net>
> Acked-by: Andy Walls <awalls@md.metrocast.net>

May I route this patch through wq branch?  As it's not clear how this
whole patchset will end up, I think it would be better to keep things
isolated in this branch.

Thank you.

-- 
tejun
