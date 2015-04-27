Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:44326 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752722AbbD0HaN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2015 03:30:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/5] dib8000: fix compiler warning
Date: Mon, 27 Apr 2015 09:29:54 +0200
Message-Id: <1430119795-16527-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1430119795-16527-1-git-send-email-hverkuil@xs4all.nl>
References: <1430119795-16527-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

In file included from include/uapi/linux/posix_types.h:4:0,
                 from include/uapi/linux/types.h:13,
                 from include/linux/types.h:5,
                 from include/uapi/linux/sysinfo.h:4,
                 from include/uapi/linux/kernel.h:4,
                 from include/linux/cache.h:4,
                 from include/linux/time.h:4,
                 from include/linux/input.h:11,
                 from drivers/media/usb/dvb-usb/dvb-usb.h:13,
                 from drivers/media/usb/dvb-usb/dib0700.h:13,
                 from drivers/media/usb/dvb-usb/dib0700_devices.c:9:
drivers/media/dvb-frontends/dib8000.h: In function 'dib8000_attach':
include/linux/stddef.h:8:14: warning: return makes integer from pointer without a cast [-Wint-conversion]
 #define NULL ((void *)0)
              ^
drivers/media/dvb-frontends/dib8000.h:72:9: note: in expansion of macro 'NULL'
  return NULL;
         ^

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/dvb-frontends/dib8000.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/dib8000.h b/drivers/media/dvb-frontends/dib8000.h
index 780c37b..25e97b4 100644
--- a/drivers/media/dvb-frontends/dib8000.h
+++ b/drivers/media/dvb-frontends/dib8000.h
@@ -69,7 +69,7 @@ void *dib8000_attach(struct dib8000_ops *ops);
 static inline int dib8000_attach(struct dib8000_ops *ops)
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return NULL;
+	return 0;
 }
 #endif
 
-- 
2.1.4

