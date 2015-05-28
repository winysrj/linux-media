Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51335 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745AbbE1Vto (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:49:44 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 11/35] DocBook: move DVB properties to happen earlier at the document
Date: Thu, 28 May 2015 18:49:14 -0300
Message-Id: <70ff21105bd10db8b3fc5a068652adcd3be1c42f.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DVBv5 API uses DVB properties as the main way to set the frontend
and collect statistics. Move the definition to happen earlier, in
order to reflect its importance.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 28acf5a1e9ff..659f71ab67ef 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -48,6 +48,8 @@ specification is available at
 
 &sub-frontend_read_status;
 
+&sub-dvbproperty;
+
 <section id="dvb-diseqc-master-cmd">
 <title>diseqc master command</title>
 
@@ -778,5 +780,3 @@ FE_TUNE_MODE_ONESHOT When set, this flag will disable any zigzagging or other "n
 
 &sub-frontend_legacy_api;
 </section>
-
-&sub-dvbproperty;
-- 
2.4.1

