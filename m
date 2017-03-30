Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43842 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932582AbdC3KqN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 06:46:13 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        John Youn <johnyoun@synopsys.com>, linux-usb@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH v2 20/22] usb: gadget.h: be consistent at kernel doc macros
Date: Thu, 30 Mar 2017 07:45:54 -0300
Message-Id: <99c5e340011fb2837042ba5dd6577d04139f3f08.1490870599.git.mchehab@s-opensource.com>
In-Reply-To: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
References: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
In-Reply-To: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
References: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's one value that use spaces instead of tabs to ident.
That causes the following warning:

./include/linux/usb/gadget.h:193: ERROR: Unexpected indentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/linux/usb/gadget.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index e4516e9ded0f..fbc22a39e7bc 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -188,7 +188,7 @@ struct usb_ep_caps {
  * @caps:The structure describing types and directions supported by endoint.
  * @maxpacket:The maximum packet size used on this endpoint.  The initial
  *	value can sometimes be reduced (hardware allowing), according to
- *      the endpoint descriptor used to configure the endpoint.
+ *	the endpoint descriptor used to configure the endpoint.
  * @maxpacket_limit:The maximum packet size value which can be handled by this
  *	endpoint. It's set once by UDC driver when endpoint is initialized, and
  *	should not be changed. Should not be confused with maxpacket.
-- 
2.9.3
