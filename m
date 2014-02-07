Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33929 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbaBGOVB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Feb 2014 09:21:01 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] Add Antti at the V4L2 revision list
Date: Fri,  7 Feb 2014 12:20:39 -0200
Message-Id: <1391782839-26272-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add SDR to V3.15 revlist, and add the credits to Antti.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 Documentation/DocBook/media/v4l/v4l2.xml | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index e826d1d5df08..61a7bb1faccf 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -107,6 +107,16 @@ Remote Controller chapter.</contrib>
 	  </address>
 	</affiliation>
       </author>
+      <author>
+	<firstname>Antti</firstname>
+	<surname>Palosaari</surname>
+	<contrib>SDR API.</contrib>
+	<affiliation>
+	  <address>
+	    <email>crope@iki.fi</email>
+	  </address>
+	</affiliation>
+      </author>
     </authorgroup>
 
     <copyright>
@@ -144,10 +154,10 @@ applications. -->
       <revision>
 	<revnumber>3.15</revnumber>
 	<date>2014-02-03</date>
-	<authorinitials>hv</authorinitials>
+	<authorinitials>hv, ap</authorinitials>
 	<revremark>Update several sections of "Common API Elements": "Opening and Closing Devices"
 "Querying Capabilities", "Application Priority", "Video Inputs and Outputs", "Audio Inputs and Outputs"
-"Tuners and Modulators", "Video Standards" and "Digital Video (DV) Timings".
+"Tuners and Modulators", "Video Standards" and "Digital Video (DV) Timings". Added SDR API.
 	</revremark>
       </revision>
 
-- 
1.8.3.1

