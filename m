Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:62941 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752250AbdCDUB7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 4 Mar 2017 15:01:59 -0500
Received: from linux.local ([94.216.42.153]) by mail.gmx.com (mrgmx103
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0MU0U9-1cssj54B9d-00QmWF for
 <linux-media@vger.kernel.org>; Sat, 04 Mar 2017 21:01:55 +0100
From: Peter Seiderer <ps.report@gmx.net>
To: linux-media@vger.kernel.org
Subject: [PATCH v1] qv4l2: fix qv4l2.pro qmake project file
Date: Sat,  4 Mar 2017 21:01:53 +0100
Message-Id: <20170304200153.10905-1-ps.report@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The header files v4l2-tpg.h and v4l2-tpg-colors.h moved
from v4l2-ctl to common.

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
---
 utils/qv4l2/qv4l2.pro | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/utils/qv4l2/qv4l2.pro b/utils/qv4l2/qv4l2.pro
index 02b03dea..6420fa24 100644
--- a/utils/qv4l2/qv4l2.pro
+++ b/utils/qv4l2/qv4l2.pro
@@ -13,6 +13,7 @@ greaterThan(QT_MAJOR_VERSION, 4): QT += widgets
 QT += opengl
 
 INCLUDEPATH += $$PWD/../..
+INCLUDEPATH += $$PWD/../common
 INCLUDEPATH += $$PWD/../v4l2-ctl/
 INCLUDEPATH += $$PWD/../v4l2-compliance
 
@@ -25,8 +26,8 @@ HEADERS += general-tab.h
 HEADERS += qv4l2.h
 HEADERS += raw2sliced.h
 HEADERS += vbi-tab.h
-HEADERS += ../v4l2-ctl/v4l2-tpg.h
-HEADERS += ../v4l2-ctl/v4l2-tpg-colors.h
+HEADERS += ../common/v4l2-tpg.h
+HEADERS += ../common/v4l2-tpg-colors.h
 HEADERS += ../../config.h
 
 SOURCES += capture-win.cpp
-- 
2.11.0
