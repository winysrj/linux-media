Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41407 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbcGHNEE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:04 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 28/54] doc-rst: linux_tv/index: Rename the book name
Date: Fri,  8 Jul 2016 10:03:20 -0300
Message-Id: <39ab63237f90b885b2f79a95ac057e8bceaebad2.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's no need for all caps at its name. As the book title is
now showing at the top of each page, let's use Camel Case, to
make it less bold.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/index.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/linux_tv/index.rst b/Documentation/linux_tv/index.rst
index 4815ad6fc6b9..67b3ef6ec3d7 100644
--- a/Documentation/linux_tv/index.rst
+++ b/Documentation/linux_tv/index.rst
@@ -3,7 +3,7 @@
 .. include:: <isonum.txt>
 
 ##############################
-LINUX MEDIA INFRASTRUCTURE API
+Linux Media Infrastructure API
 ##############################
 
 **Copyright** |copy| 2009-2016 : LinuxTV Developers
-- 
2.7.4

