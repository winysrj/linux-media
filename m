Return-path: <mchehab@pedra>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33184 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab1CCNbQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2011 08:31:16 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 1/6] media/video i.MX: use IMX_HAVE_PLATFORM_* macros
Date: Thu,  3 Mar 2011 14:30:55 +0100
Message-Id: <1299159060-9289-2-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1299159060-9289-1-git-send-email-s.hauer@pengutronix.de>
References: <1299159060-9289-1-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The i.MX architecture provides IMX_HAVE_PLATFORM_* macros to signal
that a selected SoC supports a certain hardware. Use them instead of
depending on ARCH_* directly.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index aa02160..6f869ed 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -814,7 +814,7 @@ config MX1_VIDEO
 
 config VIDEO_MX1
 	tristate "i.MX1/i.MXL CMOS Sensor Interface driver"
-	depends on VIDEO_DEV && ARCH_MX1 && SOC_CAMERA
+	depends on VIDEO_DEV && SOC_CAMERA && IMX_HAVE_PLATFORM_MX1_CAMERA
 	select FIQ
 	select VIDEOBUF_DMA_CONTIG
 	select MX1_VIDEO
@@ -872,7 +872,7 @@ config VIDEO_MX2_HOSTSUPPORT
 
 config VIDEO_MX2
 	tristate "i.MX27/i.MX25 Camera Sensor Interface driver"
-	depends on VIDEO_DEV && SOC_CAMERA && (MACH_MX27 || ARCH_MX25)
+	depends on VIDEO_DEV && SOC_CAMERA && IMX_HAVE_PLATFORM_MX2_CAMERA
 	select VIDEOBUF_DMA_CONTIG
 	select VIDEO_MX2_HOSTSUPPORT
 	---help---
-- 
1.7.2.3

