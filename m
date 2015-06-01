Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33041 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbbFAJNF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Jun 2015 05:13:05 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 2/2] [media] DocBook: fix FE_SET_PROPERTY ioctl arguments
Date: Mon,  1 Jun 2015 06:12:53 -0300
Message-Id: <c1c3c85ddf60a6d97c122d57d385b4929fcec4b3.1433149961.git.mchehab@osg.samsung.com>
In-Reply-To: <6fd877748a9c4133e37417061e426188fcb00fea.1433149961.git.mchehab@osg.samsung.com>
References: <6fd877748a9c4133e37417061e426188fcb00fea.1433149961.git.mchehab@osg.samsung.com>
In-Reply-To: <6fd877748a9c4133e37417061e426188fcb00fea.1433149961.git.mchehab@osg.samsung.com>
References: <6fd877748a9c4133e37417061e426188fcb00fea.1433149961.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

FE_SET_PROPERTY/FE_GET_PROPERTY actually expects a struct dtv_properties
argument.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/fe-get-property.xml b/Documentation/DocBook/media/dvb/fe-get-property.xml
index 7d0bd78f5a24..53a170ed3bd1 100644
--- a/Documentation/DocBook/media/dvb/fe-get-property.xml
+++ b/Documentation/DocBook/media/dvb/fe-get-property.xml
@@ -17,7 +17,7 @@
 	<funcdef>int <function>ioctl</function></funcdef>
 	<paramdef>int <parameter>fd</parameter></paramdef>
 	<paramdef>int <parameter>request</parameter></paramdef>
-	<paramdef>struct dtv_property *<parameter>argp</parameter></paramdef>
+	<paramdef>struct dtv_properties *<parameter>argp</parameter></paramdef>
       </funcprototype>
     </funcsynopsis>
   </refsynopsisdiv>
-- 
2.4.1

