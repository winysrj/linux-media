Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51010 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbcHOVXR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 17:23:17 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH RFC v2 2/9] docs-rst: improve output for .. notes:: on LaTeX
Date: Mon, 15 Aug 2016 18:21:53 -0300
Message-Id: <fdff1e5900cacbf3cd18b167ada7ff22d30a122e.1471294965.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471294965.git.mchehab@s-opensource.com>
References: <cover.1471294965.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471294965.git.mchehab@s-opensource.com>
References: <cover.1471294965.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The output for those notes are bad in pdf, as they're not
in a box with a different color. Also, it causes the output
to not build if the note is inside a table.

Change its implementation to avoid the above troubles.

The logic there came from:
	https://stackoverflow.com/questions/606746/how-to-customize-an-existing-latex-environment-without-interfering-with-other-en

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/conf.py | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/Documentation/conf.py b/Documentation/conf.py
index 9ed1a2e39b4f..bbf2878d9945 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -264,6 +264,29 @@ latex_elements = {
     'preamble': '''
         % Allow generate some pages in landscape
         \\usepackage{lscape}
+
+        % Put notes in gray color and let them be inside a table
+
+        \\definecolor{MyGray}{rgb}{0.80,0.80,0.80}
+
+        \\makeatletter\\newenvironment{graybox}{%
+           \\begin{lrbox}{\\@tempboxa}\\begin{minipage}{\\columnwidth}}{\\end{minipage}\\end{lrbox}%
+           \\colorbox{MyGray}{\\usebox{\\@tempboxa}}
+        }\\makeatother
+
+        \\makeatletter
+        \\renewenvironment{notice}[2]{
+          \\begin{graybox}
+          \\bf\\it
+          \\def\\py@noticetype{#1}
+          \\par\\strong{#2}
+          \\csname py@noticestart@#1\\endcsname
+        }
+	{
+          \\csname py@noticeend@\\py@noticetype\\endcsname
+          \\end{graybox}
+        }
+	\\makeatother
      '''
 }
 
-- 
2.7.4


