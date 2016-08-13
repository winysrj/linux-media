Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:52774 "EHLO smtp3-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbcHMONf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Aug 2016 10:13:35 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jani Nikula <jani.nikula@intel.com>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH 5/7] doc-rst: add docutils config file
Date: Sat, 13 Aug 2016 16:12:46 +0200
Message-Id: <1471097568-25990-6-git-send-email-markus.heiser@darmarit.de>
In-Reply-To: <1471097568-25990-1-git-send-email-markus.heiser@darmarit.de>
References: <1471097568-25990-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

To stop the sphinx-build on severe errors and exit with an exit code (to
stop make) the halt_level must be set. The halt_level can't be set from
sphinx, it is a docutils configuration [1]. For this a docutils.conf was
added.

[1] http://docutils.sourceforge.net/docs/user/config.html

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
---
 Documentation/docutils.conf | 7 +++++++
 1 file changed, 7 insertions(+)
 create mode 100644 Documentation/docutils.conf

diff --git a/Documentation/docutils.conf b/Documentation/docutils.conf
new file mode 100644
index 0000000..2830772
--- /dev/null
+++ b/Documentation/docutils.conf
@@ -0,0 +1,7 @@
+# -*- coding: utf-8 mode: conf-colon -*-
+#
+# docutils configuration file
+# http://docutils.sourceforge.net/docs/user/config.html
+
+[general]
+halt_level: severe
\ No newline at end of file
-- 
2.7.4

