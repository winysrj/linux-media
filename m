Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbcBILAD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Feb 2016 06:00:03 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 86831C0AA378
	for <linux-media@vger.kernel.org>; Tue,  9 Feb 2016 11:00:03 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH tvtime 1/2] Remove -lsupc++ from LDFLAGS
Date: Tue,  9 Feb 2016 11:59:57 +0100
Message-Id: <1455015598-18805-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tvtime does not use any functions from libsupc++, so there is no need
to link to it.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 src/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index d3e7044..4b4612f 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -83,7 +83,7 @@ tvtime_CFLAGS = $(TTF_CFLAGS) $(PNG_CFLAGS) $(OPT_CFLAGS) \
 	$(PLUGIN_CFLAGS) $(X11_CFLAGS) $(XML2_FLAG) $(ALSA_CFLAGS) \
 	$(FONT_CFLAGS) $(AM_CFLAGS)
 tvtime_LDFLAGS  = $(TTF_LIBS) $(ZLIB_LIBS) $(PNG_LIBS) \
-	$(X11_LIBS) $(XML2_LIBS) $(ALSA_LIBS) -lm -lsupc++
+	$(X11_LIBS) $(XML2_LIBS) $(ALSA_LIBS) -lm
 
 tvtime_command_SOURCES = utils.h utils.c tvtimeconf.h tvtimeconf.c \
 	tvtime-command.c
-- 
2.5.0

