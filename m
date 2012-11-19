Return-path: <linux-media-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41654 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab2KSSiE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Nov 2012 13:38:04 -0500
From: Bill Pemberton <wfp5p@virginia.edu>
To: gregkh@linuxfoundation.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Rob Landley <rob@landley.net>, linux-media@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH 031/493] docbook: remove references to __devexit_p
Date: Mon, 19 Nov 2012 13:19:40 -0500
Message-Id: <1353349642-3677-31-git-send-email-wfp5p@virginia.edu>
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CONFIG_HOTPLUG is going away as an option so __devexit_p is no longer
needed.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org> 
Cc: Rob Landley <rob@landley.net> 
Cc: linux-media@vger.kernel.org 
Cc: linux-doc@vger.kernel.org 
---
 Documentation/DocBook/media/v4l/driver.xml        |  2 +-
 Documentation/DocBook/writing-an-alsa-driver.tmpl | 12 ++++--------
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/driver.xml b/Documentation/DocBook/media/v4l/driver.xml
index eacafe3..cbfe8e3 100644
--- a/Documentation/DocBook/media/v4l/driver.xml
+++ b/Documentation/DocBook/media/v4l/driver.xml
@@ -157,7 +157,7 @@ my_pci_driver = {
 	.id_table = my_pci_device_ids,
 
 	.probe    = my_probe,
-	.remove   = __devexit_p (my_remove),
+	.remove   = my_remove,
 
 	/* Power management functions. */
 	.suspend  = my_suspend,
diff --git a/Documentation/DocBook/writing-an-alsa-driver.tmpl b/Documentation/DocBook/writing-an-alsa-driver.tmpl
index cab4ec5..ec40c05 100644
--- a/Documentation/DocBook/writing-an-alsa-driver.tmpl
+++ b/Documentation/DocBook/writing-an-alsa-driver.tmpl
@@ -1200,7 +1200,7 @@
           .name = KBUILD_MODNAME,
           .id_table = snd_mychip_ids,
           .probe = snd_mychip_probe,
-          .remove = __devexit_p(snd_mychip_remove),
+          .remove = snd_mychip_remove,
   };
 
   /* module initialization */
@@ -1619,7 +1619,7 @@
           .name = KBUILD_MODNAME,
           .id_table = snd_mychip_ids,
           .probe = snd_mychip_probe,
-          .remove = __devexit_p(snd_mychip_remove),
+          .remove = snd_mychip_remove,
   };
 ]]>
           </programlisting>
@@ -1630,11 +1630,7 @@
         The <structfield>probe</structfield> and
       <structfield>remove</structfield> functions have already
       been defined in the previous sections.
-      The <structfield>remove</structfield> function should
-      be defined with the 
-      <function>__devexit_p()</function> macro, so that it's not
-      defined for built-in (and non-hot-pluggable) case. The
-      <structfield>name</structfield> 
+      The <structfield>name</structfield>
       field is the name string of this device. Note that you must not
       use a slash <quote>/</quote> in this string. 
       </para>
@@ -5825,7 +5821,7 @@ struct _snd_pcm_runtime {
           .name = KBUILD_MODNAME,
           .id_table = snd_my_ids,
           .probe = snd_my_probe,
-          .remove = __devexit_p(snd_my_remove),
+          .remove = snd_my_remove,
   #ifdef CONFIG_PM
           .suspend = snd_my_suspend,
           .resume = snd_my_resume,
-- 
1.8.0

