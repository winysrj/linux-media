Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:59057 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754085AbdJIKTp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 06:19:45 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH 17/24] media: v4l2-subdev: fix a typo
Date: Mon,  9 Oct 2017 07:19:23 -0300
Message-Id: <8c66d4a7c2afddc52be7f42c5bc2cef218a0ecc6.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ownner -> owner

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-subdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index e215732eed45..345da052618c 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -814,7 +814,7 @@ struct v4l2_subdev_platform_data {
  * @list: List of sub-devices
  * @owner: The owner is the same as the driver's &struct device owner.
  * @owner_v4l2_dev: true if the &sd->owner matches the owner of @v4l2_dev->dev
- *	ownner. Initialized by v4l2_device_register_subdev().
+ *	owner. Initialized by v4l2_device_register_subdev().
  * @flags: subdev flags, as defined by &enum v4l2_subdev_flags.
  *
  * @v4l2_dev: pointer to struct &v4l2_device
-- 
2.13.6
