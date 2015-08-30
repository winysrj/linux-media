Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48363 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbbH3DHq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2015 23:07:46 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-api@vger.kernel.org
Subject: [PATCH v8 40/55] [media] media.h: don't use legacy entity macros at Kernel
Date: Sun, 30 Aug 2015 00:06:51 -0300
Message-Id: <720b750e2738f8c70535b01c9c3a3dddf044db69.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Put the legacy MEDIA_ENT_* macros under a #ifndef __KERNEL__,
in order to be sure that none of those old symbols are used
inside the Kernel.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index cd486fc25f1e..4186891e5e81 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -107,6 +107,7 @@ struct media_device_info {
 #define MEDIA_ENT_T_DVB_CA		(MEDIA_ENT_T_DVB_BASE + 3)
 #define MEDIA_ENT_T_DVB_NET_DECAP	(MEDIA_ENT_T_DVB_BASE + 4)
 
+#ifndef __KERNEL__
 /* Legacy symbols used to avoid userspace compilation breakages */
 #define MEDIA_ENT_TYPE_SHIFT		16
 #define MEDIA_ENT_TYPE_MASK		0x00ff0000
@@ -120,6 +121,7 @@ struct media_device_info {
 #define MEDIA_ENT_T_DEVNODE_FB		(MEDIA_ENT_T_DEVNODE + 2)
 #define MEDIA_ENT_T_DEVNODE_ALSA	(MEDIA_ENT_T_DEVNODE + 3)
 #define MEDIA_ENT_T_DEVNODE_DVB		(MEDIA_ENT_T_DEVNODE + 4)
+#endif
 
 /* Entity types */
 
-- 
2.4.3

