Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36547 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbbEHBMt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 May 2015 21:12:49 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 01/18] media controller: add EXPERIMENTAL to Kconfig option for DVB support
Date: Thu,  7 May 2015 22:12:23 -0300
Message-Id: <35cb86bc03b693fd5ef6133c22c78aacfd63a0e2.1431046915.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1431046915.git.mchehab@osg.samsung.com>
References: <cover.1431046915.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1431046915.git.mchehab@osg.samsung.com>
References: <cover.1431046915.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Media Controller DVB support is still an experimental feature,
as it is under heavy development. It is already said that it is
an experimental feature at the help, but let make it even clearer
and louder, as we may need to adjust some bits when we start using it
on embedded drivers.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 3ef0f90b128f..8af89b084267 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -95,7 +95,7 @@ config MEDIA_CONTROLLER
 	  This API is mostly used by camera interfaces in embedded platforms.
 
 config MEDIA_CONTROLLER_DVB
-	bool "Enable Media controller for DVB"
+	bool "Enable Media controller for DVB (EXPERIMENTAL)"
 	depends on MEDIA_CONTROLLER
 	---help---
 	  Enable the media controller API support for DVB.
-- 
2.1.0

