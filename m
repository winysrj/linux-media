Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40283 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935669AbaICXTn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 19:19:43 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Kamil Debski <k.debski@samsung.com>,
	Antti Palosaari <crope@iki.fi>,
	Jonathan McCrohan <jmccrohan@gmail.com>
Subject: [PATCH] v4l2-ctrls: avoid a sparse complain due to __user ptr
Date: Wed,  3 Sep 2014 20:19:23 -0300
Message-Id: <3de557fce274288343f3ac7f5b3e0dac87f123bf.1409786360.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

c->ptr was already copied to Kernelspace. So, this sparse warning
is bogus:

>> drivers/media/v4l2-core/v4l2-ctrls.c:1685:15: sparse: incorrect type in assignment (different address spaces)
   drivers/media/v4l2-core/v4l2-ctrls.c:1685:15:    expected void *[assigned] p
   drivers/media/v4l2-core/v4l2-ctrls.c:1685:15:    got void [noderef] <asn:1>*ptr

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 35d1f3d5045b..ed10e4a9318c 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1682,7 +1682,7 @@ static int validate_new(const struct v4l2_ctrl *ctrl,
 			break;
 		}
 	}
-	ptr.p = c->ptr;
+	ptr.p = (__force void *)c->ptr;
 	for (idx = 0; !err && idx < c->size / ctrl->elem_size; idx++)
 		err = ctrl->type_ops->validate(ctrl, idx, ptr);
 	return err;
-- 
1.9.3

