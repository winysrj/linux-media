Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60378 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbbIAV7z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Sep 2015 17:59:55 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 12/13] DocBook: add SDR specific info to G_TUNER / S_TUNER
Date: Wed,  2 Sep 2015 00:59:28 +0300
Message-Id: <1441144769-29211-13-git-send-email-crope@iki.fi>
In-Reply-To: <1441144769-29211-1-git-send-email-crope@iki.fi>
References: <1441144769-29211-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add SDR specific notes to G_TUNER / S_TUNER documentation.
Add V4L2_TUNER_SDR and V4L2_TUNER_RF to supported tuner types to
table.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 Documentation/DocBook/media/v4l/vidioc-g-tuner.xml | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml b/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
index b0d8659..0140c08 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
@@ -80,6 +80,15 @@ if the requested mode is invalid or unsupported. Since this is a
 <!-- FIXME -->write-only ioctl, it does not return the actually
 selected audio mode.</para>
 
+    <para><link linkend="sdr">SDR</link> specific tuner types are
+<constant>V4L2_TUNER_SDR</constant> and <constant>V4L2_TUNER_RF</constant>.
+Valid fields for these tuner types are <structfield>index</structfield>,
+<structfield>name</structfield>, <structfield>type</structfield>,
+<structfield>capability</structfield>, <structfield>rangelow</structfield>
+and <structfield>rangehigh</structfield>. All the rest fields must be
+initialized to zero by both application and driver.
+Term tuner means SDR receiver on this context.</para>
+
     <para>To change the radio frequency the &VIDIOC-S-FREQUENCY; ioctl
 is available.</para>
 
@@ -261,6 +270,16 @@ applications must set the array to zero.</entry>
 	    <entry>2</entry>
 	    <entry></entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_TUNER_SDR</constant></entry>
+	    <entry>4</entry>
+	    <entry></entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_TUNER_RF</constant></entry>
+	    <entry>5</entry>
+	    <entry></entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
-- 
http://palosaari.fi/

