Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49439 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbcHPQZv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 12:25:51 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 2/9] docs-rst: remove a rst2pdf left over code
Date: Tue, 16 Aug 2016 13:25:36 -0300
Message-Id: <e943c71bcbef8111c47ba6c21a1f284417a15fe9.1471364025.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471364025.git.mchehab@s-opensource.com>
References: <cover.1471364025.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471364025.git.mchehab@s-opensource.com>
References: <cover.1471364025.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The usage of rst2pdf was replaced by pdflatex on a previous
patch. Remove the left-over code at conf.py.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/conf.py | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/Documentation/conf.py b/Documentation/conf.py
index 5c06b018ad1d..2c60df7e5b79 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -31,13 +31,6 @@ from load_config import loadConfig
 # ones.
 extensions = ['kernel-doc', 'rstFlatTable', 'kernel_include']
 
-# Gracefully handle missing rst2pdf.
-try:
-    import rst2pdf
-    extensions += ['rst2pdf.pdfbuilder']
-except ImportError:
-    pass
-
 # Add any paths that contain templates here, relative to this directory.
 templates_path = ['_templates']
 
-- 
2.7.4


