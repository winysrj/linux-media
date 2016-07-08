Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41350 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbcGHNEC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:02 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 18/54] doc-rst: media-controller: missing credits
Date: Fri,  8 Jul 2016 10:03:10 -0300
Message-Id: <965a718a8b041e9e016034fa939ae93baf5c4e20.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When I wrote the MC next gen patches, I also improved the media
controller documentation and added documentation for
MEDIA_IOC_G_TOPOLOGY, but I forgot to add the credits on that
time.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/mediactl/media-controller.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/linux_tv/media/mediactl/media-controller.rst b/Documentation/linux_tv/media/mediactl/media-controller.rst
index 8b8af483c5e9..1877d68044b8 100644
--- a/Documentation/linux_tv/media/mediactl/media-controller.rst
+++ b/Documentation/linux_tv/media/mediactl/media-controller.rst
@@ -52,12 +52,19 @@ Authors:
 
  - Initial version.
 
+- Carvalho Chehab, Mauro <mchehab@kernel.org>
+
+ - MEDIA_IOC_G_TOPOLOGY documentation and documentation improvements.
+
 **Copyright** 2010 : Laurent Pinchart
+**Copyright** 2015-2016 : Mauro Carvalho Chehab
 
 ****************
 Revision History
 ****************
 
+:revision: 1.1.0 / 2015-12-12 (*mcc*)
+
 :revision: 1.0.0 / 2010-11-10 (*lp*)
 
 Initial revision
-- 
2.7.4

