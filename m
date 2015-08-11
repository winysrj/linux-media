Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42515 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbbHKWku (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 18:40:50 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kamil Debski <k.debski@samsung.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 3/3] [media] c8sectpfe: use a new Kconfig menu for DVB platform drivers
Date: Tue, 11 Aug 2015 19:39:06 -0300
Message-Id: <ca05189716c2ce02c60303e9c1228a61d1cb9542.1439332733.git.mchehab@osg.samsung.com>
In-Reply-To: <53cc7c9043f0a68a66e53623b114c86051a7250c.1439332733.git.mchehab@osg.samsung.com>
References: <53cc7c9043f0a68a66e53623b114c86051a7250c.1439332733.git.mchehab@osg.samsung.com>
In-Reply-To: <53cc7c9043f0a68a66e53623b114c86051a7250c.1439332733.git.mchehab@osg.samsung.com>
References: <53cc7c9043f0a68a66e53623b114c86051a7250c.1439332733.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While this is the first DVB platform drivers, let's keep the
Kconfig options well organized, adding it on its own DVB menu.

Of course, it should depend on MEDIA_DIGITAL_TV_SUPPORT, as
this enables all DVB-related menus.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index ce3eaf050ba7..3adf686e005d 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -293,4 +293,13 @@ config VIDEO_VIM2M
 	  framework.
 endif #V4L_TEST_DRIVERS
 
+menuconfig DVB_PLATFORM_DRIVERS
+	bool "DVB platform devices"
+	depends on MEDIA_DIGITAL_TV_SUPPORT
+	default n
+	---help---
+	  Say Y here to enable support for platform-specific Digital TV drivers.
+
+if DVB_PLATFORM_DRIVERS
 source "drivers/media/platform/sti/c8sectpfe/Kconfig"
+endif #DVB_PLATFORM_DRIVERS
-- 
2.4.3

