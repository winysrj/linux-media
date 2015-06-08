Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54756 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbbFHTyc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 15:54:32 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 03/26] [media] DocBook: add entry IDs for enum fe_sec_mini_cmd
Date: Mon,  8 Jun 2015 16:53:47 -0300
Message-Id: <38f8bcbe9865831f381a163a195fdac7e0d344e4.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

enum fe_sec_mini_cmd is documented together with
FE_DISEQC_SEND_BURST.

Add xrefs for each entry there. This makes the hyperlinks at
frontend.h to go directly to the right documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/fe-diseqc-send-burst.xml b/Documentation/DocBook/media/dvb/fe-diseqc-send-burst.xml
index 91dd2078a0f4..9f6a68f32de3 100644
--- a/Documentation/DocBook/media/dvb/fe-diseqc-send-burst.xml
+++ b/Documentation/DocBook/media/dvb/fe-diseqc-send-burst.xml
@@ -73,11 +73,11 @@
 	</thead>
 	<tbody valign="top">
 	<row>
-	    <entry align="char">SEC_MINI_A</entry>
+	    <entry align="char" id="SEC-MINI-A"><constant>SEC_MINI_A</constant></entry>
 	    <entry align="char">Sends a mini-DiSEqC 22kHz '0' Tone Burst to
 		select satellite-A</entry>
 	</row><row>
-	    <entry align="char">SEC_MINI_B</entry>
+	    <entry align="char" id="SEC-MINI-B"><constant>SEC_MINI_B</constant></entry>
 	    <entry align="char">Sends a mini-DiSEqC 22kHz '1' Data Burst to
 		select satellite-B</entry>
 	</row>
-- 
2.4.2

