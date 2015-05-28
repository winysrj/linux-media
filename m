Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51445 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169AbbE1Vtu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:49:50 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 33/35] DocBook: add a proper description for dvb_frontend_info.fe_type
Date: Thu, 28 May 2015 18:49:36 -0300
Message-Id: <7d9f980d7375ba315544c334c4be3fa0ac4a40e9.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The fe_type is deprecated at the DVB API. However, it may still
be used by legacy DVBv3 applications. While this works with old
devices, modern devices may support more than one delivery
system.

Add an explanation about that and a point to what should be
used, instead, in order for legacy apps to support newer hardware.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/frontend_legacy_api.xml b/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
index e2817f830312..1eedc4ce0e4a 100644
--- a/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
+++ b/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
@@ -45,9 +45,19 @@
 supported via the new <link linkend="FE_GET_PROPERTY">FE_GET_PROPERTY/FE_GET_SET_PROPERTY</link> ioctl's, using the <link linkend="DTV-DELIVERY-SYSTEM">DTV_DELIVERY_SYSTEM</link> parameter.
 </para>
 
-<para>The usage of this field is deprecated, as it doesn't report all supported standards, and
-will provide an incomplete information for frontends that support multiple delivery systems.
-Please use <link linkend="DTV-ENUM-DELSYS">DTV_ENUM_DELSYS</link> instead.</para>
+<para>In the old days, &dvb-frontend-info; used to contain
+    <constant>fe_type_t</constant> field to indicate the delivery systems,
+    filled with either FE_QPSK, FE_QAM, FE_OFDM or FE_ATSC. While this is
+    still filled to keep backward compatibility, the usage of this
+    field is deprecated, as it can report just one delivery system, but some
+    devices support multiple delivery systems. Please use
+    <link linkend="DTV-ENUM-DELSYS">DTV_ENUM_DELSYS</link> instead.
+</para>
+<para>On devices that support multiple delivery systems,
+    &dvb-frontend-info;::<constant>fe_type_t</constant> is filled with the
+    currently standard, as selected by the last call to
+    <link linkend="FE_GET_PROPERTY">FE_SET_PROPERTY</link>
+    using the &DTV-DELIVERY-SYSTEM; property.</para>
 </section>
 
 
-- 
2.4.1

