Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754747AbcBXLHT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2016 06:07:19 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: mchehab@osg.samsung.com
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH tvtime 3/4] docs/Makefile.am: Actually install the appdata / ship it in make dist
Date: Wed, 24 Feb 2016 12:07:06 +0100
Message-Id: <1456312027-8484-3-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1456312027-8484-1-git-send-email-hdegoede@redhat.com>
References: <1456312027-8484-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 docs/Makefile.am | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/docs/Makefile.am b/docs/Makefile.am
index 8e8e937..a3ad41d 100644
--- a/docs/Makefile.am
+++ b/docs/Makefile.am
@@ -34,6 +34,8 @@ EXTRA_DIST = $(docs_html) tvtime.16x16.png \
 # http://www.freedesktop.org/standards/desktop-entry-spec/
 desktopdatadir = $(datadir)/applications
 dist_desktopdata_DATA = tvtime.desktop
+appdatadir = $(datadir)/appdata
+dist_appdata_DATA = tvtime.appdata.xml
 
 # We use $(datadir)/icons/hicolor as our theme from the freedesktop spec
 # http://www.freedesktop.org/standards/menu-spec/
-- 
2.7.1

