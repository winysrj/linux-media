Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54638 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbbIFMD6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2015 08:03:58 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-api@vger.kernel.org
Subject: Re: [PATCH v8 40/55] [media] media.h: don't use legacy entity macros at Kernel
Date: Sun,  6 Sep 2015 09:03:00 -0300
Message-Id: <3f2e554613f0b1286bd72dfd08f02ac6b874c95e.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <720b750e2738f8c70535b01c9c3a3dddf044db69.1440902901.git.mchehab@osg.samsung.com>
References: <720b750e2738f8c70535b01c9c3a3dddf044db69.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Put the legacy MEDIA_ENT_* macros under a #ifndef __KERNEL__,
in order to be sure that none of those old symbols are used
inside the Kernel.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index f90147cb9b57..a1bd7afba110 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -105,6 +105,7 @@ struct media_device_info {
 #define MEDIA_ENT_T_DVB_CA		(MEDIA_ENT_T_DVB_BASE + 4)
 #define MEDIA_ENT_T_DVB_NET_DECAP	(MEDIA_ENT_T_DVB_BASE + 5)
 
+#ifndef __KERNEL__
 /* Legacy symbols used to avoid userspace compilation breakages */
 #define MEDIA_ENT_TYPE_SHIFT		16
 #define MEDIA_ENT_TYPE_MASK		0x00ff0000
@@ -118,6 +119,7 @@ struct media_device_info {
 #define MEDIA_ENT_T_DEVNODE_FB		(MEDIA_ENT_T_DEVNODE + 2)
 #define MEDIA_ENT_T_DEVNODE_ALSA	(MEDIA_ENT_T_DEVNODE + 3)
 #define MEDIA_ENT_T_DEVNODE_DVB		(MEDIA_ENT_T_DEVNODE + 4)
+#endif
 
 /* Entity types */
 
-- 
2.4.3


