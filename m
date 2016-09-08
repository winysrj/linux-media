Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44064 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965609AbcIHMEX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:23 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 32/47] [media] ca-set-pid.rst: document struct ca_pid
Date: Thu,  8 Sep 2016 09:03:54 -0300
Message-Id: <fcdba941411e7814d2777874753fce7054ecc462.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a table describing the fields on this struct, based
on ca.h header.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/ca-set-pid.rst | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/dvb/ca-set-pid.rst b/Documentation/media/uapi/dvb/ca-set-pid.rst
index 8e13ad9595d3..06bdaf4afada 100644
--- a/Documentation/media/uapi/dvb/ca-set-pid.rst
+++ b/Documentation/media/uapi/dvb/ca-set-pid.rst
@@ -26,7 +26,24 @@ Arguments
   File descriptor returned by a previous call to :c:func:`open() <dvb-ca-open>`.
 
 ``pid``
-  Undocumented.
+  Pointer to struct :c:type:`ca_pid`.
+
+.. c:type:: ca_pid
+
+.. flat-table:: struct ca_pid
+    :header-rows:  1
+    :stub-columns: 0
+
+    -
+       - unsigned int
+       - pid
+       - Program ID
+
+    -
+       - int
+       - index
+       - PID index. Use -1 to disable.
+
 
 
 Description
-- 
2.7.4


