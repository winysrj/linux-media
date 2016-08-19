Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52040 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754781AbcHSMtr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 08:49:47 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH] docs-rst: conf.py: adjust the size of .. note:: tag
Date: Fri, 19 Aug 2016 09:49:38 -0300
Message-Id: <88add40cfcfc49955f4e4b6c98c6662b9ac55044.1471610976.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While the current implementation works well when using as a
paragraph, it doesn't work properly if inside a table. As we
have quite a few such cases, fix the logic to take the column
size into account.

PS.: I took the logic there from the latest version of Sphinx.sty

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/conf.py | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/conf.py b/Documentation/conf.py
index 8058eb2b8340..5094a3b98ffa 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -282,7 +282,13 @@ latex_elements = {
         \\definecolor{MyGray}{rgb}{0.80,0.80,0.80}
 
         \\makeatletter\\newenvironment{graybox}{%
-           \\begin{lrbox}{\\@tempboxa}\\begin{minipage}{\\columnwidth}}{\\end{minipage}\\end{lrbox}%
+	   \\newlength{\\py@noticelength}
+	   \\setlength{\\fboxrule}{1pt}
+	   \\setlength{\\fboxsep}{7pt}
+	   \\setlength{\\py@noticelength}{\\linewidth}
+	   \\addtolength{\\py@noticelength}{-2\\fboxsep}
+	   \\addtolength{\\py@noticelength}{-2\\fboxrule}
+           \\begin{lrbox}{\\@tempboxa}\\begin{minipage}{\\py@noticelength}}{\\end{minipage}\\end{lrbox}%
            \\colorbox{MyGray}{\\usebox{\\@tempboxa}}
         }\\makeatother
 
-- 
2.7.4

