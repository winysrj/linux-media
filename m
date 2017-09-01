Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46979
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752098AbdIANZA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 09:25:00 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2 24/27] media: ca-get-descr-info.rst: document this ioctl
Date: Fri,  1 Sep 2017 10:24:46 -0300
Message-Id: <c63ef6b6b74469c37dc626413d35c48698af2418.1504272067.git.mchehab@s-opensource.com>
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
 Documentation/media/uapi/dvb/ca-get-descr-info.rst | 29 +++-------------------
 1 file changed, 4 insertions(+), 25 deletions(-)

diff --git a/Documentation/media/uapi/dvb/ca-get-descr-info.rst b/Documentation/media/uapi/dvb/ca-get-descr-info.rst
index 7bf327a3d0e3..e564fbb8d524 100644
--- a/Documentation/media/uapi/dvb/ca-get-descr-info.rst
+++ b/Documentation/media/uapi/dvb/ca-get-descr-info.rst
@@ -27,37 +27,16 @@ Arguments
 ``desc``
   Pointer to struct :c:type:`ca_descr_info`.
 
-.. c:type:: struct ca_descr_info
-
-.. flat-table:: struct ca_descr_info
-    :header-rows:  1
-    :stub-columns: 0
-
-    -
-      - type
-      - name
-      - description
-
-    -
-      - unsigned int
-      - num
-      - number of available descramblers (keys)
-    -
-      - unsigned int
-      - type
-      - type of supported scrambling system. Valid values are:
-	``CA_ECD``, ``CA_NDS`` and ``CA_DSS``.
-
-
 Description
 -----------
 
-.. note:: This ioctl is undocumented. Documentation is welcome.
-
+Returns information about all descrambler slots.
 
 Return Value
 ------------
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
+On success 0 is returned, and :c:type:`ca_descr_info` is filled.
+
+On error -1 is returned, and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-- 
2.13.5
