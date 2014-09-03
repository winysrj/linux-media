Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:33827 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbaICQHK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 12:07:10 -0400
Date: Thu, 04 Sep 2014 00:05:49 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [linuxtv-media:master 497/499]
 drivers/media/v4l2-core/v4l2-ctrls.c:1685:15: sparse: incorrect type in
 assignment (different address spaces)
Message-ID: <54073c5d.7j3p0Ima6PcuWDhl%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   fe10b84e7f6c4c8c3dc8cf63be324bc13f5acd68
commit: eadf9e26fab7f9841adcc36f3559dbce7604fcd5 [497/499] [media] videodev2.h: add __user to v4l2_ext_control pointers
reproduce: make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/v4l2-core/v4l2-ctrls.c:1685:15: sparse: incorrect type in assignment (different address spaces)
   drivers/media/v4l2-core/v4l2-ctrls.c:1685:15:    expected void *[assigned] p
   drivers/media/v4l2-core/v4l2-ctrls.c:1685:15:    got void [noderef] <asn:1>*ptr

vim +1685 drivers/media/v4l2-core/v4l2-ctrls.c

ce580fe5 drivers/media/video/v4l2-ctrls.c     Sakari Ailus 2011-08-04  1669  		case V4L2_CTRL_TYPE_INTEGER_MENU:
0176077a drivers/media/v4l2-core/v4l2-ctrls.c Hans Verkuil 2014-04-27  1670  		case V4L2_CTRL_TYPE_MENU:
fa4d7096 drivers/media/video/v4l2-ctrls.c     Hans Verkuil 2011-05-23  1671  		case V4L2_CTRL_TYPE_BITMASK:
0176077a drivers/media/v4l2-core/v4l2-ctrls.c Hans Verkuil 2014-04-27  1672  		case V4L2_CTRL_TYPE_BOOLEAN:
0996517c drivers/media/video/v4l2-ctrls.c     Hans Verkuil 2010-08-01  1673  		case V4L2_CTRL_TYPE_BUTTON:
0996517c drivers/media/video/v4l2-ctrls.c     Hans Verkuil 2010-08-01  1674  		case V4L2_CTRL_TYPE_CTRL_CLASS:
0176077a drivers/media/v4l2-core/v4l2-ctrls.c Hans Verkuil 2014-04-27  1675  			ptr.p_s32 = &c->value;
998e7659 drivers/media/v4l2-core/v4l2-ctrls.c Hans Verkuil 2014-06-10  1676  			return ctrl->type_ops->validate(ctrl, 0, ptr);
0996517c drivers/media/video/v4l2-ctrls.c     Hans Verkuil 2010-08-01  1677  
0176077a drivers/media/v4l2-core/v4l2-ctrls.c Hans Verkuil 2014-04-27  1678  		case V4L2_CTRL_TYPE_INTEGER64:
0176077a drivers/media/v4l2-core/v4l2-ctrls.c Hans Verkuil 2014-04-27  1679  			ptr.p_s64 = &c->value64;
998e7659 drivers/media/v4l2-core/v4l2-ctrls.c Hans Verkuil 2014-06-10  1680  			return ctrl->type_ops->validate(ctrl, 0, ptr);
0996517c drivers/media/video/v4l2-ctrls.c     Hans Verkuil 2010-08-01  1681  		default:
302ab7ce drivers/media/v4l2-core/v4l2-ctrls.c Hans Verkuil 2014-06-10  1682  			break;
302ab7ce drivers/media/v4l2-core/v4l2-ctrls.c Hans Verkuil 2014-06-10  1683  		}
0996517c drivers/media/video/v4l2-ctrls.c     Hans Verkuil 2010-08-01  1684  	}
302ab7ce drivers/media/v4l2-core/v4l2-ctrls.c Hans Verkuil 2014-06-10 @1685  	ptr.p = c->ptr;
302ab7ce drivers/media/v4l2-core/v4l2-ctrls.c Hans Verkuil 2014-06-10  1686  	for (idx = 0; !err && idx < c->size / ctrl->elem_size; idx++)
302ab7ce drivers/media/v4l2-core/v4l2-ctrls.c Hans Verkuil 2014-06-10  1687  		err = ctrl->type_ops->validate(ctrl, idx, ptr);
302ab7ce drivers/media/v4l2-core/v4l2-ctrls.c Hans Verkuil 2014-06-10  1688  	return err;
0996517c drivers/media/video/v4l2-ctrls.c     Hans Verkuil 2010-08-01  1689  }
0996517c drivers/media/video/v4l2-ctrls.c     Hans Verkuil 2010-08-01  1690  
0996517c drivers/media/video/v4l2-ctrls.c     Hans Verkuil 2010-08-01  1691  static inline u32 node2id(struct list_head *node)
0996517c drivers/media/video/v4l2-ctrls.c     Hans Verkuil 2010-08-01  1692  {
0996517c drivers/media/video/v4l2-ctrls.c     Hans Verkuil 2010-08-01  1693  	return list_entry(node, struct v4l2_ctrl_ref, node)->ctrl->id;

:::::: The code at line 1685 was first introduced by commit
:::::: 302ab7ce2daba8cdd82a6809adb42d117a683f06 [media] v4l2-ctrls: add array support

:::::: TO: Hans Verkuil <hans.verkuil@cisco.com>
:::::: CC: Mauro Carvalho Chehab <m.chehab@samsung.com>

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
