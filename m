Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35983 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933370AbdC3KqO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 06:46:14 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        John Youn <johnyoun@synopsys.com>, linux-usb@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v2 19/22] usb: composite.h: fix two warnings when building docs
Date: Thu, 30 Mar 2017 07:45:53 -0300
Message-Id: <3f680f3704ef71e06dca67ca7f4584256038fe78.1490870599.git.mchehab@s-opensource.com>
In-Reply-To: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
References: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
In-Reply-To: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
References: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

By definition, we use /* private: */ tag when we won't be documenting
a parameter. However, those two parameters are documented:

./include/linux/usb/composite.h:510: warning: Excess struct/union/enum/typedef member 'setup_pending' description in 'usb_composite_dev'
./include/linux/usb/composite.h:510: warning: Excess struct/union/enum/typedef member 'os_desc_pending' description in 'usb_composite_dev'

So, we need to use /* public: */ to avoid a warning.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/linux/usb/composite.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
index 30a063e98c19..f665d2ceac20 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -504,8 +504,9 @@ struct usb_composite_dev {
 	/* protects deactivations and delayed_status counts*/
 	spinlock_t			lock;
 
-	unsigned			setup_pending:1;
-	unsigned			os_desc_pending:1;
+	/* public: */
+	unsigned int			setup_pending:1;
+	unsigned int			os_desc_pending:1;
 };
 
 extern int usb_string_id(struct usb_composite_dev *c);
-- 
2.9.3
