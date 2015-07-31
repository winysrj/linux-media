Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45728 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbbGaCLL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2015 22:11:11 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [PATCHv3 13/13] DocBook: add tuner types SDR and RF for G_TUNER / S_TUNER
Date: Fri, 31 Jul 2015 05:10:50 +0300
Message-Id: <1438308650-2702-14-git-send-email-crope@iki.fi>
In-Reply-To: <1438308650-2702-1-git-send-email-crope@iki.fi>
References: <1438308650-2702-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add V4L2_TUNER_SDR and V4L2_TUNER_RF to supported tuner types to
table.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 Documentation/DocBook/media/v4l/vidioc-g-tuner.xml | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml b/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
index b0d8659..10737a1 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
@@ -261,6 +261,16 @@ applications must set the array to zero.</entry>
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

