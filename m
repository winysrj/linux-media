Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:34962 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752796AbcHTQwj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 20 Aug 2016 12:52:39 -0400
Received: by mail-qk0-f178.google.com with SMTP id v123so63287366qkh.2
        for <linux-media@vger.kernel.org>; Sat, 20 Aug 2016 09:52:39 -0700 (PDT)
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH] RFC: Show frame size widgets (width, height, size and rate)
Date: Sat, 20 Aug 2016 13:52:21 -0300
Message-Id: <20160820165221.2946-1-ezequiel@vanguardiasur.com.ar>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While using the qv4l2 tool as a quick test for frame rate
setting on tw686x, I found that it has two possible interfaces
for frame size. One interface shows frame width and height,
while the other shows frame size and frame rate.

This patch is probably wrong, but hopefully it makes the
report clear: some devices haven't a frame size discrete
enumeration, but have discrete frame rate. Having a way
to set the frame rate from the qv4l2 tool would be very useful.

Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
---
 utils/qv4l2/general-tab.cpp | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/utils/qv4l2/general-tab.cpp b/utils/qv4l2/general-tab.cpp
index c74847935194..0b5126f6c806 100644
--- a/utils/qv4l2/general-tab.cpp
+++ b/utils/qv4l2/general-tab.cpp
@@ -467,11 +467,8 @@ void GeneralTab::inputSection(v4l2_input vin)
 		return;
 
 	QWidget *wFrameWH = new QWidget();
-	QWidget *wFrameSR = new QWidget();
 	QGridLayout *m_wh = new QGridLayout(wFrameWH);
-	QGridLayout *m_sr = new QGridLayout(wFrameSR);
 	m_grids.append(m_wh);
-	m_grids.append(m_sr);
 
 	m_wh->addWidget(new QLabel("Frame Width", parentWidget()), 0, 0, Qt::AlignLeft);
 	m_frameWidth = new QSpinBox(parentWidget());
@@ -483,18 +480,17 @@ void GeneralTab::inputSection(v4l2_input vin)
 	m_wh->addWidget(m_frameHeight, 0, 3, Qt::AlignLeft);
 	connect(m_frameHeight, SIGNAL(editingFinished()), SLOT(frameHeightChanged()));
 
-	m_sr->addWidget(new QLabel("Frame Size", parentWidget()), 0, 0, Qt::AlignLeft);
+	m_wh->addWidget(new QLabel("Frame Size", parentWidget()), 1, 0, Qt::AlignLeft);
 	m_frameSize = new QComboBox(parentWidget());
-	m_sr->addWidget(m_frameSize, 0, 1, Qt::AlignLeft);
+	m_wh->addWidget(m_frameSize, 1, 1, Qt::AlignLeft);
 	connect(m_frameSize, SIGNAL(activated(int)), SLOT(frameSizeChanged(int)));
 
-	m_sr->addWidget(new QLabel("Frame Rate", parentWidget()), 0, 2, Qt::AlignLeft);
+	m_wh->addWidget(new QLabel("Frame Rate", parentWidget()), 1, 2, Qt::AlignLeft);
 	m_frameInterval = new QComboBox(parentWidget());
-	m_sr->addWidget(m_frameInterval, 0, 3, Qt::AlignLeft);
+	m_wh->addWidget(m_frameInterval, 1, 3, Qt::AlignLeft);
 	connect(m_frameInterval, SIGNAL(activated(int)), SLOT(frameIntervalChanged(int)));
 
 	m_stackedFrameSettings->addWidget(wFrameWH);
-	m_stackedFrameSettings->addWidget(wFrameSR);
 
 	QGridLayout::addWidget(m_stackedFrameSettings, m_row, 0, 1, m_cols, Qt::AlignVCenter);
 	m_row++;
@@ -1188,7 +1184,7 @@ void GeneralTab::updateGUIInput(__u32 input)
 		m_stackedStandards->show();
 		m_stackedFrequency->hide();
 	} else	{
-		m_stackedFrameSettings->setCurrentIndex(1);
+		m_stackedFrameSettings->setCurrentIndex(0);
 		m_stackedFrameSettings->show();
 		m_stackedStandards->hide();
 		m_stackedFrequency->hide();
-- 
2.9.0

