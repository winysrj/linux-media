Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:42793
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473AbcHKQ2b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 12:28:31 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 0/2] [media] tvp5150: use .registered callback to register entity and links
Date: Thu, 11 Aug 2016 12:28:14 -0400
Message-Id: <1470932896-25843-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Sakari pointed out in "[PATCH 2/8] [media] v4l2-async: call registered_async
after subdev registration" [0] that the added .registered_async callback isn't
needed since the v4l2 core already has an internal_ops .registered callback.

I missed that there was already this when added the .registered_async callback,
sorry about that.

This small series convert the tvp5150 driver to use the proper .registered and
remove .registered_async since isn't needed.

[0]: https://lkml.org/lkml/2016/8/11/254

Best regards,
Javier


Javier Martinez Canillas (2):
  [media] tvp5150: use sd internal ops .registered instead
    .registered_async
  [media] v4l2-async: remove unneeded .registered_async callback

 drivers/media/i2c/tvp5150.c          | 8 ++++++--
 drivers/media/v4l2-core/v4l2-async.c | 7 -------
 include/media/v4l2-subdev.h          | 3 ---
 3 files changed, 6 insertions(+), 12 deletions(-)

-- 
2.5.5

