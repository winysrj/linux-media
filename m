Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:52562 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbcHHNPZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Aug 2016 09:15:25 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/3] doc-rst: add stand-alone conf.py to gpu folder
Date: Mon,  8 Aug 2016 15:15:00 +0200
Message-Id: <1470662100-6927-4-git-send-email-markus.heiser@darmarit.de>
In-Reply-To: <1470662100-6927-1-git-send-email-markus.heiser@darmarit.de>
References: <1470662100-6927-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

With the gpu/conf.py, the gpu folder can be build and distributed
stand-alone.

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

