Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:43934 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751898AbbH1Lti (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2015 07:49:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, ricardo.ribalda@gmail.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 6/8] saa7164: remove unused videobuf references
Date: Fri, 28 Aug 2015 13:48:31 +0200
Message-Id: <1440762513-30457-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1440762513-30457-1-git-send-email-hverkuil@xs4all.nl>
References: <1440762513-30457-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This driver includes videobuf headers and selects VIDEOBUF_DVB, but
videobuf isn't used at all.

Remove this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7164/Kconfig   | 1 -
 drivers/media/pci/saa7164/saa7164.h | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/media/pci/saa7164/Kconfig b/drivers/media/pci/saa7164/Kconfig
index a53db7d..9098ef5 100644
--- a/drivers/media/pci/saa7164/Kconfig
+++ b/drivers/media/pci/saa7164/Kconfig
@@ -5,7 +5,6 @@ config VIDEO_SAA7164
 	select FW_LOADER
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
-	select VIDEOBUF_DVB
 	select DVB_TDA10048 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_S5H1411 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
diff --git a/drivers/media/pci/saa7164/saa7164.h b/drivers/media/pci/saa7164/saa7164.h
index f8e54d5..a2e9fa7 100644
--- a/drivers/media/pci/saa7164/saa7164.h
+++ b/drivers/media/pci/saa7164/saa7164.h
@@ -54,8 +54,6 @@
 
 #include <media/tuner.h>
 #include <media/tveeprom.h>
-#include <media/videobuf-dma-sg.h>
-#include <media/videobuf-dvb.h>
 #include <dvb_demux.h>
 #include <dvb_frontend.h>
 #include <dvb_net.h>
-- 
2.1.4

