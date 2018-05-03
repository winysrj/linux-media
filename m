Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:36549 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751173AbeECMrN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 May 2018 08:47:13 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l2-dev.h: fix doc warning
Message-ID: <d4d954aa-5bd5-bddb-4b4c-a117031a1c67@xs4all.nl>
Date: Thu, 3 May 2018 14:47:10 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix this warning when building the docs:

include/media/v4l2-dev.h:42: warning: Enum value 'VFL_TYPE_MAX' not described in enum 'vfl_devnode_type'

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index f60cf9cf3b9c..73073f6ee48c 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -30,6 +30,7 @@
  * @VFL_TYPE_SUBDEV:	for V4L2 subdevices
  * @VFL_TYPE_SDR:	for Software Defined Radio tuners
  * @VFL_TYPE_TOUCH:	for touch sensors
+ * @VFL_TYPE_MAX:	number of VFL types, must always be last in the enum
  */
 enum vfl_devnode_type {
 	VFL_TYPE_GRABBER	= 0,
