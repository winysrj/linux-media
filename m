Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55494 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab2JGSmG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Oct 2012 14:42:06 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so7621739iea.19
        for <linux-media@vger.kernel.org>; Sun, 07 Oct 2012 11:42:06 -0700 (PDT)
From: Khem Raj <raj.khem@gmail.com>
To: linux-media@vger.kernel.org
Cc: Khem Raj <raj.khem@gmail.com>
Subject: [v4l-utils] Use RCC variable to call rcc compiler
Date: Sun,  7 Oct 2012 11:41:52 -0700
Message-Id: <1349635312-3045-1-git-send-email-raj.khem@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In cross compile environment rcc native version
may be staged in a different directory or even
called rcc4 or somesuch. Lets provide a facility
to specify it in environment

Signed-off-by: Khem Raj <raj.khem@gmail.com>
---
 utils/qv4l2/Makefile.am |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/qv4l2/Makefile.am b/utils/qv4l2/Makefile.am
index 02d0bcb..86d0285 100644
--- a/utils/qv4l2/Makefile.am
+++ b/utils/qv4l2/Makefile.am
@@ -29,7 +29,7 @@ moc_capture-win.cpp: $(srcdir)/capture-win.h
 
 # Call the Qt resource compiler
 qrc_qv4l2.cpp: $(srcdir)/qv4l2.qrc
-	rcc -name qv4l2 -o $@ $(srcdir)/qv4l2.qrc
+	$(RCC) -name qv4l2 -o $@ $(srcdir)/qv4l2.qrc
 
 install-data-local:
 	$(INSTALL_DATA) -D -p "$(srcdir)/qv4l2.desktop"   "$(DESTDIR)$(datadir)/applications/qv4l2.desktop"
-- 
1.7.10.4

