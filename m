Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2072 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101Ab2ICNsz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2012 09:48:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 09/10] DocBook: document when to return ENODATA.
Date: Mon,  3 Sep 2012 15:48:43 +0200
Message-Id: <1fca85759e60e005c45cc923b56ed0a546600128.1346679785.git.hans.verkuil@cisco.com>
In-Reply-To: <1346680124-15169-1-git-send-email-hverkuil@xs4all.nl>
References: <1346680124-15169-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <c31da93f2bf615b90086d749e3f3eae6d6c3fc41.1346679785.git.hans.verkuil@cisco.com>
References: <c31da93f2bf615b90086d749e3f3eae6d6c3fc41.1346679785.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

ENODATA should be returned if the API used for getting/changing/querying
the current video timings is not supported by the current input or output.

This was decided during the 2012 Media Workshop.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-g-dv-preset.xml    |    9 ++++++---
 Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml   |   13 +++++++++----
 Documentation/DocBook/media/v4l/vidioc-g-std.xml          |   10 +++++++++-
 .../DocBook/media/v4l/vidioc-query-dv-preset.xml          |    9 +++++++++
 .../DocBook/media/v4l/vidioc-query-dv-timings.xml         |    6 ++++++
 Documentation/DocBook/media/v4l/vidioc-querystd.xml       |    8 ++++++++
 6 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-dv-preset.xml b/Documentation/DocBook/media/v4l/vidioc-g-dv-preset.xml
index 61be9fa..b9ea376 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-dv-preset.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-dv-preset.xml
@@ -78,6 +78,12 @@ If the preset is not supported, it returns an &EINVAL; </para>
 	</listitem>
       </varlistentry>
       <varlistentry>
+	<term><errorcode>ENODATA</errorcode></term>
+	<listitem>
+	  <para>Digital video presets are not supported for this input or output.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
 	<term><errorcode>EBUSY</errorcode></term>
 	<listitem>
 	  <para>The device is busy and therefore can not change the preset.</para>
@@ -104,7 +110,4 @@ If the preset is not supported, it returns an &EINVAL; </para>
       </tgroup>
     </table>
   </refsect1>
-  <refsect1>
-    &return-value;
-  </refsect1>
 </refentry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml b/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
index eda1a29..feaa180 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
@@ -56,7 +56,9 @@ a pointer to the &v4l2-dv-timings; structure as argument. If the ioctl is not su
 or the timing values are not correct, the driver returns &EINVAL;.</para>
 <para>The <filename>linux/v4l2-dv-timings.h</filename> header can be used to get the
 timings of the formats in the <xref linkend="cea861" /> and <xref linkend="vesadmt" />
-standards.</para>
+standards. If the current input or output does not support DV timings (e.g. if
+&VIDIOC-ENUMINPUT; does not set the <constant>V4L2_IN_CAP_CUSTOM_TIMINGS</constant> flag), then
+&ENODATA; is returned.</para>
   </refsect1>
 
   <refsect1>
@@ -71,6 +73,12 @@ standards.</para>
 	</listitem>
       </varlistentry>
       <varlistentry>
+	<term><errorcode>ENODATA</errorcode></term>
+	<listitem>
+	  <para>Digital video timings are not supported for this input or output.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
 	<term><errorcode>EBUSY</errorcode></term>
 	<listitem>
 	  <para>The device is busy and therefore can not change the timings.</para>
@@ -320,7 +328,4 @@ detected or used depends on the hardware.
       </tgroup>
     </table>
   </refsect1>
-  <refsect1>
-    &return-value;
-  </refsect1>
 </refentry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-std.xml b/Documentation/DocBook/media/v4l/vidioc-g-std.xml
index 99ff1a0..4a89841 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-std.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-std.xml
@@ -72,7 +72,9 @@ flags, being a write-only ioctl it does not return the actual new standard as
 the current input does not support the requested standard the driver
 returns an &EINVAL;. When the standard set is ambiguous drivers may
 return <errorcode>EINVAL</errorcode> or choose any of the requested
-standards.</para>
+standards. If the current input or output does not support standard video timings (e.g. if
+&VIDIOC-ENUMINPUT; does not set the <constant>V4L2_IN_CAP_STD</constant> flag), then
+&ENODATA; is returned.</para>
   </refsect1>
 
   <refsect1>
@@ -85,6 +87,12 @@ standards.</para>
 	  <para>The <constant>VIDIOC_S_STD</constant> parameter was unsuitable.</para>
 	</listitem>
       </varlistentry>
+      <varlistentry>
+	<term><errorcode>ENODATA</errorcode></term>
+	<listitem>
+	  <para>Standard video timings are not supported for this input or output.</para>
+	</listitem>
+      </varlistentry>
     </variablelist>
   </refsect1>
 </refentry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-query-dv-preset.xml b/Documentation/DocBook/media/v4l/vidioc-query-dv-preset.xml
index 1bc8aeb..68b49d0 100644
--- a/Documentation/DocBook/media/v4l/vidioc-query-dv-preset.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-query-dv-preset.xml
@@ -65,5 +65,14 @@ returned.</para>
 
   <refsect1>
     &return-value;
+
+    <variablelist>
+      <varlistentry>
+	<term><errorcode>ENODATA</errorcode></term>
+	<listitem>
+	  <para>Digital video presets are not supported for this input or output.</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
   </refsect1>
 </refentry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml b/Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml
index 44935a0..e185f14 100644
--- a/Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml
@@ -78,6 +78,12 @@ capabilities in order to give more precise feedback to the user.
 
     <variablelist>
       <varlistentry>
+	<term><errorcode>ENODATA</errorcode></term>
+	<listitem>
+	  <para>Digital video timings are not supported for this input or output.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
 	<term><errorcode>ENOLINK</errorcode></term>
 	<listitem>
 	  <para>No timings could be detected because no signal was found.
diff --git a/Documentation/DocBook/media/v4l/vidioc-querystd.xml b/Documentation/DocBook/media/v4l/vidioc-querystd.xml
index 4b79c7c..fe80a18 100644
--- a/Documentation/DocBook/media/v4l/vidioc-querystd.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-querystd.xml
@@ -62,5 +62,13 @@ current video input or output.</para>
 
   <refsect1>
     &return-value;
+    <variablelist>
+      <varlistentry>
+	<term><errorcode>ENODATA</errorcode></term>
+	<listitem>
+	  <para>Standard video timings are not supported for this input or output.</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
   </refsect1>
 </refentry>
-- 
1.7.10.4

