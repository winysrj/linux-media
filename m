Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39407 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422681AbbE2TWS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 May 2015 15:22:18 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	David Howells <dhowells@redhat.com>, linux-doc@vger.kernel.org
Subject: [PATCH 3/5] DocBook: cleaup the notes about DTV properties
Date: Fri, 29 May 2015 16:22:06 -0300
Message-Id: <366cb101566d6a5bdccd038eb50edf951870bfcf.1432927303.git.mchehab@osg.samsung.com>
In-Reply-To: <cad656bf57ce3c7db9a651401449537876694dfe.1432927303.git.mchehab@osg.samsung.com>
References: <cad656bf57ce3c7db9a651401449537876694dfe.1432927303.git.mchehab@osg.samsung.com>
In-Reply-To: <cad656bf57ce3c7db9a651401449537876694dfe.1432927303.git.mchehab@osg.samsung.com>
References: <cad656bf57ce3c7db9a651401449537876694dfe.1432927303.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The notes there are somewhat confusing and assumes that the
reader would have read the DVBv3 way. This is not true anymore,
as the DVBv3 is now on a separate section that is marked as
deprecated.

So, cleanup the notes.

While here, add a note about using libdvbv5, instead of using
the DVBv5 API directly.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 00ba1a9e314c..a5d0a209d3f3 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -13,8 +13,14 @@
     Also, the union didn't have any space left to be expanded without breaking
     userspace. So, the decision was to deprecate the legacy union/struct based
     approach, in favor of a properties set approach.</para>
-<para>By using a properties set, it is now possible to extend and support any
-    digital TV without needing to redesign the API</para>
+
+<para>NOTE: on Linux DVB API version 3, setting a frontend were done via
+    <link linkend="dvb-frontend-parameters">struct  <constant>dvb_frontend_parameters</constant></link>.
+    This got replaced on version 5 (also called "S2API", as this API were
+    added originally_enabled to provide support for DVB-S2), because the old
+    API has a very limited support to new standards and new hardware. This
+    section describes the new and recommended way to set the frontend, with
+    suppports all digital TV delivery systems.</para>
 
 <para>Example: with the properties based approach, in order to set the tuner
     to a DVB-C channel at 651 kHz, modulated with 256-QAM, FEC 3/4 and symbol
@@ -67,13 +73,13 @@ int main(void)
 	return 0;
 }
 </programlisting>
-<para>NOTE: This section describes the DVB version 5 extension of the DVB-API,
-also called "S2API", as this API were added to provide support for DVB-S2. It
-was designed to be able to replace the old frontend API. Yet, the DISEQC and
-the capability ioctls weren't implemented yet via the new way.</para>
-<para>The typical usage for the <constant>FE_GET_PROPERTY/FE_SET_PROPERTY</constant>
-API is to replace the ioctl's were the <link linkend="dvb-frontend-parameters">
-struct <constant>dvb_frontend_parameters</constant></link> were used.</para>
+
+<para>NOTE: While it is possible to directly call the Kernel code like the
+    above example, it is strongly recommended to use
+    <ulink url="http://linuxtv.org/docs/libdvbv5/index.html">libdvbv5</ulink>,
+    as it provides abstraction to work with the supported digital TV standards
+    and provides methods for usual operations like program scanning and to
+    read/write channel descriptor files.</para>
 
 <section id="dtv-stats">
 <title>struct <structname>dtv_stats</structname></title>
-- 
2.4.1

