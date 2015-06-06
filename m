Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42695 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbbFFMDV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2015 08:03:21 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/9] DocBook: document tuner RF gain control
Date: Sat,  6 Jun 2015 15:03:02 +0300
Message-Id: <1433592188-31748-3-git-send-email-crope@iki.fi>
In-Reply-To: <1433592188-31748-1-git-send-email-crope@iki.fi>
References: <1433592188-31748-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add brief description for tuner RF gain control.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 Documentation/DocBook/media/v4l/compat.xml   |  4 ++++
 Documentation/DocBook/media/v4l/controls.xml | 19 +++++++++++++++++++
 Documentation/DocBook/media/v4l/v4l2.xml     |  1 +
 3 files changed, 24 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index f56faf5..e8f28bf 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2600,6 +2600,10 @@ and &v4l2-mbus-framefmt;.
 <constant>V4L2_TUNER_ADC</constant> is deprecated now.
 	  </para>
 	</listitem>
+	<listitem>
+	  <para>Added <constant>V4L2_CID_RF_TUNER_RF_GAIN_AUTO</constant> and
+<constant>V4L2_CID_RF_TUNER_RF_GAIN</constant> RF Tuner controls.</para>
+	</listitem>
       </orderedlist>
     </section>
 
diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 6e1667b..44f7a3a 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -5397,6 +5397,13 @@ fulfill desired bandwidth requirement. Used when V4L2_CID_RF_TUNER_BANDWIDTH_AUT
 set. Unit is in Hz. The range and step are driver-specific.</entry>
             </row>
             <row>
+              <entry spanname="id"><constant>V4L2_CID_RF_TUNER_RF_GAIN_AUTO</constant>&nbsp;</entry>
+              <entry>boolean</entry>
+            </row>
+            <row>
+              <entry spanname="descr">Enables/disables RF amplifier automatic gain control (AGC)</entry>
+            </row>
+            <row>
               <entry spanname="id"><constant>V4L2_CID_RF_TUNER_LNA_GAIN_AUTO</constant>&nbsp;</entry>
               <entry>boolean</entry>
             </row>
@@ -5418,6 +5425,18 @@ set. Unit is in Hz. The range and step are driver-specific.</entry>
               <entry spanname="descr">Enables/disables IF automatic gain control (AGC)</entry>
             </row>
             <row>
+              <entry spanname="id"><constant>V4L2_CID_RF_TUNER_RF_GAIN</constant>&nbsp;</entry>
+              <entry>integer</entry>
+            </row>
+            <row>
+              <entry spanname="descr">RF amplifier is very first amplifier on
+the receiver signal path, just right after antenna input. Difference between
+LNA gain and RF gain on this document and context is that LNA gain is integrated
+to tuner chip whilst RF gain is separate chip. There may be both, RF and LNA
+gain control, on same device. Used when <constant>V4L2_CID_RF_TUNER_RF_GAIN_AUTO</constant> is not set.
+The range and step are driver-specific.</entry>
+            </row>
+            <row>
               <entry spanname="id"><constant>V4L2_CID_RF_TUNER_LNA_GAIN</constant>&nbsp;</entry>
               <entry>integer</entry>
             </row>
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index c9eedc1..b94d381 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -156,6 +156,7 @@ applications. -->
 	<date>2015-05-26</date>
 	<authorinitials>ap</authorinitials>
 	<revremark>Renamed V4L2_TUNER_ADC to V4L2_TUNER_SDR.
+Added V4L2_CID_RF_TUNER_RF_GAIN_AUTO and V4L2_CID_RF_TUNER_RF_GAIN controls.
 	</revremark>
       </revision>
 
-- 
http://palosaari.fi/

