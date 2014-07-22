Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:25057 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbaGVAiq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 20:38:46 -0400
Date: Tue, 22 Jul 2014 08:39:30 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [linuxtv-media:master 482/499]
 drivers/staging/media/airspy/airspy.c:1042:10: error: 'V4L2_FL_USE_FH_PRIO' undeclared
Message-ID: <53cdb2c2.8SHaff7EpSXpKg0O%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   469d4ec8776091a2846ba89803cf954cf8b3ce65
commit: 634fe5033951b80ef4b98d8f047cb1083d29170d [482/499] [media] airspy: AirSpy SDR driver
config: make ARCH=x86_64 allmodconfig

Note: the linuxtv-media/master HEAD 469d4ec8776091a2846ba89803cf954cf8b3ce65 builds fine.
      It only hurts bisectibility.

All error/warnings:

   drivers/staging/media/airspy/airspy.c: In function 'airspy_probe':
>> drivers/staging/media/airspy/airspy.c:1042:10: error: 'V4L2_FL_USE_FH_PRIO' undeclared (first use in this function)
     set_bit(V4L2_FL_USE_FH_PRIO, &s->vdev.flags);
             ^
   drivers/staging/media/airspy/airspy.c:1042:10: note: each undeclared identifier is reported only once for each function it appears in

vim +/V4L2_FL_USE_FH_PRIO +1042 drivers/staging/media/airspy/airspy.c

  1036		}
  1037	
  1038		/* Init video_device structure */
  1039		s->vdev = airspy_template;
  1040		s->vdev.queue = &s->vb_queue;
  1041		s->vdev.queue->lock = &s->vb_queue_lock;
> 1042		set_bit(V4L2_FL_USE_FH_PRIO, &s->vdev.flags);
  1043		video_set_drvdata(&s->vdev, s);
  1044	
  1045		/* Register the v4l2_device structure */

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
