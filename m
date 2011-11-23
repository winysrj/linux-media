Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3584 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab1KWLMs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Nov 2011 06:12:48 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 3/4] cx18/ddbridge: remove unused headers.
Date: Wed, 23 Nov 2011 12:12:35 +0100
Message-Id: <572687cf2a512deeec920e25a0f125baebdfec93.1322045294.git.hans.verkuil@cisco.com>
In-Reply-To: <1322046756-22870-1-git-send-email-hverkuil@xs4all.nl>
References: <1322046756-22870-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <5f3ea26a94437e97b4b7ddfb3f7dc8dd4c2a8f12.1322045294.git.hans.verkuil@cisco.com>
References: <5f3ea26a94437e97b4b7ddfb3f7dc8dd4c2a8f12.1322045294.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Work is in progress to deprecate include/linux/dvb/audio.h and video.h.
The cx18 and ddbridge drivers include these headers without using them.

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

