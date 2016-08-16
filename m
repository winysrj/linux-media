Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35259 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbcHPQrm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 12:47:42 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 9/9] docs-rst: add media documentation to PDF output
Date: Tue, 16 Aug 2016 13:47:37 -0300
Message-Id: <0b35ae766304312300ad319e8f221d405cf44b1f.1471365031.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471365031.git.mchehab@s-opensource.com>
References: <cover.1471365031.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471365031.git.mchehab@s-opensource.com>
References: <cover.1471365031.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the build of PDF output on media got fixed, re-add it
to the Sphinx PDF build.

Partially reverts 3eb6cd6834c3 ('Documentation: exclude
media documentation from pdf generation').

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/conf.py | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/conf.py b/Documentation/conf.py
index 64f5fb4170a9..8058eb2b8340 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -320,6 +320,8 @@ latex_documents = [
      'The kernel development community', 'manual'),
     ('gpu/index', 'gpu.tex', 'Linux GPU Driver Developer\'s Guide',
      'The kernel development community', 'manual'),
+    ('media/index', 'media.tex', 'Linux Media Subsystem Documentation',
+     'The kernel development community', 'manual'),
 ]
 
 # The name of an image file (relative to this directory) to place at the top of
-- 
2.7.4


