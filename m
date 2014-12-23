Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38157 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbaLWRDJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 12:03:09 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Huang Shijie <shijie8@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	devel@driverdev.osuosl.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Jim Davis <jim.epost@gmail.com>
Subject: [PATCH 2/2] tlg2300: Fix media dependencies
Date: Tue, 23 Dec 2014 15:02:57 -0200
Message-Id: <1242d0830a5a384155efaaf84325d342a078aca4.1419354167.git.mchehab@osg.samsung.com>
In-Reply-To: <0e0a5eabdd703a7afcf310cc24ea1425eea3ef07.1419354167.git.mchehab@osg.samsung.com>
References: <0e0a5eabdd703a7afcf310cc24ea1425eea3ef07.1419354167.git.mchehab@osg.samsung.com>
In-Reply-To: <0e0a5eabdd703a7afcf310cc24ea1425eea3ef07.1419354167.git.mchehab@osg.samsung.com>
References: <0e0a5eabdd703a7afcf310cc24ea1425eea3ef07.1419354167.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changeset ea2e813e8cc3 moved the driver to staging, but it forgot to
preserve the existing dependency.

Fixes: ea2e813e8cc3 ("[media] tlg2300: move to staging in preparation for removal")
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/staging/media/tlg2300/Kconfig b/drivers/staging/media/tlg2300/Kconfig
index 81784c6f7b88..77d8753f6ba4 100644
--- a/drivers/staging/media/tlg2300/Kconfig
+++ b/drivers/staging/media/tlg2300/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_TLG2300
 	tristate "Telegent TLG2300 USB video capture support (Deprecated)"
 	depends on VIDEO_DEV && I2C && SND && DVB_CORE
+	depends on MEDIA_USB_SUPPORT
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	depends on RC_CORE
-- 
2.1.0

