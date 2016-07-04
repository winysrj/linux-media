Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44701 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbcGDLrU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 08/51] Documentation: v4l2.rst: numerate the V4L2 chapters
Date: Mon,  4 Jul 2016 08:46:29 -0300
Message-Id: <a71ad8f7599238e5fd73dc4a51fd9f0913fcaa26.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Video4Linux documentation is big. We want to numerate the
items, as it makes easier to reference an item while discussing
the document on meetings.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/v4l2.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/linux_tv/media/v4l/v4l2.rst b/Documentation/linux_tv/media/v4l/v4l2.rst
index 1ddbd67ec466..44605ec92a50 100644
--- a/Documentation/linux_tv/media/v4l/v4l2.rst
+++ b/Documentation/linux_tv/media/v4l/v4l2.rst
@@ -10,7 +10,9 @@ Video for Linux Two API Specification
 **Revision 4.5**
 
 .. toctree::
+    :numbered:
     :maxdepth: 1
+    :caption: Table of Contents
 
     common
     pixfmt
-- 
2.7.4


