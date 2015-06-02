Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43166 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbbFBTwt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Jun 2015 15:52:49 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 4/5] [media] DocBook: fix some syntax issues at dvbproperty.xml
Date: Tue,  2 Jun 2015 16:52:42 -0300
Message-Id: <e954b5c370a0b30c006e5843a6c35959967d44e2.1433274739.git.mchehab@osg.samsung.com>
In-Reply-To: <017aba88da8787c41eccd4d1b65506f4e6fa9a83.1433274739.git.mchehab@osg.samsung.com>
References: <017aba88da8787c41eccd4d1b65506f4e6fa9a83.1433274739.git.mchehab@osg.samsung.com>
In-Reply-To: <017aba88da8787c41eccd4d1b65506f4e6fa9a83.1433274739.git.mchehab@osg.samsung.com>
References: <017aba88da8787c41eccd4d1b65506f4e6fa9a83.1433274739.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some minor English syntax fixes.

Reported-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 746b4e2ae346..28e306ee5827 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -1,12 +1,12 @@
 <section id="frontend-properties">
 <title>DVB Frontend properties</title>
 <para>Tuning into a Digital TV physical channel and starting decoding it
-    requires to change a set of parameters, in order to control the
+    requires changing a set of parameters, in order to control the
     tuner, the demodulator, the Linear Low-noise Amplifier (LNA) and to set the
     antenna subsystem via Satellite Equipment Control (SEC), on satellite
     systems. The actual parameters are specific to each particular digital
-    TV standards, and may change as the digital TV specs evolutes.</para>
-<para>In the past, the strategy used were to have an union with the parameters
+    TV standards, and may change as the digital TV specs evolves.</para>
+<para>In the past, the strategy used was to have a union with the parameters
     needed to tune for DVB-S, DVB-C, DVB-T and ATSC delivery systems grouped
     there. The problem is that, as the second generation standards appeared,
     those structs were not big enough to contain the additional parameters.
-- 
2.4.1

