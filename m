Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f196.google.com ([209.85.217.196]:36038 "EHLO
	mail-lb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbcEULgL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2016 07:36:11 -0400
Received: by mail-lb0-f196.google.com with SMTP id r5so6856919lbj.3
        for <linux-media@vger.kernel.org>; Sat, 21 May 2016 04:36:10 -0700 (PDT)
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: andrea.gelmini@gelma.net
Cc: trivial@kernel.org, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org
Subject: [PATCH 0004/1529] Fix typo
Date: Sat, 21 May 2016 13:36:06 +0200
Message-Id: <20160521113606.31494-1-andrea.gelmini@gelma.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 Documentation/DocBook/media/v4l/lirc_device_interface.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/lirc_device_interface.xml b/Documentation/DocBook/media/v4l/lirc_device_interface.xml
index 34cada2..725b221 100644
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
2.8.2.534.g1f66975

