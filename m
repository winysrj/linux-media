Return-path: <linux-media-owner@vger.kernel.org>
Received: from av6-2-sn3.vrr.skanova.net ([81.228.9.180]:55247 "EHLO
	av6-2-sn3.vrr.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593AbZFEONF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2009 10:13:05 -0400
Message-ID: <4A292072.9080900@mocean-labs.com>
Date: Fri, 05 Jun 2009 15:41:06 +0200
From: =?ISO-8859-15?Q?Richard_R=F6jfors?=
	<richard.rojfors.ext@mocean-labs.com>
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 6/9] V4L2: Added Timberdale Logiwin driver in Kconfig and
 Makefile
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Updates of Kconfig and Makefile for the Timberdale logiwin driver

Signed-off-by: Richard Röjfors <richard.rojfors.ext@mocean-labs.com>
---
Index: linux-2.6.30-rc7/drivers/media/video/Kconfig
===================================================================
--- linux-2.6.30-rc7/drivers/media/video/Kconfig	(revision 861)
+++ linux-2.6.30-rc7/drivers/media/video/Kconfig	(working copy)
@@ -786,6 +786,13 @@
 	---help---
 	  This is a v4l2 driver for the TI OMAP2 camera capture interface

+config VIDEO_TIMBERDALE
+	tristate "Support for timberdale Video In/LogiWIN"
+	depends on VIDEO_V4L2 && MFD_TIMBERDALE_DMA
+	select VIDEO_ADV7180
+	---help---
+	Add support for the Video In peripherial of the timberdale FPGA.
+
 #
 # USB Multimedia device configuration
 #
Index: linux-2.6.30-rc7/drivers/media/video/Makefile
===================================================================
--- linux-2.6.30-rc7/drivers/media/video/Makefile	(revision 861)
+++ linux-2.6.30-rc7/drivers/media/video/Makefile	(working copy)
@@ -150,6 +150,8 @@

 obj-$(CONFIG_VIDEO_AU0828) += au0828/

+obj-$(CONFIG_VIDEO_TIMBERDALE)	+= timblogiw.o
+
 obj-$(CONFIG_USB_VIDEO_CLASS)	+= uvc/

 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
