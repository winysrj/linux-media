Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43175 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754598AbcHSNFK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 09:05:10 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 12/15] [media] docs-rst: move cec kAPI documentation to the media book
Date: Fri, 19 Aug 2016 10:05:02 -0300
Message-Id: <e0e5d7d41639c1f71c228f9cd31c672587ec6a12.1471611003.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471611003.git.mchehab@s-opensource.com>
References: <cover.1471611003.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471611003.git.mchehab@s-opensource.com>
References: <cover.1471611003.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CEC kAPI documentation should also be part of the media book.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/{cec.txt => media/kapi/cec-core.rst} | 0
 Documentation/media/media_kapi.rst                 | 1 +
 2 files changed, 1 insertion(+)
 rename Documentation/{cec.txt => media/kapi/cec-core.rst} (100%)

diff --git a/Documentation/cec.txt b/Documentation/media/kapi/cec-core.rst
similarity index 100%
rename from Documentation/cec.txt
rename to Documentation/media/kapi/cec-core.rst
diff --git a/Documentation/media/media_kapi.rst b/Documentation/media/media_kapi.rst
index b71e8e8048ca..f282ca270369 100644
--- a/Documentation/media/media_kapi.rst
+++ b/Documentation/media/media_kapi.rst
@@ -32,3 +32,4 @@ For more details see the file COPYING in the source distribution of Linux.
     kapi/dtv-core
     kapi/rc-core
     kapi/mc-core
+    kapi/cec-core
-- 
2.7.4


