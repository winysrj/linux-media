Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46989
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752124AbdIANZD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 09:25:03 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2 22/27] media: ca-get-cap.rst: document this ioctl
Date: Fri,  1 Sep 2017 10:24:44 -0300
Message-Id: <759969ab0434f05b3ad0afae31e5334bf9309849.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of a generic boilerplate, fill it with relevant
information about this ioctl.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/ca-get-cap.rst | 36 ++++-------------------------
 1 file changed, 5 insertions(+), 31 deletions(-)

diff --git a/Documentation/media/uapi/dvb/ca-get-cap.rst b/Documentation/media/uapi/dvb/ca-get-cap.rst
index fbf7e359cb8a..02d64acfb087 100644
--- a/Documentation/media/uapi/dvb/ca-get-cap.rst
+++ b/Documentation/media/uapi/dvb/ca-get-cap.rst
@@ -28,43 +28,17 @@ Arguments
 ``caps``
   Pointer to struct :c:type:`ca_caps`.
 
-.. c:type:: struct ca_caps
-
-.. flat-table:: struct ca_caps
-    :header-rows:  1
-    :stub-columns: 0
-
-    -
-      - type
-      - name
-      - description
-    -
-      -	unsigned int
-      - slot_num
-      - total number of CA card and module slots
-    -
-      - unsigned int
-      - slot_type
-      - bitmask with all supported slot types
-    -
-      - unsigned int
-      - descr_num
-      - total number of descrambler slots (keys)
-    -
-      - unsigned int
-      - descr_type
-      - bit mask with all supported descr types
-
-
 Description
 -----------
 
-.. note:: This ioctl is undocumented. Documentation is welcome.
-
+Queries the Kernel for information about the available CA and descrambler
+slots, and their types.
 
 Return Value
 ------------
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
+On success 0 is returned and :c:type:`ca_caps` is filled.
+
+On error, -1 is returned and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-- 
2.13.5
