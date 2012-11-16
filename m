Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36035 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab2KPVoK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 16:44:10 -0500
Received: by mail-lb0-f174.google.com with SMTP id gp3so2522343lbb.19
        for <linux-media@vger.kernel.org>; Fri, 16 Nov 2012 13:44:09 -0800 (PST)
Message-ID: <1353102239.2101.7.camel@tux>
Subject: [patch] MAINTAINERS: add an entry for radio-mr800 driver
From: Alexey Klimov <klimov.linux@gmail.com>
To: linux-media@vger.kernel.org
Date: Sat, 17 Nov 2012 01:43:59 +0400
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds MAINTAINERS entry for radio-mr800 usb radio driver.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index f4b3aa8..e1d9e38 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4909,6 +4909,13 @@ S:	Maintained
 F:	Documentation/serial/moxa-smartio
 F:	drivers/tty/mxser.*
 
+MR800 AVERMEDIA USB FM RADIO DRIVER
+M:	Alexey Klimov <klimov.linux@gmail.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/radio/radio-mr800.c
+
 MSI LAPTOP SUPPORT
 M:	"Lee, Chun-Yi" <jlee@novell.com>
 L:	platform-driver-x86@vger.kernel.org


