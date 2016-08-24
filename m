Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:41452 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754187AbcHXPhI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Aug 2016 11:37:08 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/3] doc-rst: define PDF's of the media folder
Date: Wed, 24 Aug 2016 17:36:15 +0200
Message-Id: <1472052976-22541-3-git-send-email-markus.heiser@darmarit.de>
In-Reply-To: <1472052976-22541-1-git-send-email-markus.heiser@darmarit.de>
References: <1472052976-22541-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

To build only the PDF of the media folder run::

  make SPHINXDIRS=media pdfdocs

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
---
 Documentation/media/conf.py | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/media/conf.py b/Documentation/media/conf.py
index 77cb2bb..bef927b 100644
--- a/Documentation/media/conf.py
+++ b/Documentation/media/conf.py
@@ -3,3 +3,8 @@
 project = 'Linux Media Subsystem Documentation'
 
 tags.add("subproject")
+
+latex_documents = [
+    ('index', 'media.tex', 'Linux Media Subsystem Documentation',
+     'The kernel development community', 'manual'),
+]
-- 
2.7.4

