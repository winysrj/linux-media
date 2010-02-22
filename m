Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:40237 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab0BVXBz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 18:01:55 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	david.cohen@nokia.com
Subject: [PATCH v7 6/6] V4L: Events: Add documentation
Date: Tue, 23 Feb 2010 01:01:41 +0200
Message-Id: <1266879701-9814-6-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4B830CCA.8030909@maxwell.research.nokia.com>
References: <4B830CCA.8030909@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add documentation on how to use V4L2 events, both for V4L2 drivers and for
V4L2 applications.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 Documentation/DocBook/media-entities.tmpl          |    9 ++
 Documentation/DocBook/v4l/dev-event.xml            |   33 +++++
 Documentation/DocBook/v4l/v4l2.xml                 |    3 +
 Documentation/DocBook/v4l/vidioc-dqevent.xml       |  124 ++++++++++++++++++++
 .../DocBook/v4l/vidioc-subscribe-event.xml         |  104 ++++++++++++++++
 Documentation/video4linux/v4l2-framework.txt       |   57 +++++++++
 6 files changed, 330 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/dev-event.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-dqevent.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-subscribe-event.xml

diff --git a/Documentation/DocBook/media-entities.tmpl b/Documentation/DocBook/media-entities.tmpl
index c725cb8..770be3c 100644
--- a/Documentation/DocBook/media-entities.tmpl
+++ b/Documentation/DocBook/media-entities.tmpl
@@ -17,6 +17,7 @@
 <!ENTITY VIDIOC-DBG-G-REGISTER "<link linkend='vidioc-dbg-g-register'><constant>VIDIOC_DBG_G_REGISTER</constant></link>">
 <!ENTITY VIDIOC-DBG-S-REGISTER "<link linkend='vidioc-dbg-g-register'><constant>VIDIOC_DBG_S_REGISTER</constant></link>">
 <!ENTITY VIDIOC-DQBUF "<link linkend='vidioc-qbuf'><constant>VIDIOC_DQBUF</constant></link>">
+<!ENTITY VIDIOC-DQEVENT "<link linkend='vidioc-dqevent'><constant>VIDIOC_DQEVENT</constant></link>">
 <!ENTITY VIDIOC-ENCODER-CMD "<link linkend='vidioc-encoder-cmd'><constant>VIDIOC_ENCODER_CMD</constant></link>">
 <!ENTITY VIDIOC-ENUMAUDIO "<link linkend='vidioc-enumaudio'><constant>VIDIOC_ENUMAUDIO</constant></link>">
 <!ENTITY VIDIOC-ENUMAUDOUT "<link linkend='vidioc-enumaudioout'><constant>VIDIOC_ENUMAUDOUT</constant></link>">
@@ -60,6 +61,7 @@
 <!ENTITY VIDIOC-REQBUFS "<link linkend='vidioc-reqbufs'><constant>VIDIOC_REQBUFS</constant></link>">
 <!ENTITY VIDIOC-STREAMOFF "<link linkend='vidioc-streamon'><constant>VIDIOC_STREAMOFF</constant></link>">
 <!ENTITY VIDIOC-STREAMON "<link linkend='vidioc-streamon'><constant>VIDIOC_STREAMON</constant></link>">
+<!ENTITY VIDIOC-SUBSCRIBE-EVENT "<link linkend='vidioc-subscribe-event'><constant>VIDIOC_SUBSCRIBE_EVENT</constant></link>">
 <!ENTITY VIDIOC-S-AUDIO "<link linkend='vidioc-g-audio'><constant>VIDIOC_S_AUDIO</constant></link>">
 <!ENTITY VIDIOC-S-AUDOUT "<link linkend='vidioc-g-audioout'><constant>VIDIOC_S_AUDOUT</constant></link>">
 <!ENTITY VIDIOC-S-CROP "<link linkend='vidioc-g-crop'><constant>VIDIOC_S_CROP</constant></link>">
@@ -141,6 +143,8 @@
 <!ENTITY v4l2-enc-idx "struct&nbsp;<link linkend='v4l2-enc-idx'>v4l2_enc_idx</link>">
 <!ENTITY v4l2-enc-idx-entry "struct&nbsp;<link linkend='v4l2-enc-idx-entry'>v4l2_enc_idx_entry</link>">
 <!ENTITY v4l2-encoder-cmd "struct&nbsp;<link linkend='v4l2-encoder-cmd'>v4l2_encoder_cmd</link>">
+<!ENTITY v4l2-event "struct&nbsp;<link linkend='v4l2-event'>v4l2_event</link>">
+<!ENTITY v4l2-event-subscription "struct&nbsp;<link linkend='v4l2-event-subscription'>v4l2_event_subscription</link>">
 <!ENTITY v4l2-ext-control "struct&nbsp;<link linkend='v4l2-ext-control'>v4l2_ext_control</link>">
 <!ENTITY v4l2-ext-controls "struct&nbsp;<link linkend='v4l2-ext-controls'>v4l2_ext_controls</link>">
 <!ENTITY v4l2-fmtdesc "struct&nbsp;<link linkend='v4l2-fmtdesc'>v4l2_fmtdesc</link>">
@@ -200,6 +204,7 @@
 <!ENTITY sub-controls SYSTEM "v4l/controls.xml">
 <!ENTITY sub-dev-capture SYSTEM "v4l/dev-capture.xml">
 <!ENTITY sub-dev-codec SYSTEM "v4l/dev-codec.xml">
+<!ENTITY sub-dev-event SYSTEM "v4l/dev-event.xml">
 <!ENTITY sub-dev-effect SYSTEM "v4l/dev-effect.xml">
 <!ENTITY sub-dev-osd SYSTEM "v4l/dev-osd.xml">
 <!ENTITY sub-dev-output SYSTEM "v4l/dev-output.xml">
@@ -292,6 +297,8 @@
 <!ENTITY sub-v4l2grab-c SYSTEM "v4l/v4l2grab.c.xml">
 <!ENTITY sub-videodev2-h SYSTEM "v4l/videodev2.h.xml">
 <!ENTITY sub-v4l2 SYSTEM "v4l/v4l2.xml">
+<!ENTITY sub-dqevent SYSTEM "v4l/vidioc-dqevent.xml">
+<!ENTITY sub-subscribe-event SYSTEM "v4l/vidioc-subscribe-event.xml">
 <!ENTITY sub-intro SYSTEM "dvb/intro.xml">
 <!ENTITY sub-frontend SYSTEM "dvb/frontend.xml">
 <!ENTITY sub-dvbproperty SYSTEM "dvb/dvbproperty.xml">
@@ -381,3 +388,5 @@
 <!ENTITY reqbufs SYSTEM "v4l/vidioc-reqbufs.xml">
 <!ENTITY s-hw-freq-seek SYSTEM "v4l/vidioc-s-hw-freq-seek.xml">
 <!ENTITY streamon SYSTEM "v4l/vidioc-streamon.xml">
+<!ENTITY dqevent SYSTEM "v4l/vidioc-dqevent.xml">
+<!ENTITY subscribe_event SYSTEM "v4l/vidioc-subscribe-event.xml">
diff --git a/Documentation/DocBook/v4l/dev-event.xml b/Documentation/DocBook/v4l/dev-event.xml
new file mode 100644
index 0000000..ecee64d
--- /dev/null
+++ b/Documentation/DocBook/v4l/dev-event.xml
@@ -0,0 +1,33 @@
+  <title>Event Interface</title>
+
+  <para>The V4L2 event interface provides means for user to get
+  immediately notified on certain conditions taking place on a device.
+  This might include start of frame or loss of signal events, for
+  example.
+  </para>
+
+  <para>To receive events, the events the user is interested first must be
+  subscribed using the &VIDIOC-SUBSCRIBE-EVENT; ioctl. Once an event is
+  subscribed, the events of subscribed types are dequeueable using the
+  &VIDIOC-DQEVENT; ioctl. Events may be unsubscribed using
+  VIDIOC_UNSUBSCRIBE_EVENT ioctl. The special event type V4L2_EVENT_ALL may
+  be used to unsubscribe all the events the driver supports.</para>
+
+  <para>The event subscriptions and event queues are specific to file
+  handles. Subscribing an event on one file handle does not affect
+  other file handles.
+  </para>
+
+  <para>The information on dequeueable events are obtained by using
+  select or poll system calls on video devices. The V4L2 events use
+  POLLPRI events on poll system call and exceptions on select system
+  call.
+  </para>
+
+  <!--
+Local Variables:
+mode: sgml
+sgml-parent-document: "v4l2.sgml"
+indent-tabs-mode: nil
+End:
+  -->
diff --git a/Documentation/DocBook/v4l/v4l2.xml b/Documentation/DocBook/v4l/v4l2.xml
index 060105a..9737243 100644
--- a/Documentation/DocBook/v4l/v4l2.xml
+++ b/Documentation/DocBook/v4l/v4l2.xml
@@ -401,6 +401,7 @@ and discussions on the V4L mailing list.</revremark>
     <section id="ttx"> &sub-dev-teletext; </section>
     <section id="radio"> &sub-dev-radio; </section>
     <section id="rds"> &sub-dev-rds; </section>
+    <section id="event"> &sub-dev-event; </section>
   </chapter>
 
   <chapter id="driver">
@@ -426,6 +427,7 @@ and discussions on the V4L mailing list.</revremark>
     &sub-cropcap;
     &sub-dbg-g-chip-ident;
     &sub-dbg-g-register;
+    &sub-dqevent;
     &sub-encoder-cmd;
     &sub-enumaudio;
     &sub-enumaudioout;
@@ -467,6 +469,7 @@ and discussions on the V4L mailing list.</revremark>
     &sub-reqbufs;
     &sub-s-hw-freq-seek;
     &sub-streamon;
+    &sub-subscribe-event;
     <!-- End of ioctls. -->
     &sub-mmap;
     &sub-munmap;
diff --git a/Documentation/DocBook/v4l/vidioc-dqevent.xml b/Documentation/DocBook/v4l/vidioc-dqevent.xml
new file mode 100644
index 0000000..eb45c16
--- /dev/null
+++ b/Documentation/DocBook/v4l/vidioc-dqevent.xml
@@ -0,0 +1,124 @@
+<refentry id="vidioc-dqevent">
+  <refmeta>
+    <refentrytitle>ioctl VIDIOC_DQEVENT</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>VIDIOC_DQEVENT</refname>
+    <refpurpose>Dequeue event</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>struct v4l2_event
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
+	  <para>VIDIOC_DQEVENT</para>
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
+    <para>Dequeue an event from a video device. No input is required
+    for this ioctl. All the fields of the &v4l2-event; structure are
+    filled by the driver. The file handle will also receive exceptions
+    which the application may get by e.g. using the select system
+    call.</para>
+
+    <table frame="none" pgwide="1" id="v4l2-event">
+      <title>struct <structname>v4l2_event</structname></title>
+      <tgroup cols="4">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>type</structfield></entry>
+            <entry></entry>
+	    <entry>Type of the event.</entry>
+	  </row>
+	  <row>
+	    <entry>union</entry>
+	    <entry><structfield>u</structfield></entry>
+            <entry></entry>
+	    <entry></entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry>__u8</entry>
+            <entry><structfield>data</structfield>[64]</entry>
+	    <entry>Event data. Defined by the event type. The union
+            should be used to define easily accessible type for
+            events.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>pending</structfield></entry>
+            <entry></entry>
+	    <entry>Number of pending events excluding this one.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>sequence</structfield></entry>
+            <entry></entry>
+	    <entry>Event sequence number. The sequence number is
+	    incremented for every subscribed event that takes place.
+	    If sequence numbers are not contiguous it means that
+	    events have been lost.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry>struct timeval</entry>
+	    <entry><structfield>timestamp</structfield></entry>
+            <entry></entry>
+	    <entry>Event timestamp.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[9]</entry>
+            <entry></entry>
+	    <entry>Reserved for future extensions. Drivers must set
+	    the array to zero.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+  </refsect1>
+</refentry>
+<!--
+Local Variables:
+mode: sgml
+sgml-parent-document: "v4l2.sgml"
+indent-tabs-mode: nil
+End:
+-->
diff --git a/Documentation/DocBook/v4l/vidioc-subscribe-event.xml b/Documentation/DocBook/v4l/vidioc-subscribe-event.xml
new file mode 100644
index 0000000..71ab88c
--- /dev/null
+++ b/Documentation/DocBook/v4l/vidioc-subscribe-event.xml
@@ -0,0 +1,104 @@
+<refentry id="vidioc-subscribe-event">
+  <refmeta>
+    <refentrytitle>ioctl VIDIOC_SUBSCRIBE_EVENT, VIDIOC_UNSUBSCRIBE_EVENT</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>VIDIOC_SUBSCRIBE_EVENT, VIDIOC_UNSUBSCRIBE_EVENT</refname>
+    <refpurpose>Subscribe or unsubscribe event</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>struct v4l2_event_subscription
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
+	  <para>VIDIOC_SUBSCRIBE_EVENT, VIDIOC_UNSUBSCRIBE_EVENT</para>
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
+    <para>Subscribe or unsubscribe V4L2 event. Subscribed events are
+    dequeued by using the &VIDIOC-DQEVENT; ioctl.</para>
+
+    <table frame="none" pgwide="1" id="v4l2-event-subscription">
+      <title>struct <structname>v4l2_event_subscription</structname></title>
+      <tgroup cols="3">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>type</structfield></entry>
+	    <entry>Type of the event.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[7]</entry>
+	    <entry>Reserved for future extensions. Drivers and applications
+	    must set the array to zero.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table frame="none" pgwide="1" id="event-type">
+      <title>Event Types</title>
+      <tgroup cols="3">
+	&cs-def;
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>V4L2_EVENT_ALL</constant></entry>
+	    <entry>0</entry>
+	    <entry>All events. V4L2_EVENT_ALL is valid only for
+	    VIDIOC_UNSUBSCRIBE_EVENT for unsubscribing all events at once.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_EVENT_PRIVATE_START</constant></entry>
+	    <entry>0x08000000</entry>
+	    <entry>Base event number for driver-private events.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+  </refsect1>
+</refentry>
+<!--
+Local Variables:
+mode: sgml
+sgml-parent-document: "v4l2.sgml"
+indent-tabs-mode: nil
+End:
+-->
diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index bfaf0c5..d6deb35 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -732,3 +732,60 @@ Useful functions:
 The users of v4l2_fh know whether a driver uses v4l2_fh as its
 file->private_data pointer by testing the V4L2_FL_USES_V4L2_FH bit in
 video_device->flags.
+
+V4L2 events
+-----------
+
+The V4L2 events provide a generic way to pass events to user space.
+The driver must use v4l2_fh to be able to support V4L2 events.
+
+Useful functions:
+
+- v4l2_event_alloc()
+
+  To use events, the driver must allocate events for the file handle. By
+  calling the function more than once, the driver may assure that at least n
+  events in total has been allocated. The function may not be called in
+  atomic context.
+
+- v4l2_event_queue()
+
+  Queue events to video device. The driver's only responsibility is to fill
+  in the type and the data fields. The other fields will be filled in by
+  V4L2.
+
+- v4l2_event_subscribe()
+
+  The video_device->ioctl_ops->vidioc_subscribe_event must check the driver
+  is able to produce events with specified event id. Then it calls
+  v4l2_event_subscribe() to subscribe the event.
+
+- v4l2_event_unsubscribe()
+
+  vidioc_unsubscribe_event in struct v4l2_ioctl_ops. A driver may use
+  v4l2_event_unsubscribe() directly unless it wants to be involved in
+  unsubscription process.
+
+  The special type V4L2_EVENT_ALL may be used to unsubscribe all events. The
+  drivers may want to handle this in a special way.
+
+- v4l2_event_pending()
+
+  Returns the number of pending events. Useful when implementing poll.
+
+Drivers do not initialise events directly. The events are initialised
+through v4l2_fh_init() if video_device->ioctl_ops->vidioc_subscribe_event is
+non-NULL. This *MUST* be performed in the driver's
+v4l2_file_operations->open() handler.
+
+Events are delivered to user space through the poll system call. The driver
+can use v4l2_fh->events->wait wait_queue_head_t as the argument for
+poll_wait().
+
+There are standard and private events. New standard events must use the
+smallest available event type. The drivers must allocate their events
+starting from base (V4L2_EVENT_PRIVATE_START + n * 1024) + 1.
+
+An example on how the V4L2 events may be used can be found in the OMAP
+3 ISP driver available at <URL:http://gitorious.org/omap3camera> as of
+writing this.
-- 
1.5.6.5

