Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:34313 "EHLO
	mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbcGYTIh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jul 2016 15:08:37 -0400
Date: Mon, 25 Jul 2016 15:08:34 -0400
From: Tejun Heo <tj@kernel.org>
To: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Inki Dae <inki.dae@samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] [media] cx25821: Drop Freeing of Workqueue
Message-ID: <20160725190834.GM19588@mtj.duckdns.org>
References: <20160725144952.GA11594@Karyakshetra>
 <8c263ffbbc4cfc9ef95ba0ba6f5dbebf253784c2.1469458280.git.bhaktipriya96@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c263ffbbc4cfc9ef95ba0ba6f5dbebf253784c2.1469458280.git.bhaktipriya96@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 25, 2016 at 08:25:22PM +0530, Bhaktipriya Shridhar wrote:
> Workqueues shouldn't be freed. destroy_workqueue should be used instead.
> destroy_workqueue safely destroys a workqueue and ensures that all pending
> work items are done before destroying the workqueue.
> 
> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Mauro, can you please pick this one up?  It prolly should be tagged
for -stable too.

Thanks.

-- 
tejun
