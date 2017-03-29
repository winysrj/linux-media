Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43364 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753541AbdC2Syf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 14:54:35 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        John Youn <johnyoun@synopsys.com>, linux-usb@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 16/22] usb/gadget.rst: remove unused kernel-doc tags
Date: Wed, 29 Mar 2017 15:54:15 -0300
Message-Id: <81d3498d4bfd42ba4ac41781f2b5957fb0cfa29f.1490813422.git.mchehab@s-opensource.com>
In-Reply-To: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
In-Reply-To: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DocBook file used to have "!E" include tags for usb gadget functions.
However, there's nothing there to be documented:

	./drivers/usb/gadget/function/f_acm.c:1: warning: no structured comments found
	./drivers/usb/gadget/function/f_ecm.c:1: warning: no structured comments found
	./drivers/usb/gadget/function/f_subset.c:1: warning: no structured comments found
	./drivers/usb/gadget/function/f_obex.c:1: warning: no structured comments found
	./drivers/usb/gadget/function/f_serial.c:1: warning: no structured comments found

So, let's remove it. If someone wants do document the function
there, they may just revert this patch in the future.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/driver-api/usb/gadget.rst | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/Documentation/driver-api/usb/gadget.rst b/Documentation/driver-api/usb/gadget.rst
index c4c76ebb51d3..0488b89de21c 100644
--- a/Documentation/driver-api/usb/gadget.rst
+++ b/Documentation/driver-api/usb/gadget.rst
@@ -356,21 +356,6 @@ At this writing, a few of the current gadget drivers have been converted
 to this framework. Near-term plans include converting all of them,
 except for "gadgetfs".
 
-.. kernel-doc:: drivers/usb/gadget/function/f_acm.c
-   :export:
-
-.. kernel-doc:: drivers/usb/gadget/function/f_ecm.c
-   :export:
-
-.. kernel-doc:: drivers/usb/gadget/function/f_subset.c
-   :export:
-
-.. kernel-doc:: drivers/usb/gadget/function/f_obex.c
-   :export:
-
-.. kernel-doc:: drivers/usb/gadget/function/f_serial.c
-   :export:
-
 Peripheral Controller Drivers
 =============================
 
-- 
2.9.3
