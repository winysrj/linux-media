Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15452 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932426Ab2HQDS4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 23:18:56 -0400
Date: Fri, 17 Aug 2012 11:18:54 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: kernel-janitors@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [samsung:v4l-exynos-gsc 77/299]
 drivers/media/video/em28xx/em28xx-video.c:2269:17-20: ERROR: reference
 preceded by free on line 2267
Message-ID: <20120817031854.GB26261@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

FYI, there are new coccinelle warnings show up in

tree:   git://git.infradead.org/users/kmpark/linux-samsung v4l-exynos-gsc
head:   8ac9447881f291e7b473d946bde20ec952621a23
commit: 876cb14db3bec19960751bb02f03f72ee024a46f [77/299] [media] em28xx: remove V4L2_FL_LOCK_ALL_FOPS

All coccinelle warnings:

+ drivers/media/video/em28xx/em28xx-video.c:2269:17-20: ERROR: reference preceded by free on line 2267

vim +2269 drivers/media/video/em28xx/em28xx-video.c
  2266				kfree(dev->alt_max_pkt_size);
  2267				kfree(dev);
  2268				kfree(fh);
> 2269				mutex_unlock(&dev->lock);
  2270				return 0;
  2271			}
  2272	

---
0-DAY kernel build testing backend         Open Source Technology Centre
Fengguang Wu <wfg@linux.intel.com>                     Intel Corporation
