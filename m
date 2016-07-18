Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45801 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbcGRB41 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 08/36] doc-rst: add v4l-drivers to index file
Date: Sun, 17 Jul 2016 22:55:51 -0300
Message-Id: <bde8bea759f45f24392d3114f550e05ec9635bd9.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds documentation for V4L drivers.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/index.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/index.rst b/Documentation/index.rst
index b61d8deb84d1..31273cc2e0bc 100644
--- a/Documentation/index.rst
+++ b/Documentation/index.rst
@@ -17,6 +17,7 @@ Contents:
    media/media_uapi
    media/media_drivers
    media/dvb-drivers/index
+   media/v4l-drivers/index
 
 Indices and tables
 ==================
-- 
2.7.4

