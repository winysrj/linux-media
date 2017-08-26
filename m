Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53299
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752350AbdHZJ2h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 05:28:37 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 4/4] docs-rst: don't require adjustbox anymore
Date: Sat, 26 Aug 2017 06:28:28 -0300
Message-Id: <4d7980a4b72da95c73976b48c9769004974cd0bc.1503739177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503739177.git.mchehab@s-opensource.com>
References: <cover.1503739177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503739177.git.mchehab@s-opensource.com>
References: <cover.1503739177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Only the media PDF book was requiring adjustbox, in order to
scale big tables. That worked pretty good with Sphinx versions
1.4 and 1.5, but Spinx 1.6 changed the way tables are produced,
by introducing some weird macros before tabulary.
That causes adjustbox to fail. So, it can't be used anymore,
and its usage was removed from the media book.

So, let's remove it from conf.py and sphinx-pre-install.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/conf.py      | 3 ---
 scripts/sphinx-pre-install | 1 -
 2 files changed, 4 deletions(-)

diff --git a/Documentation/conf.py b/Documentation/conf.py
index f9054ab60cb1..4c87bc10220c 100644
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
