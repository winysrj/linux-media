Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:41831
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753603AbdHWI5D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 04:57:03 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        SeongJae Park <sj38.park@gmail.com>,
        Markus Heiser <markus.heiser@darmarit.de>
Subject: [PATCH v2 4/4] docs-rst: Allow Sphinx version 1.6
Date: Wed, 23 Aug 2017 05:56:57 -0300
Message-Id: <0552b7adf6e023f33494987c3e908101d75250d2.1503477995.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503477995.git.mchehab@s-opensource.com>
References: <cover.1503477995.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503477995.git.mchehab@s-opensource.com>
References: <cover.1503477995.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the PDF building issues with Sphinx 1.6 got fixed,
update the documentation and scripts accordingly.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/conf.py              | 3 ---
 Documentation/doc-guide/sphinx.rst | 4 +---
 scripts/sphinx-pre-install         | 1 -
 3 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/Documentation/conf.py b/Documentation/conf.py
index 8e74d68037a5..0834a9933d69 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -331,9 +331,6 @@ latex_elements = {
         \\setromanfont{DejaVu Sans}
         \\setmonofont{DejaVu Sans Mono}
 
-	% To allow adjusting table sizes
-	\\usepackage{adjustbox}
-
      '''
 }
 
diff --git a/Documentation/doc-guide/sphinx.rst b/Documentation/doc-guide/sphinx.rst
index 8faafb9b2d86..a2417633fdd8 100644
--- a/Documentation/doc-guide/sphinx.rst
+++ b/Documentation/doc-guide/sphinx.rst
@@ -80,9 +80,7 @@ output.
 PDF and LaTeX builds
 --------------------
 
-Such builds are currently supported only with Sphinx versions 1.4 and 1.5.
-
-Currently, it is not possible to do pdf builds with Sphinx version 1.6.
+Such builds are currently supported only with Sphinx versions 1.4 and upper.
 
 For PDF and LaTeX output, you'll also need ``XeLaTeX`` version 3.14159265.
 
diff --git a/scripts/sphinx-pre-install b/scripts/sphinx-pre-install
index 677756ae34c9..067459760a7b 100755
--- a/scripts/sphinx-pre-install
+++ b/scripts/sphinx-pre-install
@@ -40,7 +40,6 @@ my $virtualenv = 1;
 #
 
 my %texlive = (
-	'adjustbox.sty'      => 'texlive-adjustbox',
 	'amsfonts.sty'       => 'texlive-amsfonts',
 	'amsmath.sty'        => 'texlive-amsmath',
 	'amssymb.sty'        => 'texlive-amsfonts',
-- 
2.13.3
