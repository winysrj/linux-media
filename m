Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34604 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752420AbcHUSXL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 Aug 2016 14:23:11 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 1/2] docs-rst: Use better colors for note/warning/attention boxes
Date: Sun, 21 Aug 2016 15:23:03 -0300
Message-Id: <ccf42599c914825dc3b90ff718c66ff6064e4929.1471803675.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471803675.git.mchehab@s-opensource.com>
References: <cover.1471803675.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471803675.git.mchehab@s-opensource.com>
References: <cover.1471803675.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of painting the box with gray, let's use a colored
box. IMHO, that makes easier to warn users about some issue
pointed by the Sphinx. It also matches to what we do already
with the HTML output.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/conf.py | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/Documentation/conf.py b/Documentation/conf.py
index 011f6dac0c6c..f71b71048e37 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -277,11 +277,12 @@ latex_elements = {
         % Allow generate some pages in landscape
         \\usepackage{lscape}
 
-        % Put notes in gray color and let them be inside a table
-
-        \\definecolor{MyGray}{rgb}{0.80,0.80,0.80}
-
-        \\makeatletter\\newenvironment{graybox}{%
+        % Put notes in color and let them be inside a table
+	\\definecolor{NoteColor}{RGB}{204,255,255}
+	\\definecolor{WarningColor}{RGB}{255,204,204}
+	\\definecolor{AttentionColor}{RGB}{255,255,204}
+	\\definecolor{OtherColor}{RGB}{204,204,204}
+        \\makeatletter\\newenvironment{coloredbox}[1]{%
 	   \\newlength{\\py@noticelength}
 	   \\setlength{\\fboxrule}{1pt}
 	   \\setlength{\\fboxsep}{7pt}
@@ -289,20 +290,33 @@ latex_elements = {
 	   \\addtolength{\\py@noticelength}{-2\\fboxsep}
 	   \\addtolength{\\py@noticelength}{-2\\fboxrule}
            \\begin{lrbox}{\\@tempboxa}\\begin{minipage}{\\py@noticelength}}{\\end{minipage}\\end{lrbox}%
-           \\colorbox{MyGray}{\\usebox{\\@tempboxa}}
+	   \\ifthenelse%
+	      {\\equal{\\py@noticetype}{note}}%
+	      {\\colorbox{NoteColor}{\\usebox{\\@tempboxa}}}%
+	      {%
+	         \\ifthenelse%
+	         {\\equal{\\py@noticetype}{warning}}%
+	         {\\colorbox{WarningColor}{\\usebox{\\@tempboxa}}}%
+		 {%
+	            \\ifthenelse%
+	            {\\equal{\\py@noticetype}{attention}}%
+	            {\\colorbox{AttentionColor}{\\usebox{\\@tempboxa}}}%
+	            {\\colorbox{OtherColor}{\\usebox{\\@tempboxa}}}%
+		 }%
+	      }%
         }\\makeatother
 
         \\makeatletter
-        \\renewenvironment{notice}[2]{
-          \\begin{graybox}
-          \\bf\\it
+        \\renewenvironment{notice}[2]{%
           \\def\\py@noticetype{#1}
+          \\begin{coloredbox}{#1}
+          \\bf\\it
           \\par\\strong{#2}
           \\csname py@noticestart@#1\\endcsname
         }
 	{
           \\csname py@noticeend@\\py@noticetype\\endcsname
-          \\end{graybox}
+          \\end{coloredbox}
         }
 	\\makeatother
 
-- 
2.7.4


