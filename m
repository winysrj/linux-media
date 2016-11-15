Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:32832 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753507AbcKOMGF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 07:06:05 -0500
Received: by mail-wm0-f65.google.com with SMTP id u144so25074049wmu.0
        for <linux-media@vger.kernel.org>; Tue, 15 Nov 2016 04:06:05 -0800 (PST)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 3/3] qv4l2: Support for HSV encodings
Date: Tue, 15 Nov 2016 13:05:58 +0100
Message-Id: <20161115120558.2872-3-ricardo.ribalda@gmail.com>
In-Reply-To: <20161115120558.2872-1-ricardo.ribalda@gmail.com>
References: <20161115120558.2872-1-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support set/get and override of HSV encodings.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 utils/qv4l2/general-tab.cpp | 4 +++-
 utils/qv4l2/qv4l2.cpp       | 5 ++++-
 utils/qv4l2/tpg-tab.cpp     | 4 +++-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/utils/qv4l2/general-tab.cpp b/utils/qv4l2/general-tab.cpp
index c74847935194..0d98d6569c49 100644
--- a/utils/qv4l2/general-tab.cpp
+++ b/utils/qv4l2/general-tab.cpp
@@ -780,8 +780,10 @@ void GeneralTab::formatSection(v4l2_fmtdesc fmt)
 		m_ycbcrEnc->addItem("BT.2020", QVariant(V4L2_YCBCR_ENC_BT2020));
 		m_ycbcrEnc->addItem("BT.2020 Constant Luminance", QVariant(V4L2_YCBCR_ENC_BT2020_CONST_LUM));
 		m_ycbcrEnc->addItem("SMPTE 240M", QVariant(V4L2_YCBCR_ENC_SMPTE240M));
+		m_ycbcrEnc->addItem("Hue 0 - 179", QVariant(V4L2_HSV_ENC_180));
+		m_ycbcrEnc->addItem("Hue 0 - 255", QVariant(V4L2_HSV_ENC_256));
 
-		addLabel("Y'CbCr Encoding");
+		addLabel("Y'CbCr / HSV Encoding");
 		addWidget(m_ycbcrEnc);
 		connect(m_ycbcrEnc, SIGNAL(activated(int)), SLOT(ycbcrEncChanged(int)));
 
diff --git a/utils/qv4l2/qv4l2.cpp b/utils/qv4l2/qv4l2.cpp
index 4f0a52d96d39..a093fbf48913 100644
--- a/utils/qv4l2/qv4l2.cpp
+++ b/utils/qv4l2/qv4l2.cpp
@@ -213,7 +213,7 @@ ApplicationWindow::ApplicationWindow() :
 	connect(grp, SIGNAL(triggered(QAction *)), this, SLOT(overrideXferFuncChanged(QAction *)));
 
 	m_overrideYCbCrEnc = -1;
-	menu = new QMenu("Override Y'CbCr Encoding");
+	menu = new QMenu("Override Y'CbCr / HSV Encoding");
 	m_overrideYCbCrEncMenu = menu;
 	grp = new QActionGroup(menu);
 	addSubMenuItem(grp, menu, "No Override", -1)->setChecked(true);
@@ -224,6 +224,9 @@ ApplicationWindow::ApplicationWindow() :
 	addSubMenuItem(grp, menu, "BT.2020", V4L2_YCBCR_ENC_BT2020);
 	addSubMenuItem(grp, menu, "BT.2020 Constant Luminance", V4L2_YCBCR_ENC_BT2020_CONST_LUM);
 	addSubMenuItem(grp, menu, "SMPTE 240M", V4L2_YCBCR_ENC_SMPTE240M);
+	addSubMenuItem(grp, menu, "Hue 0 - 179", V4L2_HSV_ENC_180);
+	addSubMenuItem(grp, menu, "Hue 0 - 255", V4L2_HSV_ENC_256);
+
 	connect(grp, SIGNAL(triggered(QAction *)), this, SLOT(overrideYCbCrEncChanged(QAction *)));
 
 	m_overrideQuantization = -1;
diff --git a/utils/qv4l2/tpg-tab.cpp b/utils/qv4l2/tpg-tab.cpp
index 386509de986b..e234b7dbfa1c 100644
--- a/utils/qv4l2/tpg-tab.cpp
+++ b/utils/qv4l2/tpg-tab.cpp
@@ -177,7 +177,7 @@ void ApplicationWindow::addTpgTab(int m_winWidth)
 	addWidget(grid, m_tpgXferFunc);
 	connect(m_tpgXferFunc, SIGNAL(activated(int)), SLOT(tpgXferFuncChanged()));
 
-	addLabel(grid, "Y'CbCr Encoding");
+	addLabel(grid, "Y'CbCr / HSV Encoding");
 	m_tpgYCbCrEnc = new QComboBox(w);
 	m_tpgYCbCrEnc->addItem("Use Format", QVariant(V4L2_YCBCR_ENC_DEFAULT));
 	m_tpgYCbCrEnc->addItem("ITU-R 601", QVariant(V4L2_YCBCR_ENC_601));
@@ -187,6 +187,8 @@ void ApplicationWindow::addTpgTab(int m_winWidth)
 	m_tpgYCbCrEnc->addItem("BT.2020", QVariant(V4L2_YCBCR_ENC_BT2020));
 	m_tpgYCbCrEnc->addItem("BT.2020 Constant Luminance", QVariant(V4L2_YCBCR_ENC_BT2020_CONST_LUM));
 	m_tpgYCbCrEnc->addItem("SMPTE 240M", QVariant(V4L2_YCBCR_ENC_SMPTE240M));
+	m_tpgYCbCrEnc->addItem("Hue 0 - 179", QVariant(V4L2_HSV_ENC_180));
+	m_tpgYCbCrEnc->addItem("Hue 0 - 255", QVariant(V4L2_HSV_ENC_256));
 	addWidget(grid, m_tpgYCbCrEnc);
 	connect(m_tpgYCbCrEnc, SIGNAL(activated(int)), SLOT(tpgColorspaceChanged()));
 
-- 
2.10.2

