Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbcBNNBO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Feb 2016 08:01:14 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 17710C0AD405
	for <linux-media@vger.kernel.org>; Sun, 14 Feb 2016 13:01:14 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH tvtime 1/2] Stop installing icons in obsolete /usr/share/pixmaps location
Date: Sun, 14 Feb 2016 14:01:07 +0100
Message-Id: <1455454868-28512-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pretty much all desktop-environments use /usr/share/icons now a days.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 docs/Makefile.am | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/docs/Makefile.am b/docs/Makefile.am
index 09a900f..a3ad41d 100644
--- a/docs/Makefile.am
+++ b/docs/Makefile.am
@@ -43,12 +43,9 @@ install-data-local:
 	$(INSTALL) -d '$(DESTDIR)$(datadir)/icons/hicolor/16x16/apps'
 	$(INSTALL) -d '$(DESTDIR)$(datadir)/icons/hicolor/32x32/apps'
 	$(INSTALL) -d '$(DESTDIR)$(datadir)/icons/hicolor/48x48/apps'
-	$(INSTALL) -d '$(DESTDIR)$(datadir)/pixmaps'
 	$(INSTALL_DATA) '$(srcdir)/tvtime.16x16.png' '$(DESTDIR)$(datadir)/icons/hicolor/16x16/apps/tvtime.png'
 	$(INSTALL_DATA) '$(srcdir)/tvtime.32x32.png' '$(DESTDIR)$(datadir)/icons/hicolor/32x32/apps/tvtime.png'
 	$(INSTALL_DATA) '$(srcdir)/tvtime.48x48.png' '$(DESTDIR)$(datadir)/icons/hicolor/48x48/apps/tvtime.png'
-	$(INSTALL_DATA) '$(srcdir)/tvtime.32x32.xpm' '$(DESTDIR)$(datadir)/pixmaps/tvtime.xpm'
-	$(INSTALL_DATA) '$(srcdir)/tvtime.48x48.png' '$(DESTDIR)$(datadir)/pixmaps/tvtime.png'
 
 .PHONY: install-exec-hook
 install-exec-hook:
-- 
2.7.1

