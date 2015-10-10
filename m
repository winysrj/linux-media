Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34277 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbbJJQvY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 12:51:24 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [PATCHv5 03/13] DocBook: document tuner RF gain control
Date: Sat, 10 Oct 2015 19:50:59 +0300
Message-Id: <1444495869-1969-4-git-send-email-crope@iki.fi>
In-Reply-To: <1444495869-1969-1-git-send-email-crope@iki.fi>
References: <1444495869-1969-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add brief description for tuner RF gain control.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 Documentation/DocBook/media/v4l/compat.xml   |  4 ++++
 Documentation/DocBook/media/v4l/controls.xml | 14 ++++++++++++++
 Documentation/DocBook/media/v4l/v4l2.xml     |  1 +
 3 files changed, 19 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index f56faf5..eb091c7 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2600,6 +2600,10 @@ and &v4l2-mbus-framefmt;.
 <constant>V4L2_TUNER_ADC</constant> is deprecated now.
 	  </para>
 	</listitem>
+	<listitem>
+	  <para>Added <constant>V4L2_CID_RF_TUNER_RF_GAIN</constant>
+RF Tuner control.</para>
+	</listitem>
       </orderedlist>
     </section>
 
diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 33aece5..f13a429 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -5418,6 +5418,18 @@ set. Unit is in Hz. The range and step are driver-specific.</entry>
               <entry spanname="descr">Enables/disables IF automatic gain control (AGC)</entry>
             </row>
             <row>
+              <entry spanname="id"><constant>V4L2_CID_RF_TUNER_RF_GAIN</constant>&nbsp;</entry>
+              <entry>integer</entry>
+            </row>
+            <row>
+              <entry spanname="descr">The RF amplifier is the very first
+amplifier on the receiver signal path, just right after the antenna input.
+The difference between the LNA gain and the RF gain in this document is that
+the LNA gain is integrated in the tuner chip while the RF gain is a separate
+chip. There may be both RF and LNA gain controls in the same device.
+The range and step are driver-specific.</entry>
+            </row>
+            <row>
               <entry spanname="id"><constant>V4L2_CID_RF_TUNER_LNA_GAIN</constant>&nbsp;</entry>
               <entry>integer</entry>
             </row>
@@ -5425,6 +5437,8 @@ set. Unit is in Hz. The range and step are driver-specific.</entry>
               <entry spanname="descr">LNA (low noise amplifier) gain is first
 gain stage on the RF tuner signal path. It is located very close to tuner
 antenna input. Used when <constant>V4L2_CID_RF_TUNER_LNA_GAIN_AUTO</constant> is not set.
+See <constant>V4L2_CID_RF_TUNER_RF_GAIN</constant> to understand how RF gain
+and LNA gain differs from the each others.
 The range and step are driver-specific.</entry>
             </row>
             <row>
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index c9eedc1..ab9fca4 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -156,6 +156,7 @@ applications. -->
 	<date>2015-05-26</date>
 	<authorinitials>ap</authorinitials>
 	<revremark>Renamed V4L2_TUNER_ADC to V4L2_TUNER_SDR.
+Added V4L2_CID_RF_TUNER_RF_GAIN control.
 	</revremark>
       </revision>
 
-- 
http://palosaari.fi/

