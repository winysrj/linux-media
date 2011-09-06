Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858Ab1IFPaK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Sep 2011 11:30:10 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 02/10] Fix make dist target
Date: Tue,  6 Sep 2011 12:29:48 -0300
Message-Id: <1315322996-10576-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1315322996-10576-1-git-send-email-mchehab@redhat.com>
References: <1315322996-10576-1-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 src/Makefile.am |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 50687c2..3a38aac 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -38,7 +38,7 @@ COMMON_SRCS = mixer.c videoinput.c rtctimer.c leetft.c osdtools.c tvtimeconf.c \
 	speedtools.h vbiscreen.h vbiscreen.c fifo.h fifo.c commands.h \
 	commands.c videofilter.h videofilter.c station.h station.c bands.h \
 	utils.h utils.c pulldown.h pulldown.c hashtable.h hashtable.c \
-	cpuinfo.h cpuinfo.c videodev2.h menu.c menu.h \
+	cpuinfo.h cpuinfo.c menu.c menu.h \
 	outputfilter.h outputfilter.c xmltv.h xmltv.c gettext.h tvtimeglyphs.h \
 	copyfunctions.h copyfunctions.c alsa_stream.c
 
-- 
1.7.6.1

