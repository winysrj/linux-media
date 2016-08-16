Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49441 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbcHPQZv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 12:25:51 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 3/9] docs-rst: allow generating some LaTeX pages in landscape
Date: Tue, 16 Aug 2016 13:25:37 -0300
Message-Id: <ae30cc50406bedd6445929b7245b059df7b634ab.1471364025.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471364025.git.mchehab@s-opensource.com>
References: <cover.1471364025.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471364025.git.mchehab@s-opensource.com>
References: <cover.1471364025.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Portrait is too small for some tables used at the media docs.
So, allow documents to tell Sphinx to generate some pages
in landscape by using:

.. raw:: latex

    \begin{landscape}

<some stuff>

.. raw:: latex

    \end{landscape}

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/conf.py | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/Documentation/conf.py b/Documentation/conf.py
index 2c60df7e5b79..42175e87e425 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -246,16 +246,19 @@ htmlhelp_basename = 'TheLinuxKerneldoc'
 
 latex_elements = {
 # The paper size ('letterpaper' or 'a4paper').
-#'papersize': 'letterpaper',
+'papersize': 'a4paper',
 
 # The font size ('10pt', '11pt' or '12pt').
-#'pointsize': '10pt',
-
-# Additional stuff for the LaTeX preamble.
-#'preamble': '',
+'pointsize': '10pt',
 
 # Latex figure (float) alignment
 #'figure_align': 'htbp',
+
+# Additional stuff for the LaTeX preamble.
+    'preamble': '''
+        % Allow generate some pages in landscape
+        \\usepackage{lscape}
+     '''
 }
 
 # Grouping the document tree into LaTeX files. List of tuples
-- 
2.7.4


