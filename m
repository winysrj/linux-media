Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:36192 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbcCHUlK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2016 15:41:10 -0500
Received: by mail-wm0-f44.google.com with SMTP id n186so149581355wmn.1
        for <linux-media@vger.kernel.org>; Tue, 08 Mar 2016 12:41:09 -0800 (PST)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Kees Cook <keescook@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC 6/7] [media] ati_remote: avoid fragile snprintf use
Date: Tue,  8 Mar 2016 21:40:53 +0100
Message-Id: <1457469654-17059-7-git-send-email-linux@rasmusvillemoes.dk>
In-Reply-To: <1457469654-17059-1-git-send-email-linux@rasmusvillemoes.dk>
References: <CAGXu5jJ-NApCpANjfz+bAEfwZJ8xizkM-jDHVhOPCzhxV-aqdA@mail.gmail.com>
 <1457469654-17059-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Passing overlapping source and destination to snprintf is
fragile. Replace with a single (mostly) equivalent call. If one wants
to preserve the space preceding udev->product whether or not there was
a manufacturer, just remove udev->manufacturer from the && expression.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/media/rc/ati_remote.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index a35631891cc0..b6d367ba128a 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -866,13 +866,10 @@ static int ati_remote_probe(struct usb_interface *interface,
 	strlcat(ati_remote->rc_phys, "/input0", sizeof(ati_remote->rc_phys));
 	strlcat(ati_remote->mouse_phys, "/input1", sizeof(ati_remote->mouse_phys));
 
-	if (udev->manufacturer)
-		strlcpy(ati_remote->rc_name, udev->manufacturer,
-			sizeof(ati_remote->rc_name));
-
-	if (udev->product)
-		snprintf(ati_remote->rc_name, sizeof(ati_remote->rc_name),
-			 "%s %s", ati_remote->rc_name, udev->product);
+	snprintf(ati_remote->rc_name, sizeof(ati_remote->rc_name), "%s%s%s",
+		udev->manufacturer ?: "",
+		udev->manufacturer && udev->product ? " " : "",
+		udev->product ?: "");
 
 	if (!strlen(ati_remote->rc_name))
 		snprintf(ati_remote->rc_name, sizeof(ati_remote->rc_name),
-- 
2.1.4

