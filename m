Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:41592 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbbEDRfI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 13:35:08 -0400
From: Kamil Debski <k.debski@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, k.debski@samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu
Subject: [PATCH v2] libgencec: Add userspace library for the generic CEC kernel
 interface
Date: Mon, 04 May 2015 19:33:05 +0200
Message-id: <1430760785-1169-13-git-send-email-k.debski@samsung.com>
In-reply-to: <1430760785-1169-1-git-send-email-k.debski@samsung.com>
References: <1430760785-1169-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the first version of the libGenCEC library. It was designed to
act as an interface between the generic CEC kernel API and userspace
applications. It provides a simple interface for applications and an
example application that can be used to test the CEC functionality.

signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 AUTHORS              |    1 +
 INSTALL              |    9 +
 LICENSE              |  202 ++++++++++++++++
 Makefile.am          |    4 +
 README               |   22 ++
 configure.ac         |   24 ++
 doc/index.html       |  345 +++++++++++++++++++++++++++
 examples/Makefile.am |    4 +
 examples/cectest.c   |  631 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/gencec.h     |  255 ++++++++++++++++++++
 libgencec.pc.in      |   10 +
 src/Makefile.am      |    4 +
 src/gencec.c         |  445 +++++++++++++++++++++++++++++++++++
 13 files changed, 1956 insertions(+)
 create mode 100644 AUTHORS
 create mode 100644 INSTALL
 create mode 100644 LICENSE
 create mode 100644 Makefile.am
 create mode 100644 README
 create mode 100644 configure.ac
 create mode 100644 doc/index.html
 create mode 100644 examples/Makefile.am
 create mode 100644 examples/cectest.c
 create mode 100644 include/gencec.h
 create mode 100644 libgencec.pc.in
 create mode 100644 src/Makefile.am
 create mode 100644 src/gencec.c

diff --git a/AUTHORS b/AUTHORS
new file mode 100644
index 0000000..e4b7117
--- /dev/null
+++ b/AUTHORS
@@ -0,0 +1 @@
+Kamil Debski <k.debski@samsung.com>
diff --git a/INSTALL b/INSTALL
new file mode 100644
index 0000000..aac6101
--- /dev/null
+++ b/INSTALL
@@ -0,0 +1,9 @@
+To install libgencec run following commands:
+
+autoreconf -i
+./configure
+make
+make install
+
+A cross compilation example for ARM:
+CFLAGS=-I<kernel headers> ./configure --host=arm-linux-gnueabi --prefix=<installation prefix>
diff --git a/LICENSE b/LICENSE
new file mode 100644
index 0000000..d645695
--- /dev/null
+++ b/LICENSE
@@ -0,0 +1,202 @@
+
+                                 Apache License
+                           Version 2.0, January 2004
+                        http://www.apache.org/licenses/
+
+   TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION
+
+   1. Definitions.
+
+      "License" shall mean the terms and conditions for use, reproduction,
+      and distribution as defined by Sections 1 through 9 of this document.
+
+      "Licensor" shall mean the copyright owner or entity authorized by
+      the copyright owner that is granting the License.
+
+      "Legal Entity" shall mean the union of the acting entity and all
+      other entities that control, are controlled by, or are under common
+      control with that entity. For the purposes of this definition,
+      "control" means (i) the power, direct or indirect, to cause the
+      direction or management of such entity, whether by contract or
+      otherwise, or (ii) ownership of fifty percent (50%) or more of the
+      outstanding shares, or (iii) beneficial ownership of such entity.
+
+      "You" (or "Your") shall mean an individual or Legal Entity
+      exercising permissions granted by this License.
+
+      "Source" form shall mean the preferred form for making modifications,
+      including but not limited to software source code, documentation
+      source, and configuration files.
+
+      "Object" form shall mean any form resulting from mechanical
+      transformation or translation of a Source form, including but
+      not limited to compiled object code, generated documentation,
+      and conversions to other media types.
+
+      "Work" shall mean the work of authorship, whether in Source or
+      Object form, made available under the License, as indicated by a
+      copyright notice that is included in or attached to the work
+      (an example is provided in the Appendix below).
+
+      "Derivative Works" shall mean any work, whether in Source or Object
+      form, that is based on (or derived from) the Work and for which the
+      editorial revisions, annotations, elaborations, or other modifications
+      represent, as a whole, an original work of authorship. For the purposes
+      of this License, Derivative Works shall not include works that remain
+      separable from, or merely link (or bind by name) to the interfaces of,
+      the Work and Derivative Works thereof.
+
+      "Contribution" shall mean any work of authorship, including
+      the original version of the Work and any modifications or additions
+      to that Work or Derivative Works thereof, that is intentionally
+      submitted to Licensor for inclusion in the Work by the copyright owner
+      or by an individual or Legal Entity authorized to submit on behalf of
+      the copyright owner. For the purposes of this definition, "submitted"
+      means any form of electronic, verbal, or written communication sent
+      to the Licensor or its representatives, including but not limited to
+      communication on electronic mailing lists, source code control systems,
+      and issue tracking systems that are managed by, or on behalf of, the
+      Licensor for the purpose of discussing and improving the Work, but
+      excluding communication that is conspicuously marked or otherwise
+      designated in writing by the copyright owner as "Not a Contribution."
+
+      "Contributor" shall mean Licensor and any individual or Legal Entity
+      on behalf of whom a Contribution has been received by Licensor and
+      subsequently incorporated within the Work.
+
+   2. Grant of Copyright License. Subject to the terms and conditions of
+      this License, each Contributor hereby grants to You a perpetual,
+      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
+      copyright license to reproduce, prepare Derivative Works of,
+      publicly display, publicly perform, sublicense, and distribute the
+      Work and such Derivative Works in Source or Object form.
+
+   3. Grant of Patent License. Subject to the terms and conditions of
+      this License, each Contributor hereby grants to You a perpetual,
+      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
+      (except as stated in this section) patent license to make, have made,
+      use, offer to sell, sell, import, and otherwise transfer the Work,
+      where such license applies only to those patent claims licensable
+      by such Contributor that are necessarily infringed by their
+      Contribution(s) alone or by combination of their Contribution(s)
+      with the Work to which such Contribution(s) was submitted. If You
+      institute patent litigation against any entity (including a
+      cross-claim or counterclaim in a lawsuit) alleging that the Work
+      or a Contribution incorporated within the Work constitutes direct
+      or contributory patent infringement, then any patent licenses
+      granted to You under this License for that Work shall terminate
+      as of the date such litigation is filed.
+
+   4. Redistribution. You may reproduce and distribute copies of the
+      Work or Derivative Works thereof in any medium, with or without
+      modifications, and in Source or Object form, provided that You
+      meet the following conditions:
+
+      (a) You must give any other recipients of the Work or
+          Derivative Works a copy of this License; and
+
+      (b) You must cause any modified files to carry prominent notices
+          stating that You changed the files; and
+
+      (c) You must retain, in the Source form of any Derivative Works
+          that You distribute, all copyright, patent, trademark, and
+          attribution notices from the Source form of the Work,
+          excluding those notices that do not pertain to any part of
+          the Derivative Works; and
+
+      (d) If the Work includes a "NOTICE" text file as part of its
+          distribution, then any Derivative Works that You distribute must
+          include a readable copy of the attribution notices contained
+          within such NOTICE file, excluding those notices that do not
+          pertain to any part of the Derivative Works, in at least one
+          of the following places: within a NOTICE text file distributed
+          as part of the Derivative Works; within the Source form or
+          documentation, if provided along with the Derivative Works; or,
+          within a display generated by the Derivative Works, if and
+          wherever such third-party notices normally appear. The contents
+          of the NOTICE file are for informational purposes only and
+          do not modify the License. You may add Your own attribution
+          notices within Derivative Works that You distribute, alongside
+          or as an addendum to the NOTICE text from the Work, provided
+          that such additional attribution notices cannot be construed
+          as modifying the License.
+
+      You may add Your own copyright statement to Your modifications and
+      may provide additional or different license terms and conditions
+      for use, reproduction, or distribution of Your modifications, or
+      for any such Derivative Works as a whole, provided Your use,
+      reproduction, and distribution of the Work otherwise complies with
+      the conditions stated in this License.
+
+   5. Submission of Contributions. Unless You explicitly state otherwise,
+      any Contribution intentionally submitted for inclusion in the Work
+      by You to the Licensor shall be under the terms and conditions of
+      this License, without any additional terms or conditions.
+      Notwithstanding the above, nothing herein shall supersede or modify
+      the terms of any separate license agreement you may have executed
+      with Licensor regarding such Contributions.
+
+   6. Trademarks. This License does not grant permission to use the trade
+      names, trademarks, service marks, or product names of the Licensor,
+      except as required for reasonable and customary use in describing the
+      origin of the Work and reproducing the content of the NOTICE file.
+
+   7. Disclaimer of Warranty. Unless required by applicable law or
+      agreed to in writing, Licensor provides the Work (and each
+      Contributor provides its Contributions) on an "AS IS" BASIS,
+      WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
+      implied, including, without limitation, any warranties or conditions
+      of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A
+      PARTICULAR PURPOSE. You are solely responsible for determining the
+      appropriateness of using or redistributing the Work and assume any
+      risks associated with Your exercise of permissions under this License.
+
+   8. Limitation of Liability. In no event and under no legal theory,
+      whether in tort (including negligence), contract, or otherwise,
+      unless required by applicable law (such as deliberate and grossly
+      negligent acts) or agreed to in writing, shall any Contributor be
+      liable to You for damages, including any direct, indirect, special,
+      incidental, or consequential damages of any character arising as a
+      result of this License or out of the use or inability to use the
+      Work (including but not limited to damages for loss of goodwill,
+      work stoppage, computer failure or malfunction, or any and all
+      other commercial damages or losses), even if such Contributor
+      has been advised of the possibility of such damages.
+
+   9. Accepting Warranty or Additional Liability. While redistributing
+      the Work or Derivative Works thereof, You may choose to offer,
+      and charge a fee for, acceptance of support, warranty, indemnity,
+      or other liability obligations and/or rights consistent with this
+      License. However, in accepting such obligations, You may act only
+      on Your own behalf and on Your sole responsibility, not on behalf
+      of any other Contributor, and only if You agree to indemnify,
+      defend, and hold each Contributor harmless for any liability
+      incurred by, or claims asserted against, such Contributor by reason
+      of your accepting any such warranty or additional liability.
+
+   END OF TERMS AND CONDITIONS
+
+   APPENDIX: How to apply the Apache License to your work.
+
+      To apply the Apache License to your work, attach the following
+      boilerplate notice, with the fields enclosed by brackets "[]"
+      replaced with your own identifying information. (Don't include
+      the brackets!)  The text should be enclosed in the appropriate
+      comment syntax for the file format. We also recommend that a
+      file or class name and description of purpose be included on the
+      same "printed page" as the copyright notice for easier
+      identification within third-party archives.
+
+   Copyright [yyyy] [name of copyright owner]
+
+   Licensed under the Apache License, Version 2.0 (the "License");
+   you may not use this file except in compliance with the License.
+   You may obtain a copy of the License at
+
+       http://www.apache.org/licenses/LICENSE-2.0
+
+   Unless required by applicable law or agreed to in writing, software
+   distributed under the License is distributed on an "AS IS" BASIS,
+   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
+   See the License for the specific language governing permissions and
+   limitations under the License.
diff --git a/Makefile.am b/Makefile.am
new file mode 100644
index 0000000..d9e0449
--- /dev/null
+++ b/Makefile.am
@@ -0,0 +1,4 @@
+SUBDIRS = src examples
+ACLOCAL_AMFLAGS = -I m4
+library_includedir=$(includedir)
+library_include_HEADERS = include/gencec.h
diff --git a/README b/README
new file mode 100644
index 0000000..bb817b7
--- /dev/null
+++ b/README
@@ -0,0 +1,22 @@
+libGenCEC - library for the generic HDMI CEC kernel interface
+--------------------------------------------------------------------------
+
+The libGenCEC library is a simple library that was written to facilitate
+proper configuration and use of HDMI CEC devices that use the generic HDMI
+CEC kernel interface.
+
+The library provides a range of functions that wrap around the ioctls of the
+kernel API. It contains a test application that can be used to communicate
+through the CEC bus with other compatible devices.
+
+The test application also serves as a code example on how to use the library.
+
+The library calls are documented in the gencec.h file.
+
+Example application use
+--------------------------------------------------------------------------
+The following command will initiate the devic, set the name and enable
+keypress forwarding. Tested on a Samsung TV model LE32C650.
+
+./cectest -e -l playback -P -O Test123 -T -A -M on
+
diff --git a/configure.ac b/configure.ac
new file mode 100644
index 0000000..e7639a2
--- /dev/null
+++ b/configure.ac
@@ -0,0 +1,24 @@
+AC_INIT([libgencec], [0.1], [k.debski@samsung.com])
+AM_INIT_AUTOMAKE([-Wall -Werror foreign])
+
+AC_PROG_CC
+AM_PROG_AR
+AC_CONFIG_MACRO_DIR([m4])
+AC_DEFINE([_GNU_SOURCE], [], [Use GNU extensions])
+
+LT_INIT
+
+# Checks for typedefs, structures, and compiler characteristics.
+AC_C_INLINE
+AC_TYPE_SIZE_T
+AC_TYPE_UINT16_T
+AC_TYPE_UINT32_T
+AC_TYPE_UINT8_T
+
+#AC_CHECK_LIB([c], [malloc])
+# Checks for library functions.
+#AC_FUNC_MALLOC
+
+AC_CONFIG_FILES([Makefile src/Makefile examples/Makefile libgencec.pc])
+
+AC_OUTPUT
diff --git a/doc/index.html b/doc/index.html
new file mode 100644
index 0000000..914413e
--- /dev/null
+++ b/doc/index.html
@@ -0,0 +1,345 @@
+<h2>struct cec_device - a structure used to keep context of the current used CEC device</h2>
+<b>struct cec_device</b> {<br>
+&nbsp; &nbsp; <i>void *</i> <b>caps</b>;<br>
+&nbsp; &nbsp; <i>int</i> <b>handle</b>;<br>
+&nbsp; &nbsp; <i>int</i> <b>initialised</b>;<br>
+&nbsp; &nbsp; <i>uint32_t</i> <b>log_addr[CEC_MAX_NUM_LOG_ADDR]</b>;<br>
+&nbsp; &nbsp; <i>uint32_t</i> <b>log_addr_type_int[CEC_MAX_NUM_LOG_ADDR]</b>;<br>
+&nbsp; &nbsp; <i>enum cec_device_type</i> <b>dev_type[CEC_MAX_NUM_LOG_ADDR]</b>;<br>
+&nbsp; &nbsp; <i>uint32_t</i> <b>dev_type_int[CEC_MAX_NUM_LOG_ADDR]</b>;<br>
+&nbsp; &nbsp; <i>int</i> <b>num_log_addr</b>;<br>
+};<br>
+<h3>Members</h3>
+<dl>
+<dt><b>caps</b>
+<dd>used to keep a pointer to the kernel caps structure for the
+device
+<dt><b>handle</b>
+<dd>this is used to keep the file handle to the CEC device
+<dt><b>initialised</b>
+<dd>flag set if the structure was properly initialised
+<dt><b>log_addr[CEC_MAX_NUM_LOG_ADDR]</b>
+<dd>an array containing the assigned logical addresses
+<dt><b>log_addr_type_int[CEC_MAX_NUM_LOG_ADDR]</b>
+<dd>an array containing the logical addresses' types as
+needed by the kernel
+<dt><b>dev_type[CEC_MAX_NUM_LOG_ADDR]</b>
+<dd>device type, as neede by the library
+<dt><b>dev_type_int[CEC_MAX_NUM_LOG_ADDR]</b>
+<dd>primary device type, as needed by the kernel driver
+<dt><b>num_log_addr</b>
+<dd>number of ssigned logical addresses
+</dl>
+<hr>
+<h2>struct hdmi_port_info - Information about a HDMI port</h2>
+<b>struct hdmi_port_info</b> {<br>
+&nbsp; &nbsp; <i>uint8_t</i> <b>port_number</b>;<br>
+};<br>
+<h3>Members</h3>
+<dl>
+<dt><b>port_number</b>
+<dd>the port number
+</dl>
+<hr>
+<h2>struct cec_info - a structure used to get information about the CEC device</h2>
+<b>struct cec_info</b> {<br>
+&nbsp; &nbsp; <i>enum cec_version</i> <b>version</b>;<br>
+&nbsp; &nbsp; <i>uint32_t</i> <b>vendor_id</b>;<br>
+&nbsp; &nbsp; <i>unsigned int</i> <b>ports_num</b>;<br>
+&nbsp; &nbsp; <i>struct hdmi_port_info</i> <b>ports_info[MAX_NUM_OF_HDMI_PORTS]</b>;<br>
+};<br>
+<h3>Members</h3>
+<dl>
+<dt><b>version</b>
+<dd>supported CEC version
+<dt><b>vendor_id</b>
+<dd>the vendor ID
+<dt><b>ports_num</b>
+<dd>number of HDMI ports available in the system
+<dt><b>ports_info[MAX_NUM_OF_HDMI_PORTS]</b>
+<dd>an array containing information about HDMI ports
+</dl>
+<hr>
+<h2>struct cec_buffer - a structure used to store message that were received or are to be sent</h2>
+<b>struct cec_buffer</b> {<br>
+&nbsp; &nbsp; <i>uint8_t</i> <b>dst</b>;<br>
+&nbsp; &nbsp; <i>uint8_t</i> <b>src</b>;<br>
+&nbsp; &nbsp; <i>uint8_t</i> <b>len</b>;<br>
+&nbsp; &nbsp; <i>uint8_t</i> <b>payload[CEC_MAX_LENGTH]</b>;<br>
+&nbsp; &nbsp; <i>struct timespec</i> <b>ts</b>;<br>
+};<br>
+<h3>Members</h3>
+<dl>
+<dt><b>dst</b>
+<dd>The address of the destination device
+<dt><b>src</b>
+<dd>The address of the source device
+<dt><b>len</b>
+<dd>The length of the payload of the message
+<dt><b>payload[CEC_MAX_LENGTH]</b>
+<dd>The payload of the message
+<dt><b>ts</b>
+<dd>The timestamp for received messages
+</dl>
+<hr>
+<h2>cec_open - Open a CEC device</h2>
+<i>int</i>
+<b>cec_open</b>
+(<i>struct cec_device *</i> <b>dev</b>,
+<i>char *</i> <b>path</b>)
+<h3>Arguments</h3>
+<dl>
+<dt><b>dev</b>
+<dd>pointer to a structure that will hold the state of the device
+<dt><b>path</b>
+<dd>path to the CEC device
+</dl>
+<h3>Returns</h3>
+<blockquote>
+on success CEC_OK, on error returns an negative error code
+</blockquote>
+<hr>
+<h2>cec_close - Close a CEC device</h2>
+<i>int</i>
+<b>cec_close</b>
+(<i>struct cec_device *</i> <b>dev</b>)
+<h3>Arguments</h3>
+<dl>
+<dt><b>dev</b>
+<dd>pointer to a structure that holds the state of the device
+</dl>
+<h3>Returns</h3>
+<blockquote>
+on success CEC_OK, on error returns an negative error code
+</blockquote>
+<hr>
+<h2>cec_is_enabled - Check whether the CEC device is enabled</h2>
+<i>bool</i>
+<b>cec_is_enabled</b>
+(<i>struct cec_device *</i> <b>dev</b>)
+<h3>Arguments</h3>
+<dl>
+<dt><b>dev</b>
+<dd>pointer to a structure that holds the state of the device
+</dl>
+<h3>Returns</h3>
+<blockquote>
+true if all is ok and the CEC device is enabled, false otherwise
+</blockquote>
+<hr>
+<h2>cec_enable - Enable a CEC device</h2>
+<i>int</i>
+<b>cec_enable</b>
+(<i>struct cec_device *</i> <b>dev</b>,
+<i>bool</i> <b>enable</b>)
+<h3>Arguments</h3>
+<dl>
+<dt><b>dev</b>
+<dd>pointer to a structure that will hold the state of the device
+<dt><b>enable</b>
+<dd>true to enable the CEC device, false to disable the CEC device
+</dl>
+<h3>Returns</h3>
+<blockquote>
+on success CEC_OK, on error returns an negative error code
+</blockquote>
+<hr>
+<h2>cec_passthrough - Enable a CEC device</h2>
+<i>int</i>
+<b>cec_passthrough</b>
+(<i>struct cec_device *</i> <b>dev</b>,
+<i>bool</i> <b>enable</b>)
+<h3>Arguments</h3>
+<dl>
+<dt><b>dev</b>
+<dd>pointer to a structure that will hold the state of the device
+<dt><b>enable</b>
+<dd>true to enable the passthrough mode, false to disable
+</dl>
+<h3>Returns</h3>
+<blockquote>
+on success CEC_OK, on error returns an negative error code
+</blockquote>
+<hr>
+<h2>cec_get_info - Returns information about the CEC device</h2>
+<i>int</i>
+<b>cec_get_info</b>
+(<i>struct cec_device *</i> <b>dev</b>,
+<i>struct cec_info *</i> <b>info</b>)
+<h3>Arguments</h3>
+<dl>
+<dt><b>dev</b>
+<dd>pointer to a structure that holds the state of the device
+<dt><b>info</b>
+<dd>pointer to a info structure that will hold the information about
+the CEC device
+</dl>
+<h3>Returns</h3>
+<blockquote>
+on success CEC_OK, on error returns an negative error code
+</blockquote>
+<hr>
+<h2>cec_is_connected - Return information about whether a device is connected to the port</h2>
+<i>int</i>
+<b>cec_is_connected</b>
+(<i>struct cec_device *</i> <b>dev</b>)
+<h3>Arguments</h3>
+<dl>
+<dt><b>dev</b>
+<dd>pointer to a structure that holds the state of the device
+</dl>
+<h3>Returns</h3>
+<blockquote>
+when a device is connected to the port returns CEC_CONNECTED,
+CEC_DISCONNECTED when there is no device connected, on error
+returns an negative error code
+</blockquote>
+<hr>
+<h2>cec_send_message - Send a message over the CEC bus</h2>
+<i>int</i>
+<b>cec_send_message</b>
+(<i>struct cec_device *</i> <b>dev</b>,
+<i>struct cec_buffer *</i> <b>msg</b>)
+<h3>Arguments</h3>
+<dl>
+<dt><b>dev</b>
+<dd>pointer to a structure that holds the state of the device
+<dt><b>msg</b>
+<dd>the message do be sent over the CEC bus
+</dl>
+<h3>Returns</h3>
+<blockquote>
+CEC_OK on success
+CEC_REPLY on successful send and reply receive
+CEC_REPLY_TIMEOUT when waiting for reply timed out
+CEC_TIMEOUT when a timeout occurred while sending the message
+negative error code on other error
+</blockquote>
+<hr>
+<h2>cec_receive_message - Receive a message over the CEC bus</h2>
+<i>int</i>
+<b>cec_receive_message</b>
+(<i>struct cec_device *</i> <b>dev</b>,
+<i>struct cec_buffer *</i> <b>msg</b>)
+<h3>Arguments</h3>
+<dl>
+<dt><b>dev</b>
+<dd>pointer to a structure that holds the state of the device
+<dt><b>msg</b>
+<dd>a structure used to store the message received over the CEC bus
+</dl>
+<h3>Returns</h3>
+<blockquote>
+CEC_OK on success
+CEC_TIMEOUT when a timeout occurred while waiting for message
+negative error code on error
+</blockquote>
+<h3>Remarks</h3>
+<blockquote>
+when waiting for a reply, the reply is stored in the msg struct
+</blockquote>
+<hr>
+<h2>cec_get_logical_addrs - Add a new logical address to the CEC device</h2>
+<i>int</i>
+<b>cec_get_logical_addrs</b>
+(<i>struct cec_device *</i> <b>dev</b>,
+<i>uint8_t *</i> <b>addr</b>,
+<i>int *</i> <b>num_addr</b>)
+<h3>Arguments</h3>
+<dl>
+<dt><b>dev</b>
+<dd>pointer to a structure that holds the state of the device
+<dt><b>addr</b>
+<dd>pointer to an array to hold the list of assigned logical
+addresses, the size should be CEC_MAX_NUM_LOG_ADDR
+<dt><b>num_addr</b>
+<dd>pointer to an int that will hold the number of assigned
+logical addresses
+</dl>
+<h3>Returns</h3>
+<blockquote>
+CEC_OK on success
+negative error code on error
+</blockquote>
+<hr>
+<h2>cec_add_logical_addr - Add a new logical address to the CEC device</h2>
+<i>int</i>
+<b>cec_add_logical_addr</b>
+(<i>struct cec_device *</i> <b>dev</b>,
+<i>enum cec_device_type</i> <b>type</b>,
+<i>uint8_t *</i> <b>addr</b>)
+<h3>Arguments</h3>
+<dl>
+<dt><b>dev</b>
+<dd>pointer to a structure that holds the state of the device
+<dt><b>type</b>
+<dd>the type of the device that is to be added, please note that
+this indicated the type and not the address that will be
+assigned
+<dt><b>addr</b>
+<dd>a pointer to a location where to store the assigned logical
+address
+</dl>
+<h3>Returns</h3>
+<blockquote>
+CEC_OK on success
+CEC_TIMEOUT when a timeout occurred while waiting for message
+CEC_NO_ADDR_LEFT when all addresses related to the chosen device
+type are already taken
+negative error code on error
+</blockquote>
+<hr>
+<h2>cec_clear_logical_addrs - Clear the logical addresses that were assigned to the device</h2>
+<i>int</i>
+<b>cec_clear_logical_addrs</b>
+(<i>struct cec_device *</i> <b>dev</b>)
+<h3>Arguments</h3>
+<dl>
+<dt><b>dev</b>
+<dd>pointer to a structure that holds the state of the device
+</dl>
+<h3>Returns</h3>
+<blockquote>
+CEC_OK on success
+CEC_TIMEOUT when a timeout occurred while waiting for message
+negative error code on error
+</blockquote>
+<hr>
+<h2>cec_get_physical_addr - Get the physical addr of the CEC device</h2>
+<i>int</i>
+<b>cec_get_physical_addr</b>
+(<i>struct cec_device *</i> <b>dev</b>,
+<i>uint16_t *</i> <b>phys_addr</b>)
+<h3>Arguments</h3>
+<dl>
+<dt><b>dev</b>
+<dd>pointer to a structure that holds the state of the device
+<dt><b>phys_addr</b>
+<dd>pointer to a uint16_t which will hold the physical address
+</dl>
+<h3>Returns</h3>
+<blockquote>
+CEC_OK on success
+CEC_TIMEOUT when a timeout occurred while waiting for message
+negative error code on error
+</blockquote>
+<hr>
+<h2>cec_set_physical_addr - Get the physical addr of the CEC device</h2>
+<i>int</i>
+<b>cec_set_physical_addr</b>
+(<i>struct cec_device *</i> <b>dev</b>,
+<i>uint16_t</i> <b>phys_addr</b>)
+<h3>Arguments</h3>
+<dl>
+<dt><b>dev</b>
+<dd>pointer to a structure that holds the state of the device
+<dt><b>phys_addr</b>
+<dd>a uint16_t which holding the physical address
+</dl>
+<h3>Returns</h3>
+<blockquote>
+CEC_OK on success
+CEC_TIMEOUT when a timeout occurred while waiting for message
+negative error code on error
+</blockquote>
+<hr>
diff --git a/examples/Makefile.am b/examples/Makefile.am
new file mode 100644
index 0000000..1a007eb
--- /dev/null
+++ b/examples/Makefile.am
@@ -0,0 +1,4 @@
+bin_PROGRAMS = cectest
+cectest_SOURCES = cectest.c
+AM_CPPFLAGS=-I$(top_srcdir)/include/
+AM_LDFLAGS=-L../src/ -lgencec
diff --git a/examples/cectest.c b/examples/cectest.c
new file mode 100644
index 0000000..659f841
--- /dev/null
+++ b/examples/cectest.c
@@ -0,0 +1,631 @@
+/*
+ * Copyright 2015 Samsung Electronics Co. Ltd
+ *
+ * Licensed under the Apache License, Version 2.0 (the "License");
+ * you may not use this file except in compliance with the License.
+ * You may obtain a copy of the License at
+ *
+ *      http://www.apache.org/licenses/LICENSE-2.0
+ *
+ * Unless required by applicable law or agreed to in writing, software
+ * distributed under the License is distributed on an "AS IS" BASIS,
+ * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
+ * See the License for the specific language governing permissions and
+ * limitations under the License.
+ */
+
+#include <gencec.h>
+#include <getopt.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+/* A single entry in the list of tasks to be done */
+struct todo {
+	char cmd;
+	char *param;
+	struct todo *next;
+};
+
+/* Print a help message with the list and the description of all commands */
+void print_usage(char *name)
+{
+	printf("\nUsage:\n");
+	printf("\t%s\n", name);
+
+	printf("General options:\n");
+	printf("\t--help/-h - display this message\n");
+	printf("\t--device/-D <device name> - name of the CEC device (default is /dev/cec0)\n");
+
+	printf("CEC device related commands:\n");
+	printf("\t--enable/-e - enable the CEC adapter\n");
+	printf("\t--disable/-d - disable the CEC adapter\n");
+	printf("\t--add-logical/-l <addr_type> - add logical address of given type\n");
+	printf("\t\tTypes: tv, record, tuner, playback, audio, switch, videoproc\n");
+	printf("\t--clear-logical/-c - clear logical addresses\n");
+	printf("\t--get-logical/-G - get logical address(es)\n");
+	printf("\t--get-physical/-g - get the physical address\n");
+	printf("\t--set-physical/-s <addr> - set the physical address\n");
+	printf("\t\t<addr> should be in the following format N.N.N.N where N is between 0 and 15\n");
+	printf("\t\te.g. --set-physical 1.0.0.11\n");
+	printf("\t--info/-i - print information about the CEC device\n");
+	printf("\t--send/-S <addr>:<contents> - send a message to a specified address\n");
+	printf("\t\t<addr> should be an integer ranging from 0 to 15 (where 15 is a broadcast address\n");
+	printf("\t\t<contents> should be an array of hexadecimal bytes\n");
+	printf("\t\te.g. --send 11:010b0cf6 which will send a message consisting of 010b0cf6 to\n");
+	printf("\t\tthe device with logical address 11\n");
+	printf("\t\t<contents> should be a hexadecimal number that represents the bytes to be sent\n");
+	printf("\t--receive/-R - receive a single CEC message\n");
+	printf("\t--passthrough/-p <state> - enable/disable passthrough mode\n");
+
+	printf("Useful CEC standard commands:\n");
+	printf("\t--osd/-O <OSD name> - set the OSD name for device\n");
+	printf("\t--give-power-status/-P <status> - give device power status\n");
+	printf("\t--text-view-on/-T - Sent by a source device to the TV whenever it enters the active state \n");
+	printf("\t--active-source/-A - indicate that it has started to transmit a stream\n");
+	printf("\t--menu-state/-M <state> - used to indicate that the device is showing a menu (enable keycode forwarding)\n");
+	printf("\t\t<state> = \"on\" or \"off\"\n");
+	printf("\t\n");
+	printf("\tCommands are executed in the order given in argument list.\n");
+}
+
+/* Parse the arguments list and prepare a list with task that are to be done */
+struct todo *parse_args(int argc, char **argv)
+{
+	struct todo *list = 0;
+	struct todo *tmp;
+
+	int c;
+	int option_index = 0;
+
+	static struct option long_options[] =
+	{
+		{"device",		required_argument,	0, 'D'},
+		{"help",		no_argument,		0, 'h'},
+
+		{"enable",		no_argument,		0, 'e'},
+		{"disable",		no_argument,		0, 'd'},
+		{"add-logical",		required_argument,	0, 'l'},
+		{"clear-logical",	no_argument,		0, 'c'},
+		{"get-logical",		no_argument,		0, 'G'},
+		{"get-physical",	no_argument,		0, 'g'},
+		{"set-physical",	required_argument,	0, 's'},
+		{"info",		no_argument,		0, 'i'},
+		{"passthrough",		required_argument,	0, 'p'},
+
+		{"send",		required_argument,	0, 'S'},
+		{"receive",		no_argument,		0, 'R'},
+
+		{"osd",			required_argument,	0, 'O'},
+		{"give-power-status",	required_argument,	0, 'P'},
+		{"text-view-on",	no_argument,		0, 'T'},
+		{"active-source",	no_argument,		0, 'A'},
+		{"menu-state",		required_argument,	0, 'M'},
+
+		{0, 0, 0, 0}
+	};
+
+	while (1) {
+		c = getopt_long(argc, argv, "D:edl:cGgs:S:RO:PTAM:ip:", long_options, &option_index);
+		if (c == -1)
+			break;
+		switch (c) {
+		case 'D':
+			/* add as first element in todo */
+			tmp = malloc(sizeof(struct todo));
+			if (!tmp)
+				exit(1);
+			tmp->cmd = c;
+			tmp->param = strdup(optarg);
+			tmp->next = list;
+			list = tmp;
+			break;
+		/* cmds with no arg */
+		case 'A': case 'c': case 'd': case 'e':
+		case 'g': case 'G': case 'i': case 'P':
+		case 'R': case 'S': case 'T':
+		 /* cmds with arg */
+		case 'l': case 'M': case 'O': case 's':
+		case 'p':
+			/* add as last element */
+			if (!list) {
+				list = tmp = malloc(sizeof(struct todo));
+				if (!tmp)
+					exit(1);
+			} else {
+				tmp = list;
+
+				while (tmp->next)
+					tmp = tmp->next;
+				tmp->next = malloc(sizeof(struct todo));
+				if (!tmp)
+					exit(1);
+				tmp = tmp->next;
+			}
+			tmp->cmd = c;
+			if (optarg)
+				tmp->param = strdup(optarg);
+			else
+				tmp->param = 0;
+			tmp->next = 0;
+			break;
+		case 'h':
+		default:
+			while (list) {
+				tmp = list->next;
+				free(list->param);
+				free(list);
+				list = tmp;
+			}
+			return 0;
+		}
+	}
+
+	return list;
+}
+
+/* Parse a physical address which format is dd.dd.dd.dd
+ * where dd is a integer ranging from 0 to 15 */
+int parse_paddr(char *s)
+{
+	char c;
+	int r = 0;
+	int t = 0;
+	int dots = 0;
+	if (!s)
+		return -1;
+	while ((c = *(s++))) {
+		if (c == '.') {
+			r <<= 4;
+			r |= t;
+			t = 0;
+			dots++;
+		} else if (c >= '0' && c <= '9') {
+			t = t * 10 + c - '0';
+		} else {
+			return -1;
+		}
+	}
+	if (dots != 3)
+		return -1;
+	r <<= 4;
+	r |= t;
+	return r;
+}
+
+/* Get the first logical address assigned to the used CEC device */
+int get_addr(struct cec_device *cec)
+{
+	uint8_t addrs[CEC_MAX_NUM_LOG_ADDR];
+	int num_addrs;
+	int ret;
+
+	ret = cec_get_logical_addrs(cec, addrs, &num_addrs);
+	if (ret != CEC_OK)
+		return -1;
+
+	if (num_addrs)
+		return addrs[0];
+	else
+		return -1;
+}
+
+/* Convert a single character containing a single hexadecimal digit
+ * to an int */
+int hexdigit(char c)
+{
+	if (c >= '0' && c <= '9')
+		return c - '0';
+	if (c >= 'a' && c <= 'f')
+		return 10 + c - 'a';
+	if (c >= 'A' && c <= 'F')
+		return 10 + c - 'A';
+	return -1;
+}
+
+/* Parse string in the format of dd:xxxx
+ * where dd - is an integer denoting the logical address of the recipient device
+ * and xxxx is an array of bytes written in hexadecimal notation.
+ * e.g. 11:1234 means send a message consisting of the following two bytes 0x12
+ * and 0x34 to the device with logical address 11 */
+int parse_message(struct cec_buffer *msg, char *s)
+{
+	int i;
+	int tmp;
+
+	if (*s > '9' || *s < '0')
+		return 1;
+	msg->dst = *s - '0';
+	s++;
+	if (*s != ':') {
+		if (*s> '9' || *s < '0')
+			return 1;
+		msg->dst *= 10;
+		msg->dst += *s - '0';
+		s++;
+	}
+
+	if (*s != ':')
+		return 1;
+	s++;
+
+	i = 0;
+	while (*s) {
+		if (i > CEC_MAX_LENGTH * 2)
+			return 1;
+		tmp = hexdigit(*s);
+		if (tmp == -1)
+			return 1;
+		if (i % 2 == 0)
+			msg->payload[i / 2] = tmp << 4;
+		else
+			msg->payload[i / 2] |= tmp;
+		s++;
+		i++;
+	}
+
+	msg->len = i / 2;
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	struct todo *list;
+	struct cec_device cec;
+	uint8_t addr;
+	int ret;
+
+	printf("libgencec test application (c) Samsung 2015\n");
+
+	list = parse_args(argc, argv);
+
+	if (!list) {
+		print_usage(argv[0]);
+		return 1;
+	}
+
+	if (list->cmd == 'D') {
+		ret = cec_open(&cec, list->param);
+		list = list->next;
+	} else {
+		ret = cec_open(&cec, "/dev/cec0");
+	}
+	if (ret != CEC_OK) {
+		printf("Failed to open CEC device\n");
+		return 1;
+	}
+
+	printf("Succesfully opened CEC device\n");
+
+	/* Main processing loop */
+	while (list) {
+		switch (list->cmd) {
+		case 'd':
+		case 'e':
+			ret = cec_enable(&cec, list->cmd == 'e');
+			if (ret != CEC_OK) {
+				printf("Failed to %s CEC device\n",
+					list->cmd == 'e' ? "enable":"disable");
+				return 1;
+			}
+			printf("Successfully %s CEC device\n",
+					list->cmd == 'e' ? "enabled":"disabled");
+			break;
+		case 'l': {
+			enum cec_device_type type;
+			if (!strcasecmp(list->param, "tv"))
+				type = CEC_DEVICE_TYPE_TV;
+			else if (!strcasecmp(list->param, "record"))
+				type = CEC_DEVICE_TYPE_RECORD;
+			else if (!strcasecmp(list->param, "tuner"))
+				type = CEC_DEVICE_TYPE_TUNER;
+			else if (!strcasecmp(list->param, "playback"))
+				type = CEC_DEVICE_TYPE_PLAYBACK;
+			else if (!strcasecmp(list->param, "audio"))
+				type = CEC_DEVICE_TYPE_AUDIOSYSTEM;
+			else if (!strcasecmp(list->param, "switch"))
+				type = CEC_DEVICE_TYPE_SWITCH;
+			else if (!strcasecmp(list->param, "videoproc"))
+				type = CEC_DEVICE_TYPE_VIDEOPROC;
+			else {
+				printf("Unrecognised logical address type\n");
+				return 1;
+			}
+
+			ret = cec_add_logical_addr(&cec, type, &addr);
+			if (ret != CEC_OK) {
+				printf("Failed to add a logical address\n");
+				return 1;
+			}
+			printf("Successfully added logical address of type '%s', id=%d\n", list->param, addr);
+			break;
+		}
+		case 'c':
+			ret = cec_clear_logical_addrs(&cec);
+			if (ret != CEC_OK) {
+				printf("Failed to clear logical addresses\n");
+				return 1;
+			}
+			printf("Successfully cleared logical addresses\n");
+			break;
+		case 'G': {
+			uint8_t addrs[CEC_MAX_NUM_LOG_ADDR];
+			int num_addrs;
+			int i;
+
+			ret = cec_get_logical_addrs(&cec, addrs, &num_addrs);
+			if (ret != CEC_OK) {
+				printf("Failed to get logical addresses\n");
+				return 1;
+			}
+			if (num_addrs) {
+				for (i = 0; i < num_addrs; i++)
+					printf("Assigned logical address %d\n",
+					       addrs[i]);
+			} else {
+				printf("No logical addresses assigned\n");
+			}
+
+			break;
+		}
+		case 'g': {
+			uint16_t paddr;
+			ret = cec_get_physical_addr(&cec, &paddr);
+			if (ret != CEC_OK) {
+				printf("Failed to get physical address\n");
+				return 1;
+			}
+			printf("Got physical addr: %d.%d.%d.%d\n",
+				paddr >> 12 & 0xf, paddr >> 8 & 0xf,
+				paddr >> 4 & 0xf, paddr & 0xf);
+			break;
+		}
+		case 's': {
+			uint16_t paddr;
+			paddr = parse_paddr(list->param);
+			if (paddr == -1) {
+				printf("Failed to parse physical address (%s)\n", list->param);
+				return -1;
+			}
+			ret = cec_set_physical_addr(&cec, paddr);
+			if (ret != CEC_OK) {
+				printf("Failed to set physical address\n");
+				return 1;
+			}
+			printf("Set physical addr: %d.%d.%d.%d\n",
+				paddr >> 12 & 0xf, paddr >> 8 & 0xf,
+				paddr >> 4 & 0xf, paddr & 0xf);
+			break;
+		}
+		case 'i': {
+			struct cec_info info;
+
+			ret = cec_get_info(&cec, &info);
+			if (ret != CEC_OK) {
+				printf("Failed to get CEC info\n");
+				return 1;
+			}
+
+			printf(	"Got info: \n"
+				"version = %d\n"
+				"vendor_id = 0x%08x\n"
+				"ports_num = %d\n\n",
+				info.version,
+				info.vendor_id,
+				info.ports_num);
+
+			break;
+		}
+		case 'p': {
+			int passthrough;
+
+			addr = get_addr(&cec);
+			if (strcasecmp(list->param, "on") == 0) {
+				passthrough = 1;
+			} else if (strcasecmp(list->param, "off") == 0) {
+				passthrough = 0;
+			} else {
+				printf("Unknown state \"%s\"\n", list->param);
+				return 1;
+			}
+
+			printf("Successfully switched passthrought mode %s\n", list->param);
+			break;
+		}
+		case 'O': {
+			struct cec_buffer msg;
+			int addr;
+
+			if (strlen(list->param) > CEC_MAX_LENGTH) {
+				printf("OSD name too long\n");
+				return -1;
+			}
+
+			addr = get_addr(&cec);
+			if (addr == -1) {
+				printf("Failed to get logical address of the CEC device\n");
+				return 1;
+			}
+
+			msg.src = addr;
+			msg.dst = 0x0; /* The TV */
+			msg.len = 1 + strlen(list->param);
+			msg.payload[0] = 0x47;
+			memcpy(msg.payload + 1, list->param, strlen(list->param));
+
+			ret = cec_send_message(&cec, &msg);
+			if (ret != CEC_OK) {
+				printf("Failed to send message\n");
+				return 1;
+			}
+			printf("Successfully sent message - set OSD name to\"%s\"\n", list->param);
+			break;
+		}
+		case 'P': {
+			struct cec_buffer msg;
+			int addr;
+
+			addr = get_addr(&cec);
+			if (addr == -1) {
+				printf("Failed to get logical address of the CEC device\n");
+				return 1;
+			}
+
+			msg.src = addr;
+			msg.dst = 0x0; /* The TV */
+			msg.len = 1;
+			msg.payload[0] = 0x8f;
+
+			ret = cec_send_message(&cec, &msg);
+			if (ret != CEC_OK) {
+				printf("Failed to send message\n");
+				return 1;
+			}
+			printf("Successfully sent message - Give Power Status\n");
+			break;
+		}
+		case 'T': {
+			struct cec_buffer msg;
+			int addr;
+
+			addr = get_addr(&cec);
+			if (addr == -1) {
+				printf("Failed to get logical address of the CEC device\n");
+				return 1;
+			}
+
+			msg.src = addr;
+			msg.dst = 0x0; /* The TV */
+			msg.len = 1;
+			msg.payload[0] = 0x0d;
+
+			ret = cec_send_message(&cec, &msg);
+			if (ret != CEC_OK) {
+				printf("Failed to send message\n");
+				return 1;
+			}
+			printf("Successfully sent message - Text View On\n");
+			break;
+		}
+		case 'A': {
+			struct cec_buffer msg;
+			uint16_t paddr;
+			int addr;
+
+			addr = get_addr(&cec);
+			if (addr == -1) {
+				printf("Failed to get logical address of the CEC device\n");
+				return 1;
+			}
+			ret = cec_get_physical_addr(&cec, &paddr);
+			if (ret != CEC_OK) {
+				printf("Failed to get physical address\n");
+				return 1;
+			}
+
+			msg.src = addr;
+			msg.dst = 0xf; /* The TV */
+			msg.len = 3;
+			msg.payload[0] = 0x82;
+			msg.payload[1] = paddr >> 8;
+			msg.payload[2] = paddr & 0xff;
+
+			ret = cec_send_message(&cec, &msg);
+			if (ret != CEC_OK) {
+				printf("Failed to send message\n");
+				return 1;
+			}
+			printf("Successfully sent message - Active Source\n");
+			break;
+		}
+		case 'M': {
+			struct cec_buffer msg;
+			int addr;
+
+			addr = get_addr(&cec);
+			if (addr == -1) {
+				printf("Failed to get logical address of the CEC device\n");
+				return 1;
+			}
+
+			msg.src = addr;
+			msg.dst = 0x0; /* The TV */
+			msg.len = 2;
+			msg.payload[0] = 0x8e;
+			if (strcasecmp(list->param, "on") == 0) {
+				msg.payload[1] = 0;
+			} else if (strcasecmp(list->param, "off") == 0) {
+				msg.payload[1] = 1;
+			} else {
+				printf("Unknown state \"%s\"\n", list->param);
+				return 1;
+			}
+
+			ret = cec_send_message(&cec, &msg);
+			if (ret != CEC_OK) {
+				printf("Failed to send message\n");
+				return 1;
+			}
+			printf("Successfully sent message - Menu Status\n");
+			break;
+		}
+		case 'S': {
+			struct cec_buffer msg;
+			int addr;
+			int ret;
+			int i;
+
+			ret = parse_message(&msg, list->param);
+			if (ret) {
+				printf("Failed to parse message to send\n");
+				return 1;
+			}
+			printf("Sending message=0x");
+			for (i = 0; i < msg.len; i++)
+				printf("%02x", msg.payload[i]);
+			printf(" (length=%d) to addr=%d\n", msg.len, msg.dst);
+			addr = get_addr(&cec);
+			if (addr == -1) {
+				printf("Failed to get logical address of the CEC device\n");
+				return 1;
+			}
+			msg.src = addr;
+
+			ret = cec_send_message(&cec, &msg);
+			if (ret != CEC_OK) {
+				printf("Failed to send message\n");
+				return 1;
+			}
+			printf("Successfully sent custom message\n");
+			break;
+		}
+		case 'R': {
+			struct cec_buffer msg;
+			int i;
+
+			ret = cec_receive_message(&cec, &msg);
+			if (ret == CEC_TIMEOUT) {
+				printf("CEC receive message timed out\n");
+				return 2;
+			} else if (ret != CEC_OK) {
+				printf("Failed to receive a message\n");
+				return 1;
+			}
+
+			printf("Received message of length %d\n", msg.len);
+			for (i = 0; i < msg.len; i++)
+				printf("%02x", msg.payload[i]);
+			printf("\n");
+			break;
+		}
+		default:
+			printf("Command '%c' not yet implemented.\n", list->cmd);
+			break;
+		}
+
+		list = list->next;
+	}
+
+	return 0;
+}
diff --git a/include/gencec.h b/include/gencec.h
new file mode 100644
index 0000000..b727ddc
--- /dev/null
+++ b/include/gencec.h
@@ -0,0 +1,255 @@
+/*
+ * Copyright 2015 Samsung Electronics Co. Ltd
+ *
+ * Licensed under the Apache License, Version 2.0 (the "License");
+ * you may not use this file except in compliance with the License.
+ * You may obtain a copy of the License at
+ *
+ *      http://www.apache.org/licenses/LICENSE-2.0
+ *
+ * Unless required by applicable law or agreed to in writing, software
+ * distributed under the License is distributed on an "AS IS" BASIS,
+ * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
+ * See the License for the specific language governing permissions and
+ * limitations under the License.
+ */
+
+#ifndef __GENCEC_H__
+
+#include <stdint.h>
+#include <stdbool.h>
+#include <time.h>
+
+/* Maximum length of the CEC message */
+#define CEC_MAX_LENGTH		15 /* 16 including the automatically added
+				    * address byte. */
+#define MAX_NUM_OF_HDMI_PORTS	16
+#define CEC_MAX_NUM_LOG_ADDR	4
+#define DEFAULT_TIMEOUT		1000
+
+/*  cec_version: list of CEC versions */
+enum cec_version {
+	CEC_VER_UNKNOWN,
+	CEC_VER_1_0,
+	CEC_VER_1_1,
+	CEC_VER_1_2,
+	CEC_VER_1_3,
+	CEC_VER_1_3A,
+	CEC_VER_1_3B,
+	CEC_VER_1_3C,
+	CEC_VER_1_4,
+	CEC_VER_1_4B,
+	CEC_VER_2_0,
+};
+
+enum cec_device_type {
+	/* Used internally for error handling */
+	CEC_DEVICE_TYPE_EMPTY,
+	CEC_DEVICE_TYPE_TV,
+	CEC_DEVICE_TYPE_RECORD,
+	CEC_DEVICE_TYPE_TUNER,
+	CEC_DEVICE_TYPE_PLAYBACK,
+	CEC_DEVICE_TYPE_AUDIOSYSTEM,
+	CEC_DEVICE_TYPE_SWITCH,
+	CEC_DEVICE_TYPE_VIDEOPROC,
+};
+
+/**
+ * struct cec_device - a structure used to keep context of the current used CEC
+ *		       device
+ * @caps:	used to keep a pointer to the kernel caps structure for the
+ *		device
+ * @handle:	this is used to keep the file handle to the CEC device
+ * @initialised: flag set if the structure was properly initialised
+ * @log_addr:	an array containing the assigned logical addresses
+ * @log_addr_type_int: an array containing the logical addresses' types as
+ *		       needed by the kernel
+ * @dev_type:	device type, as neede by the library
+ * @dev_type_int: primary device type, as needed by the kernel driver
+ * @num_log_addr: number of ssigned logical addresses
+ */
+struct cec_device {
+	void *caps;
+	int handle;
+	int initialised;
+	uint32_t log_addr[CEC_MAX_NUM_LOG_ADDR];
+	uint32_t log_addr_type_int[CEC_MAX_NUM_LOG_ADDR];
+	enum cec_device_type dev_type[CEC_MAX_NUM_LOG_ADDR];
+	uint32_t dev_type_int[CEC_MAX_NUM_LOG_ADDR];
+	int num_log_addr;
+};
+
+/* cec_error: list of CEC framework errors */
+enum cec_error {
+	CEC_OK /* Success */,
+	CEC_TIMEOUT /* Timeout occured */,
+	CEC_NO_ADDR_LEFT /* No more logical addresses left */,
+	CEC_ERROR,
+};
+
+/**
+ * struct hdmi_port_info - Information about a HDMI port
+ * @port_number: the port number
+ */
+struct hdmi_port_info {
+	uint8_t port_number;
+};
+
+/**
+ * struct cec_info - a structure used to get information about the CEC device
+ * @version:	supported CEC version
+ * @vendor_id:	the vendor ID
+ * @ports_num:	number of HDMI ports available in the system
+ * @ports_info:	an array containing information about HDMI ports
+ * */
+struct cec_info {
+	enum cec_version version;
+	uint32_t vendor_id;
+	unsigned int ports_num;
+	struct hdmi_port_info ports_info[MAX_NUM_OF_HDMI_PORTS];
+};
+
+/**
+ * struct cec_msg - a structure used to store message that were received or are
+ *		    to be sent
+ * @dst:	The address of the destination device
+ * @src:	The address of the source device
+ * @len:	The length of the payload of the message
+ * @payload:	The payload of the message
+ * @ts:		The timestamp for received messages
+ */
+struct cec_buffer {
+	uint8_t dst;
+	uint8_t src;
+	uint8_t len;
+	uint8_t payload[CEC_MAX_LENGTH];
+	struct timespec ts;
+};
+
+/**
+ * cec_open() - Open a CEC device
+ * @dev:	pointer to a structure that will hold the state of the device
+ * @path:	path to the CEC device
+ * Returns:	on success CEC_OK, on error returns an negative error code
+ */
+int cec_open(struct cec_device *dev, char *path);
+/**
+ * cec_close() - Close a CEC device
+ * @dev:	pointer to a structure that holds the state of the device
+ * Returns:	on success CEC_OK, on error returns an negative error code
+ */
+int cec_close(struct cec_device *dev);
+/**
+ * cec_is_enabled() - Check whether the CEC device is enabled
+ * @dev:	pointer to a structure that holds the state of the device
+ * Returns:	true if all is ok and the CEC device is enabled, false otherwise
+ */
+bool cec_is_enabled(struct cec_device *dev);
+/**
+ * cec_enable() - Enable a CEC device
+ * @dev:	pointer to a structure that will hold the state of the device
+ * @enable:	true to enable the CEC device, false to disable the CEC device
+ * Returns:	on success CEC_OK, on error returns an negative error code
+ */
+int cec_enable(struct cec_device *dev, bool enable);
+/**
+ * cec_passthrough() - Enable a CEC device
+ * @dev:	pointer to a structure that will hold the state of the device
+ * @enable:	true to enable the passthrough mode, false to disable
+ * Returns:	on success CEC_OK, on error returns an negative error code
+ */
+int cec_passthrough(struct cec_device *dev, bool enable);
+/**
+ * cec_info() - Returns information about the CEC device
+ * @dev:	pointer to a structure that holds the state of the device
+ * @info:	pointer to a info structure that will hold the information about
+ *		the CEC device
+ * Returns:	on success CEC_OK, on error returns an negative error code
+ */
+int cec_get_info(struct cec_device *dev, struct cec_info *info);
+/**
+ * cec_is_connected() - Return information about whether a device is connected
+ *			to the port
+ * @dev:	pointer to a structure that holds the state of the device
+ * Returns:	when a device is connected to the port returns CEC_CONNECTED,
+ *		CEC_DISCONNECTED when there is no device connected, on error
+ *		returns an negative error code
+ */
+int cec_is_connected(struct cec_device *dev);
+/**
+ * cec_send_message() - Send a message over the CEC bus
+ * @dev:	pointer to a structure that holds the state of the device
+ * @msg:	the message do be sent over the CEC bus
+ * Returns:	CEC_OK on success
+ *		CEC_REPLY on successful send and reply receive
+ *		CEC_REPLY_TIMEOUT when waiting for reply timed out
+ *		CEC_TIMEOUT when a timeout occurred while sending the message
+ *		negative error code on other error
+ */
+int cec_send_message(struct cec_device *dev, struct cec_buffer *msg);
+/**
+ * cec_receive_message() - Receive a message over the CEC bus
+ * @dev:	pointer to a structure that holds the state of the device
+ * @msg:	a structure used to store the message received over the CEC bus
+ * Returns:	CEC_OK on success
+ *		CEC_TIMEOUT when a timeout occurred while waiting for message
+ *		negative error code on error
+ * Remarks:	when waiting for a reply, the reply is stored in the msg struct
+ */
+int cec_receive_message(struct cec_device *dev, struct cec_buffer *msg);
+/**
+ * cec_get_logical_addrs() - Add a new logical address to the CEC device
+ * @dev:	pointer to a structure that holds the state of the device
+ * @addr:	pointer to an array to hold the list of assigned logical
+ *		addresses, the size should be CEC_MAX_NUM_LOG_ADDR
+ * @num_addr:	pointer to an int that will hold the number of assigned
+ *		logical addresses
+ * Returns:	CEC_OK on success
+ *		negative error code on error
+ */
+int cec_get_logical_addrs(struct cec_device *dev, uint8_t *addr, int *num_addr);
+/**
+ * cec_add_logical_addr() - Add a new logical address to the CEC device
+ * @dev:	pointer to a structure that holds the state of the device
+ * @type:	the type of the device that is to be added, please note that
+ *		this indicated the type and not the address that will be
+ *		assigned
+ * @addr:	a pointer to a location where to store the assigned logical
+ *		address
+ * Returns:	CEC_OK on success
+ *		CEC_TIMEOUT when a timeout occurred while waiting for message
+ *		CEC_NO_ADDR_LEFT when all addresses related to the chosen device
+ *		type are already taken
+ *		negative error code on error
+ */
+int cec_add_logical_addr(struct cec_device *dev, enum cec_device_type type,
+			 uint8_t *addr);
+/**
+ * cec_clear_logical_addrs() - Clear the logical addresses that were assigned to
+ * the device
+ * @dev:	pointer to a structure that holds the state of the device
+ * Returns:	CEC_OK on success
+ *		CEC_TIMEOUT when a timeout occurred while waiting for message
+ *		negative error code on error
+ */
+int cec_clear_logical_addrs(struct cec_device *dev);
+/**
+ * cec_get_physical_addr() - Get the physical addr of the CEC device
+ * @dev:	pointer to a structure that holds the state of the device
+ * @phys_addr:	pointer to a uint16_t which will hold the physical address
+ * Returns:	CEC_OK on success
+ *		CEC_TIMEOUT when a timeout occurred while waiting for message
+ *		negative error code on error
+ */
+int cec_get_physical_addr(struct cec_device *dev, uint16_t *phys_addr);
+/**
+ * cec_set_physical_addr() - Get the physical addr of the CEC device
+ * @dev:	pointer to a structure that holds the state of the device
+ * @phys_addr:	a uint16_t which holding the physical address
+ * Returns:	CEC_OK on success
+ *		CEC_TIMEOUT when a timeout occurred while waiting for message
+ *		negative error code on error
+ */
+int cec_set_physical_addr(struct cec_device *dev, uint16_t phys_addr);
+
+#endif /* __GENCEC_H__ */
diff --git a/libgencec.pc.in b/libgencec.pc.in
new file mode 100644
index 0000000..8d75c4d
--- /dev/null
+++ b/libgencec.pc.in
@@ -0,0 +1,10 @@
+prefix=@prefix@
+exec_prefix=@exec_prefix@
+libdir=@libdir@
+includedir=@includedir@
+
+Name: libGenCEC
+Description: General CEC framework library.
+Version: @VERSION@
+Libs: -L${libdir} -lgencec
+Cflags: -I${includedir}
diff --git a/src/Makefile.am b/src/Makefile.am
new file mode 100644
index 0000000..cb024f0
--- /dev/null
+++ b/src/Makefile.am
@@ -0,0 +1,4 @@
+lib_LTLIBRARIES = libgencec.la
+libgencec_la_SOURCES = gencec.c
+libgencec_la_LDFLAGS = -version-info 0:1:0
+AM_CPPFLAGS=-I$(top_srcdir)/include
diff --git a/src/gencec.c b/src/gencec.c
new file mode 100644
index 0000000..2224115
--- /dev/null
+++ b/src/gencec.c
@@ -0,0 +1,445 @@
+/*
+ * Copyright 2015 Samsung Electronics Co. Ltd
+ *
+ * Licensed under the Apache License, Version 2.0 (the "License");
+ * you may not use this file except in compliance with the License.
+ * You may obtain a copy of the License at
+ *
+ *      http://www.apache.org/licenses/LICENSE-2.0
+ *
+ * Unless required by applicable law or agreed to in writing, software
+ * distributed under the License is distributed on an "AS IS" BASIS,
+ * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
+ * See the License for the specific language governing permissions and
+ * limitations under the License.
+ */
+
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <linux/cec.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "gencec.h"
+
+bool cec_is_enabled(struct cec_device *dev)
+{
+	struct cec_caps *caps = (struct cec_caps *)dev->caps;
+	int ret;
+
+	if (!dev)
+		return CEC_ERROR;
+	if (!dev->initialised)
+		return CEC_ERROR;
+
+	if (caps->capabilities && CEC_CAP_STATE) {
+		uint32_t arg;
+
+		ret = ioctl(dev->handle, CEC_G_ADAP_STATE, &arg);
+		if (ret)
+			return CEC_ERROR;
+		if (arg == 0)
+			return false;
+	}
+
+	return true;
+}
+
+int cec_enable(struct cec_device *dev, bool enable)
+{
+	struct cec_caps *caps = (struct cec_caps *)dev->caps;
+	int ret;
+
+	if (!dev)
+		return CEC_ERROR;
+	if (!dev->initialised)
+		return CEC_ERROR;
+
+	if (caps->capabilities && CEC_CAP_STATE) {
+		uint32_t arg;
+
+		arg = enable ? CEC_STATE_ENABLED : CEC_STATE_DISABLED;
+		ret = ioctl(dev->handle, CEC_S_ADAP_STATE, &arg);
+		if (ret)
+			return CEC_ERROR;
+	}
+
+	return CEC_OK;
+}
+
+int cec_passthrough(struct cec_device *dev, bool enable)
+{
+	struct cec_caps *caps = (struct cec_caps *)dev->caps;
+	int ret;
+
+	if (!dev)
+		return CEC_ERROR;
+	if (!dev->initialised)
+		return CEC_ERROR;
+
+	if (caps->capabilities && CEC_CAP_PASSTHROUGH) {
+		uint32_t arg;
+
+		arg = enable ? CEC_PASSTHROUGH_ENABLED : CEC_PASSTHROUGH_DISABLED;
+		ret = ioctl(dev->handle, CEC_S_PASSTHROUGH, &arg);
+		if (ret)
+			return CEC_ERROR;
+	}
+
+	return CEC_OK;
+}
+
+static int check_state(struct cec_device *dev)
+{
+	if (!dev)
+		return CEC_ERROR;
+	if (!dev->initialised)
+		return CEC_ERROR;
+	if (!cec_is_enabled(dev))
+		return CEC_ERROR;
+	return CEC_OK;
+}
+
+int cec_open(struct cec_device *dev, char *path)
+{
+	int ret;
+
+	if (!dev || !path)
+		return CEC_ERROR;
+
+	memset(dev, 0, sizeof(*dev));
+
+	dev->handle = open(path, O_RDWR);
+	if (dev->handle == -1)
+		return CEC_ERROR;
+
+	dev->caps = malloc(sizeof(struct cec_caps));
+	if (!dev->caps) {
+		close(dev->handle);
+		return CEC_ERROR;
+	}
+
+	ret = ioctl(dev->handle, CEC_G_CAPS, dev->caps);
+	if (ret) {
+		free(dev->caps);
+		close(dev->handle);
+		return CEC_ERROR;
+	}
+
+	dev->initialised = 1;
+
+	return CEC_OK;
+}
+
+int cec_close(struct cec_device *dev)
+{
+	if (!dev)
+		return CEC_ERROR;
+	if (close(dev->handle) == -1)
+		return CEC_ERROR;
+	dev->initialised = 0;
+	return CEC_OK;
+}
+
+int cec_get_info(struct cec_device *dev, struct cec_info *info)
+{
+	struct cec_caps *caps;
+	int i;
+
+	if (check_state(dev) != CEC_OK || !info)
+		return CEC_ERROR;
+
+	caps = (struct cec_caps *)(dev->caps);
+
+	info->vendor_id = caps->vendor_id;
+	switch (caps->version) {
+	case CEC_VERSION_1_4:
+		info->version = CEC_VER_1_4;
+		break;
+	case CEC_VERSION_2_0:
+		info->version = CEC_VER_2_0;
+		break;
+	default:
+		info->version = CEC_VER_UNKNOWN;
+		break;
+	}
+	info->ports_num = 1; /* ? */
+
+	for (i = 0; i < MAX_NUM_OF_HDMI_PORTS; i++) {
+		info->ports_info[i].port_number =  i;
+	}
+
+	return CEC_OK;
+}
+
+int cec_is_connected(struct cec_device *dev)
+{
+	if (!dev)
+		return CEC_ERROR;
+	/* TODO */
+	return CEC_OK;
+}
+
+int cec_send_message(struct cec_device *dev, struct cec_buffer *msg)
+{
+	struct cec_msg msg_int;
+	int i, ret;
+
+	if (check_state(dev) != CEC_OK || !msg)
+		return CEC_ERROR;
+
+	if (msg->len > CEC_MAX_LENGTH)
+		return CEC_ERROR;
+
+	msg_int.len = msg->len + 1;
+	msg_int.msg[0] =  msg->src << 4 & 0xf0;
+	msg_int.msg[0] |= msg->dst & 0x0f;
+	for (i = 0; i < msg->len; i++)
+		msg_int.msg[i + 1] = msg->payload[i];
+	msg_int.reply = 0;
+	msg_int.timeout = DEFAULT_TIMEOUT;
+
+	ret = ioctl(dev->handle, CEC_TRANSMIT, &msg_int);
+	if (ret) {
+		if (errno == ETIMEDOUT)
+			return CEC_TIMEOUT;
+		return CEC_ERROR;
+	}
+
+
+	return CEC_OK;
+}
+
+int cec_receive_message(struct cec_device *dev, struct cec_buffer *msg)
+{
+	struct cec_msg msg_int;
+	int i, ret;
+
+	if (check_state(dev) != CEC_OK || !msg)
+		return CEC_ERROR;
+
+	msg_int.timeout = DEFAULT_TIMEOUT;
+	ret = ioctl(dev->handle, CEC_RECEIVE, &msg_int);
+	if (ret) {
+		if (errno == ETIMEDOUT)
+			return CEC_TIMEOUT;
+		return CEC_ERROR;
+	}
+	if (msg_int.len == 0 || msg_int.len > CEC_MAX_LENGTH + 1)
+		return CEC_ERROR;
+
+	msg->src = msg_int.msg[0] >> 4 & 0xf;
+	msg->dst = msg_int.msg[0]  & 0xf;
+	msg->ts.tv_sec = msg_int.ts / 1000000000;
+	msg->ts.tv_nsec = msg_int.ts % 1000000000;
+	msg->len = msg_int.len - 1;
+	for (i = 0; i < msg->len; i++)
+		msg->payload[i] = msg_int.msg[i + 1];
+
+	return CEC_OK;
+}
+
+static int dev_type_to_int_dev_type(enum cec_device_type type)
+{
+	switch (type) {
+	case CEC_DEVICE_TYPE_TV:
+		return CEC_PRIM_DEVTYPE_TV;
+	case CEC_DEVICE_TYPE_RECORD:
+		return CEC_PRIM_DEVTYPE_RECORD;
+	case CEC_DEVICE_TYPE_TUNER:
+		return CEC_PRIM_DEVTYPE_TUNER;
+	case CEC_DEVICE_TYPE_PLAYBACK:
+		return CEC_PRIM_DEVTYPE_PLAYBACK;
+	case CEC_DEVICE_TYPE_AUDIOSYSTEM:
+		return CEC_PRIM_DEVTYPE_AUDIOSYSTEM;
+	case CEC_DEVICE_TYPE_SWITCH:
+		return CEC_PRIM_DEVTYPE_SWITCH;
+	case CEC_DEVICE_TYPE_VIDEOPROC:
+		return CEC_PRIM_DEVTYPE_VIDEOPROC;
+	}
+	return -1;
+}
+
+static int dev_type_to_int_addr_type(enum cec_device_type type)
+{
+	switch (type) {
+	case CEC_DEVICE_TYPE_TV:
+		return CEC_LOG_ADDR_TYPE_TV;
+	case CEC_DEVICE_TYPE_RECORD:
+		return CEC_LOG_ADDR_TYPE_RECORD;
+	case CEC_DEVICE_TYPE_TUNER:
+		return CEC_LOG_ADDR_TYPE_TUNER;
+	case CEC_DEVICE_TYPE_PLAYBACK:
+		return CEC_LOG_ADDR_TYPE_PLAYBACK;
+	case CEC_DEVICE_TYPE_AUDIOSYSTEM:
+		return CEC_LOG_ADDR_TYPE_AUDIOSYSTEM;
+	case CEC_DEVICE_TYPE_SWITCH:
+		return CEC_LOG_ADDR_TYPE_UNREGISTERED;
+	case CEC_DEVICE_TYPE_VIDEOPROC:
+		return CEC_LOG_ADDR_TYPE_SPECIFIC;
+	case CEC_DEVICE_TYPE_EMPTY:
+	default:
+		return -1;
+	}
+}
+
+#if (CEC_MAX_LOG_ADDRS < CEC_MAX_NUM_LOG_ADDR)
+#error	The CEC_MAX_NUM_LOG_ADDR (lib define) is more than CEC_MAX_LOG_ADDRS \
+	(kernel framework defined)
+#endif
+
+static int _cec_get_logical_addrs(struct cec_device *dev)
+{
+	struct cec_log_addrs log_addr;
+	uint32_t dev_type;
+	uint32_t addr_type;
+	int ret;
+	int i;
+
+	if (check_state(dev) != CEC_OK)
+		return CEC_ERROR;
+
+	memset(&log_addr, 0, sizeof(log_addr));
+	ret = ioctl(dev->handle, CEC_G_ADAP_LOG_ADDRS, &log_addr);
+	if (ret)
+		return CEC_ERROR;
+
+	for (i = 0; i < log_addr.num_log_addrs; i++) {
+		dev->dev_type_int[i] = log_addr.primary_device_type[i];
+		dev->log_addr_type_int[i] = log_addr.log_addr_type[i];
+		dev->log_addr[i] = log_addr.log_addr[i];
+	}
+
+	dev->num_log_addr = log_addr.num_log_addrs;
+
+	return CEC_OK;
+}
+
+int cec_get_logical_addrs(struct cec_device *dev, uint8_t *addr, int *num_addr)
+{
+	int i;
+
+	if (!addr || !num_addr)
+		return CEC_ERROR;
+
+	if (_cec_get_logical_addrs(dev) != CEC_OK)
+		return CEC_ERROR;
+
+	*num_addr = dev->num_log_addr;
+	for (i = 0; i < *num_addr; i++)
+		addr[i] = dev->log_addr[i];
+
+	return CEC_OK;
+}
+
+int cec_add_logical_addr(struct cec_device *dev, enum cec_device_type type,
+			 uint8_t *addr)
+{
+	struct cec_log_addrs log_addr;
+	uint32_t dev_type;
+	uint32_t addr_type;
+	int ret;
+	int i;
+
+	if (check_state(dev) != CEC_OK)
+		return CEC_ERROR;
+
+	/* Refresh copy of logical addrs */
+	if (_cec_get_logical_addrs(dev) != CEC_OK)
+		return CEC_ERROR;
+
+	if (dev->num_log_addr  >= CEC_MAX_NUM_LOG_ADDR)
+		return CEC_NO_ADDR_LEFT;
+
+	memset(&log_addr, 0, sizeof(log_addr));
+
+	if (type != CEC_DEVICE_TYPE_EMPTY) {
+		dev->dev_type[dev->num_log_addr] = type;
+		dev->dev_type_int[dev->num_log_addr] = dev_type_to_int_dev_type(type);
+		dev->log_addr_type_int[dev->num_log_addr] = dev_type_to_int_addr_type(type);
+		if (dev->dev_type_int[dev->num_log_addr] == -1 ||
+			dev->log_addr_type_int[dev->num_log_addr] == -1)
+			return CEC_ERROR;
+		dev->num_log_addr++;
+		if (dev->num_log_addr  >= CEC_MAX_NUM_LOG_ADDR) {
+			dev->num_log_addr--;
+			return CEC_NO_ADDR_LEFT;
+		}
+	}
+
+	log_addr.cec_version = CEC_VERSION_1_4;
+	log_addr.num_log_addrs = dev->num_log_addr;
+	for (i = 0; i < dev->num_log_addr; i++) {
+		log_addr.primary_device_type[i] = dev->dev_type_int[i];
+		log_addr.log_addr_type[i] = dev->log_addr_type_int[i];
+	}
+	ret = ioctl(dev->handle, CEC_S_ADAP_LOG_ADDRS, &log_addr);
+	if (ret) {
+		/* Should it call set log addr again without the last added address? */
+		if (--dev->num_log_addr > 0)
+			cec_add_logical_addr(dev, CEC_DEVICE_TYPE_EMPTY, 0);
+		return CEC_ERROR;
+	}
+
+	dev->log_addr[i - 1] = log_addr.log_addr[i - 1];
+	if (addr)
+		*addr = log_addr.log_addr[i - 1];
+
+	return CEC_OK;
+}
+
+int cec_clear_logical_addrs(struct cec_device *dev)
+{
+	struct cec_log_addrs log_addr;
+	uint32_t dev_type;
+	uint32_t addr_type;
+	int ret;
+	int i;
+
+	if (check_state(dev) != CEC_OK)
+		return CEC_ERROR;
+
+	memset(&log_addr, 0, sizeof(log_addr));
+	log_addr.num_log_addrs = 0;
+	log_addr.cec_version = CEC_VERSION_1_4;
+
+	ret = ioctl(dev->handle, CEC_S_ADAP_LOG_ADDRS, &log_addr);
+	if (ret)
+		return CEC_ERROR;
+
+	return CEC_OK;
+}
+
+int cec_get_physical_addr(struct cec_device *dev, uint16_t *phys_addr)
+{
+	int ret;
+
+	if (check_state(dev) != CEC_OK || !phys_addr)
+		return CEC_ERROR;
+	ret = ioctl(dev->handle, CEC_G_ADAP_PHYS_ADDR, phys_addr);
+	if (ret)
+		return CEC_ERROR;
+
+	return CEC_OK;
+}
+
+int cec_set_physical_addr(struct cec_device *dev, uint16_t phys_addr)
+{
+	int ret;
+
+	if (check_state(dev) != CEC_OK)
+		return CEC_ERROR;
+	ret = ioctl(dev->handle, CEC_S_ADAP_PHYS_ADDR, &phys_addr);
+	if (ret)
+		return CEC_ERROR;
+
+	return CEC_OK;
+}
+
-- 
1.7.9.5

