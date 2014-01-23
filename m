Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50515 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbaAWVJO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jan 2014 16:09:14 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [REVIEW PATCH 11/13] DocBook: mark SDR API as Experimental
Date: Thu, 23 Jan 2014 23:08:51 +0200
Message-Id: <1390511333-25837-12-git-send-email-crope@iki.fi>
In-Reply-To: <1390511333-25837-1-git-send-email-crope@iki.fi>
References: <1390511333-25837-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Let it be experimental still as all SDR drivers are in staging.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 Documentation/DocBook/media/v4l/compat.xml  | 3 +++
 Documentation/DocBook/media/v4l/dev-sdr.xml | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index 83f64ce..2fb2b8d 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2661,6 +2661,9 @@ ioctls.</para>
         <listitem>
 	  <para>Exporting DMABUF files using &VIDIOC-EXPBUF; ioctl.</para>
         </listitem>
+        <listitem>
+	  <para>Software Defined Radio (SDR) Interface, <xref linkend="sdr" />.</para>
+        </listitem>
       </itemizedlist>
     </section>
 
diff --git a/Documentation/DocBook/media/v4l/dev-sdr.xml b/Documentation/DocBook/media/v4l/dev-sdr.xml
index 332b87f..ac9f1af 100644
--- a/Documentation/DocBook/media/v4l/dev-sdr.xml
+++ b/Documentation/DocBook/media/v4l/dev-sdr.xml
@@ -1,5 +1,11 @@
   <title>Software Defined Radio Interface (SDR)</title>
 
+  <note>
+    <title>Experimental</title>
+    <para>This is an <link linkend="experimental"> experimental </link>
+    interface and may change in the future.</para>
+  </note>
+
   <para>
 SDR is an abbreviation of Software Defined Radio, the radio device
 which uses application software for modulation or demodulation. This interface
-- 
1.8.5.3

