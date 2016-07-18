Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:33451 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbcGRX6b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 19:58:31 -0400
Date: Mon, 18 Jul 2016 19:58:29 -0400
From: Tejun Heo <tj@kernel.org>
To: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [media] ad9389b: Remove deprecated
 create_singlethread_workqueue
Message-ID: <20160718235829.GZ3078@mtj.duckdns.org>
References: <20160716094241.GA10290@Karyakshetra>
 <20160716110441.GA15391@Karyakshetra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160716110441.GA15391@Karyakshetra>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 16, 2016 at 04:34:41PM +0530, Bhaktipriya Shridhar wrote:
> The workqueue work_queue is involved in EDID (Extended Display
> Identification Data) handling.
> 
> It has a single work item(&state->edid_handler) and hence
> doesn't require ordering. It is not being used on a memory reclaim path.
> Hence, the singlethreaded workqueue has been replaced with
> the use of system_wq.
> 
> &state->edid_handler is a self requeueing work item and it has been
> been sync cancelled in ad9389b_remove() to ensure that nothing is
> pending when the driver is disconnected.
> 
> The unused label err_unreg has also been dropped.
> 
> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
