Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab0GCEKK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Jul 2010 00:10:10 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o634AArT005322
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 3 Jul 2010 00:10:10 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [10.16.43.238])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o634A9md023544
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 3 Jul 2010 00:10:10 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [127.0.0.1])
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.3) with ESMTP id o634A9xS031560
	for <linux-media@vger.kernel.org>; Sat, 3 Jul 2010 00:10:09 -0400
Received: (from jarod@localhost)
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.4/Submit) id o634A9f2031558
	for linux-media@vger.kernel.org; Sat, 3 Jul 2010 00:10:09 -0400
Date: Sat, 3 Jul 2010 00:10:09 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/3] IR/lirc: add docbook info covering lirc device interface
Message-ID: <20100703041009.GF31255@redhat.com>
References: <20100601205005.GA28322@redhat.com>
 <20100703040530.GB31255@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100703040530.GB31255@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

First ever crack at creating docbook documentation... Contains a bevy of
information on the various lirc device interface ioctls, as well as a
bit about the read and write interfaces.

Forgot about this in 0/3, so this is patch 4/3. Oops.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 .../DocBook/v4l/lirc_device_interface.xml          |  235 ++++++++++++++++++++
 1 files changed, 235 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/lirc_device_interface.xml

diff --git a/Documentation/DocBook/v4l/lirc_device_interface.xml b/Documentation/DocBook/v4l/lirc_device_interface.xml
new file mode 100644
index 0000000..a6244ed
--- /dev/null
+++ b/Documentation/DocBook/v4l/lirc_device_interface.xml
@@ -0,0 +1,235 @@
+<title>LIRC Device Interface</title>
+
+
+<section id="lirc_dev_intro">
+<title>Introduction</title>
+
+<para>The LIRC device interface is a bi-directional interface for 
+transporting raw IR data between userspace and kernelspace. Fundamentally, 
+it is just a chardev (/dev/lircX, for X = 0, 1, 2, ...), with a number 
+of standard struct file_operations defined on it. With respect to 
+transporting raw IR data to and fro, the essential fops are read, write 
+and ioctl.</para>
+
+<para>Example dmesg output upon a driver registering w/LIRC:</para>
+  <blockquote>
+    <para>$ dmesg |grep lirc_dev</para>
+    <para>lirc_dev: IR Remote Control driver registered, major 248</para>
+    <para>rc rc0: lirc_dev: driver ir-lirc-codec (mceusb) registered at minor = 0</para>
+  </blockquote>
+<para>
+
+<para>What you should see for a chardev:</para>
+  <blockquote>
+    <para>$ ls -l /dev/lirc*</para>
+    <para>crw-rw---- 1 root root 248, 0 Jul  2 22:20 /dev/lirc0</para>
+  </blockquote>
+</para>
+
+
+<section id="lirc_read">
+<title>LIRC read fop</title>
+
+<para>The lircd userspace daemon reads raw IR data from the LIRC chardev. The 
+exact format of the data depends on what modes a driver supports, and what 
+mode has been selected. lircd obtains supported modes and sets the active mode 
+via the ioctl interface, detailed at <xref linkend="lirc_ioctl">. The generally 
+preferred mode is LIRC_MODE_MODE2, in which packets containing an int value 
+describing an IR signal are read from the chardev.</para>
+
+<para>See also <ulink url="http://www.lirc.org/html/technical.html">http://www.lirc.org/html/technical.html</> for more info.</para>
+
+
+<section id="lirc_write">
+<title>LIRC write fop</title>
+
+<para>The data written to the chardev is a pulse/space sequence of integer 
+values. Pulses and spaces are only marked implicitly by their position. The 
+data must start and end with a pulse, therefore, the data must always include 
+an unevent number of samples. The write function must block until the data has 
+been transmitted by the hardware.</para>
+
+
+<section id="lirc_ioctl">
+<title> LIRC ioctl fop</title>
+
+<para>The LIRC device's ioctl definition is bound by the ioctl function 
+definition of struct file_operations, leaving us with an unsigned int 
+for the ioctl command and an unsigned long for the arg. For the purposes 
+of ioctl portability across 32-bit and 64-bit, these values are capped 
+to their 32-bit sizes.</para>
+
+<para>The following ioctls can be used to change specific hardware settings. 
+In general each driver should have a default set of settings. The driver 
+implementation is expected to re-apply the default settings when the device 
+is closed by user-space, so that every application opening the device can rely 
+on working with the default settings initially.</para>
+
+<variablelist>
+  <varlistentry>
+    <term>LIRC_GET_FEATURES</term>
+    <listitem>
+      <to>Obviously, get the underlying hardware device's features. If a driver 
+      does not announce support of certain features, calling of the corresponding 
+      ioctls is undefined.</to>
+    </listitem>
+  </varlistentry>
+  <varlistentry>
+    <term>LIRC_GET_SEND_MODE</term>
+    <listitem>
+      <to>Get supported transmit mode. Only LIRC_MODE_PULSE is supported by lircd.</to>
+    </listitem>
+  </varlistentry>
+  <varlistentry>
+    <term>LIRC_GET_REC_MODE</term>
+    <listitem>
+      <to>Get supported receive modes. Only LIRC_MODE_MODE2 and LIRC_MODE_LIRCCODE 
+      are supported by lircd.</to>
+    </listitem>
+  </varlistentry>
+  <varlistentry>
+    <term>LIRC_GET_SEND_CARRIER</term>
+    <listitem>
+      <to>Get carrier frequency (in Hz) currently used for transmit.</to>
+    </listitem>
+  </varlistentry>
+  <varlistentry>
+    <term>LIRC_GET_REC_CARRIER</term>
+    <listitem>
+      <to>Get carrier frequency (in Hz) currently used for IR reception.</to>
+    </listitem>
+  </varlistentry>
+  <varlistentry>
+    <term>LIRC_{G,S}ET_{SEND,REC}_DUTY_CYCLE</term>
+    <listitem>
+      <to>Get/set the duty cycle (from 0 to 100) of the carrier signal. Currently, 
+      no special meaning is defined for 0 or 100, but this could be used to switch 
+      off carrier generation in the future, so these values should be reserved.</to>
+    </listitem>
+  </varlistentry>
+  <varlistentry>
+    <term>LIRC_GET_REC_RESOLUTION</term>
+    <listitem>
+      <to>Some receiver have maximum resolution which is defined by internal 
+      sample rate or data format limitations. E.g. it's common that signals can 
+      only be reported in 50 microsecond steps. This integer value is used by 
+      lircd to automatically adjust the aeps tolerance value in the lircd 
+      config file.</to>
+    </listitem>
+  </varlistentry>
+  <varlistentry>
+    <term>LIRC_GET_M{IN,AX}_TIMEOUT</term>
+    <listitem>
+      <to>Some devices have internal timers that can be used to detect when 
+      there's no IR activity for a long time. This can help lircd in detecting 
+      that a IR signal is finished and can speed up the decoding process. 
+      Returns an integer value with the minimum/maximum timeout that can be 
+      set. Some devices have a fixed timeout, in that case both ioctls will 
+      return the same value even though the timeout cannot be changed.</to>
+    </listitem>
+  </varlistentry>
+  <varlistentry>
+    <term>LIRC_GET_M{IN,AX}_FILTER_{PULSE,SPACE}</term>
+    <listitem>
+      <to>Some devices are able to filter out spikes in the incoming signal 
+      using given filter rules. These ioctls return the hardware capabilities 
+      that describe the bounds of the possible filters. Filter settings depend 
+      on the IR protocols that are expected. lircd derives the settings from 
+      all protocols definitions found in its config file.</to>
+    </listitem>
+  </varlistentry>
+  <varlistentry>
+    <term>LIRC_GET_LENGTH</term>
+    <listitem>
+      <to>Retrieves the code length in bits (only for LIRC_MODE_LIRCCODE). 
+      Reads on the device must be done in blocks matching the bit count. 
+      The bit could should be rounded up so that it matches full bytes.</to>
+    </listitem>
+  </varlistentry>
+  <varlistentry>
+    <term>LIRC_SET_{SEND,REC}_MODE</term>
+    <listitem>
+      <to>Set send/receive mode. Largely obsolete for send, as only 
+      LIRC_MODE_PULSE is supported.</to>
+    </listitem>
+  </varlistentry>
+  <varlistentry>
+    <term>LIRC_SET_{SEND,REC}_CARRIER</term>
+    <listitem>
+      <to>Set send/receive carrier (in Hz).</to>
+    </listitem>
+  </varlistentry>
+  <varlistentry>
+    <term>LIRC_SET_TRANSMITTER_MASK</term>
+    <listitem>
+      <to>This enables the given set of transmitters. The first transmitter 
+      is encoded by the least significant bit, etc. When an invalid bit mask 
+      is given, i.e. a bit is set, even though the device does not have so many 
+      transitters, then this ioctl returns the number of available transitters 
+      and does nothing otherwise.</to>
+    </listitem>
+  </varlistentry>
+  <varlistentry>
+    <term>LIRC_SET_REC_TIMEOUT</term>
+    <listitem>
+      <to>Sets the integer value for IR inactivity timeout (cf. 
+      LIRC_GET_MIN_TIMEOUT and LIRC_GET_MAX_TIMEOUT). A value of 0 (if 
+      supported by the hardware) disables all hardware timeouts and data should 
+      be reported as soon as possible. If the exact value cannot be set, then 
+      the next possible value _greater_ than the given value should be set.</to>
+    </listitem>
+  </varlistentry>
+  <varlistentry>
+    <term>LIRC_SET_REC_TIMEOUT_REPORTS</term>
+    <listitem>
+      <to>Enable (1) or disable (0) timeout reports in LIRC_MODE_MODE2. By 
+      default, timeout reports should be turned off.</to>
+    </listitem>
+  </varlistentry>
+  <varlistentry>
+    <term>LIRC_SET_REC_FILTER_{,PULSE,SPACE}</term>
+    <listitem>
+      <to>Pulses/spaces shorter than this are filtered out by hardware. If 
+      filters cannot be set independently for pulse/space, the corresponding 
+      ioctls must return an error and LIRC_SET_REC_FILTER shall be used instead.</to>
+    </listitem>
+  </varlistentry>
+  <varlistentry>
+    <term>LIRC_SET_MEASURE_CARRIER_MODE</term>
+    <listitem>
+      <to>Enable (1)/disable (0) measure mode. If enabled, from the next key 
+      press on, the driver will send LIRC_MODE2_FREQUENCY packets. By default 
+      this should be turned off.</to>
+    </listitem>
+  </varlistentry>
+  <varlistentry>
+    <term>LIRC_SET_REC_{DUTY_CYCLE,CARRIER}_RANGE</term>
+    <listitem>
+      <to>To set a range use LIRC_SET_REC_DUTY_CYCLE_RANGE/LIRC_SET_REC_CARRIER_RANGE
+      with the lower bound first and later LIRC_SET_REC_DUTY_CYCLE/LIRC_SET_REC_CARRIER 
+      with the upper bound.</to>
+    </listitem>
+  </varlistentry>
+  <varlistentry>
+    <term>LIRC_NOTIFY_DECODE</term>
+    <listitem>
+      <to>This ioctl is called by lircd whenever a successful decoding of an 
+      incoming IR signal could be done. This can be used by supporting hardware 
+      to give visual feedback to the user e.g. by flashing a LED.</to>
+    </listitem>
+  </varlistentry>
+  <varlistentry>
+    <term>LIRC_SETUP_{START,END}</term>
+    <listitem>
+      <to>Setting of several driver parameters can be optimized by encapsulating 
+      the according ioctl calls with LIRC_SETUP_START/LIRC_SETUP_END. When a 
+      driver receives a LIRC_SETUP_START ioctl it can choose to not commit 
+      further setting changes to the hardware until a LIRC_SETUP_END is received. 
+      But this is open to the driver implementation and every driver must also 
+      handle parameter changes which are not encapsulated by LIRC_SETUP_START
+      and LIRC_SETUP_END. Drivers can also choose to ignore these ioctls.</to>
+    </listitem>
+  </varlistentry>
+</variablelist>
+
+</section>
-- 
1.7.1


-- 
Jarod Wilson
jarod@redhat.com

