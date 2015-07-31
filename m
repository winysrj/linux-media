Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38308 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbbGaCLK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2015 22:11:10 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [PATCHv3 07/13] DocBook: add modulator type field
Date: Fri, 31 Jul 2015 05:10:44 +0300
Message-Id: <1438308650-2702-8-git-send-email-crope@iki.fi>
In-Reply-To: <1438308650-2702-1-git-send-email-crope@iki.fi>
References: <1438308650-2702-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add new modulator type field to documentation.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 Documentation/DocBook/media/v4l/vidioc-g-modulator.xml | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml b/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
index 7068b59..fe4230c 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
@@ -140,7 +140,13 @@ indicator, for example a stereo pilot tone.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-	    <entry><structfield>reserved</structfield>[4]</entry>
+	    <entry><structfield>type</structfield></entry>
+	    <entry spanname="hspan">Type of the tuner, see <xref
+		linkend="v4l2-tuner-type" />.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[3]</entry>
 	    <entry>Reserved for future extensions. Drivers and
 applications must set the array to zero.</entry>
 	  </row>
-- 
http://palosaari.fi/

