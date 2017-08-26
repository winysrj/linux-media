Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53293
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752206AbdHZJ2h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 05:28:37 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 1/4] docs-rst: fix verbatim font size on tables
Date: Sat, 26 Aug 2017 06:28:25 -0300
Message-Id: <a19557366d2e69ff9d52628baa2472faa57fe8ca.1503739177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503739177.git.mchehab@s-opensource.com>
References: <cover.1503739177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503739177.git.mchehab@s-opensource.com>
References: <cover.1503739177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sphinx 1.6, fancy boxes are used for verbatim. The sphinx.sty
sets verbatim font is always \small. That causes a problem
inside tables that use smaller fonts, as it can be too big for
the box.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/conf.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/conf.py b/Documentation/conf.py
index 9e941be37b94..f9054ab60cb1 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -345,7 +345,7 @@ if major == 1 and minor <= 4:
     latex_elements['preamble']  += '\\usepackage[margin=0.5in, top=1in, bottom=1in]{geometry}'
 elif major == 1 and (minor > 5 or (minor == 5 and patch >= 3)):
     latex_elements['sphinxsetup'] = 'hmargin=0.5in, vmargin=1in'
-
+    latex_elements['preamble']  += '\\fvset{fontsize=auto}\n'
 
 # Grouping the document tree into LaTeX files. List of tuples
 # (source start file, target name, title,
-- 
2.13.3
