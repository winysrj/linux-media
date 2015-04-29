Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:26693 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031668AbbD2KDw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 06:03:52 -0400
From: Kamil Debski <k.debski@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, k.debski@samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH v5 11/11] DocBook/media: add CEC documentation
Date: Wed, 29 Apr 2015 12:02:44 +0200
Message-id: <1430301765-22202-12-git-send-email-k.debski@samsung.com>
In-reply-to: <1430301765-22202-1-git-send-email-k.debski@samsung.com>
References: <1430301765-22202-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hverkuil@xs4all.nl>

Add DocBook documentation for the CEC API.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
[k.debski@samsung.com: add documentation for passthrough mode]
[k.debski@samsung.com: minor fixes and change of reserved field sizes]
Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 Documentation/DocBook/media/Makefile               |    4 +-
 Documentation/DocBook/media/v4l/biblio.xml         |   10 +
 Documentation/DocBook/media/v4l/cec-api.xml        |   74 ++++++
 Documentation/DocBook/media/v4l/cec-func-close.xml |   59 +++++
 Documentation/DocBook/media/v4l/cec-func-ioctl.xml |   73 ++++++
 Documentation/DocBook/media/v4l/cec-func-open.xml  |   94 +++++++
 Documentation/DocBook/media/v4l/cec-func-poll.xml  |   89 +++++++
 .../DocBook/media/v4l/cec-ioc-g-adap-log-addrs.xml |  275 ++++++++++++++++++++
 .../DocBook/media/v4l/cec-ioc-g-adap-phys-addr.xml |   78 ++++++
 .../DocBook/media/v4l/cec-ioc-g-adap-state.xml     |   87 +++++++
 Documentation/DocBook/media/v4l/cec-ioc-g-caps.xml |  167 ++++++++++++
 .../DocBook/media/v4l/cec-ioc-g-event.xml          |  142 ++++++++++
 .../DocBook/media/v4l/cec-ioc-g-vendor-id.xml      |   70 +++++
 .../DocBook/media/v4l/cec-ioc-receive.xml          |  185 +++++++++++++
 Documentation/DocBook/media_api.tmpl               |    6 +-
 15 files changed, 1410 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/cec-api.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-func-close.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-func-ioctl.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-func-open.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-func-poll.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-adap-log-addrs.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-adap-phys-addr.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-adap-state.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-caps.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-event.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-vendor-id.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-receive.xml

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index 8bf7c61..9650332 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -64,6 +64,7 @@ IOCTLS = \
 	$(shell perl -ne 'print "$$1 " if /\#define\s+([A-Z][^\s]+)\s+_IO/' $(srctree)/include/uapi/linux/dvb/net.h) \
 	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/uapi/linux/dvb/video.h) \
 	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/uapi/linux/media.h) \
+	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/uapi/linux/cec.h) \
 	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/uapi/linux/v4l2-subdev.h) \
 	VIDIOC_SUBDEV_G_FRAME_INTERVAL \
 	VIDIOC_SUBDEV_S_FRAME_INTERVAL \
@@ -98,6 +99,7 @@ STRUCTS = \
 	$(shell perl -ne 'print "$$1 " if (/^struct\s+([A-Z][^\s]+)\s+/)' $(srctree)/include/uapi/linux/dvb/net.h) \
 	$(shell perl -ne 'print "$$1 " if (/^struct\s+([^\s]+)\s+/)' $(srctree)/include/uapi/linux/dvb/video.h) \
 	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/media.h) \
+	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/cec.h) \
 	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/v4l2-subdev.h) \
 	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/v4l2-mediabus.h)
 
@@ -300,7 +302,7 @@ $(MEDIA_OBJ_DIR)/media-entities.tmpl: $(MEDIA_OBJ_DIR)/v4l2.xml
 	@(								\
 	for ident in $(IOCTLS) ; do					\
 	  entity=`echo $$ident | tr _ -` ;				\
-	  id=`grep "<refname>$$ident" $(MEDIA_OBJ_DIR)/vidioc-*.xml $(MEDIA_OBJ_DIR)/media-ioc-*.xml | sed -r s,"^.*/(.*).xml.*","\1",` ; \
+	  id=`grep "<refname>$$ident" $(MEDIA_OBJ_DIR)/vidioc-*.xml $(MEDIA_OBJ_DIR)/media-ioc-*.xml $(MEDIA_OBJ_DIR)/cec-ioc-*.xml | sed -r s,"^.*/(.*).xml.*","\1",` ; \
 	  echo "<!ENTITY $$entity \"<link"				\
 	    "linkend='$$id'><constant>$$ident</constant></link>\">"	\
 	  >>$@ ;							\
diff --git a/Documentation/DocBook/media/v4l/biblio.xml b/Documentation/DocBook/media/v4l/biblio.xml
index fdee6b3..bed940b 100644
--- a/Documentation/DocBook/media/v4l/biblio.xml
+++ b/Documentation/DocBook/media/v4l/biblio.xml
@@ -324,6 +324,16 @@ in the frequency range from 87,5 to 108,0 MHz</title>
       <subtitle>Specification Version 1.4a</subtitle>
     </biblioentry>
 
+    <biblioentry id="hdmi2">
+      <abbrev>HDMI2</abbrev>
+      <authorgroup>
+	<corpauthor>HDMI Licensing LLC
+(<ulink url="http://www.hdmi.org">http://www.hdmi.org</ulink>)</corpauthor>
+      </authorgroup>
+      <title>High-Definition Multimedia Interface</title>
+      <subtitle>Specification Version 2.0</subtitle>
+    </biblioentry>
+
     <biblioentry id="dp">
       <abbrev>DP</abbrev>
       <authorgroup>
diff --git a/Documentation/DocBook/media/v4l/cec-api.xml b/Documentation/DocBook/media/v4l/cec-api.xml
new file mode 100644
index 0000000..b59f610
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/cec-api.xml
@@ -0,0 +1,74 @@
+<partinfo>
+  <authorgroup>
+    <author>
+      <firstname>Hans</firstname>
+      <surname>Verkuil</surname>
+      <affiliation><address><email>hans.verkuil@cisco.com</email></address></affiliation>
+      <contrib>Initial version.</contrib>
+    </author>
+  </authorgroup>
+  <copyright>
+    <year>2015</year>
+    <holder>Hans Verkuil</holder>
+  </copyright>
+
+  <revhistory>
+    <!-- Put document revisions here, newest first. -->
+    <revision>
+      <revnumber>1.0.0</revnumber>
+      <date>2015-04-27</date>
+      <authorinitials>hv</authorinitials>
+      <revremark>Initial revision</revremark>
+    </revision>
+  </revhistory>
+</partinfo>
+
+<title>CEC API</title>
+
+<chapter id="cec-api">
+  <title>CEC: Consumer Electronics Control</title>
+
+  <section id="cec-intro">
+    <title>Introduction</title>
+    <para>HDMI connectors provide a single pin for use by the Consumer Electronics
+    Control protocol. This protocol allows different devices connected by an HDMI cable
+    to communicate. The protocol for CEC version 1.4 is defined in supplements 1 (CEC)
+    and 2 (HEAC or HDMI Ethernet and Audio Return Channel) of the HDMI 1.4a
+    (<xref linkend="hdmi" />) specification and the extensions added to CEC version 2.0
+    are defined in chapter 11 of the HDMI 2.0 (<xref linkend="hdmi2" />) specification.
+    </para>
+
+    <para>The bitrate is very slow (effectively no more than 36 bytes per second) and
+    is based on the ancient AV.link protocol used in old SCART connectors. The protocol
+    closely resembles a crazy Rube Goldberg contraption and is an unholy mix of low and
+    high level messages. Some messages, especially those part of the HEAC protocol layered
+    on top of CEC, need to be handled by the kernel, others can be handled either by the
+    kernel or by userspace.</para>
+
+    <para>In addition, CEC can be implemented in HDMI receivers, transmitters and in USB
+    devices that have an HDMI input and an HDMI output and that control just the CEC pin.</para>
+
+    <para>Drivers that support CEC and that allow (or require) userspace to handle CEC
+    messages and/or configure the CEC adapter will create a CEC device node (/dev/cecX)
+    to give userspace access to the CEC adapter. The &CEC-G-CAPS; ioctl will tell userspace
+    what it is allowed to do.</para>
+  </section>
+</chapter>
+
+<appendix id="cec-user-func">
+  <title>Function Reference</title>
+  <!-- Keep this alphabetically sorted. -->
+  &sub-cec-func-open;
+  &sub-cec-func-close;
+  &sub-cec-func-ioctl;
+  &sub-cec-func-poll;
+  <!-- All ioctls go here. -->
+  &sub-cec-ioc-g-caps;
+  &sub-cec-ioc-receive;
+  &sub-cec-ioc-g-adap-log-addrs;
+  &sub-cec-ioc-g-adap-state;
+  &sub-cec-ioc-g-adap-phys-addr;
+  &sub-cec-ioc-g-event;
+  &sub-cec-ioc-g-vendor-id;
+  &sub-cec-ioc-g-passthrough;
+</appendix>
diff --git a/Documentation/DocBook/media/v4l/cec-func-close.xml b/Documentation/DocBook/media/v4l/cec-func-close.xml
new file mode 100644
index 0000000..c3978af
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/cec-func-close.xml
@@ -0,0 +1,59 @@
+<refentry id="cec-func-close">
+  <refmeta>
+    <refentrytitle>cec close()</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>cec-close</refname>
+    <refpurpose>Close a cec device</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcsynopsisinfo>#include &lt;unistd.h&gt;</funcsynopsisinfo>
+      <funcprototype>
+	<funcdef>int <function>close</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
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
+    </variablelist>
+  </refsect1>
+
+  <refsect1>
+    <title>Description</title>
+
+    <para>Closes the cec device. Resources associated with the file descriptor
+    are freed. The device configuration remain unchanged.</para>
+  </refsect1>
+
+  <refsect1>
+    <title>Return Value</title>
+
+    <para><function>close</function> returns 0 on success. On error, -1 is
+    returned, and <varname>errno</varname> is set appropriately. Possible error
+    codes are:</para>
+
+    <variablelist>
+      <varlistentry>
+	<term><errorcode>EBADF</errorcode></term>
+	<listitem>
+	  <para><parameter>fd</parameter> is not a valid open file descriptor.
+	  </para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+</refentry>
diff --git a/Documentation/DocBook/media/v4l/cec-func-ioctl.xml b/Documentation/DocBook/media/v4l/cec-func-ioctl.xml
new file mode 100644
index 0000000..ad85973
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/cec-func-ioctl.xml
@@ -0,0 +1,73 @@
+<refentry id="cec-func-ioctl">
+  <refmeta>
+    <refentrytitle>cec ioctl()</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>cec-ioctl</refname>
+    <refpurpose>Control a cec device</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcsynopsisinfo>#include &lt;sys/ioctl.h&gt;</funcsynopsisinfo>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>void *<parameter>argp</parameter></paramdef>
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
+	  <para>CEC ioctl request code as defined in the cec.h header file,
+	  for example CEC_G_CAPS.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>argp</parameter></term>
+	<listitem>
+	  <para>Pointer to a request-specific structure.</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+
+  <refsect1>
+    <title>Description</title>
+    <para>The <function>ioctl()</function> function manipulates cec device
+    parameters. The argument <parameter>fd</parameter> must be an open file
+    descriptor.</para>
+    <para>The ioctl <parameter>request</parameter> code specifies the cec
+    function to be called. It has encoded in it whether the argument is an
+    input, output or read/write parameter, and the size of the argument
+    <parameter>argp</parameter> in bytes.</para>
+    <para>Macros and structures definitions specifying cec ioctl requests and
+    their parameters are located in the cec.h header file. All cec ioctl
+    requests, their respective function and parameters are specified in
+    <xref linkend="cec-user-func" />.</para>
+  </refsect1>
+
+  <refsect1>
+    &return-value;
+
+    <para>Request-specific error codes are listed in the
+    individual requests descriptions.</para>
+    <para>When an ioctl that takes an output or read/write parameter fails,
+    the parameter remains unmodified.</para>
+  </refsect1>
+</refentry>
diff --git a/Documentation/DocBook/media/v4l/cec-func-open.xml b/Documentation/DocBook/media/v4l/cec-func-open.xml
new file mode 100644
index 0000000..d814847
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/cec-func-open.xml
@@ -0,0 +1,94 @@
+<refentry id="cec-func-open">
+  <refmeta>
+    <refentrytitle>cec open()</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>cec-open</refname>
+    <refpurpose>Open a cec device</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcsynopsisinfo>#include &lt;fcntl.h&gt;</funcsynopsisinfo>
+      <funcprototype>
+	<funcdef>int <function>open</function></funcdef>
+	<paramdef>const char *<parameter>device_name</parameter></paramdef>
+	<paramdef>int <parameter>flags</parameter></paramdef>
+      </funcprototype>
+    </funcsynopsis>
+  </refsynopsisdiv>
+
+  <refsect1>
+    <title>Arguments</title>
+
+    <variablelist>
+      <varlistentry>
+	<term><parameter>device_name</parameter></term>
+	<listitem>
+	  <para>Device to be opened.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>flags</parameter></term>
+	<listitem>
+	  <para>Open flags. Access mode must be either <constant>O_RDONLY</constant>
+	  or <constant>O_RDWR</constant>. Other flags have no effect.</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+  <refsect1>
+    <title>Description</title>
+    <para>To open a cec device applications call <function>open()</function>
+    with the desired device name. The function has no side effects; the device
+    configuration remain unchanged.</para>
+    <para>When the device is opened in read-only mode, attempts to modify its
+    configuration will result in an error, and <varname>errno</varname> will be
+    set to <errorcode>EBADF</errorcode>.</para>
+  </refsect1>
+  <refsect1>
+    <title>Return Value</title>
+
+    <para><function>open</function> returns the new file descriptor on success.
+    On error, -1 is returned, and <varname>errno</varname> is set appropriately.
+    Possible error codes are:</para>
+
+    <variablelist>
+      <varlistentry>
+	<term><errorcode>EACCES</errorcode></term>
+	<listitem>
+	  <para>The requested access to the file is not allowed.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><errorcode>EMFILE</errorcode></term>
+	<listitem>
+	  <para>The  process  already  has  the  maximum number of files open.
+	  </para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><errorcode>ENFILE</errorcode></term>
+	<listitem>
+	  <para>The system limit on the total number of open files has been
+	  reached.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><errorcode>ENOMEM</errorcode></term>
+	<listitem>
+	  <para>Insufficient kernel memory was available.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><errorcode>ENXIO</errorcode></term>
+	<listitem>
+	  <para>No device corresponding to this device special file exists.
+	  </para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+</refentry>
diff --git a/Documentation/DocBook/media/v4l/cec-func-poll.xml b/Documentation/DocBook/media/v4l/cec-func-poll.xml
new file mode 100644
index 0000000..6853817
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/cec-func-poll.xml
@@ -0,0 +1,89 @@
+<refentry id="cec-func-poll">
+  <refmeta>
+    <refentrytitle>cec poll()</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>cec-poll</refname>
+    <refpurpose>Wait for some event on a file descriptor</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcsynopsisinfo>#include &lt;sys/poll.h&gt;</funcsynopsisinfo>
+      <funcprototype>
+	<funcdef>int <function>poll</function></funcdef>
+	<paramdef>struct pollfd *<parameter>ufds</parameter></paramdef>
+	<paramdef>unsigned int <parameter>nfds</parameter></paramdef>
+	<paramdef>int <parameter>timeout</parameter></paramdef>
+      </funcprototype>
+    </funcsynopsis>
+  </refsynopsisdiv>
+
+  <refsect1>
+    <title>Description</title>
+
+    <para>With the <function>poll()</function> function applications
+can wait for CEC events.</para>
+
+    <para>On success <function>poll()</function> returns the number of
+file descriptors that have been selected (that is, file descriptors
+for which the <structfield>revents</structfield> field of the
+respective <structname>pollfd</structname> structure is non-zero).
+CEC devices set the <constant>POLLIN</constant> and
+<constant>POLLRDNORM</constant> flags in the
+<structfield>revents</structfield> field if there are messages in the
+receive queue. If the transmit queue has room for new messages, the
+<constant>POLLOUT</constant> and <constant>POLLWRNORM</constant>
+flags are set. If there are events in the event queue, then the
+<constant>POLLPRI</constant> flag is set.
+When the function timed out it returns a value of zero, on
+failure it returns <returnvalue>-1</returnvalue> and the
+<varname>errno</varname> variable is set appropriately.
+</para>
+
+    <para>For more details see the
+<function>poll()</function> manual page.</para>
+  </refsect1>
+
+  <refsect1>
+    <title>Return Value</title>
+
+    <para>On success, <function>poll()</function> returns the number
+structures which have non-zero <structfield>revents</structfield>
+fields, or zero if the call timed out. On error
+<returnvalue>-1</returnvalue> is returned, and the
+<varname>errno</varname> variable is set appropriately:</para>
+
+    <variablelist>
+      <varlistentry>
+	<term><errorcode>EBADF</errorcode></term>
+	<listitem>
+	  <para>One or more of the <parameter>ufds</parameter> members
+specify an invalid file descriptor.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><errorcode>EFAULT</errorcode></term>
+	<listitem>
+	  <para><parameter>ufds</parameter> references an inaccessible
+memory area.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><errorcode>EINTR</errorcode></term>
+	<listitem>
+	  <para>The call was interrupted by a signal.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><errorcode>EINVAL</errorcode></term>
+	<listitem>
+	  <para>The <parameter>nfds</parameter> argument is greater
+than <constant>OPEN_MAX</constant>.</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+</refentry>
diff --git a/Documentation/DocBook/media/v4l/cec-ioc-g-adap-log-addrs.xml b/Documentation/DocBook/media/v4l/cec-ioc-g-adap-log-addrs.xml
new file mode 100644
index 0000000..7bed57f
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/cec-ioc-g-adap-log-addrs.xml
@@ -0,0 +1,275 @@
+<refentry id="cec-ioc-g-adap-log-addrs">
+  <refmeta>
+    <refentrytitle>ioctl CEC_G_ADAP_LOG_ADDRS, CEC_S_ADAP_LOG_ADDRS</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>CEC_G_ADAP_LOG_ADDRS</refname>
+    <refname>CEC_S_ADAP_LOG_ADDRS</refname>
+    <refpurpose>Get or set the logical addresses</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>struct cec_log_addrs *<parameter>argp</parameter></paramdef>
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
+	  <link linkend='cec-func-open'><function>open()</function></link>.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>request</parameter></term>
+	<listitem>
+	  <para>CEC_G_ADAP_LOG_ADDRS, CEC_S_ADAP_LOG_ADDRS</para>
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
+    <para>To query the current CEC logical addresses applications call the
+<constant>CEC_G_ADAP_LOG_ADDRS</constant> ioctl with a pointer to a
+<structname>cec_log_addrs</structname> structure where the drivers stores the
+logical addresses.</para>
+
+    <para>To set new logical addresses applications fill in struct <structname>cec_log_addrs</structname>
+and call the <constant>CEC_S_ADAP_LOG_ADDRS</constant> ioctl with a pointer to this struct.
+The <constant>CEC_S_ADAP_LOG_ADDRS</constant> ioctl is only available if
+<constant>CEC_CAP_LOG_ADDRS</constant> is set. This ioctl will block until all
+requested logical addresses have been claimed.</para>
+
+    <table pgwide="1" frame="none" id="cec-log-addrs">
+      <title>struct <structname>cec_log_addrs</structname></title>
+      <tgroup cols="3">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u8</entry>
+	    <entry><structfield>cec_version</structfield></entry>
+	    <entry>The CEC version that this adapter shall use. See
+	    <xref linkend="cec-versions" />.
+	    Used to implement the <constant>CEC_OP_CEC_VERSION</constant> and
+	    <constant>CEC_OP_REPORT_FEATURES</constant> messages. Note that
+	    <constant>CEC_VERSION_1_3A</constant> is not allowed
+	    by the CEC framework.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry>__u8</entry>
+	    <entry><structfield>num_log_addrs</structfield></entry>
+	    <entry>Number of logical addresses to set up. Must be &le;
+	    <structfield>available_log_addrs</structfield> as returned by
+	    &CEC-G-CAPS;. All arrays in this structure are only filled up to
+	    index <structfield>available_log_addrs</structfield>-1. The remaining
+	    array elements will be ignored. Note that the CEC 2.0 standard allows
+	    for a maximum of 2 logical addresses, although some hardware has support
+	    for more. <constant>CEC_MAX_LOG_ADDRS</constant> is 4. The driver will
+	    return the actual number of logical addresses it could claim, which may
+	    be less than what was requested. If this field is set to 0, then the
+	    CEC adapter shall clear all claimed logical addresses and all other
+	    fields will be ignored.</entry>
+	  </row>
+	  <row>
+	    <entry>__u8</entry>
+	    <entry><structfield>primary_device_type</structfield>[CEC_MAX_LOG_ADDRS]</entry>
+	    <entry>Primary device type for each logical address. See
+	    <xref linkend="cec-prim-dev-types" /> for possible types.</entry>
+	  </row>
+	  <row>
+	    <entry>__u8</entry>
+	    <entry><structfield>log_addr_type</structfield>[CEC_MAX_LOG_ADDRS]</entry>
+	    <entry>Logical address types. See <xref linkend="cec-log-addr-types" /> for
+	    possible types. The driver will update this with the actual logical address
+	    type that it claimed (e.g. it may have to fallback to
+	    <constant>CEC_LOG_ADDR_TYPE_UNREGISTERED</constant>).</entry>
+	  </row>
+	  <row>
+	    <entry>__u8</entry>
+	    <entry><structfield>log_addr</structfield>[CEC_MAX_LOG_ADDRS]</entry>
+	    <entry>The actual logical addresses that were claimed. This is set by the
+	    driver. If no logical address could be claimed, then it is set to
+	    <constant>CEC_LOG_ADDR_INVALID</constant>.</entry>
+	  </row>
+	  <row>
+	    <entry>__u8</entry>
+	    <entry><structfield>all_device_types</structfield></entry>
+	    <entry>CEC 2.0 specific: all device types. See <xref linkend="cec-all-dev-types-flags" />.
+	    Used to implement the <constant>CEC_OP_REPORT_FEATURES</constant> message.
+	    This field is ignored if <structfield>cec_version</structfield> &lt;
+	    <constant>CEC_VERSION_2_0</constant>.</entry>
+	  </row>
+	  <row>
+	    <entry>__u8</entry>
+	    <entry><structfield>features</structfield>[CEC_MAX_LOG_ADDRS][12]</entry>
+	    <entry>Features for each logical address. Used to implement the
+	    <constant>CEC_OP_REPORT_FEATURES</constant> message. The 12 bytes include
+	    both the RC Profile and the Device Features.
+	    This field is ignored if <structfield>cec_version</structfield> &lt;
+	    <constant>CEC_VERSION_2_0</constant>.</entry>
+	  </row>
+	  <row>
+	    <entry>__u8</entry>
+	    <entry><structfield>reserved</structfield>[65]</entry>
+	    <entry>Reserved for future extensions. Drivers and applications must
+	    set this array to zero.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table pgwide="1" frame="none" id="cec-prim-dev-types">
+      <title>CEC Primary Device Types</title>
+      <tgroup cols="3">
+	&cs-def;
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>CEC_PRIM_DEVTYPE_TV</constant></entry>
+	    <entry>0</entry>
+	    <entry>Use for a TV.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_PRIM_DEVTYPE_RECORD</constant></entry>
+	    <entry>1</entry>
+	    <entry>Use for a recording device.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_PRIM_DEVTYPE_TUNER</constant></entry>
+	    <entry>3</entry>
+	    <entry>Use for a device with a tuner.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_PRIM_DEVTYPE_PLAYBACK</constant></entry>
+	    <entry>4</entry>
+	    <entry>Use for a playback device.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_PRIM_DEVTYPE_AUDIOSYSTEM</constant></entry>
+	    <entry>5</entry>
+	    <entry>Use for an audio system (e.g. an audio/video receiver).</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_PRIM_DEVTYPE_SWITCH</constant></entry>
+	    <entry>6</entry>
+	    <entry>Use for a CEC switch.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_PRIM_DEVTYPE_VIDEOPROC</constant></entry>
+	    <entry>7</entry>
+	    <entry>Use for a video processor device.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table pgwide="1" frame="none" id="cec-log-addr-types">
+      <title>CEC Logical Address Types</title>
+      <tgroup cols="3">
+	&cs-def;
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>CEC_LOG_ADDR_TYPE_TV</constant></entry>
+	    <entry>0</entry>
+	    <entry>Use for a TV.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_LOG_ADDR_TYPE_RECORD</constant></entry>
+	    <entry>1</entry>
+	    <entry>Use for a recording device.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_LOG_ADDR_TYPE_TUNER</constant></entry>
+	    <entry>2</entry>
+	    <entry>Use for a tuner device.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_LOG_ADDR_TYPE_PLAYBACK</constant></entry>
+	    <entry>3</entry>
+	    <entry>Use for a playback device.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_LOG_ADDR_TYPE_AUDIOSYSTEM</constant></entry>
+	    <entry>4</entry>
+	    <entry>Use for an audio system device.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_LOG_ADDR_TYPE_SPECIFIC</constant></entry>
+	    <entry>5</entry>
+	    <entry>Use for a second TV or for a video processor device.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_LOG_ADDR_TYPE_UNREGISTERED</constant></entry>
+	    <entry>6</entry>
+	    <entry>Fallback if all relevant logical addresses are claimed, or for
+	    pure CEC switches or CDC-only devices (CDC: Capability Discovery and Control).</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table pgwide="1" frame="none" id="cec-all-dev-types-flags">
+      <title>CEC All Device Types Flags</title>
+      <tgroup cols="3">
+	&cs-def;
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>CEC_FL_ALL_DEVTYPE_TV</constant></entry>
+	    <entry>0x80</entry>
+	    <entry>This supports the TV type.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_FL_ALL_DEVTYPE_RECORD</constant></entry>
+	    <entry>0x40</entry>
+	    <entry>This supports the Recording type.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_FL_ALL_DEVTYPE_TUNER</constant></entry>
+	    <entry>0x20</entry>
+	    <entry>This supports the Tuner type.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_FL_ALL_DEVTYPE_PLAYBACK</constant></entry>
+	    <entry>0x10</entry>
+	    <entry>This supports the Playback type.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_FL_ALL_DEVTYPE_AUDIOSYSTEM</constant></entry>
+	    <entry>0x08</entry>
+	    <entry>This supports the Audio System type.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_FL_ALL_DEVTYPE_SWITCH</constant></entry>
+	    <entry>0x04</entry>
+	    <entry>This supports the CEC Switch or Video Processing type.</entry>
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
diff --git a/Documentation/DocBook/media/v4l/cec-ioc-g-adap-phys-addr.xml b/Documentation/DocBook/media/v4l/cec-ioc-g-adap-phys-addr.xml
new file mode 100644
index 0000000..0e201af
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/cec-ioc-g-adap-phys-addr.xml
@@ -0,0 +1,78 @@
+<refentry id="cec-ioc-g-adap-phys-addr">
+  <refmeta>
+    <refentrytitle>ioctl CEC_G_ADAP_PHYS_ADDR, CEC_S_ADAP_PHYS_ADDR</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>CEC_G_ADAP_PHYS_ADDR</refname>
+    <refname>CEC_S_ADAP_PHYS_ADDR</refname>
+    <refpurpose>Get or set the physical address</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>__u16 *<parameter>argp</parameter></paramdef>
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
+	  <link linkend='cec-func-open'><function>open()</function></link>.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>request</parameter></term>
+	<listitem>
+	  <para>CEC_G_ADAP_PHYS_ADDR, CEC_S_ADAP_PHYS_ADDR</para>
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
+    <para>To query the current physical address applications call the
+<constant>CEC_G_ADAP_PHYS_ADDR</constant> ioctl with a pointer to an __u16
+where the driver stores the physical address.</para>
+
+    <para>To set a new physical address applications store the physical address in
+an __u16 and call the <constant>CEC_S_ADAP_PHYS_ADDR</constant> ioctl with a
+pointer to this integer. <constant>CEC_S_ADAP_PHYS_ADDR</constant> is only
+available if <constant>CEC_CAP_PHYS_ADDR</constant> is set.</para>
+
+    <para>The physical address is a 16-bit number where each group of 4 bits
+represent a digit of the physical address a.b.c.d where the most significant
+4 bits represent 'a'. The CEC root device (usually the TV) has address 0.0.0.0.
+Every device that is hooked up to an input of the TV has address a.0.0.0 (where
+'a' is &ge; 1), devices hooked up to those in turn have addresses a.b.0.0, etc.
+So a topology of up to 5 devices deep is supported. The physical address a
+device shall use is stored in the EDID of the sink.</para>
+
+<para>For example, the EDID for each HDMI input of the TV will have a different
+physical address of the form a.0.0.0 that the sources will read out and use as
+their physical address.</para>
+  </refsect1>
+
+  <refsect1>
+    &return-value;
+  </refsect1>
+</refentry>
diff --git a/Documentation/DocBook/media/v4l/cec-ioc-g-adap-state.xml b/Documentation/DocBook/media/v4l/cec-ioc-g-adap-state.xml
new file mode 100644
index 0000000..f20dd17
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/cec-ioc-g-adap-state.xml
@@ -0,0 +1,87 @@
+<refentry id="cec-ioc-g-adap-state">
+  <refmeta>
+    <refentrytitle>ioctl CEC_G_ADAP_STATE, CEC_S_ADAP_STATE</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>CEC_G_ADAP_STATE</refname>
+    <refname>CEC_S_ADAP_STATE</refname>
+    <refpurpose>Get or set the adapter state</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>__u32 *<parameter>argp</parameter></paramdef>
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
+	  <link linkend='cec-func-open'><function>open()</function></link>.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>request</parameter></term>
+	<listitem>
+	  <para>CEC_G_ADAP_STATE, CEC_S_ADAP_STATE</para>
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
+    <para>To query the current adapter state applications call the
+<constant>CEC_G_ADAP_STATE</constant> ioctl with a pointer to an __u32
+where the driver stores the state.</para>
+
+    <para>To set the adapter state applications store the CEC adapter state
+in an __u32 and call the <constant>CEC_S_ADAP_STATE</constant> ioctl with a
+pointer to this integer. <constant>CEC_S_ADAP_STATE</constant> is only
+available if <constant>CEC_CAP_STATE</constant> is set.</para>
+
+    <para>Available states are:</para>
+
+    <table pgwide="1" frame="none" id="cec-adap-states">
+      <title>Adapter States</title>
+      <tgroup cols="3">
+	&cs-def;
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>CEC_STATE_DISABLED</constant></entry>
+	    <entry>0</entry>
+	    <entry>The adapter is disabled.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_STATE_ENABLED</constant></entry>
+	    <entry>1</entry>
+	    <entry>The adapter is enabled.</entry>
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
diff --git a/Documentation/DocBook/media/v4l/cec-ioc-g-caps.xml b/Documentation/DocBook/media/v4l/cec-ioc-g-caps.xml
new file mode 100644
index 0000000..225eaac
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/cec-ioc-g-caps.xml
@@ -0,0 +1,167 @@
+<refentry id="cec-ioc-g-caps">
+  <refmeta>
+    <refentrytitle>ioctl CEC_G_CAPS</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>CEC_G_CAPS</refname>
+    <refpurpose>Query device capabilities</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>struct cec_caps *<parameter>argp</parameter></paramdef>
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
+	  <link linkend='cec-func-open'><function>open()</function></link>.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>request</parameter></term>
+	<listitem>
+	  <para>CEC_G_CAPS</para>
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
+    <para>All cec devices must support the <constant>CEC_G_CAPS</constant>
+    ioctl. To query device information, applications call the ioctl with a
+    pointer to a &cec-caps;. The driver fills the structure and returns
+    the information to the application.
+    The ioctl never fails.</para>
+
+    <table pgwide="1" frame="none" id="cec-caps">
+      <title>struct <structname>cec_caps</structname></title>
+      <tgroup cols="3">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>available_log_addrs</structfield></entry>
+	    <entry>How many logical addresses does the CEC adapter support. This will
+	    be at most <constant>CEC_MAX_LOG_ADDRS</constant>.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>capabilities</structfield></entry>
+	    <entry>The capabilities of the CEC adapter, see <xref
+		linkend="cec-capabilities" />.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>vendor_id</structfield></entry>
+	    <entry>The CEC vendor ID.</entry>
+	  </row>
+	  <row>
+	    <entry>__u8</entry>
+	    <entry><structfield>version</structfield></entry>
+	    <entry>The CEC version supported by this device, see
+	    <xref linkend="cec-versions" />.</entry>
+	  </row>
+	  <row>
+	    <entry>__u8</entry>
+	    <entry><structfield>reserved</structfield>[35]</entry>
+	    <entry>Reserved for future extensions. Drivers must
+	    set this array to zero.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table pgwide="1" frame="none" id="cec-versions">
+      <title>CEC Versions</title>
+      <tgroup cols="3">
+	&cs-def;
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>CEC_VERSION_1_3A</constant></entry>
+	    <entry>4</entry>
+	    <entry>CEC version according to the HDMI 1.3a standard.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_VERSION_1_4B</constant></entry>
+	    <entry>5</entry>
+	    <entry>CEC version according to the HDMI 1.4b standard.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_VERSION_2_0</constant></entry>
+	    <entry>6</entry>
+	    <entry>CEC version according to the HDMI 2.0 standard.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table pgwide="1" frame="none" id="cec-capabilities">
+      <title>CEC Capabilities Flags</title>
+      <tgroup cols="3">
+	&cs-def;
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>CEC_CAP_STATE</constant></entry>
+	    <entry>0x00000001</entry>
+	    <entry>Userspace has to configure the adapter state (enable or disable it) by
+	    calling &CEC-S-ADAP-STATE;.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_CAP_PHYS_ADDR</constant></entry>
+	    <entry>0x00000002</entry>
+	    <entry>Userspace has to configure the physical address by
+	    calling &CEC-S-ADAP-PHYS-ADDR;.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_CAP_LOG_ADDRS</constant></entry>
+	    <entry>0x00000004</entry>
+	    <entry>Userspace has to configure the logical addresses by
+	    calling &CEC-S-ADAP-LOG-ADDRS;.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_CAP_TRANSMIT</constant></entry>
+	    <entry>0x00000008</entry>
+	    <entry>Userspace can transmit messages by calling &CEC-TRANSMIT;.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_CAP_RECEIVE</constant></entry>
+	    <entry>0x00000010</entry>
+	    <entry>Userspace can receive messages by calling &CEC-RECEIVE;.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_CAP_VENDOR_ID</constant></entry>
+	    <entry>0x00000020</entry>
+	    <entry>Userspace has to configure the vendor ID by
+	    calling &CEC-S-VENDOR-ID;.</entry>
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
diff --git a/Documentation/DocBook/media/v4l/cec-ioc-g-event.xml b/Documentation/DocBook/media/v4l/cec-ioc-g-event.xml
new file mode 100644
index 0000000..2b7e8e9
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/cec-ioc-g-event.xml
@@ -0,0 +1,142 @@
+<refentry id="cec-ioc-g-event">
+  <refmeta>
+    <refentrytitle>ioctl CEC_G_EVENT</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>CEC_G_EVENT</refname>
+    <refpurpose>Get a CEC event</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>struct cec_event *<parameter>argp</parameter></paramdef>
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
+	  <link linkend='cec-func-open'><function>open()</function></link>.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>request</parameter></term>
+	<listitem>
+	  <para>CEC_G_EVENT</para>
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
+    <para>CEC devices can send asynchronous events. These can be retrieved by calling
+    the <constant>CEC_G_EVENT</constant> ioctl. If the file descriptor is in non-blocking
+    mode and no event is pending, then it will return -1 and set errno to the &EAGAIN;.</para>
+
+    <table pgwide="1" frame="none" id="cec-time">
+      <title>struct <structname>cec_time</structname></title>
+      <tgroup cols="3">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u64</entry>
+	    <entry><structfield>sec</structfield></entry>
+	    <entry>Seconds.</entry>
+	  </row>
+	  <row>
+	    <entry>__u64</entry>
+	    <entry><structfield>nsec</structfield></entry>
+	    <entry>Nanoseconds.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table pgwide="1" frame="none" id="cec-event">
+      <title>struct <structname>cec_event</structname></title>
+      <tgroup cols="3">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>struct <structname>cec_time</structname></entry>
+	    <entry><structfield>ts</structfield></entry>
+	    <entry>Timestamp of the event.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>event</structfield></entry>
+	    <entry>The event, see <xref linkend="cec-events" />.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>sequence</structfield></entry>
+	    <entry>For the <constant>CEC_EVENT_GOT_REPLY</constant> event this
+	    holds the sequence number of message that requested the reply.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry>__u8</entry>
+	    <entry><structfield>reserved</structfield>[8]</entry>
+	    <entry>Reserved for future extensions. Drivers must
+	    set this array to zero.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table pgwide="1" frame="none" id="cec-events">
+      <title>CEC Events</title>
+      <tgroup cols="3">
+	&cs-def;
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>CEC_EVENT_CONNECT</constant></entry>
+	    <entry>1</entry>
+	    <entry>Generated when the HDMI cable is connected.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_EVENT_READY</constant></entry>
+	    <entry>2</entry>
+	    <entry>Generated when all logical addresses are claimed.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_EVENT_DISCONNECT</constant></entry>
+	    <entry>3</entry>
+	    <entry>Generated when the HDMI cable is disconnected.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_EVENT_GOT_REPLY</constant></entry>
+	    <entry>4</entry>
+	    <entry>Generated when a prely is received for a previously sent
+	    message. Generated only if a reply was requested and only if the
+	    message was sent in non-blocking mode.</entry>
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
diff --git a/Documentation/DocBook/media/v4l/cec-ioc-g-vendor-id.xml b/Documentation/DocBook/media/v4l/cec-ioc-g-vendor-id.xml
new file mode 100644
index 0000000..642e6b5
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/cec-ioc-g-vendor-id.xml
@@ -0,0 +1,70 @@
+<refentry id="cec-ioc-g-vendor-id">
+  <refmeta>
+    <refentrytitle>ioctl CEC_G_VENDOR_ID, CEC_S_VENDOR_ID</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>CEC_G_VENDOR_ID</refname>
+    <refname>CEC_S_VENDOR_ID</refname>
+    <refpurpose>Get or set vendor ID</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>__u32 *<parameter>argp</parameter></paramdef>
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
+	  <link linkend='cec-func-open'><function>open()</function></link>.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>request</parameter></term>
+	<listitem>
+	  <para>CEC_G_VENDOR_ID, CEC_S_VENDOR_ID</para>
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
+    <para>To query the current CEC vendor ID applications call the
+<constant>CEC_G_VENDOR_ID</constant> ioctl with a pointer to an __u32
+where the driver stores the vendor ID.</para>
+
+    <para>To set a new vendor ID applications store the vendor ID in
+an __u32 and call the <constant>CEC_S_VENDOR_ID</constant> ioctl with a
+pointer to this integer. <constant>CEC_S_VENDOR_ID</constant> is only
+available if <constant>CEC_CAP_VENDOR_ID</constant> is set.</para>
+
+    <para>The vendor ID is a 24-bit number that identifies the specific
+vendor or entity. Based on this ID vendor specific commands may be
+defined.</para>
+  </refsect1>
+
+  <refsect1>
+    &return-value;
+  </refsect1>
+</refentry>
diff --git a/Documentation/DocBook/media/v4l/cec-ioc-receive.xml b/Documentation/DocBook/media/v4l/cec-ioc-receive.xml
new file mode 100644
index 0000000..5b08bf6
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/cec-ioc-receive.xml
@@ -0,0 +1,185 @@
+<refentry id="cec-ioc-receive">
+  <refmeta>
+    <refentrytitle>ioctl CEC_RECEIVE, CEC_TRANSMIT</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>CEC_RECEIVE</refname>
+    <refname>CEC_TRANSMIT</refname>
+    <refpurpose>Receive or transmit a CEC message</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>struct cec_msg *<parameter>argp</parameter></paramdef>
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
+	  <link linkend='cec-func-open'><function>open()</function></link>.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>request</parameter></term>
+	<listitem>
+	  <para>CEC_RECEIVE, CEC_TRANSMIT</para>
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
+    <para>To receive a CEC message the application has to fill in the
+    <structname>cec_msg</structname> structure and pass it to the
+    <constant>CEC_RECEIVE</constant> ioctl. <constant>CEC_RECEIVE</constant> is
+    only available if <constant>CEC_CAP_RECEIVE</constant> is set. If the
+    file descriptor is in non-blocking mode and there are no received
+    messages pending, then it will return -1 and set errno to the &EAGAIN;.
+    If the file descriptor is in blocking mode and <structfield>timeout</structfield>
+    is non-zero and no message arrived within <structfield>timeout</structfield>
+    milliseconds, then it will return -1 and set errno to the &ETIMEDOUT;.</para>
+
+    <para>To send a CEC message the application has to fill in the
+    <structname>cec_msg</structname> structure and pass it to the
+    <constant>CEC_TRANSMIT</constant> ioctl. <constant>CEC_TRANSMIT</constant> is
+    only available if <constant>CEC_CAP_TRANSMIT</constant> is set.
+    If there is no more room in the transmit queue, then it will return
+    -1 and set errno to the &EBUSY;.</para>
+
+    <table pgwide="1" frame="none" id="cec-msg">
+      <title>struct <structname>cec_msg</structname></title>
+      <tgroup cols="3">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>struct <structname>cec_time</structname></entry>
+	    <entry><structfield>ts</structfield></entry>
+	    <entry>Timestamp of when the message was transmitted in the case
+	    of <constant>CEC_TRANSMIT</constant> with <structfield>reply</structfield>
+	    set to 0, or the timestamp of the received message in all other cases.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>len</structfield></entry>
+	    <entry>The length of the message. For <constant>CEC_TRANSMIT</constant> this
+	    is filled in by the application. The driver will fill this in for
+	    <constant>CEC_RECEIVE</constant> and for <constant>CEC_TRANSMIT</constant>
+	    it will be filled in with the length of the reply message if
+	    <structfield>reply</structfield> was set.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>status</structfield></entry>
+	    <entry>The status of the message. When used with <constant>CEC_RECEIVE</constant>
+	    this is always set to <constant>CEC_RX_STATUS_READY</constant>. When
+	    used with <constant>CEC_TRANSMIT</constant> see <xref linkend="cec-tx-status" />
+	    for the possible status values.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>timeout</structfield></entry>
+	    <entry>The timeout in milliseconds. This is the time we wait for a message to
+	    be received. If it is set to 0, then we wait indefinitely.
+	    It is ignored by <constant>CEC_TRANSMIT</constant>.</entry>
+	  </row>
+	  <row>
+	    <entry>__u8</entry>
+	    <entry><structfield>msg</structfield>[16]</entry>
+	    <entry>The message payload. For <constant>CEC_TRANSMIT</constant> this
+	    is filled in by the application. The driver will fill this in for
+	    <constant>CEC_RECEIVE</constant> and for <constant>CEC_TRANSMIT</constant>
+	    it will be filled in with the payload of the reply message if
+	    <structfield>reply</structfield> was set.</entry>
+	  </row>
+	  <row>
+	    <entry>__u8</entry>
+	    <entry><structfield>reply</structfield></entry>
+	    <entry>Wait until this message is replied. If <structfield>reply</structfield>
+	    is 0, then don't wait for a reply but return after transmitting the
+	    message. If there was an error as indicated by a non-zero <structfield>status</structfield>
+	    field, then <structfield>reply</structfield> is set to 0 by the driver.
+	    Ignored by <constant>CEC_RECEIVE</constant>.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>sequence</structfield></entry>
+	    <entry>The sequence number is automatically assigned by the CEC
+	    framework for all transmitted messages. It can be later used by the
+	    framework to generate an event if a reply for a message was
+	    requested and the message was transmitted in a non-blocking mode.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry>__u8</entry>
+	    <entry><structfield>reserved</structfield>[35]</entry>
+	    <entry>Reserved for future extensions. Drivers and applications must
+	    set this array to zero.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table pgwide="1" frame="none" id="cec-tx-status">
+      <title>CEC Transmit Status</title>
+      <tgroup cols="3">
+	&cs-def;
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>CEC_TX_STATUS_OK</constant></entry>
+	    <entry>0x00</entry>
+	    <entry>The message was transmitted successfully.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_TX_STATUS_ARB_LOST</constant></entry>
+	    <entry>0x01</entry>
+	    <entry>CEC line arbitration was lost.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_TX_STATUS_RETRY_TIMEOUT</constant></entry>
+	    <entry>0x02</entry>
+	    <entry>The transmit timed out. The timeout period is 200 ms for a polling
+	    message and 1 second for other messages as specified by the CEC protocol.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_TX_STATUS_FEATURE_ABORT</constant></entry>
+	    <entry>0x04</entry>
+	    <entry>The message was transmitted successfully but the reply was
+	    <constant>CEC_OP_FEATURE_ABORT</constant>.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_TX_STATUS_REPLY_TIMEOUT</constant></entry>
+	    <entry>0x08</entry>
+	    <entry>The message was transmitted successfully but the reply was never
+	    received within the 1 second timeout period (this timeout value is
+	    specified by the CEC protocol).</entry>
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
diff --git a/Documentation/DocBook/media_api.tmpl b/Documentation/DocBook/media_api.tmpl
index 03f9a1f..ebddc3f 100644
--- a/Documentation/DocBook/media_api.tmpl
+++ b/Documentation/DocBook/media_api.tmpl
@@ -37,7 +37,7 @@
 	<title>LINUX MEDIA INFRASTRUCTURE API</title>
 
 	<copyright>
-		<year>2009-2014</year>
+		<year>2009-2015</year>
 		<holder>LinuxTV Developers</holder>
 	</copyright>
 
@@ -60,7 +60,7 @@
 		analog and digital TV receiver cards, AM/FM receiver cards,
 		streaming capture and output devices, codec devices and remote
 		controllers.</para>
-	<para>It is divided into four parts.</para>
+	<para>It is divided into five parts.</para>
 	<para>The first part covers radio, video capture and output,
 		cameras, analog TV devices and codecs.</para>
 	<para>The second part covers the
@@ -71,6 +71,7 @@
 		to document support also for DVB-S2, ISDB-T and ISDB-S.</para>
 	<para>The third part covers the Remote Controller API.</para>
 	<para>The fourth part covers the Media Controller API.</para>
+	<para>The fifth part covers the CEC (Consumer Electronics Control) API.</para>
 	<para>For additional information and for the latest development code,
 		see: <ulink url="http://linuxtv.org">http://linuxtv.org</ulink>.</para>
 	<para>For discussing improvements, reporting troubles, sending new drivers, etc, please mail to: <ulink url="http://vger.kernel.org/vger-lists.html#linux-media">Linux Media Mailing List (LMML).</ulink>.</para>
@@ -80,6 +81,7 @@
 <part id="dvbapi">&sub-dvbapi;</part>
 <part id="remotes">&sub-remote_controllers;</part>
 <part id="media_common">&sub-media-controller;</part>
+<part id="cec">&sub-cec-api;</part>
 
 <chapter id="gen_errors">&sub-gen-errors;</chapter>
 
-- 
1.7.9.5

