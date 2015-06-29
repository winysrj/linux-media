Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:34231 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753347AbbF2KoC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2015 06:44:02 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	linux-input@vger.kernel.org, lars@opdenkamp.eu,
	linux-samsung-soc@vger.kernel.org, kamil@wypas.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/4] Makefile.am: copy cec headers with make sync-with-kernel
Date: Mon, 29 Jun 2015 12:43:13 +0200
Message-Id: <1435574596-38029-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1435574596-38029-1-git-send-email-hverkuil@xs4all.nl>
References: <1435574596-38029-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Copy the new cec headers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Makefile.am | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Makefile.am b/Makefile.am
index 1a61592..b8c450d 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -21,6 +21,8 @@ sync-with-kernel:
 	      ! -f $(KERNEL_DIR)/usr/include/linux/v4l2-common.h -o \
 	      ! -f $(KERNEL_DIR)/usr/include/linux/v4l2-subdev.h -o \
 	      ! -f $(KERNEL_DIR)/usr/include/linux/v4l2-mediabus.h -o \
+	      ! -f $(KERNEL_DIR)/usr/include/linux/cec.h -o \
+	      ! -f $(KERNEL_DIR)/usr/include/linux/cec-funcs.h -o \
 	      ! -f $(KERNEL_DIR)/usr/include/linux/ivtv.h -o \
 	      ! -f $(KERNEL_DIR)/usr/include/linux/dvb/frontend.h -o \
 	      ! -f $(KERNEL_DIR)/usr/include/linux/dvb/dmx.h -o \
@@ -38,6 +40,8 @@ sync-with-kernel:
 	cp -a $(KERNEL_DIR)/usr/include/linux/v4l2-mediabus.h $(top_srcdir)/include/linux
 	cp -a $(KERNEL_DIR)/usr/include/linux/media-bus-format.h $(top_srcdir)/include/linux
 	cp -a $(KERNEL_DIR)/usr/include/linux/media.h $(top_srcdir)/include/linux
+	cp -a $(KERNEL_DIR)/usr/include/linux/cec.h $(top_srcdir)/include/linux
+	cp -a $(KERNEL_DIR)/usr/include/linux/cec-funcs.h $(top_srcdir)/include/linux
 	cp -a $(KERNEL_DIR)/usr/include/linux/ivtv.h $(top_srcdir)/include/linux
 	cp -a $(KERNEL_DIR)/usr/include/linux/dvb/frontend.h $(top_srcdir)/include/linux/dvb
 	cp -a $(KERNEL_DIR)/usr/include/linux/dvb/dmx.h $(top_srcdir)/include/linux/dvb
-- 
2.1.4

