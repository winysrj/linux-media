Return-path: <linux-media-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:37284 "EHLO
	slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbcGSCn5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 22:43:57 -0400
Subject: Re: [PATCH] [media] gspca: finepix: Remove deprecated
 create_singlethread_workqueue
To: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <20160716085556.GA7841@Karyakshetra>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
From: Frank Zago <frank@zago.net>
Message-ID: <578D9227.7040007@zago.net>
Date: Mon, 18 Jul 2016 21:36:23 -0500
MIME-Version: 1.0
In-Reply-To: <20160716085556.GA7841@Karyakshetra>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/16/2016 03:55 AM, Bhaktipriya Shridhar wrote:
> The workqueue "work_thread" is involved in streaming the camera data.
> It has a single work item(&dev->work_struct) and hence doesn't require
> ordering. Also, it is not being used on a memory reclaim path.
> Hence, the singlethreaded workqueue has been replaced with the use of
> system_wq.
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
> Work item has been flushed in sd_stop0() to ensure that there are no
> pending tasks while disconnecting the driver.
> 
> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>

Acked-by: Frank Zago <frank@zago.net>

Thanks for the patch.
