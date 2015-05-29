Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39378 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422636AbbE2TWQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 May 2015 15:22:16 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 4/5] DocBook: Fix arguments on some ioctl documentation
Date: Fri, 29 May 2015 16:22:07 -0300
Message-Id: <9ae6409006ad9abd51f9e985a20ed8287ac8aa0b.1432927303.git.mchehab@osg.samsung.com>
In-Reply-To: <cad656bf57ce3c7db9a651401449537876694dfe.1432927303.git.mchehab@osg.samsung.com>
References: <cad656bf57ce3c7db9a651401449537876694dfe.1432927303.git.mchehab@osg.samsung.com>
In-Reply-To: <cad656bf57ce3c7db9a651401449537876694dfe.1432927303.git.mchehab@osg.samsung.com>
References: <cad656bf57ce3c7db9a651401449537876694dfe.1432927303.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to a cut-and-paste error, the argument is missing or wrong
on 3 ioctl documentation. Fix them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/fe-diseqc-send-burst.xml b/Documentation/DocBook/media/dvb/fe-diseqc-send-burst.xml
index d1a798048641..f79c3f21323d 100644
--- a/Documentation/DocBook/media/dvb/fe-diseqc-send-burst.xml
+++ b/Documentation/DocBook/media/dvb/fe-diseqc-send-burst.xml
@@ -36,7 +36,10 @@
 	</listitem>
       </varlistentry>
       <varlistentry>
-	<term><parameter>pointer to &fe-sec-mini-cmd;</parameter></term>
+	<term><parameter>tone</parameter></term>
+	<listitem>
+	  <para>pointer to &fe-sec-mini-cmd;</para>
+	</listitem>
       </varlistentry>
     </variablelist>
   </refsect1>
diff --git a/Documentation/DocBook/media/dvb/fe-set-tone.xml b/Documentation/DocBook/media/dvb/fe-set-tone.xml
index b4b1f5303170..f3d965503c25 100644
--- a/Documentation/DocBook/media/dvb/fe-set-tone.xml
+++ b/Documentation/DocBook/media/dvb/fe-set-tone.xml
@@ -36,7 +36,10 @@
 	</listitem>
       </varlistentry>
       <varlistentry>
-	<term><parameter>pointer to &fe-sec-tone-mode;</parameter></term>
+	<term><parameter>tone</parameter></term>
+	<listitem>
+	  <para>pointer to &fe-sec-tone-mode;</para>
+	</listitem>
       </varlistentry>
     </variablelist>
   </refsect1>
diff --git a/Documentation/DocBook/media/dvb/fe-set-voltage.xml b/Documentation/DocBook/media/dvb/fe-set-voltage.xml
index a1ee5f9c28e0..d43d51ab8a2d 100644
--- a/Documentation/DocBook/media/dvb/fe-set-voltage.xml
+++ b/Documentation/DocBook/media/dvb/fe-set-voltage.xml
@@ -36,7 +36,10 @@
 	</listitem>
       </varlistentry>
       <varlistentry>
-	<term><parameter>pointer to &fe-sec-voltage;</parameter></term>
+	<term><parameter>voltage</parameter></term>
+	<listitem>
+	  <para>pointer to &fe-sec-voltage;</para>
+	</listitem>
       </varlistentry>
     </variablelist>
   </refsect1>
-- 
2.4.1

