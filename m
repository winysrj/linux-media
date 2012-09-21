Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2446 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab2IULol (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Sep 2012 07:44:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 2/3] DocBook: in non-blocking mode return EAGAIN in hwseek
Date: Fri, 21 Sep 2012 13:44:27 +0200
Message-Id: <c8be3658c1cd349e3641c4d362be83d2879fd16b.1348227670.git.hans.verkuil@cisco.com>
In-Reply-To: <1348227868-20895-1-git-send-email-hverkuil@xs4all.nl>
References: <1348227868-20895-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <187f1fb0891d7ddeef202c6be7d86209c354a632.1348227670.git.hans.verkuil@cisco.com>
References: <187f1fb0891d7ddeef202c6be7d86209c354a632.1348227670.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

VIDIOC_S_HW_FREQ_SEEK should return EAGAIN when called in non-blocking
mode. This might change in the future if we add support for this in the
future, but right now this is not supported.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml b/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
index 3dd1bec..5b379e7 100644
--- a/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
@@ -75,6 +75,9 @@ seek is started.</para>
 
     <para>This ioctl is supported if the <constant>V4L2_CAP_HW_FREQ_SEEK</constant> capability is set.</para>
 
+    <para>If this ioctl is called from a non-blocking filehandle, then &EAGAIN; is
+    returned and no seek takes place.</para>
+
     <table pgwide="1" frame="none" id="v4l2-hw-freq-seek">
       <title>struct <structname>v4l2_hw_freq_seek</structname></title>
       <tgroup cols="3">
@@ -158,6 +161,13 @@ fields is wrong.</para>
 	</listitem>
       </varlistentry>
       <varlistentry>
+	<term><errorcode>EAGAIN</errorcode></term>
+	<listitem>
+	  <para>Attempted to call <constant>VIDIOC_S_HW_FREQ_SEEK</constant>
+	  with the filehandle in non-blocking mode.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
 	<term><errorcode>ENODATA</errorcode></term>
 	<listitem>
 	  <para>The hardware seek found no channels.</para>
-- 
1.7.10.4

