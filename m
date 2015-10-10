Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35957 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbbJJQv0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 12:51:26 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [PATCHv5 13/13] DocBook: add SDR specific info to G_MODULATOR / S_MODULATOR
Date: Sat, 10 Oct 2015 19:51:09 +0300
Message-Id: <1444495869-1969-14-git-send-email-crope@iki.fi>
In-Reply-To: <1444495869-1969-1-git-send-email-crope@iki.fi>
References: <1444495869-1969-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add SDR specific notes to G_MODULATOR / S_MODULATOR documentation.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 Documentation/DocBook/media/v4l/vidioc-g-modulator.xml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml b/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
index 80167fc..e83f1a3 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
@@ -78,6 +78,12 @@ different audio modulation if the request cannot be satisfied. However
 this is a write-only ioctl, it does not return the actual audio
 modulation selected.</para>
 
+    <para><link linkend="sdr">SDR</link> specific modulator types are
+<constant>V4L2_TUNER_SDR</constant> and <constant>V4L2_TUNER_RF</constant>.
+For SDR devices <structfield>txsubchans</structfield> field must be
+initialized to zero.
+The term modulator means SDR transmitter in this context.</para>
+
     <para>To change the radio frequency the &VIDIOC-S-FREQUENCY; ioctl
 is available.</para>
 
-- 
http://palosaari.fi/

