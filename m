Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51165 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933209AbaBAOYs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Feb 2014 09:24:48 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 13/17] DocBook: media: document V4L2_CTRL_CLASS_RF_TUNER
Date: Sat,  1 Feb 2014 16:24:30 +0200
Message-Id: <1391264674-4395-14-git-send-email-crope@iki.fi>
In-Reply-To: <1391264674-4395-1-git-send-email-crope@iki.fi>
References: <1391264674-4395-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is class for RF tuner specific controls, like gain controls,
filters, signal strength.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
index b3bb957..e9f6735 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
@@ -327,7 +327,12 @@ These controls are described in <xref
 These controls are described in <xref
 		linkend="fm-rx-controls" />.</entry>
 	  </row>
-
+	  <row>
+	    <entry><constant>V4L2_CTRL_CLASS_RF_TUNER</constant></entry>
+	    <entry>0xa20000</entry>
+	    <entry>The class containing RF tuner controls.
+These controls are described in <xref linkend="rf-tuner-controls" />.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
-- 
1.8.5.3

