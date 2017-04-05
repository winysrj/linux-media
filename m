Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40010
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755276AbdDENX2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Apr 2017 09:23:28 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Felipe Balbi <balbi@kernel.org>
Subject: [PATCH v2 20/21] usb: gadget.h: be consistent at kernel doc macros
Date: Wed,  5 Apr 2017 10:23:14 -0300
Message-Id: <26f475986b9061fab2d81f5fe3d7ae249b118113.1491398120.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1491398120.git.mchehab@s-opensource.com>
References: <cover.1491398120.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1491398120.git.mchehab@s-opensource.com>
References: <cover.1491398120.git.mchehab@s-opensource.com>
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
