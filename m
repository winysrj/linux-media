Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51366 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884AbbE1Vtq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:49:46 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 35/35] DocBook: some fixes at FE_GET_INFO
Date: Thu, 28 May 2015 18:49:38 -0300
Message-Id: <f129bc8737ba39c8f987060c648830c43d049e6c.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are a few issues at FE_GET_INFO documentation:
- name is a string, not a pointer to a string;
- the return text should be after the paragraph.

While here, better to bold that two fields of the structure used
by FE_GET_INFO are actually deprecated.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/fe-get-info.xml b/Documentation/DocBook/media/dvb/fe-get-info.xml
index b98a9a5e74d3..4400790b4565 100644
--- a/Documentation/DocBook/media/dvb/fe-get-info.xml
+++ b/Documentation/DocBook/media/dvb/fe-get-info.xml
@@ -53,8 +53,9 @@
 kernel devices compatible with this specification and to obtain
 information about driver and hardware capabilities. The ioctl takes a
 pointer to dvb_frontend_info which is filled by the driver. When the
-driver is not compatible with this specification the ioctl returns an error &return-value-dvb;.
+driver is not compatible with this specification the ioctl returns an error.
 </para>
+&return-value-dvb;
 
     <table pgwide="1" frame="none" id="dvb-frontend-info">
       <title>struct <structname>dvb_frontend_info</structname></title>
@@ -62,13 +63,13 @@ driver is not compatible with this specification the ioctl returns an error &ret
 	&cs-str;
 	<tbody valign="top">
 	  <row>
-	    <entry>char *</entry>
+	    <entry>char</entry>
 	    <entry>name[128]</entry>
 	    <entry>Name of the frontend</entry>
 	  </row><row>
 	    <entry>fe_type_t</entry>
 	    <entry>type</entry>
-	    <entry>DVBv3 type. Should not be used on modern programs, as a
+	    <entry><emphasis role="bold">DEPRECATED</emphasis>. DVBv3 type. Should not be used on modern programs, as a
 		frontend may have more than one type. So, the DVBv5 API should
 		be used instead to enumerate and select the frontend type.</entry>
 	  </row><row>
@@ -102,7 +103,7 @@ driver is not compatible with this specification the ioctl returns an error &ret
 	  </row><row>
 	    <entry>uint32_t</entry>
 	    <entry>notifier_delay</entry>
-	    <entry>Deprecated. Not used by any driver.</entry>
+	    <entry><emphasis role="bold">DEPRECATED</emphasis>. Not used by any driver.</entry>
 	  </row><row>
 	    <entry>&fe-caps;</entry>
 	    <entry>caps</entry>
-- 
2.4.1

