Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:35266 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751026AbdFGJdj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Jun 2017 05:33:39 -0400
Received: by mail-pf0-f171.google.com with SMTP id l89so3736913pfi.2
        for <linux-media@vger.kernel.org>; Wed, 07 Jun 2017 02:33:39 -0700 (PDT)
From: Alexandre Courbot <acourbot@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [PATCH] [media] media-ioc-g-topology.rst: fix typos
Date: Wed,  7 Jun 2017 18:33:02 +0900
Message-Id: <20170607093302.59312-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix what seems to be a few typos induced by copy/paste.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 Documentation/media/uapi/mediactl/media-ioc-g-topology.rst | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
index 48c9531f4db0..5f2d82756033 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
@@ -241,7 +241,7 @@ desired arrays with the media graph elements.
 
 .. c:type:: media_v2_intf_devnode
 
-.. flat-table:: struct media_v2_interface
+.. flat-table:: struct media_v2_devnode
     :header-rows:  0
     :stub-columns: 0
     :widths: 1 2 8
@@ -312,7 +312,7 @@ desired arrays with the media graph elements.
 
 .. c:type:: media_v2_link
 
-.. flat-table:: struct media_v2_pad
+.. flat-table:: struct media_v2_link
     :header-rows:  0
     :stub-columns: 0
     :widths: 1 2 8
@@ -324,7 +324,7 @@ desired arrays with the media graph elements.
 
        -  ``id``
 
-       -  Unique ID for the pad.
+       -  Unique ID for the link.
 
     -  .. row 2
 
@@ -334,7 +334,7 @@ desired arrays with the media graph elements.
 
        -  On pad to pad links: unique ID for the source pad.
 
-	  On interface to entity links: unique ID for the interface.
+	  On interface to entity links: unique ID for the entity.
 
     -  .. row 3
 
-- 
2.13.0.506.g27d5fe0cd-goog
