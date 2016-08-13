Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:40451 "EHLO smtp3-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbcHMONe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Aug 2016 10:13:34 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jani Nikula <jani.nikula@intel.com>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH 4/7] doc-rst: add stand-alone conf.py to gpu folder
Date: Sat, 13 Aug 2016 16:12:45 +0200
Message-Id: <1471097568-25990-5-git-send-email-markus.heiser@darmarit.de>
In-Reply-To: <1471097568-25990-1-git-send-email-markus.heiser@darmarit.de>
References: <1471097568-25990-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

With the gpu/conf.py, the gpu folder can be build and distributed
stand-alone. To compile only the html of 'gpu' folder use::

  make SPHINXDIRS="gpu" htmldocs

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
---
 Documentation/gpu/conf.py | 3 +++
 1 file changed, 3 insertions(+)
 create mode 100644 Documentation/gpu/conf.py

diff --git a/Documentation/gpu/conf.py b/Documentation/gpu/conf.py
new file mode 100644
index 0000000..d60bcd0
--- /dev/null
+++ b/Documentation/gpu/conf.py
@@ -0,0 +1,3 @@
+# -*- coding: utf-8; mode: python -*-
+
+project = "Linux GPU Driver Developer's Guide"
-- 
2.7.4

