Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41417 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbcGHNEE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:04 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 27/54] doc-rst: v4l2: Rename the V4L2 API title
Date: Fri,  8 Jul 2016 10:03:19 -0300
Message-Id: <62acdf3554822f48ecfd4dee471b33c6f59b48d8.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2 is the only part of the doc that has the word "Specification"
and mentions its version on the title.

Having the version there was important in the past, while we were
getting rid of V4L version 1. But, as v1 is long gone, all it lasts
is history (with is, btw, covered on the spec). So, no need to keep
the version on its title.

So, rename it, to be more generic and look like the remaining
of the document.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/v4l2.rst | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/v4l2.rst b/Documentation/linux_tv/media/v4l/v4l2.rst
index 9284446e3cfa..301f95b5bdc6 100644
--- a/Documentation/linux_tv/media/v4l/v4l2.rst
+++ b/Documentation/linux_tv/media/v4l/v4l2.rst
@@ -3,9 +3,11 @@
 .. include:: <isonum.txt>
 .. _v4l2spec:
 
-#####################################
-Video for Linux Two API Specification
-#####################################
+###################
+Video for Linux API
+###################
+
+This part describes the Video for Linux API version 2 (V4L2 API) specification.
 
 **Revision 4.5**
 
-- 
2.7.4

