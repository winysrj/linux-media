Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39385 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422661AbbE2TWQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 May 2015 15:22:16 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	David Howells <dhowells@redhat.com>, linux-doc@vger.kernel.org
Subject: [PATCH 2/5] DocBook: Add an example for using FE_SET_PROPERTY
Date: Fri, 29 May 2015 16:22:05 -0300
Message-Id: <4afbe665f59d4f622a8dee2304d65f3788fa7988.1432927303.git.mchehab@osg.samsung.com>
In-Reply-To: <cad656bf57ce3c7db9a651401449537876694dfe.1432927303.git.mchehab@osg.samsung.com>
References: <cad656bf57ce3c7db9a651401449537876694dfe.1432927303.git.mchehab@osg.samsung.com>
In-Reply-To: <cad656bf57ce3c7db9a651401449537876694dfe.1432927303.git.mchehab@osg.samsung.com>
References: <cad656bf57ce3c7db9a651401449537876694dfe.1432927303.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to make it clearer about how to use the DVBv5 calls,
add an example of its usage. That should make it clearer about
what's actually required for the DVBv5 calls to work.

While here, also mentions the libdvbv5 library.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index b91210d646cf..00ba1a9e314c 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -15,11 +15,13 @@
     approach, in favor of a properties set approach.</para>
 <para>By using a properties set, it is now possible to extend and support any
     digital TV without needing to redesign the API</para>
+
 <para>Example: with the properties based approach, in order to set the tuner
     to a DVB-C channel at 651 kHz, modulated with 256-QAM, FEC 3/4 and symbol
     rate of 5.217 Mbauds, those properties should be sent to
     <link linkend="FE_GET_PROPERTY"><constant>FE_SET_PROPERTY</constant></link> ioctl:</para>
     <itemizedlist>
+	<listitem>&DTV-DELIVERY-SYSTEM; = SYS_DVBC_ANNEX_A</listitem>
 	<listitem>&DTV-FREQUENCY; = 651000000</listitem>
 	<listitem>&DTV-MODULATION; = QAM_256</listitem>
 	<listitem>&DTV-INVERSION; = INVERSION_AUTO</listitem>
@@ -27,6 +29,44 @@
 	<listitem>&DTV-INNER-FEC; = FEC_3_4</listitem>
 	<listitem>&DTV-TUNE;</listitem>
     </itemizedlist>
+
+<para>The code that would do the above is:</para>
+<programlisting>
+#include &lt;stdio.h&gt;
+#include &lt;fcntl.h&gt;
+#include &lt;sys/ioctl.h&gt;
+#include &lt;linux/dvb/frontend.h&gt;
+
+static struct dtv_property props[] = {
+	{ .cmd = DTV_DELIVERY_SYSTEM, .u.data = SYS_DVBC_ANNEX_A },
+	{ .cmd = DTV_FREQUENCY,       .u.data = 651000000 },
+	{ .cmd = DTV_MODULATION,      .u.data = QAM_256 },
+	{ .cmd = DTV_INVERSION,       .u.data = INVERSION_AUTO },
+	{ .cmd = DTV_SYMBOL_RATE,     .u.data = 5217000 },
+	{ .cmd = DTV_INNER_FEC,       .u.data = FEC_3_4 },
+	{ .cmd = DTV_TUNE }
+};
+
+static struct dtv_properties dtv_prop = {
+	.num = 6, .props = props
+};
+
+int main(void)
+{
+	int fd = open("/dev/dvb/adapter0/frontend0", O_RDWR);
+
+	if (!fd) {
+	    perror ("open");
+	    return -1;
+	}
+	if (ioctl(fd, FE_SET_PROPERTY, &amp;dtv_prop) == -1) {
+		perror("ioctl");
+		return -1;
+	}
+	printf("Frontend set\n");
+	return 0;
+}
+</programlisting>
 <para>NOTE: This section describes the DVB version 5 extension of the DVB-API,
 also called "S2API", as this API were added to provide support for DVB-S2. It
 was designed to be able to replace the old frontend API. Yet, the DISEQC and
-- 
2.4.1

