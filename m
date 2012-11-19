Return-path: <linux-media-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41458 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab2KSSeS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Nov 2012 13:34:18 -0500
From: Bill Pemberton <wfp5p@virginia.edu>
To: gregkh@linuxfoundation.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Rob Landley <rob@landley.net>, linux-media@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH 289/493] docbook: remove discussion of __devinit
Date: Mon, 19 Nov 2012 13:23:58 -0500
Message-Id: <1353349642-3677-289-git-send-email-wfp5p@virginia.edu>
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CONFIG_HOTPLUG is going away as an option and __devinit will go away
as an attribute.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org> 
Cc: Rob Landley <rob@landley.net> 
Cc: linux-media@vger.kernel.org 
Cc: linux-doc@vger.kernel.org 
---
 Documentation/DocBook/media/v4l/driver.xml        |  2 +-
 Documentation/DocBook/writing-an-alsa-driver.tmpl | 22 ++++++++--------------
 2 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/driver.xml b/Documentation/DocBook/media/v4l/driver.xml
index cbfe8e3..c502c50 100644
--- a/Documentation/DocBook/media/v4l/driver.xml
+++ b/Documentation/DocBook/media/v4l/driver.xml
@@ -124,7 +124,7 @@ my_remove               (struct pci_dev *               pci_dev)
 	/* Describe me. */
 }
 
-static int __devinit
+static int
 my_probe                (struct pci_dev *               pci_dev,
 			 const struct pci_device_id *   pci_id)
 {
diff --git a/Documentation/DocBook/writing-an-alsa-driver.tmpl b/Documentation/DocBook/writing-an-alsa-driver.tmpl
index ec40c05..bf03949 100644
--- a/Documentation/DocBook/writing-an-alsa-driver.tmpl
+++ b/Documentation/DocBook/writing-an-alsa-driver.tmpl
@@ -433,7 +433,7 @@
   /* chip-specific constructor
    * (see "Management of Cards and Components")
    */
-  static int __devinit snd_mychip_create(struct snd_card *card,
+  static int snd_mychip_create(struct snd_card *card,
                                          struct pci_dev *pci,
                                          struct mychip **rchip)
   {
@@ -475,7 +475,7 @@
   }
 
   /* constructor -- see "Constructor" sub-section */
-  static int __devinit snd_mychip_probe(struct pci_dev *pci,
+  static int snd_mychip_probe(struct pci_dev *pci,
                                const struct pci_device_id *pci_id)
   {
           static int dev;
@@ -541,11 +541,6 @@
       <title>Constructor</title>
       <para>
         The real constructor of PCI drivers is the <function>probe</function> callback.
-      The <function>probe</function> callback and other component-constructors which are called
-      from the <function>probe</function> callback should be defined with
-      the <parameter>__devinit</parameter> prefix. You 
-      cannot use the <parameter>__init</parameter> prefix for them,
-      because any PCI device could be a hotplug device. 
       </para>
 
       <para>
@@ -1120,7 +1115,7 @@
   }
 
   /* chip-specific constructor */
-  static int __devinit snd_mychip_create(struct snd_card *card,
+  static int snd_mychip_create(struct snd_card *card,
                                          struct pci_dev *pci,
                                          struct mychip **rchip)
   {
@@ -1662,7 +1657,6 @@
         Note that these module entries are tagged with
       <parameter>__init</parameter> and 
       <parameter>__exit</parameter> prefixes, not
-      <parameter>__devinit</parameter> nor
       <parameter>__devexit</parameter>.
       </para>
 
@@ -1914,7 +1908,7 @@
    */
 
   /* create a pcm device */
-  static int __devinit snd_mychip_new_pcm(struct mychip *chip)
+  static int snd_mychip_new_pcm(struct mychip *chip)
   {
           struct snd_pcm *pcm;
           int err;
@@ -1953,7 +1947,7 @@
         <informalexample>
           <programlisting>
 <![CDATA[
-  static int __devinit snd_mychip_new_pcm(struct mychip *chip)
+  static int snd_mychip_new_pcm(struct mychip *chip)
   {
           struct snd_pcm *pcm;
           int err;
@@ -2120,7 +2114,7 @@
           ....
   }
 
-  static int __devinit snd_mychip_new_pcm(struct mychip *chip)
+  static int snd_mychip_new_pcm(struct mychip *chip)
   {
           struct snd_pcm *pcm;
           ....
@@ -5757,7 +5751,7 @@ struct _snd_pcm_runtime {
       <informalexample>
         <programlisting>
 <![CDATA[
-  static int __devinit snd_mychip_probe(struct pci_dev *pci,
+  static int snd_mychip_probe(struct pci_dev *pci,
                                const struct pci_device_id *pci_id)
   {
           ....
@@ -5783,7 +5777,7 @@ struct _snd_pcm_runtime {
       <informalexample>
         <programlisting>
 <![CDATA[
-  static int __devinit snd_mychip_probe(struct pci_dev *pci,
+  static int snd_mychip_probe(struct pci_dev *pci,
                                const struct pci_device_id *pci_id)
   {
           ....
-- 
1.8.0

