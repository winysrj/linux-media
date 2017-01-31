Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-2.goneo.de ([85.220.129.34]:57309 "EHLO smtp2-2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751491AbdAaKGs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 05:06:48 -0500
From: Markus Heiser <markus.heiser@darmarit.de>
To: Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
        "linux-doc @ vger . kernel . org List" <linux-doc@vger.kernel.org>,
        "linux-media @ vger . kernel . org" <linux-media@vger.kernel.org>
Subject: [PATCH] doc-rst: fixed cleandoc target when used with O=dir
Date: Tue, 31 Jan 2017 10:57:41 +0100
Message-Id: <1485856661-23095-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cleandocs target won't work if I use a different output folder::

  $ make O=/tmp/kernel SPHINXDIRS="process" cleandocs
  make[1]: Entering directory '/tmp/kernel'
  make[3]: *** No rule to make target 'clean'.  Stop.
  ... Documentation/Makefile.sphinx:100: recipe for target 'cleandocs' failed

Signed-off-by: Markus Heiser <markus.heiser@darmarit.de>
---
 Documentation/Makefile.sphinx | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/Makefile.sphinx b/Documentation/Makefile.sphinx
index e14d82a..be1936e 100644
--- a/Documentation/Makefile.sphinx
+++ b/Documentation/Makefile.sphinx
@@ -98,7 +98,7 @@ installmandocs:
 
 cleandocs:
 	$(Q)rm -rf $(BUILDDIR)
-	$(Q)$(MAKE) BUILDDIR=$(abspath $(BUILDDIR)) -C Documentation/media clean
+	$(Q)$(MAKE) BUILDDIR=$(abspath $(BUILDDIR)) $(build)=Documentation/media clean
 
 endif # HAVE_SPHINX
 
-- 
2.7.4

