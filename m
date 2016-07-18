Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:33616 "EHLO
	mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbcGRX4k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 19:56:40 -0400
Date: Mon, 18 Jul 2016 19:56:38 -0400
From: Tejun Heo <tj@kernel.org>
To: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Inki Dae <inki.dae@samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] [media] cx25821: Remove deprecated
 create_singlethread_workqueue
Message-ID: <20160718235638.GY3078@mtj.duckdns.org>
References: <cover.1468659580.git.bhaktipriya96@gmail.com>
 <ee0a1b0f01f07c3e0e1cbd2fa86e5da4c43629cb.1468659580.git.bhaktipriya96@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee0a1b0f01f07c3e0e1cbd2fa86e5da4c43629cb.1468659580.git.bhaktipriya96@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 16, 2016 at 02:43:20PM +0530, Bhaktipriya Shridhar wrote:
> The workqueue "_irq_audio_queues" runs the audio upstream handler.
> It has a single work item(&dev->_audio_work_entry) and hence doesn't
> require ordering. Also, it is not being used on a memory reclaim path.
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

The patch seems to be missing update to wq destruction path.

Thanks.

-- 
tejun
