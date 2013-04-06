Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1333 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932860Ab3DFL0K (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Apr 2013 07:26:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 4/7] v4l2: rename VIDIOC_DBG_G_CHIP_NAME to _CHIP_INFO
Date: Sat,  6 Apr 2013 13:25:49 +0200
Message-Id: <1365247552-26795-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365247552-26795-1-git-send-email-hverkuil@xs4all.nl>
References: <1365247552-26795-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This ioctl will be extended to return more information than just the name.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/compat.xml         |    2 +-
 Documentation/DocBook/media/v4l/v4l2.xml           |    4 +-
 .../DocBook/media/v4l/vidioc-dbg-g-chip-info.xml   |  223 ++++++++++++++++++++
 .../DocBook/media/v4l/vidioc-dbg-g-chip-name.xml   |  223 --------------------
 .../DocBook/media/v4l/vidioc-dbg-g-register.xml    |   10 +-
 drivers/media/usb/em28xx/em28xx-video.c            |    8 +-
 drivers/media/v4l2-core/v4l2-dev.c                 |    2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |   14 +-
 include/media/v4l2-ioctl.h                         |    4 +-
 include/uapi/linux/videodev2.h                     |    8 +-
 10 files changed, 249 insertions(+), 249 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-info.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-name.xml

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index e44161f..f43542a 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2507,7 +2507,7 @@ that used it. It was originally scheduled for removal in 2.6.35.
 	  </para>
         </listitem>
         <listitem>
-	  <para>Added new debugging ioctl &VIDIOC-DBG-G-CHIP-NAME;.
+	  <para>Added new debugging ioctl &VIDIOC-DBG-G-CHIP-INFO;.
 	  </para>
         </listitem>
       </orderedlist>
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index c1f3340..bfc93cd 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -147,7 +147,7 @@ applications. -->
 	<revremark>Remove obsolete and unused DV_PRESET ioctls:
 	VIDIOC_G_DV_PRESET, VIDIOC_S_DV_PRESET, VIDIOC_QUERY_DV_PRESET and
 	VIDIOC_ENUM_DV_PRESET. Remove the related v4l2_input/output capability
-	flags V4L2_IN_CAP_PRESETS and V4L2_OUT_CAP_PRESETS. Added VIDIOC_DBG_G_CHIP_NAME.
+	flags V4L2_IN_CAP_PRESETS and V4L2_OUT_CAP_PRESETS. Added VIDIOC_DBG_G_CHIP_INFO.
 	</revremark>
       </revision>
 
@@ -548,7 +548,7 @@ and discussions on the V4L mailing list.</revremark>
     &sub-create-bufs;
     &sub-cropcap;
     &sub-dbg-g-chip-ident;
-    &sub-dbg-g-chip-name;
+    &sub-dbg-g-chip-info;
     &sub-dbg-g-register;
     &sub-decoder-cmd;
     &sub-dqevent;
diff --git a/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-info.xml b/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-info.xml
new file mode 100644
index 0000000..e1cece6
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-info.xml
@@ -0,0 +1,223 @@
+<refentry id="vidioc-dbg-g-chip-info">
+  <refmeta>
+    <refentrytitle>ioctl VIDIOC_DBG_G_CHIP_INFO</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>VIDIOC_DBG_G_CHIP_INFO</refname>
+    <refpurpose>Identify the chips on a TV card</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>struct v4l2_dbg_chip_info
+*<parameter>argp</parameter></paramdef>
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
+	  <para>VIDIOC_DBG_G_CHIP_INFO</para>
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
+    <note>
+      <title>Experimental</title>
+
+      <para>This is an <link
+linkend="experimental">experimental</link> interface and may change in
+the future.</para>
+    </note>
+
+    <para>For driver debugging purposes this ioctl allows test
+applications to query the driver about the chips present on the TV
+card. Regular applications must not use it. When you found a chip
+specific bug, please contact the linux-media mailing list (&v4l-ml;)
+so it can be fixed.</para>
+
+    <para>Additionally the Linux kernel must be compiled with the
+<constant>CONFIG_VIDEO_ADV_DEBUG</constant> option to enable this ioctl.</para>
+
+    <para>To query the driver applications must initialize the
+<structfield>match.type</structfield> and
+<structfield>match.addr</structfield> or <structfield>match.name</structfield>
+fields of a &v4l2-dbg-chip-info;
+and call <constant>VIDIOC_DBG_G_CHIP_INFO</constant> with a pointer to
+this structure. On success the driver stores information about the
+selected chip in the <structfield>name</structfield> and
+<structfield>flags</structfield> fields. On failure the structure
+remains unchanged.</para>
+
+    <para>When <structfield>match.type</structfield> is
+<constant>V4L2_CHIP_MATCH_BRIDGE</constant>,
+<structfield>match.addr</structfield> selects the nth bridge 'chip'
+on the TV card. You can enumerate all chips by starting at zero and
+incrementing <structfield>match.addr</structfield> by one until
+<constant>VIDIOC_DBG_G_CHIP_INFO</constant> fails with an &EINVAL;.
+The number zero always selects the bridge chip itself, &eg; the chip
+connected to the PCI or USB bus. Non-zero numbers identify specific
+parts of the bridge chip such as an AC97 register block.</para>
+
+    <para>When <structfield>match.type</structfield> is
+<constant>V4L2_CHIP_MATCH_SUBDEV</constant>,
+<structfield>match.addr</structfield> selects the nth sub-device. This
+allows you to enumerate over all sub-devices.</para>
+
+    <para>On success, the <structfield>name</structfield> field will
+contain a chip name and the <structfield>flags</structfield> field will
+contain <constant>V4L2_CHIP_FL_READABLE</constant> if the driver supports
+reading registers from the device or <constant>V4L2_CHIP_FL_WRITABLE</constant>
+if the driver supports writing registers to the device.</para>
+
+    <para>We recommended the <application>v4l2-dbg</application>
+utility over calling this ioctl directly. It is available from the
+LinuxTV v4l-dvb repository; see <ulink
+url="http://linuxtv.org/repo/">http://linuxtv.org/repo/</ulink> for
+access instructions.</para>
+
+    <!-- Note for convenience vidioc-dbg-g-register.sgml
+	 contains a duplicate of this table. -->
+    <table pgwide="1" frame="none" id="name-v4l2-dbg-match">
+      <title>struct <structname>v4l2_dbg_match</structname></title>
+      <tgroup cols="4">
+	&cs-ustr;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>type</structfield></entry>
+	    <entry>See <xref linkend="name-chip-match-types" /> for a list of
+possible types.</entry>
+	  </row>
+	  <row>
+	    <entry>union</entry>
+	    <entry>(anonymous)</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry>__u32</entry>
+	    <entry><structfield>addr</structfield></entry>
+	    <entry>Match a chip by this number, interpreted according
+to the <structfield>type</structfield> field.</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry>char</entry>
+	    <entry><structfield>name[32]</structfield></entry>
+	    <entry>Match a chip by this name, interpreted according
+to the <structfield>type</structfield> field.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table pgwide="1" frame="none" id="v4l2-dbg-chip-info">
+      <title>struct <structname>v4l2_dbg_chip_info</structname></title>
+      <tgroup cols="3">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>struct v4l2_dbg_match</entry>
+	    <entry><structfield>match</structfield></entry>
+	    <entry>How to match the chip, see <xref linkend="name-v4l2-dbg-match" />.</entry>
+	  </row>
+	  <row>
+	    <entry>char</entry>
+	    <entry><structfield>name[32]</structfield></entry>
+	    <entry>The name of the chip.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>flags</structfield></entry>
+	    <entry>Set by the driver. If <constant>V4L2_CHIP_FL_READABLE</constant>
+is set, then the driver supports reading registers from the device. If
+<constant>V4L2_CHIP_FL_WRITABLE</constant> is set, then it supports writing registers.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved[8]</structfield></entry>
+	    <entry>Reserved fields, both application and driver must set these to 0.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <!-- Note for convenience vidioc-dbg-g-register.sgml
+	 contains a duplicate of this table. -->
+    <table pgwide="1" frame="none" id="name-chip-match-types">
+      <title>Chip Match Types</title>
+      <tgroup cols="3">
+	&cs-def;
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>V4L2_CHIP_MATCH_BRIDGE</constant></entry>
+	    <entry>0</entry>
+	    <entry>Match the nth chip on the card, zero for the
+	    bridge chip. Does not match sub-devices.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_CHIP_MATCH_I2C_DRIVER</constant></entry>
+	    <entry>1</entry>
+	    <entry>Match an &i2c; chip by its driver name. Can't be used with this ioctl.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_CHIP_MATCH_I2C_ADDR</constant></entry>
+	    <entry>2</entry>
+	    <entry>Match a chip by its 7 bit &i2c; bus address. Can't be used with this ioctl.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_CHIP_MATCH_AC97</constant></entry>
+	    <entry>3</entry>
+	    <entry>Match the nth anciliary AC97 chip. Can't be used with this ioctl.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_CHIP_MATCH_SUBDEV</constant></entry>
+	    <entry>4</entry>
+	    <entry>Match the nth sub-device.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+  </refsect1>
+
+  <refsect1>
+    &return-value;
+
+    <variablelist>
+      <varlistentry>
+	<term><errorcode>EINVAL</errorcode></term>
+	<listitem>
+	  <para>The <structfield>match_type</structfield> is invalid or
+no device could be matched.</para>
+	</listitem>
+      </varlistentry>
+     </variablelist>
+  </refsect1>
+</refentry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-name.xml b/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-name.xml
deleted file mode 100644
index fa3bd42..0000000
--- a/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-name.xml
+++ /dev/null
@@ -1,223 +0,0 @@
-<refentry id="vidioc-dbg-g-chip-name">
-  <refmeta>
-    <refentrytitle>ioctl VIDIOC_DBG_G_CHIP_NAME</refentrytitle>
-    &manvol;
-  </refmeta>
-
-  <refnamediv>
-    <refname>VIDIOC_DBG_G_CHIP_NAME</refname>
-    <refpurpose>Identify the chips on a TV card</refpurpose>
-  </refnamediv>
-
-  <refsynopsisdiv>
-    <funcsynopsis>
-      <funcprototype>
-	<funcdef>int <function>ioctl</function></funcdef>
-	<paramdef>int <parameter>fd</parameter></paramdef>
-	<paramdef>int <parameter>request</parameter></paramdef>
-	<paramdef>struct v4l2_dbg_chip_name
-*<parameter>argp</parameter></paramdef>
-      </funcprototype>
-    </funcsynopsis>
-  </refsynopsisdiv>
-
-  <refsect1>
-    <title>Arguments</title>
-
-    <variablelist>
-      <varlistentry>
-	<term><parameter>fd</parameter></term>
-	<listitem>
-	  <para>&fd;</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><parameter>request</parameter></term>
-	<listitem>
-	  <para>VIDIOC_DBG_G_CHIP_NAME</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><parameter>argp</parameter></term>
-	<listitem>
-	  <para></para>
-	</listitem>
-      </varlistentry>
-    </variablelist>
-  </refsect1>
-
-  <refsect1>
-    <title>Description</title>
-
-    <note>
-      <title>Experimental</title>
-
-      <para>This is an <link
-linkend="experimental">experimental</link> interface and may change in
-the future.</para>
-    </note>
-
-    <para>For driver debugging purposes this ioctl allows test
-applications to query the driver about the chips present on the TV
-card. Regular applications must not use it. When you found a chip
-specific bug, please contact the linux-media mailing list (&v4l-ml;)
-so it can be fixed.</para>
-
-    <para>Additionally the Linux kernel must be compiled with the
-<constant>CONFIG_VIDEO_ADV_DEBUG</constant> option to enable this ioctl.</para>
-
-    <para>To query the driver applications must initialize the
-<structfield>match.type</structfield> and
-<structfield>match.addr</structfield> or <structfield>match.name</structfield>
-fields of a &v4l2-dbg-chip-name;
-and call <constant>VIDIOC_DBG_G_CHIP_NAME</constant> with a pointer to
-this structure. On success the driver stores information about the
-selected chip in the <structfield>name</structfield> and
-<structfield>flags</structfield> fields. On failure the structure
-remains unchanged.</para>
-
-    <para>When <structfield>match.type</structfield> is
-<constant>V4L2_CHIP_MATCH_BRIDGE</constant>,
-<structfield>match.addr</structfield> selects the nth bridge 'chip'
-on the TV card. You can enumerate all chips by starting at zero and
-incrementing <structfield>match.addr</structfield> by one until
-<constant>VIDIOC_DBG_G_CHIP_NAME</constant> fails with an &EINVAL;.
-The number zero always selects the bridge chip itself, &eg; the chip
-connected to the PCI or USB bus. Non-zero numbers identify specific
-parts of the bridge chip such as an AC97 register block.</para>
-
-    <para>When <structfield>match.type</structfield> is
-<constant>V4L2_CHIP_MATCH_SUBDEV</constant>,
-<structfield>match.addr</structfield> selects the nth sub-device. This
-allows you to enumerate over all sub-devices.</para>
-
-    <para>On success, the <structfield>name</structfield> field will
-contain a chip name and the <structfield>flags</structfield> field will
-contain <constant>V4L2_CHIP_FL_READABLE</constant> if the driver supports
-reading registers from the device or <constant>V4L2_CHIP_FL_WRITABLE</constant>
-if the driver supports writing registers to the device.</para>
-
-    <para>We recommended the <application>v4l2-dbg</application>
-utility over calling this ioctl directly. It is available from the
-LinuxTV v4l-dvb repository; see <ulink
-url="http://linuxtv.org/repo/">http://linuxtv.org/repo/</ulink> for
-access instructions.</para>
-
-    <!-- Note for convenience vidioc-dbg-g-register.sgml
-	 contains a duplicate of this table. -->
-    <table pgwide="1" frame="none" id="name-v4l2-dbg-match">
-      <title>struct <structname>v4l2_dbg_match</structname></title>
-      <tgroup cols="4">
-	&cs-ustr;
-	<tbody valign="top">
-	  <row>
-	    <entry>__u32</entry>
-	    <entry><structfield>type</structfield></entry>
-	    <entry>See <xref linkend="name-chip-match-types" /> for a list of
-possible types.</entry>
-	  </row>
-	  <row>
-	    <entry>union</entry>
-	    <entry>(anonymous)</entry>
-	  </row>
-	  <row>
-	    <entry></entry>
-	    <entry>__u32</entry>
-	    <entry><structfield>addr</structfield></entry>
-	    <entry>Match a chip by this number, interpreted according
-to the <structfield>type</structfield> field.</entry>
-	  </row>
-	  <row>
-	    <entry></entry>
-	    <entry>char</entry>
-	    <entry><structfield>name[32]</structfield></entry>
-	    <entry>Match a chip by this name, interpreted according
-to the <structfield>type</structfield> field.</entry>
-	  </row>
-	</tbody>
-      </tgroup>
-    </table>
-
-    <table pgwide="1" frame="none" id="v4l2-dbg-chip-name">
-      <title>struct <structname>v4l2_dbg_chip_name</structname></title>
-      <tgroup cols="3">
-	&cs-str;
-	<tbody valign="top">
-	  <row>
-	    <entry>struct v4l2_dbg_match</entry>
-	    <entry><structfield>match</structfield></entry>
-	    <entry>How to match the chip, see <xref linkend="name-v4l2-dbg-match" />.</entry>
-	  </row>
-	  <row>
-	    <entry>char</entry>
-	    <entry><structfield>name[32]</structfield></entry>
-	    <entry>The name of the chip.</entry>
-	  </row>
-	  <row>
-	    <entry>__u32</entry>
-	    <entry><structfield>flags</structfield></entry>
-	    <entry>Set by the driver. If <constant>V4L2_CHIP_FL_READABLE</constant>
-is set, then the driver supports reading registers from the device. If
-<constant>V4L2_CHIP_FL_WRITABLE</constant> is set, then it supports writing registers.</entry>
-	  </row>
-	  <row>
-	    <entry>__u32</entry>
-	    <entry><structfield>reserved[8]</structfield></entry>
-	    <entry>Reserved fields, both application and driver must set these to 0.</entry>
-	  </row>
-	</tbody>
-      </tgroup>
-    </table>
-
-    <!-- Note for convenience vidioc-dbg-g-register.sgml
-	 contains a duplicate of this table. -->
-    <table pgwide="1" frame="none" id="name-chip-match-types">
-      <title>Chip Match Types</title>
-      <tgroup cols="3">
-	&cs-def;
-	<tbody valign="top">
-	  <row>
-	    <entry><constant>V4L2_CHIP_MATCH_BRIDGE</constant></entry>
-	    <entry>0</entry>
-	    <entry>Match the nth chip on the card, zero for the
-	    bridge chip. Does not match sub-devices.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>V4L2_CHIP_MATCH_I2C_DRIVER</constant></entry>
-	    <entry>1</entry>
-	    <entry>Match an &i2c; chip by its driver name. Can't be used with this ioctl.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>V4L2_CHIP_MATCH_I2C_ADDR</constant></entry>
-	    <entry>2</entry>
-	    <entry>Match a chip by its 7 bit &i2c; bus address. Can't be used with this ioctl.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>V4L2_CHIP_MATCH_AC97</constant></entry>
-	    <entry>3</entry>
-	    <entry>Match the nth anciliary AC97 chip. Can't be used with this ioctl.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>V4L2_CHIP_MATCH_SUBDEV</constant></entry>
-	    <entry>4</entry>
-	    <entry>Match the nth sub-device.</entry>
-	  </row>
-	</tbody>
-      </tgroup>
-    </table>
-  </refsect1>
-
-  <refsect1>
-    &return-value;
-
-    <variablelist>
-      <varlistentry>
-	<term><errorcode>EINVAL</errorcode></term>
-	<listitem>
-	  <para>The <structfield>match_type</structfield> is invalid or
-no device could be matched.</para>
-	</listitem>
-      </varlistentry>
-     </variablelist>
-  </refsect1>
-</refentry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml b/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml
index db7844f..d13bac9 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml
@@ -99,7 +99,7 @@ unchanged.</para>
 <structfield>match.addr</structfield> selects the nth non-sub-device chip
 on the TV card.  The number zero always selects the host chip, &eg; the
 chip connected to the PCI or USB bus. You can find out which chips are
-present with the &VIDIOC-DBG-G-CHIP-NAME; ioctl.</para>
+present with the &VIDIOC-DBG-G-CHIP-INFO; ioctl.</para>
 
     <para>When <structfield>match.type</structfield> is
 <constant>V4L2_CHIP_MATCH_I2C_DRIVER</constant>,
@@ -109,7 +109,7 @@ For instance
 supported by the saa7127 driver, regardless of its &i2c; bus address.
 When multiple chips supported by the same driver are present, the
 effect of these ioctls is undefined. Again with the
-&VIDIOC-DBG-G-CHIP-NAME; ioctl you can find out which &i2c; chips are
+&VIDIOC-DBG-G-CHIP-INFO; ioctl you can find out which &i2c; chips are
 present.</para>
 
     <para>When <structfield>match.type</structfield> is
@@ -131,14 +131,14 @@ on the TV card.</para>
 
       <para>Due to a flaw in the Linux &i2c; bus driver these ioctls may
 return successfully without actually reading or writing a register. To
-catch the most likely failure we recommend a &VIDIOC-DBG-G-CHIP-NAME;
+catch the most likely failure we recommend a &VIDIOC-DBG-G-CHIP-INFO;
 call confirming the presence of the selected &i2c; chip.</para>
     </note>
 
     <para>These ioctls are optional, not all drivers may support them.
 However when a driver supports these ioctls it must also support
-&VIDIOC-DBG-G-CHIP-NAME;. Conversely it may support
-<constant>VIDIOC_DBG_G_CHIP_NAME</constant> but not these ioctls.</para>
+&VIDIOC-DBG-G-CHIP-INFO;. Conversely it may support
+<constant>VIDIOC_DBG_G_CHIP_INFO</constant> but not these ioctls.</para>
 
     <para><constant>VIDIOC_DBG_G_REGISTER</constant> and
 <constant>VIDIOC_DBG_S_REGISTER</constant> were introduced in Linux
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 39951f5..c27c1f6 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1332,8 +1332,8 @@ static int vidioc_g_chip_ident(struct file *file, void *priv,
 }
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-static int vidioc_g_chip_name(struct file *file, void *priv,
-	       struct v4l2_dbg_chip_name *chip)
+static int vidioc_g_chip_info(struct file *file, void *priv,
+	       struct v4l2_dbg_chip_info *chip)
 {
 	struct em28xx_fh      *fh  = priv;
 	struct em28xx         *dev = fh->dev;
@@ -1797,7 +1797,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 	.vidioc_g_chip_ident        = vidioc_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-	.vidioc_g_chip_name         = vidioc_g_chip_name,
+	.vidioc_g_chip_info         = vidioc_g_chip_info,
 	.vidioc_g_register          = vidioc_g_register,
 	.vidioc_s_register          = vidioc_s_register,
 #endif
@@ -1827,7 +1827,7 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 	.vidioc_g_chip_ident  = vidioc_g_chip_ident,
-	.vidioc_g_chip_name   = vidioc_g_chip_name,
+	.vidioc_g_chip_info   = vidioc_g_chip_info,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register    = vidioc_g_register,
 	.vidioc_s_register    = vidioc_s_register,
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 1c3b43c..5923c5d 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -592,7 +592,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	SET_VALID_IOCTL(ops, VIDIOC_S_FREQUENCY, vidioc_s_frequency);
 	SET_VALID_IOCTL(ops, VIDIOC_LOG_STATUS, vidioc_log_status);
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-	set_bit(_IOC_NR(VIDIOC_DBG_G_CHIP_NAME), valid_ioctls);
+	set_bit(_IOC_NR(VIDIOC_DBG_G_CHIP_INFO), valid_ioctls);
 	set_bit(_IOC_NR(VIDIOC_DBG_G_REGISTER), valid_ioctls);
 	set_bit(_IOC_NR(VIDIOC_DBG_S_REGISTER), valid_ioctls);
 #endif
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index c48d0ac..f81bda1 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -638,9 +638,9 @@ static void v4l_print_dbg_chip_ident(const void *arg, bool write_only)
 			p->ident, p->revision);
 }
 
-static void v4l_print_dbg_chip_name(const void *arg, bool write_only)
+static void v4l_print_dbg_chip_info(const void *arg, bool write_only)
 {
-	const struct v4l2_dbg_chip_name *p = arg;
+	const struct v4l2_dbg_chip_info *p = arg;
 
 	pr_cont("type=%u, ", p->match.type);
 	if (p->match.type == V4L2_CHIP_MATCH_I2C_DRIVER)
@@ -1854,12 +1854,12 @@ static int v4l_dbg_g_chip_ident(const struct v4l2_ioctl_ops *ops,
 	return ops->vidioc_g_chip_ident(file, fh, p);
 }
 
-static int v4l_dbg_g_chip_name(const struct v4l2_ioctl_ops *ops,
+static int v4l_dbg_g_chip_info(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	struct video_device *vfd = video_devdata(file);
-	struct v4l2_dbg_chip_name *p = arg;
+	struct v4l2_dbg_chip_info *p = arg;
 	struct v4l2_subdev *sd;
 	int idx = 0;
 
@@ -1875,8 +1875,8 @@ static int v4l_dbg_g_chip_name(const struct v4l2_ioctl_ops *ops,
 			strlcpy(p->name, vfd->parent->driver->name, sizeof(p->name));
 		else
 			strlcpy(p->name, "bridge", sizeof(p->name));
-		if (ops->vidioc_g_chip_name)
-			return ops->vidioc_g_chip_name(file, fh, arg);
+		if (ops->vidioc_g_chip_info)
+			return ops->vidioc_g_chip_info(file, fh, arg);
 		if (p->match.addr)
 			return -EINVAL;
 		return 0;
@@ -2116,7 +2116,7 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_STD(VIDIOC_QUERY_DV_TIMINGS, vidioc_query_dv_timings, v4l_print_dv_timings, 0),
 	IOCTL_INFO_STD(VIDIOC_DV_TIMINGS_CAP, vidioc_dv_timings_cap, v4l_print_dv_timings_cap, INFO_FL_CLEAR(v4l2_dv_timings_cap, type)),
 	IOCTL_INFO_FNC(VIDIOC_ENUM_FREQ_BANDS, v4l_enum_freq_bands, v4l_print_freq_band, 0),
-	IOCTL_INFO_FNC(VIDIOC_DBG_G_CHIP_NAME, v4l_dbg_g_chip_name, v4l_print_dbg_chip_name, INFO_FL_CLEAR(v4l2_dbg_chip_name, match)),
+	IOCTL_INFO_FNC(VIDIOC_DBG_G_CHIP_INFO, v4l_dbg_g_chip_info, v4l_print_dbg_chip_info, INFO_FL_CLEAR(v4l2_dbg_chip_info, match)),
 };
 #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
 
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 6b917d6..931652f 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -244,8 +244,8 @@ struct v4l2_ioctl_ops {
 	int (*vidioc_s_register)       (struct file *file, void *fh,
 					const struct v4l2_dbg_register *reg);
 
-	int (*vidioc_g_chip_name)      (struct file *file, void *fh,
-					struct v4l2_dbg_chip_name *chip);
+	int (*vidioc_g_chip_info)      (struct file *file, void *fh,
+					struct v4l2_dbg_chip_info *chip);
 #endif
 	int (*vidioc_g_chip_ident)     (struct file *file, void *fh,
 					struct v4l2_dbg_chip_ident *chip);
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 4c941c1..be43b46 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1839,8 +1839,8 @@ struct v4l2_dbg_chip_ident {
 #define V4L2_CHIP_FL_READABLE (1 << 0)
 #define V4L2_CHIP_FL_WRITABLE (1 << 1)
 
-/* VIDIOC_DBG_G_CHIP_NAME */
-struct v4l2_dbg_chip_name {
+/* VIDIOC_DBG_G_CHIP_INFO */
+struct v4l2_dbg_chip_info {
 	struct v4l2_dbg_match match;
 	char name[32];
 	__u32 flags;
@@ -1938,7 +1938,7 @@ struct v4l2_create_buffers {
 
 /* Experimental, meant for debugging, testing and internal use.
    Never use this ioctl in applications!
-   Note: this ioctl is deprecated in favor of VIDIOC_DBG_G_CHIP_NAME and
+   Note: this ioctl is deprecated in favor of VIDIOC_DBG_G_CHIP_INFO and
    will go away in the future. */
 #define VIDIOC_DBG_G_CHIP_IDENT _IOWR('V', 81, struct v4l2_dbg_chip_ident)
 
@@ -1976,7 +1976,7 @@ struct v4l2_create_buffers {
 
 /* Experimental, meant for debugging, testing and internal use.
    Never use these in applications! */
-#define VIDIOC_DBG_G_CHIP_NAME  _IOWR('V', 102, struct v4l2_dbg_chip_name)
+#define VIDIOC_DBG_G_CHIP_INFO  _IOWR('V', 102, struct v4l2_dbg_chip_info)
 
 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/video/v4l2-compat-ioctl32.c as well! */
-- 
1.7.10.4

