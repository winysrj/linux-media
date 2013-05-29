Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3153 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965688Ab3E2LBL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:01:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCHv1 23/38] DocBook: remove references to the dropped VIDIOC_DBG_G_CHIP_IDENT ioctl.
Date: Wed, 29 May 2013 12:59:56 +0200
Message-Id: <1369825211-29770-24-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Documentation/DocBook/media/v4l/compat.xml         |   14 +-
 Documentation/DocBook/media/v4l/v4l2.xml           |   11 +-
 .../DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml  |  271 --------------------
 .../DocBook/media/v4l/vidioc-dbg-g-chip-info.xml   |   17 +-
 .../DocBook/media/v4l/vidioc-dbg-g-register.xml    |   40 +--
 5 files changed, 24 insertions(+), 329 deletions(-)
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index f43542a..0c7195e 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2254,7 +2254,7 @@ video encoding.</para>
       <orderedlist>
 	<listitem>
 	  <para>The <constant>VIDIOC_G_CHIP_IDENT</constant> ioctl was renamed
-to <constant>VIDIOC_G_CHIP_IDENT_OLD</constant> and &VIDIOC-DBG-G-CHIP-IDENT;
+to <constant>VIDIOC_G_CHIP_IDENT_OLD</constant> and <constant>VIDIOC_DBG_G_CHIP_IDENT</constant>
 was introduced in its place. The old struct <structname>v4l2_chip_ident</structname>
 was renamed to <structname id="v4l2-chip-ident-old">v4l2_chip_ident_old</structname>.</para>
 	</listitem>
@@ -2513,6 +2513,16 @@ that used it. It was originally scheduled for removal in 2.6.35.
       </orderedlist>
     </section>
 
+    <section>
+      <title>V4L2 in Linux 3.11</title>
+      <orderedlist>
+        <listitem>
+	  <para>Remove obsolete <constant>VIDIOC_DBG_G_CHIP_IDENT</constant> ioctl.
+	  </para>
+        </listitem>
+      </orderedlist>
+    </section>
+
     <section id="other">
       <title>Relation of V4L2 to other Linux multimedia APIs</title>
 
@@ -2596,7 +2606,7 @@ and may change in the future.</para>
 ioctls.</para>
         </listitem>
         <listitem>
-	  <para>&VIDIOC-DBG-G-CHIP-IDENT; ioctl.</para>
+	  <para>&VIDIOC-DBG-G-CHIP-INFO; ioctl.</para>
         </listitem>
         <listitem>
 	  <para>&VIDIOC-ENUM-DV-TIMINGS;, &VIDIOC-QUERY-DV-TIMINGS; and
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index bfc93cd..8469fe1 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -141,6 +141,14 @@ structs, ioctls) must be noted in more detail in the history chapter
 applications. -->
 
       <revision>
+	<revnumber>3.11</revnumber>
+	<date>2013-05-26</date>
+	<authorinitials>hv</authorinitials>
+	<revremark>Remove obsolete VIDIOC_DBG_G_CHIP_IDENT ioctl.
+	</revremark>
+      </revision>
+
+      <revision>
 	<revnumber>3.10</revnumber>
 	<date>2013-03-25</date>
 	<authorinitials>hv</authorinitials>
@@ -493,7 +501,7 @@ and discussions on the V4L mailing list.</revremark>
 </partinfo>
 
 <title>Video for Linux Two API Specification</title>
- <subtitle>Revision 3.9</subtitle>
+ <subtitle>Revision 3.11</subtitle>
 
   <chapter id="common">
     &sub-common;
@@ -547,7 +555,6 @@ and discussions on the V4L mailing list.</revremark>
     <!-- All ioctls go here. -->
     &sub-create-bufs;
     &sub-cropcap;
-    &sub-dbg-g-chip-ident;
     &sub-dbg-g-chip-info;
     &sub-dbg-g-register;
     &sub-decoder-cmd;
diff --git a/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml b/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml
deleted file mode 100644
index 921e185..0000000
--- a/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml
+++ /dev/null
@@ -1,271 +0,0 @@
-<refentry id="vidioc-dbg-g-chip-ident">
-  <refmeta>
-    <refentrytitle>ioctl VIDIOC_DBG_G_CHIP_IDENT</refentrytitle>
-    &manvol;
-  </refmeta>
-
-  <refnamediv>
-    <refname>VIDIOC_DBG_G_CHIP_IDENT</refname>
-    <refpurpose>Identify the chips on a TV card</refpurpose>
-  </refnamediv>
-
-  <refsynopsisdiv>
-    <funcsynopsis>
-      <funcprototype>
-	<funcdef>int <function>ioctl</function></funcdef>
-	<paramdef>int <parameter>fd</parameter></paramdef>
-	<paramdef>int <parameter>request</parameter></paramdef>
-	<paramdef>struct v4l2_dbg_chip_ident
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
-	  <para>VIDIOC_DBG_G_CHIP_IDENT</para>
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
-    <para>To query the driver applications must initialize the
-<structfield>match.type</structfield> and
-<structfield>match.addr</structfield> or <structfield>match.name</structfield>
-fields of a &v4l2-dbg-chip-ident;
-and call <constant>VIDIOC_DBG_G_CHIP_IDENT</constant> with a pointer to
-this structure. On success the driver stores information about the
-selected chip in the <structfield>ident</structfield> and
-<structfield>revision</structfield> fields. On failure the structure
-remains unchanged.</para>
-
-    <para>When <structfield>match.type</structfield> is
-<constant>V4L2_CHIP_MATCH_HOST</constant>,
-<structfield>match.addr</structfield> selects the nth non-&i2c; chip
-on the TV card. You can enumerate all chips by starting at zero and
-incrementing <structfield>match.addr</structfield> by one until
-<constant>VIDIOC_DBG_G_CHIP_IDENT</constant> fails with an &EINVAL;.
-The number zero always selects the host chip, &eg; the chip connected
-to the PCI or USB bus.</para>
-
-    <para>When <structfield>match.type</structfield> is
-<constant>V4L2_CHIP_MATCH_I2C_DRIVER</constant>,
-<structfield>match.name</structfield> contains the I2C driver name.
-For instance
-<constant>"saa7127"</constant> will match any chip
-supported by the saa7127 driver, regardless of its &i2c; bus address.
-When multiple chips supported by the same driver are present, the
-ioctl will return <constant>V4L2_IDENT_AMBIGUOUS</constant> in the
-<structfield>ident</structfield> field.</para>
-
-    <para>When <structfield>match.type</structfield> is
-<constant>V4L2_CHIP_MATCH_I2C_ADDR</constant>,
-<structfield>match.addr</structfield> selects a chip by its 7 bit
-&i2c; bus address.</para>
-
-    <para>When <structfield>match.type</structfield> is
-<constant>V4L2_CHIP_MATCH_AC97</constant>,
-<structfield>match.addr</structfield> selects the nth AC97 chip
-on the TV card. You can enumerate all chips by starting at zero and
-incrementing <structfield>match.addr</structfield> by one until
-<constant>VIDIOC_DBG_G_CHIP_IDENT</constant> fails with an &EINVAL;.</para>
-
-    <para>On success, the <structfield>ident</structfield> field will
-contain a chip ID from the Linux
-<filename>media/v4l2-chip-ident.h</filename> header file, and the
-<structfield>revision</structfield> field will contain a driver
-specific value, or zero if no particular revision is associated with
-this chip.</para>
-
-    <para>When the driver could not identify the selected chip,
-<structfield>ident</structfield> will contain
-<constant>V4L2_IDENT_UNKNOWN</constant>. When no chip matched
-the ioctl will succeed but the
-<structfield>ident</structfield> field will contain
-<constant>V4L2_IDENT_NONE</constant>. If multiple chips matched,
-<structfield>ident</structfield> will contain
-<constant>V4L2_IDENT_AMBIGUOUS</constant>. In all these cases the
-<structfield>revision</structfield> field remains unchanged.</para>
-
-    <para>This ioctl is optional, not all drivers may support it. It
-was introduced in Linux 2.6.21, but the API was changed to the
-one described here in 2.6.29.</para>
-
-    <para>We recommended the <application>v4l2-dbg</application>
-utility over calling this ioctl directly. It is available from the
-LinuxTV v4l-dvb repository; see <ulink
-url="http://linuxtv.org/repo/">http://linuxtv.org/repo/</ulink> for
-access instructions.</para>
-
-    <!-- Note for convenience vidioc-dbg-g-register.sgml
-	 contains a duplicate of this table. -->
-    <table pgwide="1" frame="none" id="ident-v4l2-dbg-match">
-      <title>struct <structname>v4l2_dbg_match</structname></title>
-      <tgroup cols="4">
-	&cs-ustr;
-	<tbody valign="top">
-	  <row>
-	    <entry>__u32</entry>
-	    <entry><structfield>type</structfield></entry>
-	    <entry>See <xref linkend="ident-chip-match-types" /> for a list of
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
-    <table pgwide="1" frame="none" id="v4l2-dbg-chip-ident">
-      <title>struct <structname>v4l2_dbg_chip_ident</structname></title>
-      <tgroup cols="3">
-	&cs-str;
-	<tbody valign="top">
-	  <row>
-	    <entry>struct v4l2_dbg_match</entry>
-	    <entry><structfield>match</structfield></entry>
-	    <entry>How to match the chip, see <xref linkend="ident-v4l2-dbg-match" />.</entry>
-	  </row>
-	  <row>
-	    <entry>__u32</entry>
-	    <entry><structfield>ident</structfield></entry>
-	    <entry>A chip identifier as defined in the Linux
-<filename>media/v4l2-chip-ident.h</filename> header file, or one of
-the values from <xref linkend="chip-ids" />.</entry>
-	  </row>
-	  <row>
-	    <entry>__u32</entry>
-	    <entry><structfield>revision</structfield></entry>
-	    <entry>A chip revision, chip and driver specific.</entry>
-	  </row>
-	</tbody>
-      </tgroup>
-    </table>
-
-    <!-- Note for convenience vidioc-dbg-g-register.sgml
-	 contains a duplicate of this table. -->
-    <table pgwide="1" frame="none" id="ident-chip-match-types">
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
-	    <entry>Match an &i2c; chip by its driver name.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>V4L2_CHIP_MATCH_I2C_ADDR</constant></entry>
-	    <entry>2</entry>
-	    <entry>Match a chip by its 7 bit &i2c; bus address.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>V4L2_CHIP_MATCH_AC97</constant></entry>
-	    <entry>3</entry>
-	    <entry>Match the nth anciliary AC97 chip.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>V4L2_CHIP_MATCH_SUBDEV</constant></entry>
-	    <entry>4</entry>
-	    <entry>Match the nth sub-device. Can't be used with this ioctl.</entry>
-	  </row>
-	</tbody>
-      </tgroup>
-    </table>
-
-    <!-- This is an anonymous enum in media/v4l2-chip-ident.h. -->
-    <table pgwide="1" frame="none" id="chip-ids">
-      <title>Chip Identifiers</title>
-      <tgroup cols="3">
-	&cs-def;
-	<tbody valign="top">
-	  <row>
-	    <entry><constant>V4L2_IDENT_NONE</constant></entry>
-	    <entry>0</entry>
-	    <entry>No chip matched.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>V4L2_IDENT_AMBIGUOUS</constant></entry>
-	    <entry>1</entry>
-	    <entry>Multiple chips matched.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>V4L2_IDENT_UNKNOWN</constant></entry>
-	    <entry>2</entry>
-	    <entry>A chip is present at this address, but the driver
-could not identify it.</entry>
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
-	  <para>The <structfield>match_type</structfield> is invalid.</para>
-	</listitem>
-      </varlistentry>
-     </variablelist>
-  </refsect1>
-</refentry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-info.xml b/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-info.xml
index e1cece6..706989d 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-info.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-info.xml
@@ -132,7 +132,7 @@ to the <structfield>type</structfield> field.</entry>
 	    <entry>char</entry>
 	    <entry><structfield>name[32]</structfield></entry>
 	    <entry>Match a chip by this name, interpreted according
-to the <structfield>type</structfield> field.</entry>
+to the <structfield>type</structfield> field. Currently unused.</entry>
 	  </row>
 	</tbody>
       </tgroup>
@@ -183,21 +183,6 @@ is set, then the driver supports reading registers from the device. If
 	    bridge chip. Does not match sub-devices.</entry>
 	  </row>
 	  <row>
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
 	    <entry><constant>V4L2_CHIP_MATCH_SUBDEV</constant></entry>
 	    <entry>4</entry>
 	    <entry>Match the nth sub-device.</entry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml b/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml
index d13bac9..8d554db 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml
@@ -102,27 +102,6 @@ chip connected to the PCI or USB bus. You can find out which chips are
 present with the &VIDIOC-DBG-G-CHIP-INFO; ioctl.</para>
 
     <para>When <structfield>match.type</structfield> is
-<constant>V4L2_CHIP_MATCH_I2C_DRIVER</constant>,
-<structfield>match.name</structfield> contains the I2C driver name.
-For instance
-<constant>"saa7127"</constant> will match any chip
-supported by the saa7127 driver, regardless of its &i2c; bus address.
-When multiple chips supported by the same driver are present, the
-effect of these ioctls is undefined. Again with the
-&VIDIOC-DBG-G-CHIP-INFO; ioctl you can find out which &i2c; chips are
-present.</para>
-
-    <para>When <structfield>match.type</structfield> is
-<constant>V4L2_CHIP_MATCH_I2C_ADDR</constant>,
-<structfield>match.addr</structfield> selects a chip by its 7 bit &i2c;
-bus address.</para>
-
-    <para>When <structfield>match.type</structfield> is
-<constant>V4L2_CHIP_MATCH_AC97</constant>,
-<structfield>match.addr</structfield> selects the nth AC97 chip
-on the TV card.</para>
-
-    <para>When <structfield>match.type</structfield> is
 <constant>V4L2_CHIP_MATCH_SUBDEV</constant>,
 <structfield>match.addr</structfield> selects the nth sub-device.</para>
 
@@ -160,7 +139,7 @@ access instructions.</para>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>type</structfield></entry>
-	    <entry>See <xref linkend="ident-chip-match-types" /> for a list of
+	    <entry>See <xref linkend="chip-match-types" /> for a list of
 possible types.</entry>
 	  </row>
 	  <row>
@@ -179,7 +158,7 @@ to the <structfield>type</structfield> field.</entry>
 	    <entry>char</entry>
 	    <entry><structfield>name[32]</structfield></entry>
 	    <entry>Match a chip by this name, interpreted according
-to the <structfield>type</structfield> field.</entry>
+to the <structfield>type</structfield> field. Currently unused.</entry>
 	  </row>
 	</tbody>
       </tgroup>
@@ -227,21 +206,6 @@ register.</entry>
 	    bridge chip. Does not match sub-devices.</entry>
 	  </row>
 	  <row>
-	    <entry><constant>V4L2_CHIP_MATCH_I2C_DRIVER</constant></entry>
-	    <entry>1</entry>
-	    <entry>Match an &i2c; chip by its driver name.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>V4L2_CHIP_MATCH_I2C_ADDR</constant></entry>
-	    <entry>2</entry>
-	    <entry>Match a chip by its 7 bit &i2c; bus address.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>V4L2_CHIP_MATCH_AC97</constant></entry>
-	    <entry>3</entry>
-	    <entry>Match the nth anciliary AC97 chip.</entry>
-	  </row>
-	  <row>
 	    <entry><constant>V4L2_CHIP_MATCH_SUBDEV</constant></entry>
 	    <entry>4</entry>
 	    <entry>Match the nth sub-device.</entry>
-- 
1.7.10.4

