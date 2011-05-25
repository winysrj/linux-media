Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:32321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757985Ab1EYP0w (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 11:26:52 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p4PFQqO8008044
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 25 May 2011 11:26:52 -0400
Received: from pedra (vpn-235-184.phx2.redhat.com [10.3.235.184])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p4PFQnlZ007978
	for <linux-media@vger.kernel.org>; Wed, 25 May 2011 11:26:51 -0400
Date: Wed, 25 May 2011 12:26:40 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/3] [media] add V4L2-PIX-FMT-SRGGB12 & friends to docbook
Message-ID: <20110525122640.5b872ace@pedra>
In-Reply-To: <96c3a1277523b929bd27f5d68d5f40e2a0e5bdf3.1306337174.git.mchehab@redhat.com>
References: <96c3a1277523b929bd27f5d68d5f40e2a0e5bdf3.1306337174.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The xml with those guys are there, but they weren't included
on the docbook.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media-entities.tmpl b/Documentation/DocBook/media-entities.tmpl
index 5c44aa7..e5fe094 100644
--- a/Documentation/DocBook/media-entities.tmpl
+++ b/Documentation/DocBook/media-entities.tmpl
@@ -293,6 +293,7 @@
 <!ENTITY sub-yuyv SYSTEM "v4l/pixfmt-yuyv.xml">
 <!ENTITY sub-yvyu SYSTEM "v4l/pixfmt-yvyu.xml">
 <!ENTITY sub-srggb10 SYSTEM "v4l/pixfmt-srggb10.xml">
+<!ENTITY sub-srggb12 SYSTEM "v4l/pixfmt-srggb12.xml">
 <!ENTITY sub-srggb8 SYSTEM "v4l/pixfmt-srggb8.xml">
 <!ENTITY sub-y10 SYSTEM "v4l/pixfmt-y10.xml">
 <!ENTITY sub-y12 SYSTEM "v4l/pixfmt-y12.xml">
diff --git a/Documentation/DocBook/v4l/pixfmt.xml b/Documentation/DocBook/v4l/pixfmt.xml
index dbfe3b0..deb6602 100644
--- a/Documentation/DocBook/v4l/pixfmt.xml
+++ b/Documentation/DocBook/v4l/pixfmt.xml
@@ -673,6 +673,7 @@ access the palette, this must be done with ioctls of the Linux framebuffer API.<
     &sub-srggb8;
     &sub-sbggr16;
     &sub-srggb10;
+    &sub-srggb12;
   </section>
 
   <section id="yuv-formats">
-- 
1.7.1


