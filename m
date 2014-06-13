Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:25233 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbaFMCGP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 22:06:15 -0400
Date: Fri, 13 Jun 2014 10:04:27 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Michal Simek <monstr@monstr.eu>, kbuild-all@01.org
Subject: [xlnx:master-next 164/499]
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c:1090:7: error:
 'VIDIOC_SUBDEV_G_EDID32' undeclared
Message-ID: <539a5c2b.iI/OMhR4k7lMdM53%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://git.xilinx.com/linux-xlnx master-next
head:   f9d391370402f7428cd12e7aaa5c8ab768ba5332
commit: b3640ef37e11cbe388be747b0eb46be3c4cac239 [164/499] v4l2: add VIDIOC_G/S_EDID support to the v4l2 core
config: make ARCH=x86_64 allmodconfig

All error/warnings:

   drivers/media/v4l2-core/v4l2-compat-ioctl32.c: In function 'v4l2_compat_ioctl32':
>> drivers/media/v4l2-core/v4l2-compat-ioctl32.c:1090:7: error: 'VIDIOC_SUBDEV_G_EDID32' undeclared (first use in this function)
     case VIDIOC_SUBDEV_G_EDID32:
          ^
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:1090:7: note: each undeclared identifier is reported only once for each function it appears in
>> drivers/media/v4l2-core/v4l2-compat-ioctl32.c:1091:7: error: 'VIDIOC_SUBDEV_S_EDID32' undeclared (first use in this function)
     case VIDIOC_SUBDEV_S_EDID32:
          ^

vim +/VIDIOC_SUBDEV_G_EDID32 +1090 drivers/media/v4l2-core/v4l2-compat-ioctl32.c

2150158b drivers/media/video/v4l2-compat-ioctl32.c     Guennadi Liakhovetski 2011-09-28  1084  	case VIDIOC_CREATE_BUFS32:
2150158b drivers/media/video/v4l2-compat-ioctl32.c     Guennadi Liakhovetski 2011-09-28  1085  	case VIDIOC_PREPARE_BUF32:
5d7758ee drivers/media/video/v4l2-compat-ioctl32.c     Hans Verkuil          2012-05-15  1086  	case VIDIOC_ENUM_DV_TIMINGS:
5d7758ee drivers/media/video/v4l2-compat-ioctl32.c     Hans Verkuil          2012-05-15  1087  	case VIDIOC_QUERY_DV_TIMINGS:
5d7758ee drivers/media/video/v4l2-compat-ioctl32.c     Hans Verkuil          2012-05-15  1088  	case VIDIOC_DV_TIMINGS_CAP:
82b655bf drivers/media/video/v4l2-compat-ioctl32.c     Hans Verkuil          2012-07-05  1089  	case VIDIOC_ENUM_FREQ_BANDS:
ed45ce2c drivers/media/v4l2-core/v4l2-compat-ioctl32.c Hans Verkuil          2012-08-10 @1090  	case VIDIOC_SUBDEV_G_EDID32:
ed45ce2c drivers/media/v4l2-core/v4l2-compat-ioctl32.c Hans Verkuil          2012-08-10 @1091  	case VIDIOC_SUBDEV_S_EDID32:
0d0fbf81 drivers/media/video/compat_ioctl32.c          Arnd Bergmann         2006-01-09  1092  		ret = do_video_ioctl(file, cmd, arg);
0d0fbf81 drivers/media/video/compat_ioctl32.c          Arnd Bergmann         2006-01-09  1093  		break;
0d0fbf81 drivers/media/video/compat_ioctl32.c          Arnd Bergmann         2006-01-09  1094  

:::::: The code at line 1090 was first introduced by commit
:::::: ed45ce2cc0b31cb442685934b627916f83d1d7c6 [media] v4l2-subdev: add support for the new edid ioctls

:::::: TO: Hans Verkuil <hans.verkuil@cisco.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@redhat.com>

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
