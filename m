Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44136 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965735AbcIHMEa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:30 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 31/47] [media] ca-get-slot-info.rst: document struct ca_slot_info
Date: Thu,  8 Sep 2016 09:03:53 -0300
Message-Id: <631221a3f5dfbf52d95e994ae2940cca9fd4ffd5.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add documentation for struct ca_slot_info and for the two
sets of define used by it, according with what's there at the
ca.h header.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/ca-get-slot-info.rst | 84 ++++++++++++++++++++++-
 1 file changed, 83 insertions(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/dvb/ca-get-slot-info.rst b/Documentation/media/uapi/dvb/ca-get-slot-info.rst
index fcecd80e30d4..4398aeb83eb7 100644
--- a/Documentation/media/uapi/dvb/ca-get-slot-info.rst
+++ b/Documentation/media/uapi/dvb/ca-get-slot-info.rst
@@ -26,7 +26,89 @@ Arguments
   File descriptor returned by a previous call to :c:func:`open() <cec-open>`.
 
 ``info``
-  Undocumented.
+  Pointer to struct c:type:`ca_slot_info`.
+
+.. _ca_slot_info_type:
+
+.. flat-table:: ca_slot_info types
+    :header-rows:  1
+    :stub-columns: 0
+
+    -
+      - type
+      - name
+      - description
+    -
+       - CA_CI
+       - 1
+       - CI high level interface
+
+    -
+       - CA_CI_LINK
+       - 2
+       - CI link layer level interface
+
+    -
+       - CA_CI_PHYS
+       - 4
+       - CI physical layer level interface
+
+    -
+       - CA_DESCR
+       - 8
+       - built-in descrambler
+
+    -
+       - CA_SC
+       - 128
+       - simple smart card interface
+
+.. _ca_slot_info_flag:
+
+.. flat-table:: ca_slot_info flags
+    :header-rows:  1
+    :stub-columns: 0
+
+    -
+      - type
+      - name
+      - description
+
+    -
+       - CA_CI_MODULE_PRESENT
+       - 1
+       - module (or card) inserted
+
+    -
+       - CA_CI_MODULE_READY
+       - 2
+       -
+
+.. c:type:: ca_slot_info
+
+.. flat-table:: struct ca_slot_info
+    :header-rows:  1
+    :stub-columns: 0
+
+    -
+      - type
+      - name
+      - description
+
+    -
+       - int
+       - num
+       - slot number
+
+    -
+       - int
+       - type
+       - CA interface this slot supports, as defined at :ref:`ca_slot_info_type`.
+
+    -
+       - unsigned int
+       - flags
+       - flags as defined at :ref:`ca_slot_info_flag`.
 
 
 Description
-- 
2.7.4


