Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39375 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752592AbdC2Syb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 14:54:31 -0400
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
Subject: [PATCH 08/22] usb/bulk-streams.txt: convert to ReST and add to driver-api book
Date: Wed, 29 Mar 2017 15:54:07 -0300
Message-Id: <2ec64a50c17c505bc907b60b31fbbce3ab518369.1490813422.git.mchehab@s-opensource.com>
In-Reply-To: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
In-Reply-To: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This document describe some USB core functions. Add it to the
driver-api book.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../bulk-streams.txt => driver-api/usb/bulk-streams.rst}    | 13 +++++++++----
 Documentation/driver-api/usb/index.rst                      |  1 +
 2 files changed, 10 insertions(+), 4 deletions(-)
 rename Documentation/{usb/bulk-streams.txt => driver-api/usb/bulk-streams.rst} (94%)

diff --git a/Documentation/usb/bulk-streams.txt b/Documentation/driver-api/usb/bulk-streams.rst
similarity index 94%
rename from Documentation/usb/bulk-streams.txt
rename to Documentation/driver-api/usb/bulk-streams.rst
index ffc02021863e..99b515babdeb 100644
--- a/Documentation/usb/bulk-streams.txt
+++ b/Documentation/driver-api/usb/bulk-streams.rst
@@ -1,3 +1,6 @@
+USB bulk streams
+~~~~~~~~~~~~~~~~
+
 Background
 ==========
 
@@ -25,7 +28,9 @@ time.
 Driver implications
 ===================
 
-int usb_alloc_streams(struct usb_interface *interface,
+::
+
+  int usb_alloc_streams(struct usb_interface *interface,
 		struct usb_host_endpoint **eps, unsigned int num_eps,
 		unsigned int num_streams, gfp_t mem_flags);
 
@@ -53,7 +58,7 @@ controller driver, and may change in the future.
 
 
 Picking new Stream IDs to use
-============================
+=============================
 
 Stream ID 0 is reserved, and should not be used to communicate with devices.  If
 usb_alloc_streams() returns with a value of N, you may use streams 1 though N.
@@ -68,9 +73,9 @@ Clean up
 ========
 
 If a driver wishes to stop using streams to communicate with the device, it
-should call
+should call::
 
-void usb_free_streams(struct usb_interface *interface,
+  void usb_free_streams(struct usb_interface *interface,
 		struct usb_host_endpoint **eps, unsigned int num_eps,
 		gfp_t mem_flags);
 
diff --git a/Documentation/driver-api/usb/index.rst b/Documentation/driver-api/usb/index.rst
index 5dfb04b2d730..6fe7611f7332 100644
--- a/Documentation/driver-api/usb/index.rst
+++ b/Documentation/driver-api/usb/index.rst
@@ -7,6 +7,7 @@ Linux USB API
    usb
    gadget
    anchors
+   bulk-streams
    writing_usb_driver
    writing_musb_glue_layer
 
-- 
2.9.3
