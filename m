Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2180 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab1KXNjR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 08:39:17 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 02/12] v4l spec: document VIDIOC_(TRY_)DECODER_CMD.
Date: Thu, 24 Nov 2011 14:38:59 +0100
Message-Id: <e148aa3f00f8f542d530137f5892e6207a0a7b67.1322141686.git.hans.verkuil@cisco.com>
In-Reply-To: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl>
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <07c1a0737016dcf588e866cde0f3bc1a59e35bfb.1322141686.git.hans.verkuil@cisco.com>
References: <07c1a0737016dcf588e866cde0f3bc1a59e35bfb.1322141686.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/v4l2.xml           |    1 +
 .../DocBook/media/v4l/vidioc-decoder-cmd.xml       |  256 ++++++++++++++++++++
 .../DocBook/media/v4l/vidioc-encoder-cmd.xml       |    9 +-
 3 files changed, 262 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml

diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index 2ab365c..7fc11db 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -473,6 +473,7 @@ and discussions on the V4L mailing list.</revremark>
     &sub-cropcap;
     &sub-dbg-g-chip-ident;
     &sub-dbg-g-register;
+    &sub-decoder-cmd;
     &sub-dqevent;
     &sub-encoder-cmd;
     &sub-enumaudio;
diff --git a/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml b/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
new file mode 100644
index 0000000..466fe27
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
@@ -0,0 +1,256 @@
+<refentry id="vidioc-decoder-cmd">
+  <refmeta>
+    <refentrytitle>ioctl VIDIOC_DECODER_CMD, VIDIOC_TRY_DECODER_CMD</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>VIDIOC_DECODER_CMD</refname>
+    <refname>VIDIOC_TRY_DECODER_CMD</refname>
+    <refpurpose>Execute an decoder command</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>struct v4l2_decoder_cmd *<parameter>argp</parameter></paramdef>
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
+	  <para>VIDIOC_DECODER_CMD, VIDIOC_TRY_DECODER_CMD</para>
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
+      <para>This is an <link linkend="experimental">experimental</link>
+interface and may change in the future.</para>
+    </note>
+
+    <para>These ioctls control an audio/video (usually MPEG-) decoder.
+<constant>VIDIOC_DECODER_CMD</constant> sends a command to the
+decoder, <constant>VIDIOC_TRY_DECODER_CMD</constant> can be used to
+try a command without actually executing it. To send a command applications
+must initialize all fields of a &v4l2-decoder-cmd; and call
+<constant>VIDIOC_DECODER_CMD</constant> or <constant>VIDIOC_TRY_DECODER_CMD</constant>
+with a pointer to this structure.</para>
+
+    <para>The <structfield>cmd</structfield> field must contain the
+command code. Some commands use the <structfield>flags</structfield> field for
+additional information.
+</para>
+
+    <para>A <function>write</function>() or &VIDIOC-STREAMON; call sends an implicit
+START command to the decoder if it has not been started yet.
+</para>
+
+    <para>A <function>close</function>() or &VIDIOC-STREAMOFF; call of a streaming
+file descriptor sends an implicit immediate STOP command to the decoder, and all
+buffered data is discarded.</para>
+
+    <para>These ioctls are optional, not all drivers may support
+them. They were introduced in Linux 3.3.</para>
+
+    <table pgwide="1" frame="none" id="v4l2-decoder-cmd">
+      <title>struct <structname>v4l2_decoder_cmd</structname></title>
+      <tgroup cols="5">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>cmd</structfield></entry>
+            <entry></entry>
+            <entry></entry>
+	    <entry>The decoder command, see <xref linkend="decoder-cmds" />.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>flags</structfield></entry>
+            <entry></entry>
+            <entry></entry>
+	    <entry>Flags to go with the command. If no flags are defined for
+this command, drivers and applications must set this field to zero.</entry>
+	  </row>
+	  <row>
+	    <entry>union</entry>
+	    <entry>(anonymous)</entry>
+            <entry></entry>
+	    <entry></entry>
+            <entry></entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry>struct</entry>
+            <entry><structfield>start</structfield></entry>
+            <entry></entry>
+            <entry>Structure containing additional data for the
+<constant>V4L2_DEC_CMD_START</constant> command.</entry>
+	  </row>
+	  <row>
+            <entry></entry>
+            <entry></entry>
+	    <entry>__u32</entry>
+	    <entry><structfield>speed</structfield></entry>
+            <entry>Playback speed and direction. The playback speed is defined as
+<structfield>speed</structfield>/1000 of the normal speed. So 1000 is normal playback.
+Negative numbers denote reverse playback, so -1000 does reverse playback at normal
+speed. Speeds -1, 0 and 1 have special meanings: speed 0 is shorthand for 1000
+(normal playback). A speed of 1 steps just one frame forward, a speed of -1 steps
+just one frame back.
+	    </entry>
+	  </row>
+	  <row>
+            <entry></entry>
+            <entry></entry>
+	    <entry>__u32</entry>
+	    <entry><structfield>format</structfield></entry>
+            <entry>Format restrictions. This field is set by the driver, not the
+application. Possible values are <constant>V4L2_DEC_START_FMT_NONE</constant> if
+there are no format restrictions or <constant>V4L2_DEC_START_FMT_GOP</constant>
+if the decoder operates on full GOPs (<wordasword>Group Of Pictures</wordasword>).
+This is usually the case for reverse playback: the decoder needs full GOPs, which
+it can then play in reverse order. So to implement reverse playback the application
+must feed the decoder the last GOP in the video file, then the GOP before that, etc. etc.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry>struct</entry>
+            <entry><structfield>stop</structfield></entry>
+            <entry></entry>
+            <entry>Structure containing additional data for the
+<constant>V4L2_DEC_CMD_STOP</constant> command.</entry>
+	  </row>
+	  <row>
+            <entry></entry>
+            <entry></entry>
+	    <entry>__u64</entry>
+	    <entry><structfield>pts</structfield></entry>
+            <entry>Stop playback at this <structfield>pts</structfield> or immediately
+if the playback is already past that timestamp. Leave to 0 if you want to stop after the
+last frame was decoded.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry>struct</entry>
+            <entry><structfield>raw</structfield></entry>
+            <entry></entry>
+            <entry></entry>
+	  </row>
+	  <row>
+            <entry></entry>
+            <entry></entry>
+	    <entry>__u32</entry>
+	    <entry><structfield>data</structfield>[16]</entry>
+	    <entry>Reserved for future extensions. Drivers and
+applications must set the array to zero.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table pgwide="1" frame="none" id="decoder-cmds">
+      <title>Decoder Commands</title>
+      <tgroup cols="3">
+	&cs-def;
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>V4L2_DEC_CMD_START</constant></entry>
+	    <entry>0</entry>
+	    <entry>Start the decoder. When the decoder is already
+running or paused, this command will just change the playback speed.
+That means that calling <constant>V4L2_DEC_CMD_START</constant> when
+the decoder was paused will <emphasis>not</emphasis> resume the decoder.
+You have to explicitly call <constant>V4L2_DEC_CMD_RESUME</constant> for that.
+This command has one flag:
+<constant>V4L2_DEC_CMD_START_MUTE_AUDIO</constant>. If set, then audio will
+be muted when playing back at a non-standard speed.
+            </entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_DEC_CMD_STOP</constant></entry>
+	    <entry>1</entry>
+	    <entry>Stop the decoder. When the decoder is already stopped,
+this command does nothing. This command has two flags:
+if <constant>V4L2_DEC_CMD_STOP_TO_BLACK</constant> is set, then the decoder will
+set the picture to black after it stopped decoding. Otherwise the last image will
+repeat. If <constant>V4L2_DEC_CMD_STOP_IMMEDIATELY</constant> is set, then the decoder
+stops immediately (ignoring the <structfield>pts</structfield> value), otherwise it
+will keep decoding until timestamp >= pts or until the last of the pending data from
+its internal buffers was decoded.
+</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_DEC_CMD_PAUSE</constant></entry>
+	    <entry>2</entry>
+	    <entry>Pause the decoder. When the decoder has not been
+started yet, the driver will return an &EPERM;. When the decoder is
+already paused, this command does nothing. This command has one flag:
+if <constant>V4L2_DEC_CMD_PAUSE_TO_BLACK</constant> is set, then set the
+decoder output to black when paused.
+</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_DEC_CMD_RESUME</constant></entry>
+	    <entry>3</entry>
+	    <entry>Resume decoding after a PAUSE command. When the
+decoder has not been started yet, the driver will return an &EPERM;.
+When the decoder is already running, this command does nothing. No
+flags are defined for this command.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+  </refsect1>
+
+  <refsect1>
+    &return-value;
+
+    <variablelist>
+      <varlistentry>
+	<term><errorcode>EINVAL</errorcode></term>
+	<listitem>
+	  <para>The <structfield>cmd</structfield> field is invalid.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><errorcode>EPERM</errorcode></term>
+	<listitem>
+	  <para>The application sent a PAUSE or RESUME command when
+the decoder was not running.</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+</refentry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml b/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
index af7f3f2..f431b3b 100644
--- a/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
@@ -74,15 +74,16 @@ only used by the STOP command and contains one bit: If the
 encoding will continue until the end of the current <wordasword>Group
 Of Pictures</wordasword>, otherwise it will stop immediately.</para>
 
-    <para>A <function>read</function>() call sends a START command to
-the encoder if it has not been started yet. After a STOP command,
+    <para>A <function>read</function>() or &VIDIOC-STREAMON; call sends an implicit
+START command to the encoder if it has not been started yet. After a STOP command,
 <function>read</function>() calls will read the remaining data
 buffered by the driver. When the buffer is empty,
 <function>read</function>() will return zero and the next
 <function>read</function>() call will restart the encoder.</para>
 
-    <para>A <function>close</function>() call sends an immediate STOP
-to the encoder, and all buffered data is discarded.</para>
+    <para>A <function>close</function>() or &VIDIOC-STREAMOFF; call of a streaming
+file descriptor sends an implicit immediate STOP to the encoder, and all buffered
+data is discarded.</para>
 
     <para>These ioctls are optional, not all drivers may support
 them. They were introduced in Linux 2.6.21.</para>
-- 
1.7.7.3

