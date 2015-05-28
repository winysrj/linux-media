Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51439 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbbE1Vtu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:49:50 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Masanari Iida <standby24x7@gmail.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 01/35] DocBook: Update DVB supported standards at introduction
Date: Thu, 28 May 2015 18:49:04 -0300
Message-Id: <5d9eb89aef94914ac81a298f0b61872ba49c970d.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The list of standards at the media docbook is incomplete, and it
is mentioning that the DVB-S2 & friends is "currently being updated".
That's wrong, as such update occurred back in 2008.

So, provide a more complete list of supported standards and add
a reference to the actual list.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media_api.tmpl b/Documentation/DocBook/media_api.tmpl
index 03f9a1f8d413..60d0c877ea16 100644
--- a/Documentation/DocBook/media_api.tmpl
+++ b/Documentation/DocBook/media_api.tmpl
@@ -67,8 +67,9 @@
 		API used for digital TV and Internet reception via one of the
 		several digital tv standards. While it is called as DVB API,
 		in fact it covers several different video standards including
-		DVB-T, DVB-S, DVB-C and ATSC. The API is currently being updated
-		to document support also for DVB-S2, ISDB-T and ISDB-S.</para>
+		DVB-T/T2, DVB-S/S2, DVB-C, ATSC, ISDB-T, ISDB-S,etc. The complete
+		list of supported standards can be found at
+		<xref linkend="fe-delivery-system-t" />.</para>
 	<para>The third part covers the Remote Controller API.</para>
 	<para>The fourth part covers the Media Controller API.</para>
 	<para>For additional information and for the latest development code,
-- 
2.4.1

