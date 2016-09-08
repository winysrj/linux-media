Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44146 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941749AbcIHMEZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 30/47] [media] ca-get-msg.rst: add a boilerplate for struct ca_msg
Date: Thu,  8 Sep 2016 09:03:52 -0300
Message-Id: <f9bfaf8466a086934a002ffc256cd9c3eadf69cc.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are no descriptions at ca.h header for this struct.
Yet, as we want to get rid of the warnings, let's add a
boilerplate, with just the struct types and fields.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/ca-get-msg.rst | 33 ++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/dvb/ca-get-msg.rst b/Documentation/media/uapi/dvb/ca-get-msg.rst
index 880995230909..03b2a602f02a 100644
--- a/Documentation/media/uapi/dvb/ca-get-msg.rst
+++ b/Documentation/media/uapi/dvb/ca-get-msg.rst
@@ -26,7 +26,38 @@ Arguments
   File descriptor returned by a previous call to :c:func:`open() <dvb-ca-open>`.
 
 ``msg``
-  Undocumented.
+  Pointer to struct :c:type:`ca_msg`.
+
+
+.. c:type:: struct ca_msg
+
+.. flat-table:: struct ca_msg
+    :header-rows:  1
+    :stub-columns: 0
+
+    -
+      - type
+      - name
+      - description
+    -
+       - unsigned int
+       - index
+       -
+
+    -
+       - unsigned int
+       - type
+       -
+
+    -
+       - unsigned int
+       - length
+       -
+
+    -
+       - unsigned char
+       - msg[256]
+       -
 
 
 Description
-- 
2.7.4


