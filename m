Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:34359 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933407AbdC3KqP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 06:46:15 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        John Youn <johnyoun@synopsys.com>, linux-usb@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        David Mosberger <davidm@egauge.net>,
        Oliver Neukum <oneukum@suse.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jaejoong Kim <climbbb.kim@gmail.com>,
        Roger Quadros <rogerq@ti.com>,
        Wolfram Sang <wsa-dev@sang-engineering.com>
Subject: [PATCH v2 18/22] usb: get rid of some ReST doc build errors
Date: Thu, 30 Mar 2017 07:45:52 -0300
Message-Id: <49b49c8946f566c0c7bfc1ddbb041b285aaa574b.1490870599.git.mchehab@s-opensource.com>
In-Reply-To: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
References: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
In-Reply-To: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
References: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need an space before a numbered list to avoid those warnings:

./drivers/usb/core/message.c:478: ERROR: Unexpected indentation.
./drivers/usb/core/message.c:479: WARNING: Block quote ends without a blank line; unexpected unindent.
./include/linux/usb/composite.h:455: ERROR: Unexpected indentation.
./include/linux/usb/composite.h:456: WARNING: Block quote ends without a blank line; unexpected unindent.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/usb/core/message.c    | 1 +
 include/linux/usb/composite.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 2184ef40a82a..4c38ea41ae96 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -474,6 +474,7 @@ EXPORT_SYMBOL_GPL(usb_sg_init);
  * significantly improve USB throughput.
  *
  * There are three kinds of completion for this function.
+ *
  * (1) success, where io->status is zero.  The number of io->bytes
  *     transferred is as requested.
  * (2) error, where io->status is a negative errno value.  The number
diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
index 4616a49a1c2e..30a063e98c19 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -451,6 +451,7 @@ static inline struct usb_composite_driver *to_cdriver(
  * sure doing that won't hurt too much.
  *
  * One notion for how to handle Wireless USB devices involves:
+ *
  * (a) a second gadget here, discovery mechanism TBD, but likely
  *     needing separate "register/unregister WUSB gadget" calls;
  * (b) updates to usb_gadget to include flags "is it wireless",
-- 
2.9.3
