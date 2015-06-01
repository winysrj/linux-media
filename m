Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60236 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbbFAMT1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Jun 2015 08:19:27 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Masanari Iida <standby24x7@gmail.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH] [media] DocBook: document DVB net API
Date: Mon,  1 Jun 2015 09:19:15 -0300
Message-Id: <b743242904e7a8f50c5c6f2022c7e19d546d6053.1433161148.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DVB network API was not documented. There are just some
placeholders there.

Replace it by a proper documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index dbc9a56e8260..ae9d5a0404aa 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -91,7 +91,7 @@ STRUCTS = \
 	$(shell perl -ne 'print "$$1 " if (/^struct\s+([^\s]+)\s+/)' $(srctree)/include/uapi/linux/dvb/ca.h) \
 	$(shell perl -ne 'print "$$1 " if (/^struct\s+([^\s]+)\s+/)' $(srctree)/include/uapi/linux/dvb/dmx.h) \
 	$(shell perl -ne 'print "$$1 " if (!/dtv\_cmds\_h/ && /^struct\s+([^\s]+)\s+/)' $(srctree)/include/uapi/linux/dvb/frontend.h) \
-	$(shell perl -ne 'print "$$1 " if (/^struct\s+([A-Z][^\s]+)\s+/)' $(srctree)/include/uapi/linux/dvb/net.h) \
+	$(shell perl -ne 'print "$$1 " if (/^struct\s+([^\s]+)\s+/ && !/_old/)' $(srctree)/include/uapi/linux/dvb/net.h) \
 	$(shell perl -ne 'print "$$1 " if (/^struct\s+([^\s]+)\s+/)' $(srctree)/include/uapi/linux/dvb/video.h) \
 	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/media.h) \
 	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/v4l2-subdev.h) \
diff --git a/Documentation/DocBook/media/dvb/dvbapi.xml b/Documentation/DocBook/media/dvb/dvbapi.xml
index dc8cb558f9fd..858fd7d17104 100644
--- a/Documentation/DocBook/media/dvb/dvbapi.xml
+++ b/Documentation/DocBook/media/dvb/dvbapi.xml
@@ -108,7 +108,7 @@ Added ISDB-T test originally written by Patrick Boettcher
   <chapter id="dvb_ca">
     &sub-ca;
   </chapter>
-  <chapter id="dvb_net">
+  <chapter id="net">
     &sub-net;
   </chapter>
   <chapter id="legacy_dvb_apis">
diff --git a/Documentation/DocBook/media/dvb/net.xml b/Documentation/DocBook/media/dvb/net.xml
index d4ef21764959..aeac41ca7eae 100644
--- a/Documentation/DocBook/media/dvb/net.xml
+++ b/Documentation/DocBook/media/dvb/net.xml
@@ -1,156 +1,238 @@
 <title>DVB Network API</title>
-<para>The DVB net device enables feeding of MPE (multi protocol encapsulation) packets
-received via DVB into the Linux network protocol stack, e.g. for internet via satellite
-applications. It can be accessed through <emphasis role="bold">/dev/dvb/adapter0/net0</emphasis>. Data types and
-and ioctl definitions can be accessed by including <emphasis role="bold">linux/dvb/net.h</emphasis> in your
-application.
-</para>
-<section id="dvb_net_types">
-<title>DVB Net Data Types</title>
+<para>The DVB net device controls the mapping of data packages that are
+    part of a transport stream to be mapped into a virtual network interface,
+    visible through the standard Linux network protocol stack.</para>
+<para>Currently, two encapsulations are supported:</para>
+<itemizedlist>
+    <listitem><para><ulink url="http://en.wikipedia.org/wiki/Multiprotocol_Encapsulation">
+	Multi Protocol Encapsulation (MPE)</ulink></para></listitem>
+    <listitem><para><ulink url="http://en.wikipedia.org/wiki/Unidirectional_Lightweight_Encapsulation">
+	Ultra Lightweight Encapsulation (ULE)</ulink></para></listitem>
+</itemizedlist>
 
-<section id="dvb-net-if">
-<title>struct dvb_net_if</title>
-<programlisting>
-struct dvb_net_if {
-	__u16 pid;
-	__u16 if_num;
-	__u8  feedtype;
-#define DVB_NET_FEEDTYPE_MPE 0	/&#x22C6; multi protocol encapsulation &#x22C6;/
-#define DVB_NET_FEEDTYPE_ULE 1	/&#x22C6; ultra lightweight encapsulation &#x22C6;/
-};
-</programlisting>
-</section>
+<para>In order to create the Linux virtual network interfaces, an application
+    needs to tell to the Kernel what are the PIDs and the encapsulation types
+    that are present on the transport stream. This is done through
+    <emphasis role="bold">/dev/dvb/adapter?/net?</emphasis> device node.
+    The data will be available via virtual <constant>dvb?_?</constant>
+    network interfaces, and will be controled/routed via the standard
+    ip tools (like ip, route, netstat, ifconfig, etc).</para>
+<para> Data types and and ioctl definitions are defined via
+    <emphasis role="bold">linux/dvb/net.h</emphasis> header.</para>
 
-</section>
 <section id="net_fcalls">
 <title>DVB net Function Calls</title>
-<para>To be written&#x2026;
-</para>
-
-<section id="NET_ADD_IF"
-role="subsection"><title>NET_ADD_IF</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>This ioctl is undocumented. Documentation is welcome.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int ioctl(fd, int request = NET_ADD_IF,
- struct dvb_net_if *if);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>PARAMETERS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>int fd</para>
-</entry><entry
- align="char">
-<para>File descriptor returned by a previous call to open().</para>
-</entry>
- </row><row><entry
- align="char">
-<para>int request</para>
-</entry><entry
- align="char">
-<para>Equals NET_ADD_IF for this command.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>struct dvb_net_if *if
-</para>
-</entry><entry
- align="char">
-<para>Undocumented.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
+
+
+<refentry id="NET_ADD_IF">
+  <refmeta>
+    <refentrytitle>ioctl NET_ADD_IF</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>NET_ADD_IF</refname>
+    <refpurpose>Creates a new network interface for a given Packet ID.</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>struct dvb_net_if *<parameter>net_if</parameter></paramdef>
+      </funcprototype>
+    </funcsynopsis>
+  </refsynopsisdiv>
+
+  <refsect1>
+    <title>Arguments</title>
+        <variablelist>
+      <varlistentry>
+	<term><parameter>fd</parameter></term>
+	<listitem>
+	  <para>&fe_fd;</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>request</parameter></term>
+	<listitem>
+	  <para>FE_SET_TONE</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>net_if</parameter></term>
+	<listitem>
+	  <para>pointer to &dvb-net-if;</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+
+  <refsect1>
+    <title>Description</title>
+
+<para>The NET_ADD_IF ioctl system call selects the Packet ID (PID) that
+    contains a TCP/IP traffic, the type of encapsulation to be used (MPE or ULE)
+    and the interface number for the new interface to be created. When the
+    system call successfully returns, a new virtual network interface is  created.</para>
+<para>The &dvb-net-if;::ifnum field will be filled with the number of the
+    created interface.</para>
+
 &return-value-dvb;
-</section>
+</refsect1>
+
+<refsect1 id="dvb-net-if-t">
+<title>struct <structname>dvb_net_if</structname> description</title>
+
+<table pgwide="1" frame="none" id="dvb-net-if">
+    <title>struct <structname>dvb_net_if</structname></title>
+    <tgroup cols="2">
+	&cs-def;
+	<thead>
+	<row>
+	    <entry>ID</entry>
+	    <entry>Description</entry>
+	</row>
+	</thead>
+	<tbody valign="top">
+	<row>
+	    <entry align="char">pid</entry>
+	    <entry align="char">Packet ID (PID) of the MPEG-TS that contains
+		data</entry>
+	</row><row>
+	    <entry align="char">ifnum</entry>
+	    <entry align="char">number of the DVB interface.</entry>
+	</row><row>
+	    <entry align="char">feedtype</entry>
+	    <entry align="char">Encapsulation type of the feed. It can be:
+		<constant>DVB_NET_FEEDTYPE_MPE</constant> for MPE encoding
+		or
+		<constant>DVB_NET_FEEDTYPE_ULE</constant> for ULE encoding.
+		</entry>
+	</row>
+        </tbody>
+    </tgroup>
+</table>
+</refsect1>
+</refentry>
+
+<refentry id="NET_REMOVE_IF">
+  <refmeta>
+    <refentrytitle>ioctl NET_REMOVE_IF</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>NET_REMOVE_IF</refname>
+    <refpurpose>Removes a network interface.</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>int <parameter>ifnum</parameter></paramdef>
+      </funcprototype>
+    </funcsynopsis>
+  </refsynopsisdiv>
+
+  <refsect1>
+    <title>Arguments</title>
+        <variablelist>
+      <varlistentry>
+	<term><parameter>fd</parameter></term>
+	<listitem>
+	  <para>&fe_fd;</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>request</parameter></term>
+	<listitem>
+	  <para>FE_SET_TONE</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>net_if</parameter></term>
+	<listitem>
+	  <para>number of the interface to be removed</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+
+  <refsect1>
+    <title>Description</title>
+
+<para>The NET_REMOVE_IF ioctl deletes an interface previously created
+    via &NET-ADD-IF;.</para>
 
-<section id="NET_REMOVE_IF"
-role="subsection"><title>NET_REMOVE_IF</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>This ioctl is undocumented. Documentation is welcome.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int ioctl(fd, int request = NET_REMOVE_IF);
-</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>PARAMETERS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>int fd</para>
-</entry><entry
- align="char">
-<para>File descriptor returned by a previous call to open().</para>
-</entry>
- </row><row><entry
- align="char">
-<para>int request</para>
-</entry><entry
- align="char">
-<para>Equals NET_REMOVE_IF for this command.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 &return-value-dvb;
-</section>
+</refsect1>
+</refentry>
+
+
+<refentry id="NET_GET_IF">
+  <refmeta>
+    <refentrytitle>ioctl NET_GET_IF</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>NET_GET_IF</refname>
+    <refpurpose>Read the configuration data of an interface created via
+	&NET-ADD-IF;.</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>struct dvb_net_if *<parameter>net_if</parameter></paramdef>
+      </funcprototype>
+    </funcsynopsis>
+  </refsynopsisdiv>
+
+  <refsect1>
+    <title>Arguments</title>
+        <variablelist>
+      <varlistentry>
+	<term><parameter>fd</parameter></term>
+	<listitem>
+	  <para>&fe_fd;</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>request</parameter></term>
+	<listitem>
+	  <para>FE_SET_TONE</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>net_if</parameter></term>
+	<listitem>
+	  <para>pointer to &dvb-net-if;</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+
+  <refsect1>
+    <title>Description</title>
+
+<para>The NET_GET_IF ioctl uses the interface number given by the
+    &dvb-net-if;::ifnum field and fills the content of &dvb-net-if; with
+    the packet ID and encapsulation type used on such interface. If the
+    interface was not created yet with &NET-ADD-IF;, it will return -1 and
+    fill the <constant>errno</constant> with <constant>EINVAL</constant>
+    error code.</para>
 
-<section id="NET_GET_IF"
-role="subsection"><title>NET_GET_IF</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>This ioctl is undocumented. Documentation is welcome.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int ioctl(fd, int request = NET_GET_IF,
- struct dvb_net_if *if);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>PARAMETERS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>int fd</para>
-</entry><entry
- align="char">
-<para>File descriptor returned by a previous call to open().</para>
-</entry>
- </row><row><entry
- align="char">
-<para>int request</para>
-</entry><entry
- align="char">
-<para>Equals NET_GET_IF for this command.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>struct dvb_net_if *if
-</para>
-</entry><entry
- align="char">
-<para>Undocumented.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
 &return-value-dvb;
-</section>
+</refsect1>
+</refentry>
 </section>
diff --git a/Documentation/DocBook/media_api.tmpl b/Documentation/DocBook/media_api.tmpl
index 1e194514841c..43eda245a1b5 100644
--- a/Documentation/DocBook/media_api.tmpl
+++ b/Documentation/DocBook/media_api.tmpl
@@ -95,12 +95,22 @@
 	<para>For discussing improvements, reporting troubles, sending new drivers, etc, please mail to: <ulink url="http://vger.kernel.org/vger-lists.html#linux-media">Linux Media Mailing List (LMML).</ulink>.</para>
 </preface>
 
-<part id="v4l2spec">&sub-v4l2;</part>
-<part id="dvbapi">&sub-dvbapi;</part>
-<part id="remotes">&sub-remote_controllers;</part>
-<part id="media_common">&sub-media-controller;</part>
+<part id="v4l2spec">
+&sub-v4l2;
+</part>
+<part id="dvbapi">
+&sub-dvbapi;
+</part>
+<part id="remotes">
+&sub-remote_controllers;
+</part>
+<part id="media_common">
+&sub-media-controller;
+</part>
 
-<chapter id="gen_errors">&sub-gen-errors;</chapter>
+<chapter id="gen_errors">
+&sub-gen-errors;
+</chapter>
 
 &sub-fdl-appendix;
 
-- 
2.4.1

