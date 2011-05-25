Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:4934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757953Ab1EYP0v (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 11:26:51 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p4PFQoQY019559
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 25 May 2011 11:26:50 -0400
Received: from pedra (vpn-235-184.phx2.redhat.com [10.3.235.184])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p4PFQnlY007978
	for <linux-media@vger.kernel.org>; Wed, 25 May 2011 11:26:50 -0400
Date: Wed, 25 May 2011 12:26:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/3] [media] Documentation/DocBook: Rename media fops xml
 files
Message-ID: <20110525122643.1e2e4d8a@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

By convention, the name of the XML file should match the references
declared at media-entities.tmpl, as, otherwise, some validation
scripts break.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media-entities.tmpl b/Documentation/DocBook/media-entities.tmpl
index c8abb23..5c44aa7 100644
--- a/Documentation/DocBook/media-entities.tmpl
+++ b/Documentation/DocBook/media-entities.tmpl
@@ -373,9 +373,9 @@
 <!ENTITY sub-media-indices SYSTEM "media-indices.tmpl">
 
 <!ENTITY sub-media-controller SYSTEM "v4l/media-controller.xml">
-<!ENTITY sub-media-open SYSTEM "v4l/media-func-open.xml">
-<!ENTITY sub-media-close SYSTEM "v4l/media-func-close.xml">
-<!ENTITY sub-media-ioctl SYSTEM "v4l/media-func-ioctl.xml">
+<!ENTITY sub-media-func-open SYSTEM "v4l/media-func-open.xml">
+<!ENTITY sub-media-func-close SYSTEM "v4l/media-func-close.xml">
+<!ENTITY sub-media-func-ioctl SYSTEM "v4l/media-func-ioctl.xml">
 <!ENTITY sub-media-ioc-device-info SYSTEM "v4l/media-ioc-device-info.xml">
 <!ENTITY sub-media-ioc-enum-entities SYSTEM "v4l/media-ioc-enum-entities.xml">
 <!ENTITY sub-media-ioc-enum-links SYSTEM "v4l/media-ioc-enum-links.xml">
diff --git a/Documentation/DocBook/v4l/media-controller.xml b/Documentation/DocBook/v4l/media-controller.xml
index 2dc25e1..873ac3a 100644
--- a/Documentation/DocBook/v4l/media-controller.xml
+++ b/Documentation/DocBook/v4l/media-controller.xml
@@ -78,9 +78,9 @@
 <appendix id="media-user-func">
   <title>Function Reference</title>
   <!-- Keep this alphabetically sorted. -->
-  &sub-media-open;
-  &sub-media-close;
-  &sub-media-ioctl;
+  &sub-media-func-open;
+  &sub-media-func-close;
+  &sub-media-func-ioctl;
   <!-- All ioctls go here. -->
   &sub-media-ioc-device-info;
   &sub-media-ioc-enum-entities;
-- 
1.7.1


