Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41332 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022AbaB0AWW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 19:22:22 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 13/13] DocBook: media: add some general info about RF tuners
Date: Thu, 27 Feb 2014 02:22:08 +0200
Message-Id: <1393460528-11684-14-git-send-email-crope@iki.fi>
In-Reply-To: <1393460528-11684-1-git-send-email-crope@iki.fi>
References: <1393460528-11684-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add some info what is RF tuner in context of V4L RF tuner class.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 Documentation/DocBook/media/v4l/controls.xml | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 92e3335..9adf630 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -4975,8 +4975,27 @@ defines possible values for de-emphasis. Here they are:</entry>
     <section id="rf-tuner-controls">
       <title>RF Tuner Control Reference</title>
 
-      <para>The RF Tuner (RF_TUNER) class includes controls for common features
-of devices having RF tuner.</para>
+      <para>
+The RF Tuner (RF_TUNER) class includes controls for common features of devices
+having RF tuner.
+      </para>
+      <para>
+In this context, RF tuner is radio receiver circuit between antenna and
+demodulator. It receives radio frequency (RF) from the antenna and converts that
+received signal to lower intermediate frequency (IF) or baseband frequency (BB).
+Tuners that could do baseband output are often called Zero-IF tuners. Older
+tuners were typically simple PLL tuners inside a metal box, whilst newer ones
+are highly integrated chips without a metal box "silicon tuners". These controls
+are mostly applicable for new feature rich silicon tuners, just because older
+tuners does not have much adjustable features.
+      </para>
+      <para>
+For more information about RF tuners see
+<ulink url="http://en.wikipedia.org/wiki/Tuner_%28radio%29">Tuner (radio)</ulink>
+and
+<ulink url="http://en.wikipedia.org/wiki/RF_front_end">RF front end</ulink>
+from Wikipedia.
+      </para>
 
       <table pgwide="1" frame="none" id="rf-tuner-control-id">
         <title>RF_TUNER Control IDs</title>
-- 
1.8.5.3

