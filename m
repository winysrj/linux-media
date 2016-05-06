Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:57272 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758138AbcEFK4z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2016 06:56:55 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [RFC 17/22] DocBook: media: Document the media request API
Date: Fri,  6 May 2016 13:53:26 +0300
Message-Id: <1462532011-15527-18-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The media request API is made of a new ioctl to implement request
management. Document it.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Strip off the reserved fields.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 .../DocBook/media/v4l/media-controller.xml         |   1 +
 .../DocBook/media/v4l/media-ioc-request-cmd.xml    | 188 +++++++++++++++++++++
 2 files changed, 189 insertions(+)
 create mode 100644 Documentation/DocBook/media/v4l/media-ioc-request-cmd.xml

diff --git a/Documentation/DocBook/media/v4l/media-controller.xml b/Documentation/DocBook/media/v4l/media-controller.xml
index 5f2fc07..2a5a5d0 100644
--- a/Documentation/DocBook/media/v4l/media-controller.xml
+++ b/Documentation/DocBook/media/v4l/media-controller.xml
@@ -101,5 +101,6 @@
   &sub-media-ioc-g-topology;
   &sub-media-ioc-enum-entities;
   &sub-media-ioc-enum-links;
+  &sub-media-ioc-request-cmd;
   &sub-media-ioc-setup-link;
 </appendix>
diff --git a/Documentation/DocBook/media/v4l/media-ioc-request-cmd.xml b/Documentation/DocBook/media/v4l/media-ioc-request-cmd.xml
new file mode 100644
index 0000000..4f4acea
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/media-ioc-request-cmd.xml
@@ -0,0 +1,188 @@
+<refentry id="media-ioc-request-cmd">
+  <refmeta>
+    <refentrytitle>ioctl MEDIA_IOC_REQUEST_CMD</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>MEDIA_IOC_REQUEST_CMD</refname>
+    <refpurpose>Manage media device requests</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>struct media_request_cmd *<parameter>argp</parameter></paramdef>
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
+	  <para>MEDIA_IOC_REQUEST_CMD</para>
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
+    <para>The MEDIA_IOC_REQUEST_CMD ioctl allow applications to manage media
+    device requests. A request is an object that can group media device
+    configuration parameters, including subsystem-specific parameters, in order
+    to apply all the parameters atomically. Applications are responsible for
+    allocating and deleting requests, filling them with configuration parameters
+    and (synchronously) applying or (asynchronously) queuing them.</para>
+
+    <para>Request operations are performed by calling the MEDIA_IOC_REQUEST_CMD
+    ioctl with a pointer to a &media-request-cmd; with the
+    <structfield>cmd</structfield> set to the appropriate command.
+    <xref linkend="media-request-commands" /> lists the commands supported by
+    the ioctl.</para>
+
+    <para>The &media-request-cmd; <structfield>request</structfield> field
+    contains the ID of the request on which the command operates. For the
+    <constant>MEDIA_REQ_CMD_ALLOC</constant> command the field is set to zero
+    by applications and filled by the driver. For all other commands the field
+    is set by applications and left untouched by the driver.</para>
+
+    <para>To allocate a new request applications use the
+    <constant>MEDIA_REQ_CMD_ALLOC</constant>. The driver will allocate a new
+    request and return its ID in the <structfield>request</structfield> field.
+    </para>
+
+    <para>Requests are reference-counted. A newly allocate request is referenced
+    by the media device file handled on which it has been created, and can be
+    later referenced by subsystem-specific operations using the request ID.
+    Requests will thus be automatically deleted when they're not longer used
+    after the media device file handle is closed.</para>
+
+    <para>If a request isn't needed applications can delete it using the
+    <constant>MEDIA_REQ_CMD_DELETE</constant> command. The driver will drop the
+    reference to the request stored in the media device file handle. The request
+    will not be usable through the MEDIA_IOC_REQUEST_CMD ioctl anymore, but will
+    only be deleted when the last reference is released. If no other reference
+    exists when the delete command is invoked the request will be deleted
+    immediately.</para>
+
+    <para>After creating a request applications should fill it with
+    configuration parameters. This is performed through subsystem-specific
+    request APIs outside the scope of the media controller API. See the
+    appropriate subsystem APIs for more information, including how they interact
+    with the MEDIA_IOC_REQUEST_CMD ioctl.</para>
+
+    <para>Once a request contains all the desired configuration parameters it
+    can be applied synchronously or queued asynchronously. To apply a request
+    applications use the <constant>MEDIA_REQ_CMD_APPLY</constant> command. The
+    driver will apply all configuration parameters stored in the request to the
+    device atomically. The ioctl will return once all parameters have been
+    applied, but it should be noted that they might not have fully taken effect
+    yet.</para>
+
+    <para>To queue a request applications use the
+    <constant>MEDIA_REQ_CMD_QUEUE</constant> command. The driver will queue the
+    request for processing and return immediately. The request will then be
+    processed and applied after all previously queued requests.</para>
+
+    <para>Once a request has been queued applications are not allowed to modify
+    its configuration parameters until the request has been fully processed.
+    Any attempt to do so will result in the related subsystem API returning
+    an error. The media device request API doesn't notify applications of
+    request processing completion, this is left to the other subsystems APIs to
+    implement.</para>
+
+    <table pgwide="1" frame="none" id="media-request-cmd">
+      <title>struct <structname>media_request_cmd</structname></title>
+      <tgroup cols="3">
+        &cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>cmd</structfield></entry>
+	    <entry>Command, set by the application. See
+	    <xref linkend="media-request-commands" /> for the list of supported
+	    commands.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>request</structfield></entry>
+	    <entry>Request ID, set by the driver for the
+	    <constant>MEDIA_REQ_CMD_ALLOC</constant> and by the application
+	    for all other commands.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table frame="none" pgwide="1" id="media-request-commands">
+      <title>Media request commands</title>
+      <tgroup cols="2">
+        <colspec colname="c1"/>
+        <colspec colname="c2"/>
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>MEDIA_REQ_CMD_ALLOC</constant></entry>
+	    <entry>Allocate a new request.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_REQ_CMD_DELETE</constant></entry>
+	    <entry>Delete a request.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_REQ_CMD_APPLY</constant></entry>
+	    <entry>Apply all settings from a request.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_REQ_CMD_QUEUE</constant></entry>
+	    <entry>Queue a request for processing.</entry>
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
+	  <para>The &media-request-cmd; specifies an invalid command or
+	  references a non-existing request.
+	  </para>
+	</listitem>
+	<term><errorcode>ENOSYS</errorcode></term>
+	<listitem>
+	  <para>The &media-request-cmd; specifies the
+	  <constant>MEDIA_REQ_CMD_QUEUE</constant> or
+	  <constant>MEDIA_REQ_CMD_APPLY</constant> and that command isn't
+	  implemented by the device.
+	  </para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+</refentry>
-- 
1.9.1

