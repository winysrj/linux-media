Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43790 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941743AbcIHMES (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 28/47] [media] ca-get-cap.rst: add a table for struct ca_caps
Date: Thu,  8 Sep 2016 09:03:50 -0300
Message-Id: <f40673634bdbc787a247431903114394373cf633.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a flat-table describing struct ca_caps, as found at
the source file.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/ca-get-cap.rst | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/dvb/ca-get-cap.rst b/Documentation/media/uapi/dvb/ca-get-cap.rst
index 3486805b62a9..77c57ac59535 100644
--- a/Documentation/media/uapi/dvb/ca-get-cap.rst
+++ b/Documentation/media/uapi/dvb/ca-get-cap.rst
@@ -26,7 +26,34 @@ Arguments
   File descriptor returned by a previous call to :c:func:`open() <dvb-ca-open>`.
 
 ``caps``
-  Undocumented.
+  struct :c:type:`ca_caps` pointer
+
+.. c:type:: struct ca_caps
+
+.. flat-table:: struct ca_caps
+    :header-rows:  1
+    :stub-columns: 0
+
+    -
+      - type
+      - name
+      - description
+    -
+      -	unsigned int
+      - slot_num
+      - total number of CA card and module slots
+    -
+      - unsigned int
+      - slot_type
+      - bitmask with all supported slot types
+    -
+      - unsigned int
+      - descr_num
+      - total number of descrambler slots (keys)
+    -
+      - unsigned int
+      - descr_type
+      - bit mask with all supported descr types
 
 
 Description
-- 
2.7.4


