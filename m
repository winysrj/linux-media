Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53277
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751203AbdHZJ2g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 05:28:36 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        SeongJae Park <sj38.park@gmail.com>,
        Markus Heiser <markus.heiser@darmarit.de>
Subject: [PATCH 3/4] sphinx.rst: Allow Sphinx version 1.6 at the docs
Date: Sat, 26 Aug 2017 06:28:27 -0300
Message-Id: <cc17359229d67b2c7f4022ffbc57c8c0178cc37f.1503739177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503739177.git.mchehab@s-opensource.com>
References: <cover.1503739177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503739177.git.mchehab@s-opensource.com>
References: <cover.1503739177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the PDF building issues with Sphinx 1.6 got fixed,
update the documentation and scripts accordingly.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/doc-guide/sphinx.rst | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

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
 
-- 
2.13.3
