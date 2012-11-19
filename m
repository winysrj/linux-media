Return-path: <linux-media-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41487 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab2KSSfX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Nov 2012 13:35:23 -0500
From: Bill Pemberton <wfp5p@virginia.edu>
To: gregkh@linuxfoundation.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Rob Landley <rob@landley.net>, linux-media@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH 493/493] docbook: remove use of __devexit
Date: Mon, 19 Nov 2012 13:27:22 -0500
Message-Id: <1353349642-3677-493-git-send-email-wfp5p@virginia.edu>
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CONFIG_HOTPLUG is going away as an option so __devexit is no
longer needed.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org> 
Cc: Rob Landley <rob@landley.net> 
Cc: linux-media@vger.kernel.org 
Cc: linux-doc@vger.kernel.org 
---
 Documentation/DocBook/media/v4l/driver.xml        |  2 +-
 Documentation/DocBook/writing-an-alsa-driver.tmpl | 20 +++-----------------
 2 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/driver.xml b/Documentation/DocBook/media/v4l/driver.xml
index c502c50..7c6638b 100644
--- a/Documentation/DocBook/media/v4l/driver.xml
+++ b/Documentation/DocBook/media/v4l/driver.xml
@@ -116,7 +116,7 @@ my_suspend              (struct pci_dev *               pci_dev,
 	return 0; /* a negative value on error, 0 on success. */
 }
 
-static void __devexit
+static void
 my_remove               (struct pci_dev *               pci_dev)
 {
 	my_device *my = pci_get_drvdata (pci_dev);
diff --git a/Documentation/DocBook/writing-an-alsa-driver.tmpl b/Documentation/DocBook/writing-an-alsa-driver.tmpl
index 3d02703..060fe3c 100644
--- a/Documentation/DocBook/writing-an-alsa-driver.tmpl
+++ b/Documentation/DocBook/writing-an-alsa-driver.tmpl
@@ -526,7 +526,7 @@
   }
 
   /* destructor -- see the "Destructor" sub-section */
-  static void __devexit snd_mychip_remove(struct pci_dev *pci)
+  static void snd_mychip_remove(struct pci_dev *pci)
   {
           snd_card_free(pci_get_drvdata(pci));
           pci_set_drvdata(pci, NULL);
@@ -723,7 +723,7 @@
         <informalexample>
           <programlisting>
 <![CDATA[
-  static void __devexit snd_mychip_remove(struct pci_dev *pci)
+  static void snd_mychip_remove(struct pci_dev *pci)
   {
           snd_card_free(pci_get_drvdata(pci));
           pci_set_drvdata(pci, NULL);
@@ -1054,14 +1054,6 @@
       </para>
 
       <para>
-        As further notes, the destructors (both
-      <function>snd_mychip_dev_free</function> and
-      <function>snd_mychip_free</function>) cannot be defined with
-      the <parameter>__devexit</parameter> prefix, because they may be
-      called from the constructor, too, at the false path. 
-      </para>
-
-      <para>
       For a device which allows hotplugging, you can use
       <function>snd_card_free_when_closed</function>.  This one will
       postpone the destruction until all devices are closed.
@@ -1460,11 +1452,6 @@
       </para>
 
       <para>
-      Again, remember that you cannot
-      use the <parameter>__devexit</parameter> prefix for this destructor. 
-      </para>
-
-      <para>
       We didn't implement the hardware disabling part in the above.
       If you need to do this, please note that the destructor may be
       called even before the initialization of the chip is completed.
@@ -1656,8 +1643,7 @@
       <para>
         Note that these module entries are tagged with
       <parameter>__init</parameter> and 
-      <parameter>__exit</parameter> prefixes, not
-      <parameter>__devexit</parameter>.
+      <parameter>__exit</parameter> prefixes
       </para>
 
       <para>
-- 
1.8.0

