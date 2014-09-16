Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:4334 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063AbaIPBSU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 21:18:20 -0400
Date: Tue, 16 Sep 2014 09:17:43 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [linuxtv-media:devel 499/499]
 drivers/media/v4l2-core/videobuf2-core.c:2549:16: warning: unused variable
 'flags'
Message-ID: <54178fb7.AkAOyPnkkTwDwgWW%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git devel
head:   e0857d1d1af8478b33e63dbb22bb2160a807d868
commit: e0857d1d1af8478b33e63dbb22bb2160a807d868 [499/499] [media] BZ#84401: Revert "[media] v4l: vb2: Don't return POLLERR during transient buffer underruns"
config: x86_64-allmodconfig
reproduce:
  git checkout e0857d1d1af8478b33e63dbb22bb2160a807d868
  make ARCH=x86_64  allmodconfig
  make ARCH=x86_64 

All warnings:

   drivers/media/v4l2-core/videobuf2-core.c:2590:17: sparse: Expected ) after if
   drivers/media/v4l2-core/videobuf2-core.c:2590:17: sparse: got return
   drivers/media/v4l2-core/videobuf2-core.c: In function 'vb2_poll':
   drivers/media/v4l2-core/videobuf2-core.c:2590:3: error: expected ')' before 'return'
      return res | POLLERR;
      ^
   drivers/media/v4l2-core/videobuf2-core.c:2618:1: error: expected expression before '}' token
    }
    ^
>> drivers/media/v4l2-core/videobuf2-core.c:2549:16: warning: unused variable 'flags' [-Wunused-variable]
     unsigned long flags;
                   ^
>> drivers/media/v4l2-core/videobuf2-core.c:2547:21: warning: unused variable 'vb' [-Wunused-variable]
     struct vb2_buffer *vb = NULL;
                        ^
   drivers/media/v4l2-core/videobuf2-core.c:2618:1: warning: control reaches end of non-void function [-Wreturn-type]
    }
    ^

vim +/flags +2549 drivers/media/v4l2-core/videobuf2-core.c

e23ccc0a drivers/media/video/videobuf2-core.c     Pawel Osciak          2010-10-11  2541   * from poll handler in driver.
e23ccc0a drivers/media/video/videobuf2-core.c     Pawel Osciak          2010-10-11  2542   */
e23ccc0a drivers/media/video/videobuf2-core.c     Pawel Osciak          2010-10-11  2543  unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
e23ccc0a drivers/media/video/videobuf2-core.c     Pawel Osciak          2010-10-11  2544  {
95213ceb drivers/media/video/videobuf2-core.c     Hans Verkuil          2011-07-13  2545  	struct video_device *vfd = video_devdata(file);
bf5c7cbb drivers/media/video/videobuf2-core.c     Hans Verkuil          2011-07-13  2546  	unsigned long req_events = poll_requested_events(wait);
e23ccc0a drivers/media/video/videobuf2-core.c     Pawel Osciak          2010-10-11  2547  	struct vb2_buffer *vb = NULL;
95213ceb drivers/media/video/videobuf2-core.c     Hans Verkuil          2011-07-13  2548  	unsigned int res = 0;
95213ceb drivers/media/video/videobuf2-core.c     Hans Verkuil          2011-07-13  2549  	unsigned long flags;
95213ceb drivers/media/video/videobuf2-core.c     Hans Verkuil          2011-07-13  2550  
95213ceb drivers/media/video/videobuf2-core.c     Hans Verkuil          2011-07-13  2551  	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)) {
95213ceb drivers/media/video/videobuf2-core.c     Hans Verkuil          2011-07-13  2552  		struct v4l2_fh *fh = file->private_data;
95213ceb drivers/media/video/videobuf2-core.c     Hans Verkuil          2011-07-13  2553  
95213ceb drivers/media/video/videobuf2-core.c     Hans Verkuil          2011-07-13  2554  		if (v4l2_event_pending(fh))
95213ceb drivers/media/video/videobuf2-core.c     Hans Verkuil          2011-07-13  2555  			res = POLLPRI;
95213ceb drivers/media/video/videobuf2-core.c     Hans Verkuil          2011-07-13  2556  		else if (req_events & POLLPRI)
95213ceb drivers/media/video/videobuf2-core.c     Hans Verkuil          2011-07-13  2557  			poll_wait(file, &fh->wait, wait);
95213ceb drivers/media/video/videobuf2-core.c     Hans Verkuil          2011-07-13  2558  	}
e23ccc0a drivers/media/video/videobuf2-core.c     Pawel Osciak          2010-10-11  2559  
cd13823f drivers/media/v4l2-core/videobuf2-core.c Hans Verkuil          2013-01-30  2560  	if (!V4L2_TYPE_IS_OUTPUT(q->type) && !(req_events & (POLLIN | POLLRDNORM)))
cd13823f drivers/media/v4l2-core/videobuf2-core.c Hans Verkuil          2013-01-30  2561  		return res;
cd13823f drivers/media/v4l2-core/videobuf2-core.c Hans Verkuil          2013-01-30  2562  	if (V4L2_TYPE_IS_OUTPUT(q->type) && !(req_events & (POLLOUT | POLLWRNORM)))
cd13823f drivers/media/v4l2-core/videobuf2-core.c Hans Verkuil          2013-01-30  2563  		return res;
cd13823f drivers/media/v4l2-core/videobuf2-core.c Hans Verkuil          2013-01-30  2564  
e23ccc0a drivers/media/video/videobuf2-core.c     Pawel Osciak          2010-10-11  2565  	/*
4ffabdb3 drivers/media/video/videobuf2-core.c     Pawel Osciak          2011-03-20  2566  	 * Start file I/O emulator only if streaming API has not been used yet.
b25748fe drivers/media/video/videobuf2-core.c     Marek Szyprowski      2010-12-06  2567  	 */
74753cff drivers/media/v4l2-core/videobuf2-core.c Hans Verkuil          2014-04-07  2568  	if (q->num_buffers == 0 && !vb2_fileio_is_active(q)) {
bf5c7cbb drivers/media/video/videobuf2-core.c     Hans Verkuil          2011-07-13  2569  		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ) &&
bf5c7cbb drivers/media/video/videobuf2-core.c     Hans Verkuil          2011-07-13  2570  				(req_events & (POLLIN | POLLRDNORM))) {
95213ceb drivers/media/video/videobuf2-core.c     Hans Verkuil          2011-07-13  2571  			if (__vb2_init_fileio(q, 1))
95213ceb drivers/media/video/videobuf2-core.c     Hans Verkuil          2011-07-13  2572  				return res | POLLERR;
b25748fe drivers/media/video/videobuf2-core.c     Marek Szyprowski      2010-12-06  2573  		}
bf5c7cbb drivers/media/video/videobuf2-core.c     Hans Verkuil          2011-07-13  2574  		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE) &&
bf5c7cbb drivers/media/video/videobuf2-core.c     Hans Verkuil          2011-07-13  2575  				(req_events & (POLLOUT | POLLWRNORM))) {
95213ceb drivers/media/video/videobuf2-core.c     Hans Verkuil          2011-07-13  2576  			if (__vb2_init_fileio(q, 0))
95213ceb drivers/media/video/videobuf2-core.c     Hans Verkuil          2011-07-13  2577  				return res | POLLERR;
b25748fe drivers/media/video/videobuf2-core.c     Marek Szyprowski      2010-12-06  2578  			/*
b25748fe drivers/media/video/videobuf2-core.c     Marek Szyprowski      2010-12-06  2579  			 * Write to OUTPUT queue can be done immediately.
b25748fe drivers/media/video/videobuf2-core.c     Marek Szyprowski      2010-12-06  2580  			 */
95213ceb drivers/media/video/videobuf2-core.c     Hans Verkuil          2011-07-13  2581  			return res | POLLOUT | POLLWRNORM;
b25748fe drivers/media/video/videobuf2-core.c     Marek Szyprowski      2010-12-06  2582  		}
b25748fe drivers/media/video/videobuf2-core.c     Marek Szyprowski      2010-12-06  2583  	}
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

:::::: The code at line 2549 was first introduced by commit
:::::: 95213ceb1b527b8102c589bd41fcb7c9163fdd79 [media] videobuf2-core: also test for pending events

:::::: TO: Hans Verkuil <hans.verkuil@cisco.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@redhat.com>

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
