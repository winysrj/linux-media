Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55099 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbcFPLSk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 07:18:40 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] media-devnode.h: Fix documentation
Date: Thu, 16 Jun 2016 08:18:35 -0300
Message-Id: <0db5c79989de2c68d5abb7ba891bfdb3cd3b7e05.1466075912.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two parameters were documented with a wrong name, and a struct
device pointer description was missing.

That caused the following warnings, when building documentation:

include/media/media-devnode.h:102: warning: No description found for parameter 'media_dev'
include/media/media-devnode.h:126: warning: No description found for parameter 'mdev'
include/media/media-devnode.h:126: warning: Excess function parameter 'media_dev' description in 'media_devnode_register'

Rename the description, to match the function parameter and fix
Documentation.

No funcional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/media-devnode.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
index f0b7dd79fb92..37d494805944 100644
--- a/include/media/media-devnode.h
+++ b/include/media/media-devnode.h
@@ -69,8 +69,9 @@ struct media_file_operations {
 
 /**
  * struct media_devnode - Media device node
+ * @media_dev:	pointer to struct &media_device
  * @fops:	pointer to struct &media_file_operations with media device ops
- * @dev:	struct device pointer for the media controller device
+ * @dev:	pointer to struct &device containing the media controller device
  * @cdev:	struct cdev pointer character device
  * @parent:	parent device
  * @minor:	device node minor number
@@ -107,7 +108,7 @@ struct media_devnode {
 /**
  * media_devnode_register - register a media device node
  *
- * @media_dev: struct media_device we want to register a device node
+ * @mdev: struct media_device we want to register a device node
  * @devnode: media device node structure we want to register
  * @owner: should be filled with %THIS_MODULE
  *
-- 
2.5.5

