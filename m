Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34600 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753164AbcHUSXL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 Aug 2016 14:23:11 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 2/2] docs-rst: Fix an warning when in interactive mode
Date: Sun, 21 Aug 2016 15:23:04 -0300
Message-Id: <1a1375ce4fd1f8f95695cfcc809899e58f157b2d.1471803675.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471803675.git.mchehab@s-opensource.com>
References: <cover.1471803675.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471803675.git.mchehab@s-opensource.com>
References: <cover.1471803675.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When XeLaTeX is in interactive mode, it complains that
py@noticelength already exists. Rename it and declare it
only once to avoid such messages.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/conf.py | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/conf.py b/Documentation/conf.py
index f71b71048e37..42045c26581b 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -282,14 +282,14 @@ latex_elements = {
 	\\definecolor{WarningColor}{RGB}{255,204,204}
 	\\definecolor{AttentionColor}{RGB}{255,255,204}
 	\\definecolor{OtherColor}{RGB}{204,204,204}
+        \\newlength{\\mynoticelength}
         \\makeatletter\\newenvironment{coloredbox}[1]{%
-	   \\newlength{\\py@noticelength}
 	   \\setlength{\\fboxrule}{1pt}
 	   \\setlength{\\fboxsep}{7pt}
-	   \\setlength{\\py@noticelength}{\\linewidth}
-	   \\addtolength{\\py@noticelength}{-2\\fboxsep}
-	   \\addtolength{\\py@noticelength}{-2\\fboxrule}
-           \\begin{lrbox}{\\@tempboxa}\\begin{minipage}{\\py@noticelength}}{\\end{minipage}\\end{lrbox}%
+	   \\setlength{\\mynoticelength}{\\linewidth}
+	   \\addtolength{\\mynoticelength}{-2\\fboxsep}
+	   \\addtolength{\\mynoticelength}{-2\\fboxrule}
+           \\begin{lrbox}{\\@tempboxa}\\begin{minipage}{\\mynoticelength}}{\\end{minipage}\\end{lrbox}%
 	   \\ifthenelse%
 	      {\\equal{\\py@noticetype}{note}}%
 	      {\\colorbox{NoteColor}{\\usebox{\\@tempboxa}}}%
-- 
2.7.4


