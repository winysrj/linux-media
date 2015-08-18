Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:29845 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbbHRIjP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2015 04:39:15 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	linux-input@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	lars@opdenkamp.eu, kamil@wypas.org, linux@arm.linux.org.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 1/4] Makefile.am: copy cec headers with make sync-with-kernel
Date: Tue, 18 Aug 2015 10:36:35 +0200
Message-Id: <c769e29166554f38f99e543648e261c27ddb20af.1439886496.git.hans.verkuil@cisco.com>
In-Reply-To: <cover.1439886496.git.hans.verkuil@cisco.com>
References: <cover.1439886496.git.hans.verkuil@cisco.com>
In-Reply-To: <cover.1439886496.git.hans.verkuil@cisco.com>
References: <cover.1439886496.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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

