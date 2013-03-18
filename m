Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3759 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab3CRQir (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 12:38:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	Frank Schaefer <fschaefer.oss@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 6/6] DocBook media: add VIDIOC_DBG_G_CHIP_NAME documentation
Date: Mon, 18 Mar 2013 17:38:20 +0100
Message-Id: <1363624700-29270-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363624700-29270-1-git-send-email-hverkuil@xs4all.nl>
References: <1363624700-29270-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

And update the other debug ioctls accordingly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/v4l2.xml           |    4 +-
 .../DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml  |   14 +-
 .../DocBook/media/v4l/vidioc-dbg-g-chip-name.xml   |  234 ++++++++++++++++++++
 .../DocBook/media/v4l/vidioc-dbg-g-register.xml    |   42 +++-
 4 files changed, 280 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-name.xml

diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index a3cce18..a3c7adb7 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -144,8 +144,7 @@ applications. -->
 	<date>2012-12-03</date>
 	<authorinitials>sa, sn</authorinitials>
 	<revremark>Added timestamp types to v4l2_buffer.
-	Added <constant>V4L2_EVENT_CTRL_CH_RANGE</constant> control
-	event changes flag, see <xref linkend="changes-flags"/>.
+	Added V4L2_EVENT_CTRL_CH_RANGE control event changes flag.
 	</revremark>
       </revision>
 
@@ -537,6 +536,7 @@ and discussions on the V4L mailing list.</revremark>
     &sub-create-bufs;
     &sub-cropcap;
     &sub-dbg-g-chip-ident;
+    &sub-dbg-g-chip-name;
     &sub-dbg-g-register;
     &sub-decoder-cmd;
     &sub-dqevent;
diff --git a/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml b/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml
index 4ecd966..82e43c6 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml
@@ -200,10 +200,10 @@ the values from <xref linkend="chip-ids" />.</entry>
 	&cs-def;
 	<tbody valign="top">
 	  <row>
-	    <entry><constant>V4L2_CHIP_MATCH_HOST</constant></entry>
+	    <entry><constant>V4L2_CHIP_MATCH_BRIDGE</constant></entry>
 	    <entry>0</entry>
 	    <entry>Match the nth chip on the card, zero for the
-	    host chip. Does not match &i2c; chips.</entry>
+	    bridge chip. Does not match sub-devices.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_CHIP_MATCH_I2C_DRIVER</constant></entry>
@@ -220,6 +220,16 @@ the values from <xref linkend="chip-ids" />.</entry>
 	    <entry>3</entry>
 	    <entry>Match the nth anciliary AC97 chip.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_CHIP_MATCH_SUBDEV_NAME</constant></entry>
+	    <entry>4</entry>
+	    <entry>Match the sub-device by name. Can't be used with this ioctl.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_CHIP_MATCH_SUBDEV_IDX</constant></entry>
+	    <entry>5</entry>
+	    <entry>Match the nth sub-device. Can't be used with this ioctl.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-name.xml b/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-name.xml
new file mode 100644
index 0000000..4921346
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-name.xml
@@ -0,0 +1,234 @@
+<refentry id="vidioc-dbg-g-chip-name">
+  <refmeta>
+    <refentrytitle>ioctl VIDIOC_DBG_G_CHIP_NAME</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>VIDIOC_DBG_G_CHIP_NAME</refname>
+    <refpurpose>Identify the chips on a TV card</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>struct v4l2_dbg_chip_name
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
+	  <para>VIDIOC_DBG_G_CHIP_NAME</para>
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
+    <para>To query the driver applications must initialize the
+<structfield>match.type</structfield> and
+<structfield>match.addr</structfield> or <structfield>match.name</structfield>
+fields of a &v4l2-dbg-chip-name;
+and call <constant>VIDIOC_DBG_G_CHIP_NAME</constant> with a pointer to
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
+<constant>VIDIOC_DBG_G_CHIP_NAME</constant> fails with an &EINVAL;.
+The number zero always selects the bridge chip itself, &eg; the chip
+connected to the PCI or USB bus. Non-zero numbers identify specific
+parts of the bridge chip such as an AC97 register block.</para>
+
+    <para>When <structfield>match.type</structfield> is
+<constant>V4L2_CHIP_MATCH_SUBDEV_NAME</constant>,
+<structfield>match.name</structfield> contains the name of a sub-device.
+For instance
+<constant>"saa7127 6-0044"</constant> will match the saa7127 sub-device
+at the given i2c bus. This match type is not very useful for this ioctl
+and is here only for consistency.
+</para>
+
+    <para>When <structfield>match.type</structfield> is
+<constant>V4L2_CHIP_MATCH_SUBDEV_IDX</constant>,
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
+    <table pgwide="1" frame="none" id="v4l2-dbg-chip-name">
+      <title>struct <structname>v4l2_dbg_chip_name</structname></title>
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
+	    <entry><constant>V4L2_CHIP_MATCH_SUBDEV_NAME</constant></entry>
+	    <entry>4</entry>
+	    <entry>Match the sub-device by name.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_CHIP_MATCH_SUBDEV_IDX</constant></entry>
+	    <entry>5</entry>
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
diff --git a/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml b/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml
index a44aebc..3082b41 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml
@@ -87,7 +87,7 @@ written into the register.</para>
 
     <para>To read a register applications must initialize the
 <structfield>match.type</structfield>,
-<structfield>match.chip</structfield> or <structfield>match.name</structfield> and
+<structfield>match.addr</structfield> or <structfield>match.name</structfield> and
 <structfield>reg</structfield> fields, and call
 <constant>VIDIOC_DBG_G_REGISTER</constant> with a pointer to this
 structure. On success the driver stores the register value in the
@@ -95,11 +95,11 @@ structure. On success the driver stores the register value in the
 unchanged.</para>
 
     <para>When <structfield>match.type</structfield> is
-<constant>V4L2_CHIP_MATCH_HOST</constant>,
-<structfield>match.addr</structfield> selects the nth non-&i2c; chip
+<constant>V4L2_CHIP_MATCH_BRIDGE</constant>,
+<structfield>match.addr</structfield> selects the nth non-sub-device chip
 on the TV card.  The number zero always selects the host chip, &eg; the
 chip connected to the PCI or USB bus. You can find out which chips are
-present with the &VIDIOC-DBG-G-CHIP-IDENT; ioctl.</para>
+present with the &VIDIOC-DBG-G-CHIP-NAME; ioctl.</para>
 
     <para>When <structfield>match.type</structfield> is
 <constant>V4L2_CHIP_MATCH_I2C_DRIVER</constant>,
@@ -109,7 +109,7 @@ For instance
 supported by the saa7127 driver, regardless of its &i2c; bus address.
 When multiple chips supported by the same driver are present, the
 effect of these ioctls is undefined. Again with the
-&VIDIOC-DBG-G-CHIP-IDENT; ioctl you can find out which &i2c; chips are
+&VIDIOC-DBG-G-CHIP-NAME; ioctl you can find out which &i2c; chips are
 present.</para>
 
     <para>When <structfield>match.type</structfield> is
@@ -122,19 +122,31 @@ bus address.</para>
 <structfield>match.addr</structfield> selects the nth AC97 chip
 on the TV card.</para>
 
+    <para>When <structfield>match.type</structfield> is
+<constant>V4L2_CHIP_MATCH_SUBDEV_NAME</constant>,
+<structfield>match.name</structfield> contains the sub-device name.
+For instance
+<constant>"saa7127 6-0044"</constant> will match this specific saa7127
+sub-device. Again with the &VIDIOC-DBG-G-CHIP-NAME; ioctl you can find
+out which sub-devices are present.</para>
+
+    <para>When <structfield>match.type</structfield> is
+<constant>V4L2_CHIP_MATCH_SUBDEV_IDX</constant>,
+<structfield>match.addr</structfield> selects the nth sub-device.</para>
+
     <note>
       <title>Success not guaranteed</title>
 
       <para>Due to a flaw in the Linux &i2c; bus driver these ioctls may
 return successfully without actually reading or writing a register. To
-catch the most likely failure we recommend a &VIDIOC-DBG-G-CHIP-IDENT;
+catch the most likely failure we recommend a &VIDIOC-DBG-G-CHIP-NAME;
 call confirming the presence of the selected &i2c; chip.</para>
     </note>
 
     <para>These ioctls are optional, not all drivers may support them.
 However when a driver supports these ioctls it must also support
-&VIDIOC-DBG-G-CHIP-IDENT;. Conversely it may support
-<constant>VIDIOC_DBG_G_CHIP_IDENT</constant> but not these ioctls.</para>
+&VIDIOC-DBG-G-CHIP-NAME;. Conversely it may support
+<constant>VIDIOC_DBG_G_CHIP_NAME</constant> but not these ioctls.</para>
 
     <para><constant>VIDIOC_DBG_G_REGISTER</constant> and
 <constant>VIDIOC_DBG_S_REGISTER</constant> were introduced in Linux
@@ -217,10 +229,10 @@ register.</entry>
 	&cs-def;
 	<tbody valign="top">
 	  <row>
-	    <entry><constant>V4L2_CHIP_MATCH_HOST</constant></entry>
+	    <entry><constant>V4L2_CHIP_MATCH_BRIDGE</constant></entry>
 	    <entry>0</entry>
 	    <entry>Match the nth chip on the card, zero for the
-	    host chip. Does not match &i2c; chips.</entry>
+	    bridge chip. Does not match sub-devices.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_CHIP_MATCH_I2C_DRIVER</constant></entry>
@@ -237,6 +249,16 @@ register.</entry>
 	    <entry>3</entry>
 	    <entry>Match the nth anciliary AC97 chip.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_CHIP_MATCH_SUBDEV_NAME</constant></entry>
+	    <entry>4</entry>
+	    <entry>Match the sub-device by name.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_CHIP_MATCH_SUBDEV_IDX</constant></entry>
+	    <entry>5</entry>
+	    <entry>Match the nth sub-device.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
-- 
1.7.10.4

