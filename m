Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44140 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941748AbcIHMEZ (ORCPT
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
Subject: [PATCH 29/47] [media] ca-get-descr-info.rst: add doc for for struct ca_descr_info
Date: Thu,  8 Sep 2016 09:03:51 -0300
Message-Id: <e03836d29fc5df3ecd647a618bd544afd11e626b.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The documentation follows what's there at the ca.h header.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/ca-get-descr-info.rst | 23 +++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/dvb/ca-get-descr-info.rst b/Documentation/media/uapi/dvb/ca-get-descr-info.rst
index b007f10b4910..b4a31940cec0 100644
--- a/Documentation/media/uapi/dvb/ca-get-descr-info.rst
+++ b/Documentation/media/uapi/dvb/ca-get-descr-info.rst
@@ -25,7 +25,28 @@ Arguments
   File descriptor returned by a previous call to :c:func:`open() <dvb-ca-open>`.
 
 ``desc``
-  Undocumented.
+  Pointer to struct :c:type:`ca_descr_info`.
+
+.. c:type:: struct ca_descr_info
+
+.. flat-table:: struct ca_descr_info
+    :header-rows:  1
+    :stub-columns: 0
+
+    -
+      - type
+      - name
+      - description
+
+    -
+      - unsigned int
+      - num
+      - number of available descramblers (keys)
+    -
+      - unsigned int
+      - type
+      - type of supported scrambling system. Valid values are:
+	``CA_ECD``, ``CA_NDS`` and ``CA_DSS``.
 
 
 Description
-- 
2.7.4


