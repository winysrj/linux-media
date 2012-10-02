Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:4077 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab2JBEUK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 00:20:10 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 1/8] MAINTAINERS: add Michael Krufky as tda18271 maintainer
Date: Tue,  2 Oct 2012 00:04:05 -0400
Message-Id: <1349150652-12171-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 MAINTAINERS |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4e07521..b436561 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7001,6 +7001,16 @@ T:	git git://linuxtv.org/anttip/media_tree.git
 S:	Maintained
 F:	drivers/media/tuners/tda18218*
 
+TDA18271 MEDIA DRIVER
+M:	Michael Krufky <mkrufky@linuxtv.org>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://github.com/mkrufky
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/mkrufky/tuners.git
+S:	Maintained
+F:	drivers/media/tuners/tda18271*
+
 TEAM DRIVER
 M:	Jiri Pirko <jpirko@redhat.com>
 L:	netdev@vger.kernel.org
-- 
1.7.9.5

