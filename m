Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:33942 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751496AbcFRPDH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2016 11:03:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hansverk@cisco.com>, Kamil Debski <kamil@wypas.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv18 04/15] DocBook/media: add CEC documentation
Date: Sat, 18 Jun 2016 17:02:37 +0200
Message-Id: <1466262168-12805-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1466262168-12805-1-git-send-email-hverkuil@xs4all.nl>
References: <1466262168-12805-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add DocBook documentation for the CEC API.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
[k.debski@samsung.com: add documentation for passthrough mode]
[k.debski@samsung.com: minor fixes and change of reserved field sizes]
Signed-off-by: Kamil Debski <kamil@wypas.org>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/device-drivers.tmpl          |   3 +
 Documentation/DocBook/media/Makefile               |   2 +
 Documentation/DocBook/media/v4l/biblio.xml         |  10 +
 Documentation/DocBook/media/v4l/cec-api.xml        |  75 +++++
 Documentation/DocBook/media/v4l/cec-func-close.xml |  64 ++++
 Documentation/DocBook/media/v4l/cec-func-ioctl.xml |  78 +++++
 Documentation/DocBook/media/v4l/cec-func-open.xml  | 104 +++++++
 Documentation/DocBook/media/v4l/cec-func-poll.xml  |  94 ++++++
 .../DocBook/media/v4l/cec-ioc-adap-g-caps.xml      | 151 ++++++++++
 .../DocBook/media/v4l/cec-ioc-adap-g-log-addrs.xml | 329 +++++++++++++++++++++
 .../DocBook/media/v4l/cec-ioc-adap-g-phys-addr.xml |  86 ++++++
 .../DocBook/media/v4l/cec-ioc-dqevent.xml          | 195 ++++++++++++
 Documentation/DocBook/media/v4l/cec-ioc-g-mode.xml | 255 ++++++++++++++++
 .../DocBook/media/v4l/cec-ioc-receive.xml          | 265 +++++++++++++++++
 Documentation/DocBook/media_api.tmpl               |   6 +-
 15 files changed, 1716 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/DocBook/media/v4l/cec-api.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-func-close.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-func-ioctl.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-func-open.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-func-poll.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-adap-g-caps.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-adap-g-log-addrs.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-adap-g-phys-addr.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-dqevent.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-mode.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-receive.xml

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index de79efd..a20a45b 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -272,6 +272,9 @@ X!Isound/sound_firmware.c
 !Iinclude/media/media-devnode.h
 !Iinclude/media/media-entity.h
     </sect1>
+    <sect1><title>Consumer Electronics Control devices</title>
+!Iinclude/media/cec-edid.h
+    </sect1>
 
   </chapter>
 
diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index 2840ff4..fdc1386 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -64,6 +64,7 @@ IOCTLS = \
 	$(shell perl -ne 'print "$$1 " if /\#define\s+([A-Z][^\s]+)\s+_IO/' $(srctree)/include/uapi/linux/dvb/net.h) \
 	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/uapi/linux/dvb/video.h) \
 	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/uapi/linux/media.h) \
+	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/cec.h) \
 	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/uapi/linux/v4l2-subdev.h) \
 
 DEFINES = \
@@ -100,6 +101,7 @@ STRUCTS = \
 	$(shell perl -ne 'print "$$1 " if (/^struct\s+([^\s]+)\s+/ && !/_old/)' $(srctree)/include/uapi/linux/dvb/net.h) \
 	$(shell perl -ne 'print "$$1 " if (/^struct\s+([^\s]+)\s+/)' $(srctree)/include/uapi/linux/dvb/video.h) \
 	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/media.h) \
+	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/cec.h) \
 	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/v4l2-subdev.h) \
 	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/v4l2-mediabus.h)
 
diff --git a/Documentation/DocBook/media/v4l/biblio.xml b/Documentation/DocBook/media/v4l/biblio.xml
index 9beb30f..87f1d24 100644
--- a/Documentation/DocBook/media/v4l/biblio.xml
+++ b/Documentation/DocBook/media/v4l/biblio.xml
@@ -342,6 +342,16 @@ in the frequency range from 87,5 to 108,0 MHz</title>
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
index 0000000..7062c1f
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/cec-api.xml
@@ -0,0 +1,75 @@
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
+    <year>2016</year>
+    <holder>Hans Verkuil</holder>
+  </copyright>
+
+  <revhistory>
+    <!-- Put document revisions here, newest first. -->
+    <revision>
+      <revnumber>1.0.0</revnumber>
+      <date>2016-03-17</date>
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
+    <para>
+      Note: this documents the proposed CEC API. This API is not yet finalized and
+      is currently only available as a staging kernel module.
+    </para>
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
+    <para>Drivers that support CEC will create a CEC device node (/dev/cecX)
+    to give userspace access to the CEC adapter. The &CEC-ADAP-G-CAPS; ioctl will tell userspace
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
+  &sub-cec-ioc-adap-g-caps;
+  &sub-cec-ioc-adap-g-log-addrs;
+  &sub-cec-ioc-adap-g-phys-addr;
+  &sub-cec-ioc-dqevent;
+  &sub-cec-ioc-g-mode;
+  &sub-cec-ioc-receive;
+</appendix>
diff --git a/Documentation/DocBook/media/v4l/cec-func-close.xml b/Documentation/DocBook/media/v4l/cec-func-close.xml
new file mode 100644
index 0000000..0812c8c
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/cec-func-close.xml
@@ -0,0 +1,64 @@
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
+    <para>
+      Note: this documents the proposed CEC API. This API is not yet finalized and
+      is currently only available as a staging kernel module.
+    </para>
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
index 0000000..f92817a
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/cec-func-ioctl.xml
@@ -0,0 +1,78 @@
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
+	  for example CEC_ADAP_G_CAPS.</para>
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
+    <para>
+      Note: this documents the proposed CEC API. This API is not yet finalized and
+      is currently only available as a staging kernel module.
+    </para>
+
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
index 0000000..2edc555
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/cec-func-open.xml
@@ -0,0 +1,104 @@
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
+	  <para>Open flags. Access mode must be <constant>O_RDWR</constant>.
+	  </para>
+	  <para>When the <constant>O_NONBLOCK</constant> flag is
+given, the &CEC-RECEIVE; ioctl will return &EAGAIN; when no message is
+available, and the &CEC-TRANSMIT;, &CEC-ADAP-S-PHYS-ADDR; and
+&CEC-ADAP-S-LOG-ADDRS; ioctls all act in non-blocking mode.</para>
+	  <para>Other flags have no effect.</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+  <refsect1>
+    <title>Description</title>
+    <para>
+      Note: this documents the proposed CEC API. This API is not yet finalized and
+      is currently only available as a staging kernel module.
+    </para>
+
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
+    Possible error codes include:</para>
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
index 0000000..1bddbde
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/cec-func-poll.xml
@@ -0,0 +1,94 @@
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
+    <para>
+      Note: this documents the proposed CEC API. This API is not yet finalized and
+      is currently only available as a staging kernel module.
+    </para>
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
diff --git a/Documentation/DocBook/media/v4l/cec-ioc-adap-g-caps.xml b/Documentation/DocBook/media/v4l/cec-ioc-adap-g-caps.xml
new file mode 100644
index 0000000..3523ef2
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/cec-ioc-adap-g-caps.xml
@@ -0,0 +1,151 @@
+<refentry id="cec-ioc-adap-g-caps">
+  <refmeta>
+    <refentrytitle>ioctl CEC_ADAP_G_CAPS</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>CEC_ADAP_G_CAPS</refname>
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
+	  <para>CEC_ADAP_G_CAPS</para>
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
+    <para>
+      Note: this documents the proposed CEC API. This API is not yet finalized and
+      is currently only available as a staging kernel module.
+    </para>
+
+    <para>All cec devices must support the <constant>CEC_ADAP_G_CAPS</constant>
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
+	    <entry>char</entry>
+	    <entry><structfield>driver[32]</structfield></entry>
+	    <entry>The name of the cec adapter driver.</entry>
+	  </row>
+	  <row>
+	    <entry>char</entry>
+	    <entry><structfield>name[32]</structfield></entry>
+	    <entry>The name of this CEC adapter. The combination <structfield>driver</structfield>
+	    and <structfield>name</structfield> must be unique.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>capabilities</structfield></entry>
+	    <entry>The capabilities of the CEC adapter, see <xref
+		linkend="cec-capabilities" />.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>version</structfield></entry>
+	    <entry>CEC Framework API version, formatted with the
+	    <constant>KERNEL_VERSION()</constant> macro.</entry>
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
+	    <entry><constant>CEC_CAP_PHYS_ADDR</constant></entry>
+	    <entry>0x00000001</entry>
+	    <entry>Userspace has to configure the physical address by
+	    calling &CEC-ADAP-S-PHYS-ADDR;. If this capability isn't set,
+	    then setting the physical address is handled by the kernel
+	    whenever the EDID is set (for an HDMI receiver) or read (for
+	    an HDMI transmitter).</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_CAP_LOG_ADDRS</constant></entry>
+	    <entry>0x00000002</entry>
+	    <entry>Userspace has to configure the logical addresses by
+	    calling &CEC-ADAP-S-LOG-ADDRS;. If this capability isn't set,
+	    then the kernel will have configured this.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_CAP_TRANSMIT</constant></entry>
+	    <entry>0x00000004</entry>
+	    <entry>Userspace can transmit CEC messages by calling &CEC-TRANSMIT;. This
+	    implies that userspace can be a follower as well, since being able to
+	    transmit messages is a prerequisite of becoming a follower. If this
+	    capability isn't set, then the kernel will handle all CEC transmits
+	    and process all CEC messages it receives.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_CAP_PASSTHROUGH</constant></entry>
+	    <entry>0x00000008</entry>
+	    <entry>Userspace can use the passthrough mode by
+	    calling &CEC-S-MODE;.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_CAP_RC</constant></entry>
+	    <entry>0x00000010</entry>
+	    <entry>This adapter supports the remote control protocol.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_CAP_MONITOR_ALL</constant></entry>
+	    <entry>0x00000020</entry>
+	    <entry>The CEC hardware can monitor all messages, not just directed and
+	    broadcast messages.</entry>
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
diff --git a/Documentation/DocBook/media/v4l/cec-ioc-adap-g-log-addrs.xml b/Documentation/DocBook/media/v4l/cec-ioc-adap-g-log-addrs.xml
new file mode 100644
index 0000000..302b829
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/cec-ioc-adap-g-log-addrs.xml
@@ -0,0 +1,329 @@
+<refentry id="cec-ioc-adap-g-log-addrs">
+  <refmeta>
+    <refentrytitle>ioctl CEC_ADAP_G_LOG_ADDRS, CEC_ADAP_S_LOG_ADDRS</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>CEC_ADAP_G_LOG_ADDRS</refname>
+    <refname>CEC_ADAP_S_LOG_ADDRS</refname>
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
+	  <para>CEC_ADAP_G_LOG_ADDRS, CEC_ADAP_S_LOG_ADDRS</para>
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
+    <para>
+      Note: this documents the proposed CEC API. This API is not yet finalized and
+      is currently only available as a staging kernel module.
+    </para>
+
+    <para>To query the current CEC logical addresses, applications call the
+<constant>CEC_ADAP_G_LOG_ADDRS</constant> ioctl with a pointer to a
+<structname>cec_log_addrs</structname> structure where the drivers stores the
+logical addresses.</para>
+
+    <para>To set new logical addresses, applications fill in struct <structname>cec_log_addrs</structname>
+and call the <constant>CEC_ADAP_S_LOG_ADDRS</constant> ioctl with a pointer to this struct.
+The <constant>CEC_ADAP_S_LOG_ADDRS</constant> ioctl is only available if
+<constant>CEC_CAP_LOG_ADDRS</constant> is set (&ENOTTY; is returned otherwise). This ioctl will block until all
+requested logical addresses have been claimed. <constant>CEC_ADAP_S_LOG_ADDRS</constant>
+can only be called by a file handle in initiator mode (see &CEC-S-MODE;).</para>
+
+    <table pgwide="1" frame="none" id="cec-log-addrs">
+      <title>struct <structname>cec_log_addrs</structname></title>
+      <tgroup cols="3">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u8</entry>
+	    <entry><structfield>log_addr</structfield>[CEC_MAX_LOG_ADDRS]</entry>
+	    <entry>The actual logical addresses that were claimed. This is set by the
+	    driver. If no logical address could be claimed, then it is set to
+	    <constant>CEC_LOG_ADDR_INVALID</constant>. If this adapter is Unregistered,
+	    then <structfield>log_addr[0]</structfield> is set to 0xf and all others to
+	    <constant>CEC_LOG_ADDR_INVALID</constant>.</entry>
+	  </row>
+	  <row>
+	    <entry>__u16</entry>
+	    <entry><structfield>log_addr_mask</structfield></entry>
+	    <entry>The bitmask of all logical addresses this adapter has claimed.
+	    If this adapter is Unregistered then <structfield>log_addr_mask</structfield>
+	    sets bit 15 and clears all other bits. If this adapter is not configured at all, then
+	    <structfield>log_addr_mask</structfield> is set to 0. Set by the driver.</entry>
+	  </row>
+	  <row>
+	    <entry>__u8</entry>
+	    <entry><structfield>cec_version</structfield></entry>
+	    <entry>The CEC version that this adapter shall use. See
+	    <xref linkend="cec-versions" />.
+	    Used to implement the <constant>CEC_MSG_CEC_VERSION</constant> and
+	    <constant>CEC_MSG_REPORT_FEATURES</constant> messages. Note that
+	    <constant>CEC_OP_CEC_VERSION_1_3A</constant> is not allowed
+	    by the CEC framework.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry>__u8</entry>
+	    <entry><structfield>num_log_addrs</structfield></entry>
+	    <entry>Number of logical addresses to set up. Must be &le;
+	    <structfield>available_log_addrs</structfield> as returned by
+	    &CEC-ADAP-G-CAPS;. All arrays in this structure are only filled up to
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
+	    <entry>__u32</entry>
+	    <entry><structfield>vendor_id</structfield></entry>
+	    <entry>The vendor ID is a 24-bit number that identifies the specific
+	    vendor or entity. Based on this ID vendor specific commands may be
+	    defined. If you do not want a vendor ID then set it to
+	    <constant>CEC_VENDOR_ID_NONE</constant>.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>flags</structfield></entry>
+	    <entry>Flags. No flags are defined yet, so set this to 0.</entry>
+	  </row>
+	  <row>
+	    <entry>char</entry>
+	    <entry><structfield>osd_name</structfield>[15]</entry>
+	    <entry>The On-Screen Display name as is returned by the
+	    <constant>CEC_MSG_SET_OSD_NAME</constant> message.</entry>
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
+	    <entry><structfield>all_device_types</structfield>[CEC_MAX_LOG_ADDRS]</entry>
+	    <entry>CEC 2.0 specific: all device types. See <xref linkend="cec-all-dev-types-flags" />.
+	    Used to implement the <constant>CEC_MSG_REPORT_FEATURES</constant> message.
+	    This field is ignored if <structfield>cec_version</structfield> &lt;
+	    <constant>CEC_OP_CEC_VERSION_2_0</constant>.</entry>
+	  </row>
+	  <row>
+	    <entry>__u8</entry>
+	    <entry><structfield>features</structfield>[CEC_MAX_LOG_ADDRS][12]</entry>
+	    <entry>Features for each logical address. Used to implement the
+	    <constant>CEC_MSG_REPORT_FEATURES</constant> message. The 12 bytes include
+	    both the RC Profile and the Device Features.
+	    This field is ignored if <structfield>cec_version</structfield> &lt;
+	    <constant>CEC_OP_CEC_VERSION_2_0</constant>.</entry>
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
+	    <entry><constant>CEC_OP_CEC_VERSION_1_3A</constant></entry>
+	    <entry>4</entry>
+	    <entry>CEC version according to the HDMI 1.3a standard.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_OP_CEC_VERSION_1_4B</constant></entry>
+	    <entry>5</entry>
+	    <entry>CEC version according to the HDMI 1.4b standard.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_OP_CEC_VERSION_2_0</constant></entry>
+	    <entry>6</entry>
+	    <entry>CEC version according to the HDMI 2.0 standard.</entry>
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
+	    <entry><constant>CEC_OP_PRIM_DEVTYPE_TV</constant></entry>
+	    <entry>0</entry>
+	    <entry>Use for a TV.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_OP_PRIM_DEVTYPE_RECORD</constant></entry>
+	    <entry>1</entry>
+	    <entry>Use for a recording device.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_OP_PRIM_DEVTYPE_TUNER</constant></entry>
+	    <entry>3</entry>
+	    <entry>Use for a device with a tuner.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_OP_PRIM_DEVTYPE_PLAYBACK</constant></entry>
+	    <entry>4</entry>
+	    <entry>Use for a playback device.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_OP_PRIM_DEVTYPE_AUDIOSYSTEM</constant></entry>
+	    <entry>5</entry>
+	    <entry>Use for an audio system (e.g. an audio/video receiver).</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_OP_PRIM_DEVTYPE_SWITCH</constant></entry>
+	    <entry>6</entry>
+	    <entry>Use for a CEC switch.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_OP_PRIM_DEVTYPE_VIDEOPROC</constant></entry>
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
+	    <entry>Use this if you just want to remain unregistered.
+	    Used for pure CEC switches or CDC-only devices (CDC:
+	    Capability Discovery and Control).</entry>
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
+	    <entry><constant>CEC_OP_ALL_DEVTYPE_TV</constant></entry>
+	    <entry>0x80</entry>
+	    <entry>This supports the TV type.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_OP_ALL_DEVTYPE_RECORD</constant></entry>
+	    <entry>0x40</entry>
+	    <entry>This supports the Recording type.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_OP_ALL_DEVTYPE_TUNER</constant></entry>
+	    <entry>0x20</entry>
+	    <entry>This supports the Tuner type.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_OP_ALL_DEVTYPE_PLAYBACK</constant></entry>
+	    <entry>0x10</entry>
+	    <entry>This supports the Playback type.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_OP_ALL_DEVTYPE_AUDIOSYSTEM</constant></entry>
+	    <entry>0x08</entry>
+	    <entry>This supports the Audio System type.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_OP_ALL_DEVTYPE_SWITCH</constant></entry>
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
diff --git a/Documentation/DocBook/media/v4l/cec-ioc-adap-g-phys-addr.xml b/Documentation/DocBook/media/v4l/cec-ioc-adap-g-phys-addr.xml
new file mode 100644
index 0000000..d95f178
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/cec-ioc-adap-g-phys-addr.xml
@@ -0,0 +1,86 @@
+<refentry id="cec-ioc-adap-g-phys-addr">
+  <refmeta>
+    <refentrytitle>ioctl CEC_ADAP_G_PHYS_ADDR, CEC_ADAP_S_PHYS_ADDR</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>CEC_ADAP_G_PHYS_ADDR</refname>
+    <refname>CEC_ADAP_S_PHYS_ADDR</refname>
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
+	  <para>CEC_ADAP_G_PHYS_ADDR, CEC_ADAP_S_PHYS_ADDR</para>
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
+    <para>
+      Note: this documents the proposed CEC API. This API is not yet finalized and
+      is currently only available as a staging kernel module.
+    </para>
+
+    <para>To query the current physical address applications call the
+<constant>CEC_ADAP_G_PHYS_ADDR</constant> ioctl with a pointer to an __u16
+where the driver stores the physical address.</para>
+
+    <para>To set a new physical address applications store the physical address in
+an __u16 and call the <constant>CEC_ADAP_S_PHYS_ADDR</constant> ioctl with a
+pointer to this integer. <constant>CEC_ADAP_S_PHYS_ADDR</constant> is only
+available if <constant>CEC_CAP_PHYS_ADDR</constant> is set (&ENOTTY; will be returned
+otherwise). <constant>CEC_ADAP_S_PHYS_ADDR</constant>
+can only be called by a file handle in initiator mode (see &CEC-S-MODE;), if not
+&EBUSY; will be returned.</para>
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
diff --git a/Documentation/DocBook/media/v4l/cec-ioc-dqevent.xml b/Documentation/DocBook/media/v4l/cec-ioc-dqevent.xml
new file mode 100644
index 0000000..87d4f29
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/cec-ioc-dqevent.xml
@@ -0,0 +1,195 @@
+<refentry id="cec-ioc-g-event">
+  <refmeta>
+    <refentrytitle>ioctl CEC_DQEVENT</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>CEC_DQEVENT</refname>
+    <refpurpose>Dequeue a CEC event</refpurpose>
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
+	  <para>CEC_DQEVENT</para>
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
+    <para>
+      Note: this documents the proposed CEC API. This API is not yet finalized and
+      is currently only available as a staging kernel module.
+    </para>
+
+    <para>CEC devices can send asynchronous events. These can be retrieved by calling
+    the <constant>CEC_DQEVENT</constant> ioctl. If the file descriptor is in non-blocking
+    mode and no event is pending, then it will return -1 and set errno to the &EAGAIN;.</para>
+
+    <para>The internal event queues are per-filehandle and per-event type. If there is
+    no more room in a queue then the last event is overwritten with the new one. This
+    means that intermediate results can be thrown away but that the latest event is always
+    available. This also mean that is it possible to read two successive events that have
+    the same value (e.g. two CEC_EVENT_STATE_CHANGE events with the same state). In that
+    case the intermediate state changes were lost but it is guaranteed that the state
+    did change in between the two events.</para>
+
+    <table pgwide="1" frame="none" id="cec-event-state-change">
+      <title>struct <structname>cec_event_state_change</structname></title>
+      <tgroup cols="3">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u16</entry>
+	    <entry><structfield>phys_addr</structfield></entry>
+	    <entry>The current physical address.</entry>
+	  </row>
+	  <row>
+	    <entry>__u16</entry>
+	    <entry><structfield>log_addr_mask</structfield></entry>
+	    <entry>The current set of claimed logical addresses.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table pgwide="1" frame="none" id="cec-event-lost-msgs">
+      <title>struct <structname>cec_event_lost_msgs</structname></title>
+      <tgroup cols="3">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>lost_msgs</structfield></entry>
+	    <entry>Set to the number of lost messages since the filehandle
+	    was opened or since the last time this event was dequeued for
+	    this filehandle.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table pgwide="1" frame="none" id="cec-event">
+      <title>struct <structname>cec_event</structname></title>
+      <tgroup cols="4">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u64</entry>
+	    <entry><structfield>ts</structfield></entry>
+	    <entry>Timestamp of the event in ns.</entry>
+	    <entry></entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>event</structfield></entry>
+	    <entry>The CEC event type, see <xref linkend="cec-events" />.</entry>
+	    <entry></entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>flags</structfield></entry>
+	    <entry>Event flags, see <xref linkend="cec-event-flags" />.</entry>
+	    <entry></entry>
+	  </row>
+	  <row>
+	    <entry>union</entry>
+	    <entry>(anonymous)</entry>
+	    <entry></entry>
+	    <entry></entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry>struct cec_event_state_change</entry>
+	    <entry><structfield>state_change</structfield></entry>
+	    <entry>The new adapter state as sent by the <constant>CEC_EVENT_STATE_CHANGE</constant>
+	    event.</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry>struct cec_event_lost_msgs</entry>
+	    <entry><structfield>lost_msgs</structfield></entry>
+	    <entry>The number of lost messages as sent by the <constant>CEC_EVENT_LOST_MSGS</constant>
+	    event.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table pgwide="1" frame="none" id="cec-events">
+      <title>CEC Events Types</title>
+      <tgroup cols="3">
+	&cs-def;
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>CEC_EVENT_STATE_CHANGE</constant></entry>
+	    <entry>1</entry>
+	    <entry>Generated when the CEC Adapter's state changes. When open() is
+	    called an initial event will be generated for that filehandle with the
+	    CEC Adapter's state at that time.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_EVENT_LOST_MSGS</constant></entry>
+	    <entry>2</entry>
+	    <entry>Generated if one or more CEC messages were lost because the
+	    application didn't dequeue CEC messages fast enough.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table pgwide="1" frame="none" id="cec-event-flags">
+      <title>CEC Event Flags</title>
+      <tgroup cols="3">
+	&cs-def;
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>CEC_EVENT_FL_INITIAL_VALUE</constant></entry>
+	    <entry>1</entry>
+	    <entry>Set for the initial events that are generated when the device is
+	    opened. See the table above for which events do this. This allows
+	    applications to learn the initial state of the CEC adapter at open()
+	    time.</entry>
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
diff --git a/Documentation/DocBook/media/v4l/cec-ioc-g-mode.xml b/Documentation/DocBook/media/v4l/cec-ioc-g-mode.xml
new file mode 100644
index 0000000..26b4282
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/cec-ioc-g-mode.xml
@@ -0,0 +1,255 @@
+<refentry id="cec-ioc-g-mode">
+  <refmeta>
+    <refentrytitle>ioctl CEC_G_MODE, CEC_S_MODE</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>CEC_G_MODE</refname>
+    <refname>CEC_S_MODE</refname>
+    <refpurpose>Get or set exclusive use of the CEC adapter</refpurpose>
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
+	  <para>CEC_G_MODE, CEC_S_MODE</para>
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
+    <para>
+      Note: this documents the proposed CEC API. This API is not yet finalized and
+      is currently only available as a staging kernel module.
+    </para>
+
+    <para>By default any filehandle can use &CEC-TRANSMIT; and &CEC-RECEIVE;, but
+in order to prevent applications from stepping on each others toes it must be possible
+to obtain exclusive access to the CEC adapter. This ioctl sets the filehandle
+to initiator and/or follower mode which can be exclusive depending on the chosen
+mode. The initiator is the filehandle that is used
+to initiate messages, i.e. it commands other CEC devices. The follower is the filehandle
+that receives messages sent to the CEC adapter and processes them. The same filehandle
+can be both initiator and follower, or this role can be taken by two different
+filehandles.</para>
+
+    <para>When a CEC message is received, then the CEC framework will decide how
+it will be processed. If the message is a reply to an earlier transmitted message,
+then the reply is sent back to the filehandle that is waiting for it. In addition
+the CEC framework will process it.</para>
+
+    <para>If the message is not a reply, then the CEC framework will process it
+first. If there is no follower, then the message is just discarded and a feature
+abort is sent back to the initiator if the framework couldn't process it. If there
+is a follower, then the message is passed on to the follower who will use
+&CEC-RECEIVE; to dequeue the new message. The framework expects the follower to
+make the right decisions.</para>
+
+    <para>The CEC framework will process core messages unless requested otherwise
+by the follower. The follower can enable the passthrough mode. In that case, the
+CEC framework will pass on most core messages without processing them and
+the follower will have to implement those messages. There are some messages
+that the core will always process, regardless of the passthrough mode. See
+<xref linkend="cec-core-processing" /> for details.</para>
+
+    <para>If there is no initiator, then any CEC filehandle can use &CEC-TRANSMIT;.
+If there is an exclusive initiator then only that initiator can call &CEC-TRANSMIT;.
+The follower can of course always call &CEC-TRANSMIT;.</para>
+
+    <para>Available initiator modes are:</para>
+
+    <table pgwide="1" frame="none" id="cec-mode-initiator">
+      <title>Initiator Modes</title>
+      <tgroup cols="3">
+	&cs-def;
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>CEC_MODE_NO_INITIATOR</constant></entry>
+	    <entry>0x0</entry>
+	    <entry>This is not an initiator, i.e. it cannot transmit CEC messages
+	    or make any other changes to the CEC adapter.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_MODE_INITIATOR</constant></entry>
+	    <entry>0x1</entry>
+	    <entry>This is an initiator (the default when the device is opened) and it
+	    can transmit CEC messages and make changes to the CEC adapter, unless there
+	    is an exclusive initiator.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_MODE_EXCL_INITIATOR</constant></entry>
+	    <entry>0x2</entry>
+	    <entry>This is an exclusive initiator and this file descriptor is the only one
+	    that can transmit CEC messages and make changes to the CEC adapter. If someone
+	    else is already the exclusive initiator then an attempt to become one will return
+	    the &EBUSY; error.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <para>Available follower modes are:</para>
+
+    <table pgwide="1" frame="none" id="cec-mode-follower">
+      <title>Follower Modes</title>
+      <tgroup cols="3">
+	&cs-def;
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>CEC_MODE_NO_FOLLOWER</constant></entry>
+	    <entry>0x00</entry>
+	    <entry>This is not a follower (the default when the device is opened).</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_MODE_FOLLOWER</constant></entry>
+	    <entry>0x10</entry>
+	    <entry>This is a follower and it will receive CEC messages unless there is
+	    an exclusive follower. You cannot become a follower if <constant>CEC_CAP_TRANSMIT</constant>
+	    is not set or if <constant>CEC_MODE_NO_INITIATOR</constant> was specified,
+	    &EINVAL; is returned in that case.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_MODE_EXCL_FOLLOWER</constant></entry>
+	    <entry>0x20</entry>
+	    <entry>This is an exclusive follower and only this file descriptor will receive
+	    CEC messages for processing. If someone else is already the exclusive follower
+	    then an attempt to become one will return the &EBUSY; error. You cannot become
+	    a follower if <constant>CEC_CAP_TRANSMIT</constant> is not set or if
+	    <constant>CEC_MODE_NO_INITIATOR</constant> was specified, &EINVAL; is returned
+	    in that case.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_MODE_EXCL_FOLLOWER_PASSTHRU</constant></entry>
+	    <entry>0x30</entry>
+	    <entry>This is an exclusive follower and only this file descriptor will receive
+	    CEC messages for processing. In addition it will put the CEC device into
+	    passthrough mode, allowing the exclusive follower to handle most core messages
+	    instead of relying on the CEC framework for that. If someone else is already the
+	    exclusive follower then an attempt to become one will return the &EBUSY; error.
+	    You cannot become a follower if <constant>CEC_CAP_TRANSMIT</constant>
+            is not set or if <constant>CEC_MODE_NO_INITIATOR</constant> was specified,
+            &EINVAL; is returned in that case.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_MODE_MONITOR</constant></entry>
+	    <entry>0xe0</entry>
+	    <entry>Put the file descriptor into monitor mode. Can only be used in combination
+	    with <constant>CEC_MODE_NO_INITIATOR</constant>, otherwise &EINVAL; will be
+	    returned. In monitor mode all messages this CEC device transmits and all messages
+	    it receives (both broadcast messages and directed messages for one its logical
+	    addresses) will be reported. This is very useful for debugging. This is only
+	    allowed if the process has the <constant>CAP_NET_ADMIN</constant>
+	    capability. If that is not set, then &EPERM; is returned.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_MODE_MONITOR_ALL</constant></entry>
+	    <entry>0xf0</entry>
+	    <entry>Put the file descriptor into 'monitor all' mode. Can only be used in combination
+            with <constant>CEC_MODE_NO_INITIATOR</constant>, otherwise &EINVAL; will be
+            returned. In 'monitor all' mode all messages this CEC device transmits and all messages
+            it receives, including directed messages for other CEC devices will be reported. This
+	    is very useful for debugging, but not all devices support this. This mode requires that
+	    the <constant>CEC_CAP_MONITOR_ALL</constant> capability is set, otherwise &EINVAL; is
+	    returned. This is only allowed if the process has the <constant>CAP_NET_ADMIN</constant>
+	    capability. If that is not set, then &EPERM; is returned.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <para>Core message processing details:</para>
+
+    <table pgwide="1" frame="none" id="cec-core-processing">
+      <title>Core Message Processing</title>
+      <tgroup cols="2">
+	&cs-def;
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>CEC_MSG_GET_CEC_VERSION</constant></entry>
+	    <entry>When in passthrough mode this message has to be handled by userspace,
+	    otherwise the core will return the CEC version that was set with &CEC-ADAP-S-LOG-ADDRS;.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_MSG_GIVE_DEVICE_VENDOR_ID</constant></entry>
+	    <entry>When in passthrough mode this message has to be handled by userspace,
+	    otherwise the core will return the vendor ID that was set with &CEC-ADAP-S-LOG-ADDRS;.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_MSG_ABORT</constant></entry>
+	    <entry>When in passthrough mode this message has to be handled by userspace,
+	    otherwise the core will return a feature refused message as per the specification.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_MSG_GIVE_PHYSICAL_ADDR</constant></entry>
+	    <entry>When in passthrough mode this message has to be handled by userspace,
+	    otherwise the core will report the current physical address.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_MSG_GIVE_OSD_NAME</constant></entry>
+	    <entry>When in passthrough mode this message has to be handled by userspace,
+	    otherwise the core will report the current OSD name as was set with
+	    &CEC-ADAP-S-LOG-ADDRS;.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_MSG_GIVE_FEATURES</constant></entry>
+	    <entry>When in passthrough mode this message has to be handled by userspace,
+	    otherwise the core will report the current features as was set with
+	    &CEC-ADAP-S-LOG-ADDRS; or the message is ignore if the CEC version was
+	    older than 2.0.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_MSG_USER_CONTROL_PRESSED</constant></entry>
+	    <entry>If <constant>CEC_CAP_RC</constant> is set, then generate a remote control
+	    key press. This message is always passed on to userspace.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_MSG_USER_CONTROL_RELEASED</constant></entry>
+	    <entry>If <constant>CEC_CAP_RC</constant> is set, then generate a remote control
+	    key release. This message is always passed on to userspace.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_MSG_REPORT_PHYSICAL_ADDR</constant></entry>
+	    <entry>The CEC framework will make note of the reported physical address
+	    and then just pass the message on to userspace.</entry>
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
diff --git a/Documentation/DocBook/media/v4l/cec-ioc-receive.xml b/Documentation/DocBook/media/v4l/cec-ioc-receive.xml
new file mode 100644
index 0000000..4da7239
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/cec-ioc-receive.xml
@@ -0,0 +1,265 @@
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
+    <para>
+      Note: this documents the proposed CEC API. This API is not yet finalized and
+      is currently only available as a staging kernel module.
+    </para>
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
+	    <entry>__u64</entry>
+	    <entry><structfield>ts</structfield></entry>
+	    <entry>Timestamp of when the message was transmitted in ns in the case
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
+	    <entry><structfield>timeout</structfield></entry>
+	    <entry>The timeout in milliseconds. This is the time we wait for a message to
+	    be received. If it is set to 0, then we wait indefinitely.
+	    It is ignored by <constant>CEC_TRANSMIT</constant>.</entry>
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
+	    <entry>__u32</entry>
+	    <entry><structfield>flags</structfield></entry>
+	    <entry>Flags. No flags are defined yet, so set this to 0.</entry>
+	  </row>
+	  <row>
+	    <entry>__u8</entry>
+	    <entry><structfield>rx_status</structfield></entry>
+	    <entry>The status bits of the received message. See <xref linkend="cec-rx-status" />
+	    for the possible status values. It is 0 if this message was transmitted, not
+	    received, unless this is the reply to a transmitted message. In that case both
+	    <structfield>rx_status</structfield> and <structfield>tx_status</structfield>
+	    are set.</entry>
+	  </row>
+	  <row>
+	    <entry>__u8</entry>
+	    <entry><structfield>tx_status</structfield></entry>
+	    <entry>The status bits of the transmitted message. See <xref linkend="cec-tx-status" />
+	    for the possible status values. It is 0 if this messages was received, not
+	    transmitted.</entry>
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
+	    <entry>__u8</entry>
+	    <entry><structfield>tx_arb_lost_cnt</structfield></entry>
+	    <entry>A counter of the number of transmit attempts that resulted in the
+	    Arbitration Lost error. This is only set if the hardware supports this, otherwise
+	    it is always 0. This counter is only valid if the <constant>CEC_TX_STATUS_ARB_LOST</constant>
+	    status bit is set.</entry>
+	  </row>
+	  <row>
+	    <entry>__u8</entry>
+	    <entry><structfield>tx_nack_cnt</structfield></entry>
+	    <entry>A counter of the number of transmit attempts that resulted in the
+	    Not Acknowledged error. This is only set if the hardware supports this, otherwise
+	    it is always 0. This counter is only valid if the <constant>CEC_TX_STATUS_NACK</constant>
+            status bit is set.</entry>
+	  </row>
+	  <row>
+	    <entry>__u8</entry>
+	    <entry><structfield>tx_low_drive_cnt</structfield></entry>
+	    <entry>A counter of the number of transmit attempts that resulted in the
+	    Arbitration Lost error. This is only set if the hardware supports this, otherwise
+	    it is always 0. This counter is only valid if the <constant>CEC_TX_STATUS_LOW_DRIVE</constant>
+            status bit is set.</entry>
+	  </row>
+	  <row>
+	    <entry>__u8</entry>
+	    <entry><structfield>tx_error_cnt</structfield></entry>
+	    <entry>A counter of the number of transmit errors other than Arbitration Lost
+	    or Not Acknowledged. This is only set if the hardware supports this, otherwise
+	    it is always 0. This counter is only valid if the <constant>CEC_TX_STATUS_ERROR</constant>
+	    status bit is set.</entry>
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
+	    <entry>0x01</entry>
+	    <entry>The message was transmitted successfully. This is mutually exclusive with
+	    <constant>CEC_TX_STATUS_MAX_RETRIES</constant>. Other bits can still be set if
+	    earlier attempts met with failure before the transmit was eventually successful.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_TX_STATUS_ARB_LOST</constant></entry>
+	    <entry>0x02</entry>
+	    <entry>CEC line arbitration was lost.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_TX_STATUS_NACK</constant></entry>
+	    <entry>0x04</entry>
+	    <entry>Message was not acknowledged.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_TX_STATUS_LOW_DRIVE</constant></entry>
+	    <entry>0x08</entry>
+	    <entry>Low drive was detected on the CEC bus. This indicates that a follower
+	    detected an error on the bus and requests a retransmission.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_TX_STATUS_ERROR</constant></entry>
+	    <entry>0x10</entry>
+	    <entry>Some error occurred. This is used for any errors that do not
+	    fit the previous two, either because the hardware could not tell
+	    which error occurred, or because the hardware tested for other conditions
+	    besides those two.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_TX_STATUS_MAX_RETRIES</constant></entry>
+	    <entry>0x20</entry>
+	    <entry>The transmit failed after one or more retries. This status bit is mutually
+	    exclusive with <constant>CEC_TX_STATUS_OK</constant>. Other bits can still be set
+	    to explain which failures were seen.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table pgwide="1" frame="none" id="cec-rx-status">
+      <title>CEC Receive Status</title>
+      <tgroup cols="3">
+	&cs-def;
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>CEC_RX_STATUS_OK</constant></entry>
+	    <entry>0x01</entry>
+	    <entry>The message was received successfully.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_RX_STATUS_TIMEOUT</constant></entry>
+	    <entry>0x02</entry>
+	    <entry>The reply to an earlier transmitted message timed out.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_RX_STATUS_FEATURE_ABORT</constant></entry>
+	    <entry>0x04</entry>
+	    <entry>The message was received successfully but the reply was
+	    <constant>CEC_MSG_FEATURE_ABORT</constant>. This status is only
+	    set if this message was the reply to an earlier transmitted
+	    message.</entry>
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
index 7b77e0f..a2765d8 100644
--- a/Documentation/DocBook/media_api.tmpl
+++ b/Documentation/DocBook/media_api.tmpl
@@ -75,7 +75,7 @@
 	    </mediaobject>
 	</figure>
 	<para>The media infrastructure API was designed to control such
-	    devices. It is divided into four parts.</para>
+	    devices. It is divided into five parts.</para>
 	<para>The first part covers radio, video capture and output,
 		cameras, analog TV devices and codecs.</para>
 	<para>The second part covers the
@@ -87,6 +87,7 @@
 		<xref linkend="fe-delivery-system-t" />.</para>
 	<para>The third part covers the Remote Controller API.</para>
 	<para>The fourth part covers the Media Controller API.</para>
+	<para>The fifth part covers the CEC (Consumer Electronics Control) API.</para>
 	<para>It should also be noted that a media device may also have audio
 	      components, like mixers, PCM capture, PCM playback, etc, which
 	      are controlled via ALSA API.</para>
@@ -107,6 +108,9 @@
 <part id="media_common">
 &sub-media-controller;
 </part>
+<part id="cec">
+&sub-cec-api;
+</part>
 
 <chapter id="gen_errors">
 &sub-gen-errors;
-- 
2.8.1

