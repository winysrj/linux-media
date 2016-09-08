Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56846 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936480AbcIHVhr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 17:37:47 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 01/15] [media] mc-core.rst: fix a warning about an internal routine
Date: Thu,  8 Sep 2016 18:37:27 -0300
Message-Id: <4734daada63bece30c7ba88e2ba9aa3d06898248.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473370390.git.mchehab@s-opensource.com>
References: <cover.1473370390.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix this warning:
	Documentation/media/kapi/mc-core.rst:97: WARNING: c:func reference target not found: media_devnode_release

The media_device_release() is a function internal to media-devnode.c,
and not exported elsewhere. So, we can't cross-reference it here.
Make it explicit at the documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/media-devnode.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
index 972168e90413..cd23e915764c 100644
--- a/include/media/media-devnode.h
+++ b/include/media/media-devnode.h
@@ -76,7 +76,8 @@ struct media_file_operations {
  * @parent:	parent device
  * @minor:	device node minor number
  * @flags:	flags, combination of the ``MEDIA_FLAG_*`` constants
- * @release:	release callback called at the end of media_devnode_release()
+ * @release:	release callback called at the end of ``media_devnode_release()``
+ *		routine at media-device.c.
  *
  * This structure represents a media-related device node.
  *
-- 
2.7.4


