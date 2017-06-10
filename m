Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38174 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751922AbdFJJF5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Jun 2017 05:05:57 -0400
From: Johannes Thumshirn <jthumshirn@suse.de>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fbdev@vger.kernel.org,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 1/7] [media] media: introduce MEDIA_REVISION macro
Date: Sat, 10 Jun 2017 11:05:30 +0200
Message-Id: <20170610090536.12472-2-jthumshirn@suse.de>
In-Reply-To: <20170610090536.12472-1-jthumshirn@suse.de>
References: <20170610090536.12472-1-jthumshirn@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently the media code abuses the KERNEL_VERSION macro to encode a
version triplet.

Introduce a MEDIA_REVISION macro to get rid of the confusing and
creative KERNEL_VERSION usage in the media subsystem.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 include/uapi/linux/media.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 4890787731b8..25e2ae4432bd 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -30,7 +30,9 @@
 #include <linux/types.h>
 #include <linux/version.h>
 
-#define MEDIA_API_VERSION	KERNEL_VERSION(0, 1, 0)
+#define MEDIA_REVISION(a,b,c) (((a) << 16) + ((b) << 8) + (c))
+
+#define MEDIA_API_VERSION	MEDIA_REVISION(0, 1, 0)
 
 struct media_device_info {
 	char driver[16];
-- 
2.12.3
