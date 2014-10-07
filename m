Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.sysproserver.de ([78.138.95.108]:47029 "EHLO
	mailout1.sysproserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbaJGOHx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Oct 2014 10:07:53 -0400
Received: from srv5.sysproserver.de (srv5.sysproserver.de [78.138.89.176])
	by mailout1.sysproserver.de (Postfix) with ESMTPSA id 7FA5F9615D
	for <linux-media@vger.kernel.org>; Tue,  7 Oct 2014 15:58:20 +0200 (CEST)
From: Niels Ole Salscheider <niels_ole@salscheider-online.de>
To: linux-media@vger.kernel.org
Cc: Niels Ole Salscheider <niels_ole@salscheider-online.de>
Subject: [PATCH] qv4l2: Fix out-of-source build
Date: Tue,  7 Oct 2014 15:58:13 +0200
Message-Id: <1412690293-30841-1-git-send-email-niels_ole@salscheider-online.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Niels Ole Salscheider <niels_ole@salscheider-online.de>
---
 utils/qv4l2/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/qv4l2/Makefile.am b/utils/qv4l2/Makefile.am
index 26f8dca..2b3251c 100644
--- a/utils/qv4l2/Makefile.am
+++ b/utils/qv4l2/Makefile.am
@@ -8,7 +8,7 @@ qv4l2_SOURCES = qv4l2.cpp general-tab.cpp ctrl-tab.cpp vbi-tab.cpp capture-win.c
 nodist_qv4l2_SOURCES = moc_qv4l2.cpp moc_general-tab.cpp moc_capture-win.cpp moc_vbi-tab.cpp qrc_qv4l2.cpp
 qv4l2_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la ../libv4l2util/libv4l2util.la \
   ../libmedia_dev/libmedia_dev.la
-qv4l2_CPPFLAGS = -I../v4l2-compliance -I../v4l2-ctl
+qv4l2_CPPFLAGS = -I$(srcdir)/../v4l2-compliance -I$(srcdir)/../v4l2-ctl
 
 if WITH_QTGL
 qv4l2_CPPFLAGS += $(QTGL_CFLAGS)
-- 
2.1.2

