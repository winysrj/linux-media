Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47795 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755337AbaCLRyU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Mar 2014 13:54:20 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH] v4l: define unit for V4L2_CID_RF_TUNER_BANDWIDTH
Date: Wed, 12 Mar 2014 19:53:39 +0200
Message-Id: <1394646819-2667-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use Hertz as a unit for radio channel bandwidth.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 Documentation/DocBook/media/v4l/controls.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index b3e222e..f4fa1ee 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -5062,7 +5062,7 @@ by the driver.</entry>
               <entry spanname="descr">Filter(s) on tuner signal path are used to
 filter signal according to receiving party needs. Driver configures filters to
 fulfill desired bandwidth requirement. Used when V4L2_CID_RF_TUNER_BANDWIDTH_AUTO is not
-set. The range and step are driver-specific.</entry>
+set. Unit is in Hz. The range and step are driver-specific.</entry>
             </row>
             <row>
               <entry spanname="id"><constant>V4L2_CID_RF_TUNER_LNA_GAIN_AUTO</constant>&nbsp;</entry>
-- 
1.8.5.3

