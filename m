Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1177 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758718Ab1LOOP5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 09:15:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 7/8] cx18/ddbridge: remove unused headers.
Date: Thu, 15 Dec 2011 15:15:36 +0100
Message-Id: <201b9cb2e9773439a807bcfe40ff17b19c5bbb0f.1323957539.git.hans.verkuil@cisco.com>
In-Reply-To: <1323958537-7026-1-git-send-email-hverkuil@xs4all.nl>
References: <1323958537-7026-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <26fac753ffa549b2ffdc5fe64a50e0a9637c2b16.1323957539.git.hans.verkuil@cisco.com>
References: <26fac753ffa549b2ffdc5fe64a50e0a9637c2b16.1323957539.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The cx18 and ddbridge drivers include linux/dvb/audio.h and video.h
without using them.

Remove those includes.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/dvb/ddbridge/ddbridge.h  |    2 --
 drivers/media/video/cx18/cx18-driver.h |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/ddbridge/ddbridge.h b/drivers/media/dvb/ddbridge/ddbridge.h
index 6d14893..8b1b41d 100644
--- a/drivers/media/dvb/ddbridge/ddbridge.h
+++ b/drivers/media/dvb/ddbridge/ddbridge.h
@@ -32,8 +32,6 @@
 #include <asm/dma.h>
 #include <linux/dvb/frontend.h>
 #include <linux/dvb/ca.h>
-#include <linux/dvb/video.h>
-#include <linux/dvb/audio.h>
 #include <linux/socket.h>
 
 #include "dmxdev.h"
diff --git a/drivers/media/video/cx18/cx18-driver.h b/drivers/media/video/cx18/cx18-driver.h
index b9a94fc..7a37e0e 100644
--- a/drivers/media/video/cx18/cx18-driver.h
+++ b/drivers/media/video/cx18/cx18-driver.h
@@ -44,8 +44,6 @@
 #include <linux/slab.h>
 #include <asm/byteorder.h>
 
-#include <linux/dvb/video.h>
-#include <linux/dvb/audio.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
-- 
1.7.7.3

