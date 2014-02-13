Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:37016 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaBMVbO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Feb 2014 16:31:14 -0500
Received: by mail-wi0-f181.google.com with SMTP id hi5so9244679wib.8
        for <linux-media@vger.kernel.org>; Thu, 13 Feb 2014 13:31:13 -0800 (PST)
Message-ID: <1392327062.6200.17.camel@canaries32-MCP7A>
Subject: [PATCH 3/4] MAINTAINERS: Remove it913x* maintainers entries.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Date: Thu, 13 Feb 2014 21:31:02 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 MAINTAINERS | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b2cf5cf..538b894 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4771,22 +4771,6 @@ F:	Documentation/hwmon/it87
 F:	drivers/hwmon/it87.c
 
 IT913X MEDIA DRIVER
-M:	Malcolm Priestley <tvboxspy@gmail.com>
-L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
-Q:	http://patchwork.linuxtv.org/project/linux-media/list/
-S:	Maintained
-F:	drivers/media/usb/dvb-usb-v2/it913x*
-
-IT913X FE MEDIA DRIVER
-M:	Malcolm Priestley <tvboxspy@gmail.com>
-L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
-Q:	http://patchwork.linuxtv.org/project/linux-media/list/
-S:	Maintained
-F:	drivers/media/dvb-frontends/it913x-fe*
-
-IT913X MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org/
-- 
1.9.rc1

