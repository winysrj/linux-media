Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:56045 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757841Ab3HHNru (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 09:47:50 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-90.cisco.com [10.54.92.90])
	by ams-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id r78Dlk9m032678
	for <linux-media@vger.kernel.org>; Thu, 8 Aug 2013 13:47:48 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] qv4l2: fix missing status tips
Date: Thu,  8 Aug 2013 15:47:37 +0200
Message-Id: <c45fad89698912cf93481ab0801a3445ee0ef18e.1375969534.git.bwinther@cisco.com>
In-Reply-To: <1375969658-20415-1-git-send-email-bwinther@cisco.com>
References: <1375969658-20415-1-git-send-email-bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qv4l2/general-tab.cpp | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/utils/qv4l2/general-tab.cpp b/utils/qv4l2/general-tab.cpp
index c404a3b..2605397 100644
--- a/utils/qv4l2/general-tab.cpp
+++ b/utils/qv4l2/general-tab.cpp
@@ -236,7 +236,9 @@ GeneralTab::GeneralTab(const QString &device, v4l2 &fd, int n, QWidget *parent)
 		m_freq = new QLineEdit(parent);
 		m_freq->setValidator(val);
 		m_freq->setWhatsThis(QString("Frequency\nLow: %1\nHigh: %2")
-				.arg(m_tuner.rangelow / factor).arg(m_tuner.rangehigh / factor));
+				     .arg(m_tuner.rangelow / factor)
+				     .arg((double)m_tuner.rangehigh / factor, 0, 'f', 2));
+		m_freq->setStatusTip(m_freq->whatsThis());
 		connect(m_freq, SIGNAL(lostFocus()), SLOT(freqChanged()));
 		connect(m_freq, SIGNAL(returnPressed()), SLOT(freqChanged()));
 		updateFreq();
@@ -306,7 +308,9 @@ GeneralTab::GeneralTab(const QString &device, v4l2 &fd, int n, QWidget *parent)
 		m_freq = new QLineEdit(parent);
 		m_freq->setValidator(val);
 		m_freq->setWhatsThis(QString("Frequency\nLow: %1\nHigh: %2")
-				.arg(m_modulator.rangelow / factor).arg(m_modulator.rangehigh / factor));
+				     .arg(m_tuner.rangelow / factor)
+				     .arg((double)m_tuner.rangehigh / factor, 0, 'f', 2));
+		m_freq->setStatusTip(m_freq->whatsThis());
 		connect(m_freq, SIGNAL(lostFocus()), SLOT(freqChanged()));
 		connect(m_freq, SIGNAL(returnPressed()), SLOT(freqChanged()));
 		updateFreq();
@@ -899,6 +903,7 @@ void GeneralTab::updateAudioInput()
 		what += ", has AVL";
 	if (audio.mode & V4L2_AUDMODE_AVL)
 		what += ", AVL is on";
+	m_audioInput->setStatusTip(what);
 	m_audioInput->setWhatsThis(what);
 }
 
@@ -951,6 +956,7 @@ void GeneralTab::updateStandard()
 		(double)vs.frameperiod.numerator / vs.frameperiod.denominator,
 		vs.frameperiod.numerator, vs.frameperiod.denominator,
 		vs.framelines);
+	m_tvStandard->setStatusTip(what);
 	m_tvStandard->setWhatsThis(what);
 	updateVidCapFormat();
 }
@@ -1014,6 +1020,7 @@ void GeneralTab::updateTimings()
 	what.sprintf("Video Timings (%u)\n"
 		"Frame %ux%u\n",
 		p.index, p.timings.bt.width, p.timings.bt.height);
+	m_videoTimings->setStatusTip(what);
 	m_videoTimings->setWhatsThis(what);
 	updateVidCapFormat();
 }
-- 
1.8.4.rc1

