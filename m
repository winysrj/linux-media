Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:33996 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966631Ab3HIMMf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 08:12:35 -0400
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Cc: baard.e.winther@wintherstormer.no
Subject: [PATCH FINAL 3/6] qv4l2: fix missing status tips
Date: Fri,  9 Aug 2013 14:12:09 +0200
Message-Id: <9c2f42eb70481244a46f779b65871743be4cd791.1376049957.git.bwinther@cisco.com>
In-Reply-To: <1376050332-27290-1-git-send-email-bwinther@cisco.com>
References: <1376050332-27290-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <42a47889f837e362abc7a527c1029329e62034b0.1376049957.git.bwinther@cisco.com>
References: <42a47889f837e362abc7a527c1029329e62034b0.1376049957.git.bwinther@cisco.com>
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
index 3855296..cfc6bcf 100644
--- a/utils/qv4l2/general-tab.cpp
+++ b/utils/qv4l2/general-tab.cpp
@@ -249,7 +249,9 @@ GeneralTab::GeneralTab(const QString &device, v4l2 &fd, int n, QWidget *parent)
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
@@ -319,7 +321,9 @@ GeneralTab::GeneralTab(const QString &device, v4l2 &fd, int n, QWidget *parent)
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
@@ -912,6 +916,7 @@ void GeneralTab::updateAudioInput()
 		what += ", has AVL";
 	if (audio.mode & V4L2_AUDMODE_AVL)
 		what += ", AVL is on";
+	m_audioInput->setStatusTip(what);
 	m_audioInput->setWhatsThis(what);
 }
 
@@ -964,6 +969,7 @@ void GeneralTab::updateStandard()
 		(double)vs.frameperiod.numerator / vs.frameperiod.denominator,
 		vs.frameperiod.numerator, vs.frameperiod.denominator,
 		vs.framelines);
+	m_tvStandard->setStatusTip(what);
 	m_tvStandard->setWhatsThis(what);
 	updateVidCapFormat();
 }
@@ -1027,6 +1033,7 @@ void GeneralTab::updateTimings()
 	what.sprintf("Video Timings (%u)\n"
 		"Frame %ux%u\n",
 		p.index, p.timings.bt.width, p.timings.bt.height);
+	m_videoTimings->setStatusTip(what);
 	m_videoTimings->setWhatsThis(what);
 	updateVidCapFormat();
 }
-- 
1.8.4.rc1

