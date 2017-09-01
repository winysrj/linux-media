Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46944
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752087AbdIANY7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 09:24:59 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2 23/27] media: ca-get-slot-info.rst: document this ioctl
Date: Fri,  1 Sep 2017 10:24:45 -0300
Message-Id: <6f1e7979981a4aec031f8f635041ac599e5c1004.1504272067.git.mchehab@s-opensource.com>
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
 Documentation/media/uapi/dvb/ca-get-slot-info.rst | 98 +++--------------------
 1 file changed, 11 insertions(+), 87 deletions(-)

diff --git a/Documentation/media/uapi/dvb/ca-get-slot-info.rst b/Documentation/media/uapi/dvb/ca-get-slot-info.rst
index 54e5dc78a2dc..d7e41e038ca7 100644
--- a/Documentation/media/uapi/dvb/ca-get-slot-info.rst
+++ b/Documentation/media/uapi/dvb/ca-get-slot-info.rst
@@ -26,100 +26,24 @@ Arguments
   File descriptor returned by a previous call to :c:func:`open() <cec-open>`.
 
 ``info``
-  Pointer to struct c:type:`ca_slot_info`.
-
-.. _ca_slot_info_type:
-
-.. flat-table:: ca_slot_info types
-    :header-rows:  1
-    :stub-columns: 0
-
-    -
-      - type
-      - name
-      - description
-    -
-       - CA_CI
-       - 1
-       - CI high level interface
-
-    -
-       - CA_CI_LINK
-       - 2
-       - CI link layer level interface
-
-    -
-       - CA_CI_PHYS
-       - 4
-       - CI physical layer level interface
-
-    -
-       - CA_DESCR
-       - 8
-       - built-in descrambler
-
-    -
-       - CA_SC
-       - 128
-       - simple smart card interface
-
-.. _ca_slot_info_flag:
-
-.. flat-table:: ca_slot_info flags
-    :header-rows:  1
-    :stub-columns: 0
-
-    -
-      - type
-      - name
-      - description
-
-    -
-       - CA_CI_MODULE_PRESENT
-       - 1
-       - module (or card) inserted
-
-    -
-       - CA_CI_MODULE_READY
-       - 2
-       -
-
-.. c:type:: ca_slot_info
-
-.. flat-table:: struct ca_slot_info
-    :header-rows:  1
-    :stub-columns: 0
-
-    -
-      - type
-      - name
-      - description
-
-    -
-       - int
-       - num
-       - slot number
-
-    -
-       - int
-       - type
-       - CA interface this slot supports, as defined at :ref:`ca_slot_info_type`.
-
-    -
-       - unsigned int
-       - flags
-       - flags as defined at :ref:`ca_slot_info_flag`.
-
+  Pointer to struct :c:type:`ca_slot_info`.
 
 Description
 -----------
 
-.. note:: This ioctl is undocumented. Documentation is welcome.
+Returns information about a CA slot identified by
+:c:type:`ca_slot_info`.slot_num.
 
 
 Return Value
 ------------
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+On success 0 is returned, and :c:type:`ca_slot_info` is filled.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+If the slot is not available, ``errno`` will contain ``-EINVAL``.
+
+The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-- 
2.13.5
