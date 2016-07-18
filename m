Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36559 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbcGRXzm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 19:55:42 -0400
Date: Mon, 18 Jul 2016 19:55:27 -0400
From: Tejun Heo <tj@kernel.org>
To: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Inki Dae <inki.dae@samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] [media] cx25821: Drop Freeing of Workqueue
Message-ID: <20160718235527.GX3078@mtj.duckdns.org>
References: <cover.1468659580.git.bhaktipriya96@gmail.com>
 <c138d0a859516d8a4176c4ddb32b83119d4ad51c.1468659580.git.bhaktipriya96@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c138d0a859516d8a4176c4ddb32b83119d4ad51c.1468659580.git.bhaktipriya96@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 16, 2016 at 02:41:49PM +0530, Bhaktipriya Shridhar wrote:
> Workqueues shouldn't be freed. destroy_workqueue should be used instead.
> destroy_workqueue safely destroys a workqueue and ensures that all pending
> work items are done before destroying the workqueue.
> 
> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

This needs to be marked for stable.

Thanks.

-- 
tejun
