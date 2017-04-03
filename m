Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:38901 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752273AbdDCOyY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Apr 2017 10:54:24 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Songjun Wu <Songjun.Wu@microchip.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] MAINTAINERS: update atmel-isi.c path
Message-ID: <d8b1734c-a689-bea5-33f3-113b4b7b3247@xs4all.nl>
Date: Mon, 3 Apr 2017 16:54:19 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver moved to drivers/media/platform/atmel.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
After the atmel-isi v6 patch series this atmel-isi entry is no longer correct.
Fixed.

Songjun, I don't think Ludovic is still maintainer of this driver. Should that
be changed to you? (And no, I'm not planning to maintain this driver going forward :-) )

Regards,

	Hans
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 93500928ca4f..08d41f8e5d33 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2224,7 +2224,7 @@ ATMEL ISI DRIVER
 M:	Ludovic Desroches <ludovic.desroches@microchip.com>
 L:	linux-media@vger.kernel.org
 S:	Supported
-F:	drivers/media/platform/soc_camera/atmel-isi.c
+F:	drivers/media/platform/atmel/atmel-isi.c
 F:	include/media/atmel-isi.h

 ATMEL LCDFB DRIVER
-- 
2.11.0
