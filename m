Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:3974 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab2JBEE6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 00:04:58 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 8/8] MAINTAINERS: add Michael Krufky as tda827x maintainer
Date: Tue,  2 Oct 2012 00:04:12 -0400
Message-Id: <1349150652-12171-8-git-send-email-mkrufky@linuxtv.org>
In-Reply-To: <1349150652-12171-1-git-send-email-mkrufky@linuxtv.org>
References: <1349150652-12171-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 MAINTAINERS |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3d43576..a21df13 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7061,6 +7061,16 @@ T:	git git://linuxtv.org/mkrufky/tuners.git
 S:	Maintained
 F:	drivers/media/tuners/tda18271*
 
+TDA827x MEDIA DRIVER
+M:	Michael Krufky <mkrufky@linuxtv.org>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://github.com/mkrufky
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/mkrufky/tuners.git
+S:	Maintained
+F:	drivers/media/tuners/tda8290.*
+
 TDA8290 MEDIA DRIVER
 M:	Michael Krufky <mkrufky@linuxtv.org>
 L:	linux-media@vger.kernel.org
-- 
1.7.9.5

