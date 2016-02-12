Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34835 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbcBLJqb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 04:46:31 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 01/11] [media] v4l2-mc.h: prevent it for being included twice
Date: Fri, 12 Feb 2016 07:44:56 -0200
Message-Id: <ee25e26aaa5280050e7d216b80ecf4fe5cab8237.1455269986.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1455269986.git.mchehab@osg.samsung.com>
References: <cover.1455269986.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1455269986.git.mchehab@osg.samsung.com>
References: <cover.1455269986.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Don't let it be included twice, to avoid compiler issues.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 include/media/v4l2-mc.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
index 6fad97277a0b..20f1ee285947 100644
--- a/include/media/v4l2-mc.h
+++ b/include/media/v4l2-mc.h
@@ -14,6 +14,9 @@
  * GNU General Public License for more details.
  */
 
+#ifndef _V4L2_MC_H
+#define _V4L2_MC_H
+
 #include <media/media-device.h>
 
 /**
@@ -136,3 +139,5 @@ struct media_device *v4l2_mc_pci_media_device_init(struct pci_dev *pci_dev,
 }
 
 #endif
+
+#endif
-- 
2.5.0


