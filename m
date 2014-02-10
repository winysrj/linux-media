Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60548 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbaBJQVe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 11:21:34 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 3/6] DocBook: document RF tuner gain controls
Date: Mon, 10 Feb 2014 18:21:16 +0200
Message-Id: <1392049279-13495-4-git-send-email-crope@iki.fi>
In-Reply-To: <1392049279-13495-1-git-send-email-crope@iki.fi>
References: <1392049279-13495-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add documentation for LNA, mixer and IF gain controls. These
controls are RF tuner specific.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/controls.xml | 91 ++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index a5a3188..0145341 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -4971,4 +4971,95 @@ defines possible values for de-emphasis. Here they are:</entry>
       </table>
 
       </section>
+
+    <section id="rf-tuner-controls">
+      <title>RF Tuner Control Reference</title>
+
+      <para>The RF Tuner (RF_TUNER) class includes controls for common features
+of devices having RF tuner.</para>
+
+      <table pgwide="1" frame="none" id="rf-tuner-control-id">
+        <title>RF_TUNER Control IDs</title>
+
+        <tgroup cols="4">
+          <colspec colname="c1" colwidth="1*" />
+          <colspec colname="c2" colwidth="6*" />
+          <colspec colname="c3" colwidth="2*" />
+          <colspec colname="c4" colwidth="6*" />
+          <spanspec namest="c1" nameend="c2" spanname="id" />
+          <spanspec namest="c2" nameend="c4" spanname="descr" />
+          <thead>
+            <row>
+              <entry spanname="id" align="left">ID</entry>
+              <entry align="left">Type</entry>
+            </row>
+            <row rowsep="1">
+              <entry spanname="descr" align="left">Description</entry>
+            </row>
+          </thead>
+          <tbody valign="top">
+            <row><entry></entry></row>
+            <row>
+              <entry spanname="id"><constant>V4L2_CID_RF_TUNER_CLASS</constant>&nbsp;</entry>
+              <entry>class</entry>
+            </row><row><entry spanname="descr">The RF_TUNER class
+descriptor. Calling &VIDIOC-QUERYCTRL; for this control will return a
+description of this control class.</entry>
+            </row>
+            <row>
+              <entry spanname="id"><constant>V4L2_CID_LNA_GAIN_AUTO</constant>&nbsp;</entry>
+              <entry>boolean</entry>
+            </row>
+            <row>
+              <entry spanname="descr">Enables/disables LNA automatic gain control (AGC)</entry>
+            </row>
+            <row>
+              <entry spanname="id"><constant>V4L2_CID_MIXER_GAIN_AUTO</constant>&nbsp;</entry>
+              <entry>boolean</entry>
+            </row>
+            <row>
+              <entry spanname="descr">Enables/disables mixer automatic gain control (AGC)</entry>
+            </row>
+            <row>
+              <entry spanname="id"><constant>V4L2_CID_IF_GAIN_AUTO</constant>&nbsp;</entry>
+              <entry>boolean</entry>
+            </row>
+            <row>
+              <entry spanname="descr">Enables/disables IF automatic gain control (AGC)</entry>
+            </row>
+            <row>
+              <entry spanname="id"><constant>V4L2_CID_LNA_GAIN</constant>&nbsp;</entry>
+              <entry>integer</entry>
+            </row>
+            <row>
+              <entry spanname="descr">LNA (low noise amplifier) gain is first
+gain stage on the RF tuner signal path. It is located very close to tuner
+antenna input. Used when <constant>V4L2_CID_LNA_GAIN_AUTO</constant> is not set.
+The range and step are driver-specific.</entry>
+            </row>
+            <row>
+              <entry spanname="id"><constant>V4L2_CID_MIXER_GAIN</constant>&nbsp;</entry>
+              <entry>integer</entry>
+            </row>
+            <row>
+              <entry spanname="descr">Mixer gain is second gain stage on the RF
+tuner signal path. It is located inside mixer block, where RF signal is
+down-converted by the mixer. Used when <constant>V4L2_CID_MIXER_GAIN_AUTO</constant>
+is not set. The range and step are driver-specific.</entry>
+            </row>
+            <row>
+              <entry spanname="id"><constant>V4L2_CID_IF_GAIN</constant>&nbsp;</entry>
+              <entry>integer</entry>
+            </row>
+            <row>
+              <entry spanname="descr">IF gain is last gain stage on the RF tuner
+signal path. It is located on output of RF tuner. It controls signal level of
+intermediate frequency output or baseband output. Used when
+<constant>V4L2_CID_IF_GAIN_AUTO</constant> is not set. The range and step are
+driver-specific.</entry>
+            </row>
+          </tbody>
+        </tgroup>
+      </table>
+    </section>
 </section>
-- 
1.8.5.3

