Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50135 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbbIAV7y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Sep 2015 17:59:54 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 07/13] DocBook: add modulator type field
Date: Wed,  2 Sep 2015 00:59:23 +0300
Message-Id: <1441144769-29211-8-git-send-email-crope@iki.fi>
In-Reply-To: <1441144769-29211-1-git-send-email-crope@iki.fi>
References: <1441144769-29211-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add new modulator type field to documentation.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 Documentation/DocBook/media/v4l/vidioc-g-modulator.xml | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml b/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
index 7068b59..80167fc 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
@@ -140,7 +140,13 @@ indicator, for example a stereo pilot tone.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-	    <entry><structfield>reserved</structfield>[4]</entry>
+	    <entry><structfield>type</structfield></entry>
+	    <entry spanname="hspan">Type of the modulator, see <xref
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

