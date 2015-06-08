Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54752 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbbFHTyc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 15:54:32 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 06/26] [media] Docbook: add entry IDs for enum fe_sec_voltage
Date: Mon,  8 Jun 2015 16:53:50 -0300
Message-Id: <004c164bcfadb02cf9c5e1eadec62d9cb131c157.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

enum fe_sec_voltage is documented together with FE_SET_VOLTAGE.

Add xrefs for each entry there. This makes the hyperlinks at
frontend.h to go directly to the right documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/fe-set-voltage.xml b/Documentation/DocBook/media/dvb/fe-set-voltage.xml
index 73710f89ff1e..053c4cb0f540 100644
--- a/Documentation/DocBook/media/dvb/fe-set-voltage.xml
+++ b/Documentation/DocBook/media/dvb/fe-set-voltage.xml
@@ -80,13 +80,13 @@
 	</thead>
 	<tbody valign="top">
 	<row>
-	    <entry align="char">SEC_VOLTAGE_13</entry>
+	    <entry align="char" id="SEC-VOLTAGE-13"><constant>SEC_VOLTAGE_13</constant></entry>
 	    <entry align="char">Set DC voltage level to 13V</entry>
 	</row><row>
-	    <entry align="char">SEC_VOLTAGE_18</entry>
+	    <entry align="char" id="SEC-VOLTAGE-18"><constant>SEC_VOLTAGE_18</constant></entry>
 	    <entry align="char">Set DC voltage level to 18V</entry>
 	</row><row>
-	    <entry align="char">SEC_VOLTAGE_OFF</entry>
+	    <entry align="char" id="SEC-VOLTAGE-OFF"><constant>SEC_VOLTAGE_OFF</constant></entry>
 	    <entry align="char">Don't send any voltage to the antenna</entry>
 	</row>
         </tbody>
-- 
2.4.2

