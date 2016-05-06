Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:19796 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758247AbcEFK4m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2016 06:56:42 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: [RFC 21/22] DocBook: media: Document media events (MEDIA_IOC_DQEVENT IOCTL)
Date: Fri,  6 May 2016 13:53:30 +0300
Message-Id: <1462532011-15527-22-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add DocBook documentation for media events.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 .../DocBook/media/v4l/media-controller.xml         |   1 +
 .../DocBook/media/v4l/media-ioc-dqevent.xml        | 155 +++++++++++++++++++++
 2 files changed, 156 insertions(+)
 create mode 100644 Documentation/DocBook/media/v4l/media-ioc-dqevent.xml

diff --git a/Documentation/DocBook/media/v4l/media-controller.xml b/Documentation/DocBook/media/v4l/media-controller.xml
index 2a5a5d0..aa78fcb 100644
--- a/Documentation/DocBook/media/v4l/media-controller.xml
+++ b/Documentation/DocBook/media/v4l/media-controller.xml
@@ -98,6 +98,7 @@
   &sub-media-func-ioctl;
   <!-- All ioctls go here. -->
   &sub-media-ioc-device-info;
+  &sub-media-ioc-dqevent;
   &sub-media-ioc-g-topology;
   &sub-media-ioc-enum-entities;
   &sub-media-ioc-enum-links;
diff --git a/Documentation/DocBook/media/v4l/media-ioc-dqevent.xml b/Documentation/DocBook/media/v4l/media-ioc-dqevent.xml
new file mode 100644
index 0000000..7d58491
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/media-ioc-dqevent.xml
@@ -0,0 +1,155 @@
+<refentry id="media-ioc-dqevent">
+  <refmeta>
+    <refentrytitle>ioctl MEDIA_IOC_DQEVENT</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>MEDIA_IOC_DQEVENT</refname>
+    <refpurpose>Dequeue a media event</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>struct media_event *<parameter>argp</parameter></paramdef>
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
+	  <para>File descriptor returned by
+	  <link linkend='media-func-open'><function>open()</function></link>.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>request</parameter></term>
+	<listitem>
+	  <para>MEDIA_IOC_DQEVENT</para>
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
+    <para>Dequeue a media event from a media device. Both non-blocking
+    and blocking access is supported. <constant>poll</constant>(2)
+    IOCTL may be used with poll event type
+    <constant>POLLPRI</constant> to learn about dequeueable
+    events.</para>
+
+    <para>Media events are specific to file handle: they are delivered
+    to and dequeued from each file handle separately.</para>
+
+    <table pgwide="1" frame="none" id="media-event">
+      <title>struct <structname>media_event</structname></title>
+      <tgroup cols="4">
+        &cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>type</structfield></entry>
+	    <entry></entry>
+	    <entry>Type of the media event. Set by the driver. See
+	    <xref linkend="media-event-type" /> for available media
+	    event types.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>sequence</structfield></entry>
+	    <entry></entry>
+	    <entry>Event sequence number. The sequence number is file
+	    handle specific and counts from zero until it wraps around
+	    after reaching 32^2-1.</entry>
+	  </row>
+	  <row>
+	    <entry>union</entry>
+	    <entry><structfield></structfield></entry>
+	    <entry></entry>
+	    <entry>Anonymous union for event type specific data.</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry>struct &media_event_request_complete;</entry>
+	    <entry><structfield>req_complete</structfield></entry>
+	    <entry>Event data for
+	    <constant>MEDIA_EVENT_REQUEST_COMPLETE</constant> event.
+	    </entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table frame="none" pgwide="1" id="media-event-type">
+      <title>Media event types</title>
+      <tgroup cols="3">
+	&cs-def;
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>MEDIA_EVENT_REQUEST_COMPLETE</constant></entry>
+	    <entry>1</entry>
+	    <entry>A request has been completed. This media event type
+	    has &media-event-request-complete; associated with it. The
+	    event is only queued to the file handle from which the
+	    event was queued.
+	    </entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table pgwide="1" frame="none" id="media-event-request-complete">
+      <title>struct <structname>media_event_request_complete</structname></title>
+      <tgroup cols="3">
+        &cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>id</structfield></entry>
+	    <entry>Request ID. The identifier of the request which has
+	    been completed.</entry>
+	  </row>
+	  <row>
+	    <entry>__s32</entry>
+	    <entry><structfield>status</structfield></entry>
+	    <entry>Negative error code of the completed request. See errno(2)
+	    for possible error codes.</entry>
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
+	<term><errorcode>ENOENT</errorcode></term>
+	<listitem>
+	  <para>No events are available for dequeueing. This is returned
+	  only when non-blocking I/O is used.
+	  </para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+</refentry>
-- 
1.9.1

