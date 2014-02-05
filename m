Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51326 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbaBEIy5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Feb 2014 03:54:57 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/9] DocBook: document RF tuner bandwidth controls
Date: Wed,  5 Feb 2014 10:54:34 +0200
Message-Id: <1391590480-2146-3-git-send-email-crope@iki.fi>
In-Reply-To: <1391590480-2146-1-git-send-email-crope@iki.fi>
References: <1391590480-2146-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add documentation for RF tuner bandwidth controls. These controls are
used to set filters on tuner signal path.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 Documentation/DocBook/media/v4l/controls.xml | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 0145341..345b6e5 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -5007,6 +5007,25 @@ descriptor. Calling &VIDIOC-QUERYCTRL; for this control will return a
 description of this control class.</entry>
             </row>
             <row>
+              <entry spanname="id"><constant>V4L2_CID_BANDWIDTH_AUTO</constant>&nbsp;</entry>
+              <entry>boolean</entry>
+            </row>
+            <row>
+              <entry spanname="descr">Enables/disables tuner radio channel
+bandwidth configuration. In automatic mode bandwidth configuration is performed
+by the driver.</entry>
+            </row>
+            <row>
+              <entry spanname="id"><constant>V4L2_CID_BANDWIDTH</constant>&nbsp;</entry>
+              <entry>integer</entry>
+            </row>
+            <row>
+              <entry spanname="descr">Filter(s) on tuner signal path are used to
+filter signal according to receiving party needs. Driver configures filters to
+fulfill desired bandwidth requirement. Used when V4L2_CID_BANDWIDTH_AUTO is not
+set. The range and step are driver-specific.</entry>
+            </row>
+            <row>
               <entry spanname="id"><constant>V4L2_CID_LNA_GAIN_AUTO</constant>&nbsp;</entry>
               <entry>boolean</entry>
             </row>
-- 
1.8.5.3

