Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:3974 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab2JBEEz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 00:04:55 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 4/8] MAINTAINERS: add Michael Krufky as lgdt3305 maintainer
Date: Tue,  2 Oct 2012 00:04:08 -0400
Message-Id: <1349150652-12171-4-git-send-email-mkrufky@linuxtv.org>
In-Reply-To: <1349150652-12171-1-git-send-email-mkrufky@linuxtv.org>
References: <1349150652-12171-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 MAINTAINERS |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index fc4a6e4..99bb052 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4349,6 +4349,16 @@ W:	http://legousb.sourceforge.net/
 S:	Maintained
 F:	drivers/usb/misc/legousbtower.c
 
+LGDT3305 MEDIA DRIVER
+M:	Michael Krufky <mkrufky@linuxtv.org>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://github.com/mkrufky
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/mkrufky/tuners.git
+S:	Maintained
+F:	drivers/media/dvb-frontends/lgdt3305.*
+
 LGUEST
 M:	Rusty Russell <rusty@rustcorp.com.au>
 L:	lguest@lists.ozlabs.org
-- 
1.7.9.5

