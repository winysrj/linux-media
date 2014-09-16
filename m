Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:55788 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292AbaIPBUE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 21:20:04 -0400
Date: Tue, 16 Sep 2014 09:19:11 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [linuxtv-media:devel 499/499]
 drivers/media/v4l2-core/videobuf2-core.c:2589 vb2_poll() warn: if();
Message-ID: <5417900f.Aceh4Gi2zx0jXyPA%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git devel
head:   e0857d1d1af8478b33e63dbb22bb2160a807d868
commit: e0857d1d1af8478b33e63dbb22bb2160a807d868 [499/499] [media] BZ#84401: Revert "[media] v4l: vb2: Don't return POLLERR during transient buffer underruns"

drivers/media/v4l2-core/videobuf2-core.c:2589 vb2_poll() warn: if();

vim +2589 drivers/media/v4l2-core/videobuf2-core.c

  2573			}
  2574			if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE) &&
  2575					(req_events & (POLLOUT | POLLWRNORM))) {
  2576				if (__vb2_init_fileio(q, 0))
  2577					return res | POLLERR;
  2578				/*
  2579				 * Write to OUTPUT queue can be done immediately.
  2580				 */
  2581				return res | POLLOUT | POLLWRNORM;
  2582			}
  2583		}
  2584	
  2585		/*
  2586		 * There is nothing to wait for if no buffer has been queued
  2587		 * or if the error flag is set.
  2588		 */
> 2589		if ((list_empty(&q->queued_list) || q->error)
  2590			return res | POLLERR;
  2591	
  2592		/*
  2593		 * For output streams you can write as long as there are fewer buffers
  2594		 * queued than there are buffers available.
  2595		 */
  2596		if (V4L2_TYPE_IS_OUTPUT(q->type) && q->queued_count < q->num_buffers)
  2597			return res | POLLOUT | POLLWRNORM;

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
