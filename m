Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:38125 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753469AbbEFG5p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 May 2015 02:57:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 2/8] DocBook/media: document VIDIOC_SUBDEV_QUERYCAP
Date: Wed,  6 May 2015 08:57:17 +0200
Message-Id: <1430895443-41839-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1430895443-41839-1-git-send-email-hverkuil@xs4all.nl>
References: <1430895443-41839-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add documentation for the new VIDIOC_SUBDEV_QUERYCAP ioctl.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/v4l2.xml           |   1 +
 .../DocBook/media/v4l/vidioc-subdev-querycap.xml   | 125 +++++++++++++++++++++
 2 files changed, 126 insertions(+)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-subdev-querycap.xml

diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index e98caa1..23607bc 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -669,6 +669,7 @@ and discussions on the V4L mailing list.</revremark>
     &sub-subdev-g-fmt;
     &sub-subdev-g-frame-interval;
     &sub-subdev-g-selection;
+    &sub-subdev-querycap;
     &sub-subscribe-event;
     <!-- End of ioctls. -->
     &sub-mmap;
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-querycap.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-querycap.xml
new file mode 100644
index 0000000..7c4fceb
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-querycap.xml
@@ -0,0 +1,125 @@
+<refentry id="vidioc-subdev-querycap">
+  <refmeta>
+    <refentrytitle>ioctl VIDIOC_SUBDEV_QUERYCAP</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>VIDIOC_SUBDEV_QUERYCAP</refname>
+    <refpurpose>Query sub-device capabilities</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>struct v4l2_subdev_capability *<parameter>argp</parameter></paramdef>
+      </funcprototype>
+    </funcsynopsis>
+  </refsynopsisdiv>
+
+  <refsect1>
+    <title>Arguments</title>
+
+    <variablelist>
+      <varlistentry>
+	<term><parameter>fd</parameter></term>
+	<listitem>
+	  <para>&fd;</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>request</parameter></term>
+	<listitem>
+	  <para>VIDIOC_SUBDEV_QUERYCAP</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>argp</parameter></term>
+	<listitem>
+	  <para></para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+
+  <refsect1>
+    <title>Description</title>
+
+    <para>All V4L2 sub-devices support the
+<constant>VIDIOC_SUBDEV_QUERYCAP</constant> ioctl. It is used to identify
+kernel devices compatible with this specification and to obtain
+information about driver and hardware capabilities. The ioctl takes a
+pointer to a &v4l2-subdev-capability; which is filled by the driver. When the
+driver is not compatible with this specification the ioctl returns an
+error, most likely the &ENOTTY;.</para>
+
+    <table pgwide="1" frame="none" id="v4l2-subdev-capability">
+      <title>struct <structname>v4l2_subdev_capability</structname></title>
+      <tgroup cols="3">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>version</structfield></entry>
+	    <entry><para>Version number of the driver.</para>
+<para>The version reported is provided by the
+V4L2 subsystem following the kernel numbering scheme. However, it
+may not always return the same version as the kernel if, for example,
+a stable or distribution-modified kernel uses the V4L2 stack from a
+newer kernel.</para>
+<para>The version number is formatted using the
+<constant>KERNEL_VERSION()</constant> macro:</para></entry>
+	  </row>
+	  <row>
+	    <entry spanname="hspan"><para>
+<programlisting>
+#define KERNEL_VERSION(a,b,c) (((a) &lt;&lt; 16) + ((b) &lt;&lt; 8) + (c))
+
+__u32 version = KERNEL_VERSION(0, 8, 1);
+
+printf ("Version: %u.%u.%u\n",
+	(version &gt;&gt; 16) &amp; 0xFF,
+	(version &gt;&gt; 8) &amp; 0xFF,
+	 version &amp; 0xFF);
+</programlisting></para></entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>device_caps</structfield></entry>
+	    <entry>Sub-device capabilities of the opened device, see <xref
+		linkend="subdevice-capabilities" />.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[50]</entry>
+	    <entry>Reserved for future extensions. Drivers must set
+this array to zero.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table pgwide="1" frame="none" id="subdevice-capabilities">
+      <title>Sub-Device Capabilities Flags</title>
+      <tgroup cols="3">
+	&cs-def;
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>V4L2_SUBDEV_CAP_ENTITY</constant></entry>
+	    <entry>0x00000001</entry>
+	    <entry>The sub-device is a media controller entity. If this
+capability is set, then you can call &MEDIA-IOC-DEVICE-INFO;.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+  </refsect1>
+
+  <refsect1>
+    &return-value;
+  </refsect1>
+</refentry>
-- 
2.1.4

