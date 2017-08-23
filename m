Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:41837
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753628AbdHWI5E (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 04:57:04 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2 3/4] docs-rst: pdf: use same vertical margin on all Sphinx versions
Date: Wed, 23 Aug 2017 05:56:56 -0300
Message-Id: <0e6417df428a74e82e84aeb41f07e8aaa0aed495.1503477995.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503477995.git.mchehab@s-opensource.com>
References: <cover.1503477995.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503477995.git.mchehab@s-opensource.com>
References: <cover.1503477995.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, on Sphinx up to version 1.4, pdf output uses a vertical
margin of 1 inch. For upper versions, it uses a margin of 0.5 inches.

That causes both page headers and footers to be very close to the margin
of the sheet. Not all printers support writing like that.

Also, there's no reason why the layout for newer versions would be
different than for previous ones.

So, standardize it, by always setting to 1 inch.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/conf.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/conf.py b/Documentation/conf.py
index 71b032bb44fd..8e74d68037a5 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -344,7 +344,7 @@ if major == 1 and minor > 3:
 if major == 1 and minor <= 4:
     latex_elements['preamble']  += '\\usepackage[margin=0.5in, top=1in, bottom=1in]{geometry}'
 elif major == 1 and (minor > 5 or (minor == 5 and patch >= 3)):
-    latex_elements['sphinxsetup'] = 'hmargin=0.5in, vmargin=0.5in'
+    latex_elements['sphinxsetup'] = 'hmargin=0.5in, vmargin=1in'
 
 
 # Grouping the document tree into LaTeX files. List of tuples
-- 
2.13.3
