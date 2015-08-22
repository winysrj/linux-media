Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40376 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbbHVR2e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:34 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 03/39] [media] Docbook: Fix description of struct media_devnode
Date: Sat, 22 Aug 2015 14:27:48 -0300
Message-Id: <6133502e023e5683ffcc7ab57d2ef752ea1b434f.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Warning(.//include/media/media-devnode.h:80): No description found for parameter 'fops'
Warning(.//include/media/media-devnode.h:80): No description found for parameter 'dev'
Warning(.//include/media/media-devnode.h:80): No description found for parameter 'cdev'
Warning(.//include/media/media-devnode.h:80): No description found for parameter 'release'

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
index 0dc7060f9625..17ddae32060d 100644
--- a/include/media/media-devnode.h
+++ b/include/media/media-devnode.h
@@ -53,9 +53,13 @@ struct media_file_operations {
 
 /**
  * struct media_devnode - Media device node
+ * @fops:	pointer to struct media_file_operations with media device ops
+ * @dev:	struct device pointer for the media controller device
+ * @cdev:	struct cdev pointer character device
  * @parent:	parent device
  * @minor:	device node minor number
  * @flags:	flags, combination of the MEDIA_FLAG_* constants
+ * @release:	release callback called at the end of media_devnode_release()
  *
  * This structure represents a media-related device node.
  *
-- 
2.4.3

