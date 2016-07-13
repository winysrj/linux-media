Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40917 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbcGMOtw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 10:49:52 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] docs-rst: Fix some typos
Date: Wed, 13 Jul 2016 11:49:18 -0300
Message-Id: <e6e9c9b238e49e4973391078952b34d3bde3df99.1468421353.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those fixes came from patchs from Andrea for the old DocBook
documentation.

As we're removing it on Kernel 4.8, it doesn't make sense to
apply the original patches, but, as the typos were ported
to ReST, let's fix the issues there.

Suggested-by: Andrea Gelmini <andrea.gelmini@gelma.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/DocBook/media/v4l/fdl-appendix.xml          | 2 +-
 Documentation/DocBook/media/v4l/lirc_device_interface.xml | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/fdl-appendix.xml b/Documentation/DocBook/media/v4l/fdl-appendix.xml
index ae22394ba997..71299a3897c4 100644
--- a/Documentation/DocBook/media/v4l/fdl-appendix.xml
+++ b/Documentation/DocBook/media/v4l/fdl-appendix.xml
@@ -526,7 +526,7 @@
 
     <para>
       You may extract a single document from such a collection, and
-      dispbibute it individually under this License, provided you
+      distribute it individually under this License, provided you
       insert a copy of this License into the extracted document, and
       follow this License in all other respects regarding verbatim
       copying of that document.
diff --git a/Documentation/DocBook/media/v4l/lirc_device_interface.xml b/Documentation/DocBook/media/v4l/lirc_device_interface.xml
index 34cada2ca710..725b221e1f6c 100644
--- a/Documentation/DocBook/media/v4l/lirc_device_interface.xml
+++ b/Documentation/DocBook/media/v4l/lirc_device_interface.xml
@@ -114,7 +114,7 @@ on working with the default settings initially.</para>
       <para>Some receiver have maximum resolution which is defined by internal
       sample rate or data format limitations. E.g. it's common that signals can
       only be reported in 50 microsecond steps. This integer value is used by
-      lircd to automatically adjust the aeps tolerance value in the lircd
+      lircd to automatically adjust the steps tolerance value in the lircd
       config file.</para>
     </listitem>
   </varlistentry>
-- 
2.7.4

