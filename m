Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12406 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbaIPAqE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 20:46:04 -0400
Date: Tue, 16 Sep 2014 08:45:35 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [linuxtv-media:devel 499/499]
 drivers/media/v4l2-core/videobuf2-core.c:2590:3: error: expected ')' before 'return'
Message-ID: <5417882f.yH9BoAcyNRhP8//C%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git devel
head:   e0857d1d1af8478b33e63dbb22bb2160a807d868
commit: e0857d1d1af8478b33e63dbb22bb2160a807d868 [499/499] [media] BZ#84401: Revert "[media] v4l: vb2: Don't return POLLERR during transient buffer underruns"
config: ia64-allmodconfig
reproduce:
  wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
  chmod +x ~/bin/make.cross
  git checkout e0857d1d1af8478b33e63dbb22bb2160a807d868
  make.cross ARCH=ia64  allmodconfig
  make.cross ARCH=ia64 

All error/warnings:

   drivers/media/v4l2-core/videobuf2-core.c: In function 'vb2_poll':
>> drivers/media/v4l2-core/videobuf2-core.c:2590:3: error: expected ')' before 'return'
      return res | POLLERR;
      ^
>> drivers/media/v4l2-core/videobuf2-core.c:2618:1: error: expected expression before '}' token
    }
    ^
   drivers/media/v4l2-core/videobuf2-core.c:2549:16: warning: unused variable 'flags' [-Wunused-variable]
     unsigned long flags;
                   ^
   drivers/media/v4l2-core/videobuf2-core.c:2547:21: warning: unused variable 'vb' [-Wunused-variable]
     struct vb2_buffer *vb = NULL;
                        ^
>> drivers/media/v4l2-core/videobuf2-core.c:2618:1: warning: control reaches end of non-void function [-Wreturn-type]
    }
    ^

vim +2590 drivers/media/v4l2-core/videobuf2-core.c

b25748fe drivers/media/video/videobuf2-core.c     Marek Szyprowski      2010-12-06  2584  
b25748fe drivers/media/video/videobuf2-core.c     Marek Szyprowski      2010-12-06  2585  	/*
e0857d1d drivers/media/v4l2-core/videobuf2-core.c Mauro Carvalho Chehab 2014-09-15  2586  	 * There is nothing to wait for if no buffer has been queued
e0857d1d drivers/media/v4l2-core/videobuf2-core.c Mauro Carvalho Chehab 2014-09-15  2587  	 * or if the error flag is set.
e23ccc0a drivers/media/video/videobuf2-core.c     Pawel Osciak          2010-10-11  2588  	 */
e0857d1d drivers/media/v4l2-core/videobuf2-core.c Mauro Carvalho Chehab 2014-09-15  2589  	if ((list_empty(&q->queued_list) || q->error)
95213ceb drivers/media/video/videobuf2-core.c     Hans Verkuil          2011-07-13  2590  		return res | POLLERR;
e23ccc0a drivers/media/video/videobuf2-core.c     Pawel Osciak          2010-10-11  2591  
1612f20e drivers/media/v4l2-core/videobuf2-core.c Hans Verkuil          2014-07-24  2592  	/*
1612f20e drivers/media/v4l2-core/videobuf2-core.c Hans Verkuil          2014-07-24  2593  	 * For output streams you can write as long as there are fewer buffers
1612f20e drivers/media/v4l2-core/videobuf2-core.c Hans Verkuil          2014-07-24  2594  	 * queued than there are buffers available.
1612f20e drivers/media/v4l2-core/videobuf2-core.c Hans Verkuil          2014-07-24  2595  	 */
1612f20e drivers/media/v4l2-core/videobuf2-core.c Hans Verkuil          2014-07-24  2596  	if (V4L2_TYPE_IS_OUTPUT(q->type) && q->queued_count < q->num_buffers)
1612f20e drivers/media/v4l2-core/videobuf2-core.c Hans Verkuil          2014-07-24  2597  		return res | POLLOUT | POLLWRNORM;
1612f20e drivers/media/v4l2-core/videobuf2-core.c Hans Verkuil          2014-07-24  2598  
412cb87d drivers/media/v4l2-core/videobuf2-core.c Seung-Woo Kim         2013-05-20  2599  	if (list_empty(&q->done_list))
e23ccc0a drivers/media/video/videobuf2-core.c     Pawel Osciak          2010-10-11  2600  		poll_wait(file, &q->done_wq, wait);
e23ccc0a drivers/media/video/videobuf2-core.c     Pawel Osciak          2010-10-11  2601  
e23ccc0a drivers/media/video/videobuf2-core.c     Pawel Osciak          2010-10-11  2602  	/*
e23ccc0a drivers/media/video/videobuf2-core.c     Pawel Osciak          2010-10-11  2603  	 * Take first buffer available for dequeuing.
e23ccc0a drivers/media/video/videobuf2-core.c     Pawel Osciak          2010-10-11  2604  	 */
e23ccc0a drivers/media/video/videobuf2-core.c     Pawel Osciak          2010-10-11  2605  	spin_lock_irqsave(&q->done_lock, flags);
e23ccc0a drivers/media/video/videobuf2-core.c     Pawel Osciak          2010-10-11  2606  	if (!list_empty(&q->done_list))
e23ccc0a drivers/media/video/videobuf2-core.c     Pawel Osciak          2010-10-11  2607  		vb = list_first_entry(&q->done_list, struct vb2_buffer,
e23ccc0a drivers/media/video/videobuf2-core.c     Pawel Osciak          2010-10-11  2608  					done_entry);
e23ccc0a drivers/media/video/videobuf2-core.c     Pawel Osciak          2010-10-11  2609  	spin_unlock_irqrestore(&q->done_lock, flags);
e23ccc0a drivers/media/video/videobuf2-core.c     Pawel Osciak          2010-10-11  2610  
e23ccc0a drivers/media/video/videobuf2-core.c     Pawel Osciak          2010-10-11  2611  	if (vb && (vb->state == VB2_BUF_STATE_DONE
e23ccc0a drivers/media/video/videobuf2-core.c     Pawel Osciak          2010-10-11  2612  			|| vb->state == VB2_BUF_STATE_ERROR)) {
95213ceb drivers/media/video/videobuf2-core.c     Hans Verkuil          2011-07-13  2613  		return (V4L2_TYPE_IS_OUTPUT(q->type)) ?
95213ceb drivers/media/video/videobuf2-core.c     Hans Verkuil          2011-07-13  2614  				res | POLLOUT | POLLWRNORM :
95213ceb drivers/media/video/videobuf2-core.c     Hans Verkuil          2011-07-13  2615  				res | POLLIN | POLLRDNORM;
e23ccc0a drivers/media/video/videobuf2-core.c     Pawel Osciak          2010-10-11  2616  	}
95213ceb drivers/media/video/videobuf2-core.c     Hans Verkuil          2011-07-13  2617  	return res;
e23ccc0a drivers/media/video/videobuf2-core.c     Pawel Osciak          2010-10-11  2618  }
e23ccc0a drivers/media/video/videobuf2-core.c     Pawel Osciak          2010-10-11  2619  EXPORT_SYMBOL_GPL(vb2_poll);
e23ccc0a drivers/media/video/videobuf2-core.c     Pawel Osciak          2010-10-11  2620  
e23ccc0a drivers/media/video/videobuf2-core.c     Pawel Osciak          2010-10-11  2621  /**

:::::: The code at line 2590 was first introduced by commit
:::::: 95213ceb1b527b8102c589bd41fcb7c9163fdd79 [media] videobuf2-core: also test for pending events

:::::: TO: Hans Verkuil <hans.verkuil@cisco.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@redhat.com>

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
