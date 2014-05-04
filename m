Return-path: <linux-media-owner@vger.kernel.org>
Received: from fep19.mx.upcmail.net ([62.179.121.39]:63351 "EHLO
	fep19.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbaEDCJy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 May 2014 22:09:54 -0400
From: Jonathan McCrohan <jmccrohan@gmail.com>
To: linux-media@vger.kernel.org,
	pkg-vdr-dvb-devel@lists.alioth.debian.org
Cc: Jonathan McCrohan <jmccrohan@gmail.com>
Subject: [PATCH 5/6] [dvb-apps] alevt: fix FTBFS with libpng15
Date: Sun,  4 May 2014 02:51:20 +0100
Message-Id: <1399168281-20626-6-git-send-email-jmccrohan@gmail.com>
In-Reply-To: <1399168281-20626-1-git-send-email-jmccrohan@gmail.com>
References: <1399168281-20626-1-git-send-email-jmccrohan@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

libpng15 no longer includes zlib.h; we must include it ourselves

Bug-Debian: http://bugs.debian.org/742566

Signed-off-by: Jonathan McCrohan <jmccrohan@gmail.com>
---
 util/alevt/exp-gfx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/util/alevt/exp-gfx.c b/util/alevt/exp-gfx.c
index e68167b..0f7ad0c 100644
--- a/util/alevt/exp-gfx.c
+++ b/util/alevt/exp-gfx.c
@@ -138,6 +138,7 @@ static int ppm_output(struct export *e, char *name, struct fmt_page *pg)
 #ifdef WITH_PNG
 
 #include <png.h>
+#include <zlib.h>
 static int png_open(struct export *e);
 static int png_option(struct export *e, int opt, char *arg);
 static int png_output(struct export *e, char *name, struct fmt_page *pg);
-- 
1.9.2

