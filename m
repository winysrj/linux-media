Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:8838 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab3HINGe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 09:06:34 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-90.cisco.com [10.54.92.90])
	by ams-core-1.cisco.com (8.14.5/8.14.5) with ESMTP id r79D6TlQ013742
	for <linux-media@vger.kernel.org>; Fri, 9 Aug 2013 13:06:31 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] qv4l2: fix GeneralTab layout
Date: Fri,  9 Aug 2013 15:03:22 +0200
Message-Id: <709a686d9e35ac65862e13f40f3298a40ccfd72b.1376053312.git.bwinther@cisco.com>
In-Reply-To: <1376053402-28300-1-git-send-email-bwinther@cisco.com>
References: <1376053402-28300-1-git-send-email-bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This moves the layout items for cropping, scaling and ALSA
to not interfere with driver specific controls.

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qv4l2/general-tab.cpp | 129 ++++++++++++++++++++++----------------------
 1 file changed, 64 insertions(+), 65 deletions(-)

diff --git a/utils/qv4l2/general-tab.cpp b/utils/qv4l2/general-tab.cpp
index cfc6bcf..cd00ecd 100644
--- a/utils/qv4l2/general-tab.cpp
+++ b/utils/qv4l2/general-tab.cpp
@@ -98,6 +98,70 @@ GeneralTab::GeneralTab(const QString &device, v4l2 &fd, int n, QWidget *parent)
 	if (m_querycap.capabilities & V4L2_CAP_DEVICE_CAPS)
 		m_isVbi = caps() & (V4L2_CAP_VBI_CAPTURE | V4L2_CAP_SLICED_VBI_CAPTURE);
 
+	if (hasAlsaAudio()) {
+		m_audioInDevice = new QComboBox(parent);
+		m_audioOutDevice = new QComboBox(parent);
+		m_audioInDevice->setSizeAdjustPolicy(QComboBox::AdjustToContents);
+		m_audioOutDevice->setSizeAdjustPolicy(QComboBox::AdjustToContents);
+
+		if (createAudioDeviceList()) {
+			addLabel("Audio Input Device");
+			connect(m_audioInDevice, SIGNAL(activated(int)), SLOT(changeAudioDevice()));
+			addWidget(m_audioInDevice);
+
+			addLabel("Audio Output Device");
+			connect(m_audioOutDevice, SIGNAL(activated(int)), SLOT(changeAudioDevice()));
+			addWidget(m_audioOutDevice);
+
+			if (isRadio()) {
+				setAudioDeviceBufferSize(75);
+			} else {
+				v4l2_fract fract;
+				if (!v4l2::get_interval(fract)) {
+					// Default values are for 30 FPS
+					fract.numerator = 33;
+					fract.denominator = 1000;
+				}
+				// Standard capacity is two frames
+				setAudioDeviceBufferSize((fract.numerator * 2000) / fract.denominator);
+			}
+		} else {
+			delete m_audioInDevice;
+			delete m_audioOutDevice;
+			m_audioInDevice = NULL;
+			m_audioOutDevice = NULL;
+		}
+	}
+
+	if (!isRadio() && !isVbi()) {
+		m_pixelAspectRatio = new QComboBox(parent);
+		m_pixelAspectRatio->addItem("Autodetect");
+		m_pixelAspectRatio->addItem("Square");
+		m_pixelAspectRatio->addItem("NTSC/PAL-M/PAL-60");
+		m_pixelAspectRatio->addItem("NTSC/PAL-M/PAL-60, Anamorphic");
+		m_pixelAspectRatio->addItem("PAL/SECAM");
+		m_pixelAspectRatio->addItem("PAL/SECAM, Anamorphic");
+
+		// Update hints by calling a get
+		getPixelAspectRatio();
+
+		addLabel("Pixel Aspect Ratio");
+		addWidget(m_pixelAspectRatio);
+		connect(m_pixelAspectRatio, SIGNAL(activated(int)), SLOT(changePixelAspectRatio()));
+
+		m_crop = new QComboBox(parent);
+		m_crop->addItem("None");
+		m_crop->addItem("Top and Bottom Line");
+		m_crop->addItem("Widescreen 14:9");
+		m_crop->addItem("Widescreen 16:9");
+		m_crop->addItem("Cinema 1.85:1");
+		m_crop->addItem("Cinema 2.39:1");
+
+		addLabel("Cropping");
+		addWidget(m_crop);
+		connect(m_crop, SIGNAL(activated(int)), SIGNAL(cropChanged()));
+	}
+
 	if (!isRadio() && enum_input(vin, true)) {
 		addLabel("Input");
 		m_videoInput = new QComboBox(parent);
@@ -148,42 +212,6 @@ GeneralTab::GeneralTab(const QString &device, v4l2 &fd, int n, QWidget *parent)
 		updateAudioOutput();
 	}
 
-	if (hasAlsaAudio()) {
-		m_audioInDevice = new QComboBox(parent);
-		m_audioOutDevice = new QComboBox(parent);
-		m_audioInDevice->setSizeAdjustPolicy(QComboBox::AdjustToContents);
-		m_audioOutDevice->setSizeAdjustPolicy(QComboBox::AdjustToContents);
-
-		if (createAudioDeviceList()) {
-			addLabel("Audio Input Device");
-			connect(m_audioInDevice, SIGNAL(activated(int)), SLOT(changeAudioDevice()));
-			addWidget(m_audioInDevice);
-
-			addLabel("Audio Output Device");
-			connect(m_audioOutDevice, SIGNAL(activated(int)), SLOT(changeAudioDevice()));
-			addWidget(m_audioOutDevice);
-
-			if (isRadio()) {
-				setAudioDeviceBufferSize(75);
-			} else {
-				v4l2_fract fract;
-				if (!v4l2::get_interval(fract)) {
-					// Default values are for 30 FPS
-					fract.numerator = 33;
-					fract.denominator = 1000;
-				}
-				// Standard capacity is two frames
-				setAudioDeviceBufferSize((fract.numerator * 2000) / fract.denominator);
-			}
-		} else {
-			fprintf(stderr, "BANNA\n");
-			delete m_audioInDevice;
-			delete m_audioOutDevice;
-			m_audioInDevice = NULL;
-			m_audioOutDevice = NULL;
-		}
-	}
-
 	if (needsStd) {
 		v4l2_std_id tmp;
 
@@ -212,35 +240,6 @@ GeneralTab::GeneralTab(const QString &device, v4l2 &fd, int n, QWidget *parent)
 		connect(m_qryTimings, SIGNAL(clicked()), SLOT(qryTimingsClicked()));
 	}
 
-	if (!isRadio() && !isVbi()) {
-		m_pixelAspectRatio = new QComboBox(parent);
-		m_pixelAspectRatio->addItem("Autodetect");
-		m_pixelAspectRatio->addItem("Square");
-		m_pixelAspectRatio->addItem("NTSC/PAL-M/PAL-60");
-		m_pixelAspectRatio->addItem("NTSC/PAL-M/PAL-60, Anamorphic");
-		m_pixelAspectRatio->addItem("PAL/SECAM");
-		m_pixelAspectRatio->addItem("PAL/SECAM, Anamorphic");
-
-		// Update hints by calling a get
-		getPixelAspectRatio();
-
-		addLabel("Pixel Aspect Ratio");
-		addWidget(m_pixelAspectRatio);
-		connect(m_pixelAspectRatio, SIGNAL(activated(int)), SLOT(changePixelAspectRatio()));
-
-		m_crop = new QComboBox(parent);
-		m_crop->addItem("None");
-		m_crop->addItem("Top and Bottom Line");
-		m_crop->addItem("Widescreen 14:9");
-		m_crop->addItem("Widescreen 16:9");
-		m_crop->addItem("Cinema 1.85:1");
-		m_crop->addItem("Cinema 2.39:1");
-
-		addLabel("Cropping");
-		addWidget(m_crop);
-		connect(m_crop, SIGNAL(activated(int)), SIGNAL(cropChanged()));
-	}
-
 	if (m_tuner.capability) {
 		QDoubleValidator *val;
 		double factor = (m_tuner.capability & V4L2_TUNER_CAP_LOW) ? 16 : 16000;
-- 
1.8.4.rc1

