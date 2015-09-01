Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36998 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbbIAV7z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Sep 2015 17:59:55 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 13/13] DocBook: add SDR specific info to G_MODULATOR / S_MODULATOR
Date: Wed,  2 Sep 2015 00:59:29 +0300
Message-Id: <1441144769-29211-14-git-send-email-crope@iki.fi>
In-Reply-To: <1441144769-29211-1-git-send-email-crope@iki.fi>
References: <1441144769-29211-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add SDR specific notes to G_MODULATOR / S_MODULATOR documentation.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 Documentation/DocBook/media/v4l/vidioc-g-modulator.xml | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml b/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
index 80167fc..affb694 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
@@ -78,6 +78,15 @@ different audio modulation if the request cannot be satisfied. However
 this is a write-only ioctl, it does not return the actual audio
 modulation selected.</para>
 
+    <para><link linkend="sdr">SDR</link> specific modulator types are
+<constant>V4L2_TUNER_SDR</constant> and <constant>V4L2_TUNER_RF</constant>.
+Valid fields for these modulator types are <structfield>index</structfield>,
+<structfield>name</structfield>, <structfield>capability</structfield>,
+<structfield>rangelow</structfield>, <structfield>rangehigh</structfield>
+and <structfield>type</structfield>. All the rest fields must be
+initialized to zero by both application and driver.
+Term modulator means SDR transmitter on this context.</para>
+
     <para>To change the radio frequency the &VIDIOC-S-FREQUENCY; ioctl
 is available.</para>
 
-- 
http://palosaari.fi/

