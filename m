Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:52266
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751071AbdICTD7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Sep 2017 15:03:59 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 7/7] media: index.rst: don't write "Contents:" on PDF output
Date: Sun,  3 Sep 2017 16:03:53 -0300
Message-Id: <1af1affbaae2f9e72846d3c78940f93c03c1c9fc.1504464984.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504464984.git.mchehab@s-opensource.com>
References: <cover.1504464984.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504464984.git.mchehab@s-opensource.com>
References: <cover.1504464984.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now, Sphinx unconditionally creates a blank page with
just "Contents:" on it, on PDF output. While this makes sense
for html, it doesn't o PDF, as LaTeX does what's required
automatically.

Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/index.rst | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/media/index.rst b/Documentation/media/index.rst
index 7d2907d4f8d7..1cf5316c8ff8 100644
--- a/Documentation/media/index.rst
+++ b/Documentation/media/index.rst
@@ -1,7 +1,11 @@
 Linux Media Subsystem Documentation
 ===================================
 
-Contents:
+.. only:: html
+
+   .. class:: toc-title
+
+        Table of Contents
 
 .. toctree::
    :maxdepth: 2
-- 
2.13.5
