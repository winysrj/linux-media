Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:35215 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbcCHUlR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2016 15:41:17 -0500
Received: by mail-wm0-f52.google.com with SMTP id l68so149513976wml.0
        for <linux-media@vger.kernel.org>; Tue, 08 Mar 2016 12:41:11 -0800 (PST)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Kees Cook <keescook@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	mjpeg-users@lists.sourceforge.net, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC 4/7] drivers/media/pci/zoran: avoid fragile snprintf use
Date: Tue,  8 Mar 2016 21:40:51 +0100
Message-Id: <1457469654-17059-5-git-send-email-linux@rasmusvillemoes.dk>
In-Reply-To: <1457469654-17059-1-git-send-email-linux@rasmusvillemoes.dk>
References: <CAGXu5jJ-NApCpANjfz+bAEfwZJ8xizkM-jDHVhOPCzhxV-aqdA@mail.gmail.com>
 <1457469654-17059-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Appending to a string by doing snprintf(buf, bufsize, "%s...", buf,
...) is not guaranteed to work.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/media/pci/zoran/videocodec.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/zoran/videocodec.c b/drivers/media/pci/zoran/videocodec.c
index c01071635290..13a3c07cd259 100644
--- a/drivers/media/pci/zoran/videocodec.c
+++ b/drivers/media/pci/zoran/videocodec.c
@@ -116,8 +116,9 @@ videocodec_attach (struct videocodec_master *master)
 				goto out_module_put;
 			}
 
-			snprintf(codec->name, sizeof(codec->name),
-				 "%s[%d]", codec->name, h->attached);
+			res = strlen(codec->name);
+			snprintf(codec->name + res, sizeof(codec->name) - res,
+				 "[%d]", h->attached);
 			codec->master_data = master;
 			res = codec->setup(codec);
 			if (res == 0) {
-- 
2.1.4

