Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:32789 "EHLO
	mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbcGRXuD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 19:50:03 -0400
Date: Mon, 18 Jul 2016 19:50:00 -0400
From: Tejun Heo <tj@kernel.org>
To: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] s5p-mfc: Remove deprecated
 create_singlethread_workqueue
Message-ID: <20160718235000.GR3078@mtj.duckdns.org>
References: <20160716083025.GA7294@Karyakshetra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160716083025.GA7294@Karyakshetra>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 16, 2016 at 02:00:25PM +0530, Bhaktipriya Shridhar wrote:
> alloc_workqueue replaces deprecated create_singlethread_workqueue().
> 
> The MFC device driver is a v4l2 driver which can encode/decode video
> raw/elementary streams and has support for all popular video codecs.
> 
> The driver's watchdog_workqueue has been replaced with system_wq since
> it queues a single work item, &dev->watchdog_work, which calls for no
> ordering requirement. The work item is involved in running the watchdog
> timer and is not being used on a memory reclaim path.
> 
> Work item has been flushed in s5p_mfc_remove() to ensure
> that there are no pending tasks while disconnecting the driver.
> 
> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
