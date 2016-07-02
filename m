Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33581 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbcGBNby (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jul 2016 09:31:54 -0400
Date: Sat, 2 Jul 2016 08:31:30 -0500
From: Tejun Heo <tj@kernel.org>
To: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] adv7604: Remove deprecated
 create_singlethread_workqueue
Message-ID: <20160702133130.GV17431@htj.duckdns.org>
References: <20160702104355.GA2100@Karyakshetra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160702104355.GA2100@Karyakshetra>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 02, 2016 at 04:13:55PM +0530, Bhaktipriya Shridhar wrote:
> The workqueue "work_queues" enables hotplugging.
> It has a single work item(&state->delayed_work_enable_hotplug) and hence
> doesn't require ordering. Also, it is not being used on a memory
> reclaim path. Hence, the singlethreaded workqueue has been replaced with
> the use of system_wq.
> 
> System workqueues have been able to handle high level of concurrency
> for a long time now and hence it's not required to have a singlethreaded
> workqueue just to gain concurrency. Unlike a dedicated per-cpu workqueue
> created with create_singlethread_workqueue(), system_wq allows multiple
> work items to overlap executions even on the same CPU; however, a
> per-cpu workqueue doesn't have any CPU locality or global ordering
> guarantee unless the target CPU is explicitly specified and thus the
> increase of local concurrency shouldn't make any difference.
> 
> Work item has been sync cancelled in adv76xx_remove() to ensure
> that there are no pending tasks while disconnecting the driver.
> 
> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
