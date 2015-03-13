Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:39002 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751798AbbCMKAT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 06:00:19 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 9A7DA2A002F
	for <linux-media@vger.kernel.org>; Fri, 13 Mar 2015 11:00:07 +0100 (CET)
Message-ID: <5502B527.2020600@xs4all.nl>
Date: Fri, 13 Mar 2015 11:00:07 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] cx231xx: fix compiler warnings
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If CONFIG_VIDEO_CX231XX_RC is undefined, then these compiler warnings
are generated:

In file included from drivers/media/usb/cx231xx/cx231xx-cards.c:23:0:
drivers/media/usb/cx231xx/cx231xx-cards.c: In function ‘cx231xx_release_resources’:
drivers/media/usb/cx231xx/cx231xx.h:982:30: warning: statement with no effect [-Wunused-value]
 #define cx231xx_ir_exit(dev) (0)
                              ^
drivers/media/usb/cx231xx/cx231xx-cards.c:1158:2: note: in expansion of macro ‘cx231xx_ir_exit’
  cx231xx_ir_exit(dev);
  ^
drivers/media/usb/cx231xx/cx231xx-cards.c: In function ‘cx231xx_init_dev’:
drivers/media/usb/cx231xx/cx231xx.h:981:30: warning: statement with no effect [-Wunused-value]
 #define cx231xx_ir_init(dev) (0)
                              ^
drivers/media/usb/cx231xx/cx231xx-cards.c:1351:2: note: in expansion of macro ‘cx231xx_ir_init’
  cx231xx_ir_init(dev);
  ^
drivers/media/usb/cx231xx/cx231xx-cards.c: In function ‘cx231xx_usb_probe’:
drivers/media/usb/cx231xx/cx231xx.h:982:30: warning: statement with no effect [-Wunused-value]
 #define cx231xx_ir_exit(dev) (0)
                              ^
drivers/media/usb/cx231xx/cx231xx-cards.c:1705:2: note: in expansion of macro ‘cx231xx_ir_exit’
  cx231xx_ir_exit(dev);
  ^
drivers/media/usb/cx231xx/cx231xx-cards.c: In function ‘cx231xx_usb_disconnect’:
drivers/media/usb/cx231xx/cx231xx.h:982:30: warning: statement with no effect [-Wunused-value]
 #define cx231xx_ir_exit(dev) (0)
                              ^
drivers/media/usb/cx231xx/cx231xx-cards.c:1754:3: note: in expansion of macro ‘cx231xx_ir_exit’
   cx231xx_ir_exit(dev);
   ^

Fix by using static inlines instead of defines.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index 573b3c0..9871c79f 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -978,8 +978,11 @@ extern void cx231xx_417_unregister(struct cx231xx *dev);
 int cx231xx_ir_init(struct cx231xx *dev);
 void cx231xx_ir_exit(struct cx231xx *dev);
 #else
-#define cx231xx_ir_init(dev)	(0)
-#define cx231xx_ir_exit(dev)	(0)
+static inline int cx231xx_ir_init(struct cx231xx *dev)
+{
+	return 0;
+}
+static inline void cx231xx_ir_exit(struct cx231xx *dev) {}
 #endif
 
 static inline unsigned int norm_maxw(struct cx231xx *dev)
