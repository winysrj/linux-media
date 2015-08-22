Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40373 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbbHVR2e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:34 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 05/39] [media] Docbook: Fix  comments at v4l2-async.h
Date: Sat, 22 Aug 2015 14:27:50 -0300
Message-Id: <4d7ec30bca40ba452fe38c13342c6b175489bf62.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Warning(.//include/media/v4l2-async.h:62): No description found for parameter 'match_type'
Warning(.//include/media/v4l2-async.h:62): Excess struct/union/enum/typedef member 'bus_type' description in 'v4l2_async_subdev'
Warning(.//include/media/v4l2-async.h:76): cannot understand function prototype: 'struct v4l2_async_notifier '

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index 768356917bea..1d6d7da4c45d 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -32,7 +32,8 @@ enum v4l2_async_match_type {
 
 /**
  * struct v4l2_async_subdev - sub-device descriptor, as known to a bridge
- * @bus_type:	subdevice bus type to select the appropriate matching method
+ *
+ * @match_type:	type of match that will be used
  * @match:	union of per-bus type matching data sets
  * @list:	used to link struct v4l2_async_subdev objects, waiting to be
  *		probed, to a notifier->waiting list
@@ -62,8 +63,9 @@ struct v4l2_async_subdev {
 };
 
 /**
- * v4l2_async_notifier - v4l2_device notifier data
- * @num_subdevs:number of subdevices
+ * struct v4l2_async_notifier - v4l2_device notifier data
+ *
+ * @num_subdevs: number of subdevices
  * @subdevs:	array of pointers to subdevice descriptors
  * @v4l2_dev:	pointer to struct v4l2_device
  * @waiting:	list of struct v4l2_async_subdev, waiting for their drivers
-- 
2.4.3

