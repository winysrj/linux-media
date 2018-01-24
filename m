Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:44776 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752588AbeAXHlH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Jan 2018 02:41:07 -0500
Received: by mail-wr0-f196.google.com with SMTP id w50so3093718wrc.11
        for <linux-media@vger.kernel.org>; Tue, 23 Jan 2018 23:41:07 -0800 (PST)
From: Enrico Mioso <mrkiko.rs@gmail.com>
Cc: Enrico Mioso <mrkiko.rs@gmail.com>, linux-media@vger.kernel.org,
        Sean Young <sean@mess.org>,
        Piotr Oleszczyk <piotr.oleszczyk@gmail.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH] dib700: stop flooding system ring buffer
Date: Wed, 24 Jan 2018 08:40:38 +0100
Message-Id: <20180124074038.13275-1-mrkiko.rs@gmail.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stop flooding system ring buffer with messages like:
dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0
while tuning an Asus My Cinema-U3000Hybrid dvb card.

The correctness of this patch is opinable, but it's annoying me so much I
sent it anyway.

CC: linux-media@vger.kernel.org
CC: Sean Young <sean@mess.org>
CC: Piotr Oleszczyk <piotr.oleszczyk@gmail.com>
CC: Andrey Konovalov <andreyknvl@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Enrico Mioso <mrkiko.rs@gmail.com>
---
 drivers/media/usb/dvb-usb/dib0700_devices.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index 366b05529915..bc5d250ed2f2 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -432,8 +432,7 @@ static int stk7700ph_xc3028_callback(void *ptr, int component,
 	case XC2028_RESET_CLK:
 		break;
 	default:
-		err("%s: unknown command %d, arg %d\n", __func__,
-			command, arg);
+		break;
 		return -EINVAL;
 	}
 	return 0;
-- 
2.16.1
