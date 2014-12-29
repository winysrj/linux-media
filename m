Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:14761 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752339AbaL2ObI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Dec 2014 09:31:08 -0500
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Fabian Frederick <fabf@skynet.be>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH 07/11 linux-next] [media] s5p-mfc: remove unnecessary version.h inclusion
Date: Mon, 29 Dec 2014 15:29:41 +0100
Message-Id: <1419863387-24233-8-git-send-email-fabf@skynet.be>
In-Reply-To: <1419863387-24233-1-git-send-email-fabf@skynet.be>
References: <1419863387-24233-1-git-send-email-fabf@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Based on versioncheck.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 1 -
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index c6c3452..a9ef843 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -18,7 +18,6 @@
 #include <linux/platform_device.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/version.h>
 #include <linux/videodev2.h>
 #include <linux/workqueue.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index bd64f1d..68df3cd 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -19,7 +19,6 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/sched.h>
-#include <linux/version.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-event.h>
 #include <linux/workqueue.h>
-- 
2.1.0

