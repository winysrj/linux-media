Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:3974 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab2JBEEx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 00:04:53 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 2/8] MAINTAINERS: add Michael Krufky as mxl5007t maintainer
Date: Tue,  2 Oct 2012 00:04:06 -0400
Message-Id: <1349150652-12171-2-git-send-email-mkrufky@linuxtv.org>
In-Reply-To: <1349150652-12171-1-git-send-email-mkrufky@linuxtv.org>
References: <1349150652-12171-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 MAINTAINERS |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b436561..f3a39e8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4805,6 +4805,16 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git
 S:	Maintained
 F:	drivers/usb/musb/
 
+MXL5007T MEDIA DRIVER
+M:	Michael Krufky <mkrufky@linuxtv.org>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://github.com/mkrufky
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/mkrufky/tuners.git
+S:	Maintained
+F:	drivers/media/tuners/mxl5007t.*
+
 MYRICOM MYRI-10G 10GbE DRIVER (MYRI10GE)
 M:	Andrew Gallatin <gallatin@myri.com>
 L:	netdev@vger.kernel.org
-- 
1.7.9.5

