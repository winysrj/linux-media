Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41421 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345AbcGHNEE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:04 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 26/54] doc-rst: Rename the title of the Digital TV section
Date: Fri,  8 Jul 2016 10:03:18 -0300
Message-Id: <86191cd762218156ce70fd6de24b412f7c26e420.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Digital TV section is ackward for two reasons:

  1) it is the only one with everything in upper case;
  2) its name is associated with the European digital TV standard.

Rename the part name, and add a notice that it refers to what's
known as "DVB API".

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/dvb/dvbapi.rst | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/Documentation/linux_tv/media/dvb/dvbapi.rst b/Documentation/linux_tv/media/dvb/dvbapi.rst
index 3a7d39e98fa3..60fb3d46b1d6 100644
--- a/Documentation/linux_tv/media/dvb/dvbapi.rst
+++ b/Documentation/linux_tv/media/dvb/dvbapi.rst
@@ -4,9 +4,12 @@
 
 .. _dvbapi:
 
-#############
-LINUX DVB API
-#############
+##############
+Digital TV API
+##############
+
+**NOTE:** This API is also known as **DVB API**, although it is generic
+enough to support all digital TV standards.
 
 **Version 5.10**
 
-- 
2.7.4

