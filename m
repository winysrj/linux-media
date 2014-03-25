Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:35925 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786AbaCYQ5d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Mar 2014 12:57:33 -0400
Date: Wed, 26 Mar 2014 00:57:29 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Michal Simek <monstr@monstr.eu>, kbuild-all@01.org
Subject: [microblaze:master-next-test 22/78]
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c:1090:14: sparse: incompatible types for 'case' statement
Message-ID: <5331b579.AvxEgo2JAf0UaoIZ%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://git.monstr.eu/linux-2.6-microblaze master-next-test
head:   4b7d2ed82a743f8f3f7fe09904e154e7b3f5d5e8
commit: f71a8a643dfe0bfc514b3223a440f0f4e4b9f39d [22/78] v4l2: add VIDIOC_G/S_EDID support to the v4l2 core
reproduce: make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:335:26: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:335:26:    expected void [noderef] <asn:1>*to
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:335:26:    got struct v4l2_plane *up
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:335:30: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:335:30:    expected void const [noderef] <asn:1>*from
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:335:30:    got struct v4l2_plane32 *up32
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:336:31: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:336:31:    expected void [noderef] <asn:1>*to
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:336:31:    got unsigned int *<noident>
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:336:49: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:336:49:    expected void const [noderef] <asn:1>*from
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:336:49:    got unsigned int *<noident>
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:341:21: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:341:21:    expected void const volatile [noderef] <asn:1>*<noident>
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:341:21:    got signed int *<noident>
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:344:21: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:344:21:    expected void const volatile [noderef] <asn:1>*<noident>
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:344:21:    got unsigned long *<noident>
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:347:35: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:347:35:    expected void [noderef] <asn:1>*to
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:347:35:    got signed int *<noident>
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:347:46: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:347:46:    expected void const [noderef] <asn:1>*from
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:347:46:    got signed int *<noident>
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:350:35: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:350:35:    expected void [noderef] <asn:1>*to
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:350:35:    got unsigned int *<noident>
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:350:54: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:350:54:    expected void const [noderef] <asn:1>*from
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:350:54:    got unsigned int *<noident>
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:361:26: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:361:26:    expected void [noderef] <asn:1>*to
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:361:26:    got struct v4l2_plane32 *up32
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:361:32: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:361:32:    expected void const [noderef] <asn:1>*from
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:361:32:    got struct v4l2_plane *up
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:362:31: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:362:31:    expected void [noderef] <asn:1>*to
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:362:31:    got unsigned int *<noident>
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:362:51: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:362:51:    expected void const [noderef] <asn:1>*from
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:362:51:    got unsigned int *<noident>
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:369:35: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:369:35:    expected void [noderef] <asn:1>*to
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:369:35:    got unsigned int *<noident>
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:369:56: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:369:56:    expected void const [noderef] <asn:1>*from
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:369:56:    got unsigned int *<noident>
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:374:35: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:374:35:    expected void [noderef] <asn:1>*to
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:374:35:    got signed int *<noident>
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:374:48: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:374:48:    expected void const [noderef] <asn:1>*from
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:374:48:    got signed int *<noident>
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:428:30: sparse: incorrect type in assignment (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:428:30:    expected struct v4l2_plane *planes
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:428:30:    got struct v4l2_plane [noderef] <asn:1>*[assigned] uplane
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:431:48: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:431:48:    expected struct v4l2_plane *up
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:431:48:    got struct v4l2_plane [noderef] <asn:1>*[assigned] uplane
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:431:56: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:431:56:    expected struct v4l2_plane32 *up32
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:431:56:    got struct v4l2_plane32 [noderef] <asn:1>*[assigned] uplane32
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:499:24: sparse: incorrect type in assignment (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:499:24:    expected struct v4l2_plane [noderef] <asn:1>*uplane
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:499:24:    got struct v4l2_plane *planes
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:505:48: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:505:48:    expected struct v4l2_plane *up
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:505:48:    got struct v4l2_plane [noderef] <asn:1>*uplane
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:505:56: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:505:56:    expected struct v4l2_plane32 *up32
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:505:56:    got struct v4l2_plane32 [noderef] <asn:1>*[assigned] uplane32
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:553:18: sparse: incorrect type in assignment (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:553:18:    expected void *base
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:553:18:    got void [noderef] <asn:1>*
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:659:22: sparse: incorrect type in assignment (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:659:22:    expected struct v4l2_ext_control *controls
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:659:22:    got struct v4l2_ext_control [noderef] <asn:1>*[assigned] kcontrols
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:669:29: sparse: incorrect type in assignment (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:669:29:    expected char *__pu_val
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:669:29:    got void [noderef] <asn:1>*[assigned] s
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:681:55: sparse: incorrect type in initializer (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:681:55:    expected struct v4l2_ext_control [noderef] <asn:1>*kcontrols
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:681:55:    got struct v4l2_ext_control *controls
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:775:30: sparse: incorrect type in argument 1 (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:775:30:    expected void [noderef] <asn:1>*to
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:775:30:    got unsigned int *<noident>
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:775:44: sparse: incorrect type in argument 2 (different address spaces)
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:775:44:    expected void const *from
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:775:44:    got unsigned int [noderef] <asn:1>*<noident>
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:1090:14: sparse: undefined identifier 'VIDIOC_SUBDEV_G_EDID32'
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:1091:14: sparse: undefined identifier 'VIDIOC_SUBDEV_S_EDID32'
>> drivers/media/v4l2-core/v4l2-compat-ioctl32.c:1090:14: sparse: incompatible types for 'case' statement
>> drivers/media/v4l2-core/v4l2-compat-ioctl32.c:1091:14: sparse: incompatible types for 'case' statement
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:1090:14: sparse: Expected constant expression in case statement
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:1091:14: sparse: Expected constant expression in case statement
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c: In function 'v4l2_compat_ioctl32':
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:1090:7: error: 'VIDIOC_SUBDEV_G_EDID32' undeclared (first use in this function)
     case VIDIOC_SUBDEV_G_EDID32:
          ^
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:1090:7: note: each undeclared identifier is reported only once for each function it appears in
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:1091:7: error: 'VIDIOC_SUBDEV_S_EDID32' undeclared (first use in this function)
     case VIDIOC_SUBDEV_S_EDID32:
          ^

vim +/case +1090 drivers/media/v4l2-core/v4l2-compat-ioctl32.c

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
