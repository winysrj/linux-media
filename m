Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36008 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab2K0XM5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 18:12:57 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so7119380lbb.19
        for <linux-media@vger.kernel.org>; Tue, 27 Nov 2012 15:12:56 -0800 (PST)
Message-ID: <1352703452.5567.21.camel@linux>
Subject: [patch 03/03 v2] MAINTAINERS: add entry for radio-ma901 driver
From: Alexey Klimov <klimov.linux@gmail.com>
To: linux-media@vger.kernel.org
Date: Mon, 12 Nov 2012 07:57:32 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds MAINTAINERS entry for radio-ma901 usb radio driver.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>


diff --git a/MAINTAINERS b/MAINTAINERS
index b623679..a36b29c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4723,6 +4723,13 @@ Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 S:	Maintained
 F:	drivers/media/dvb-frontends/m88rs2000*
 
+MA901 MASTERKIT USB FM RADIO DRIVER
+M:      Alexey Klimov <klimov.linux@gmail.com>
+L:      linux-media@vger.kernel.org
+T:      git git://linuxtv.org/media_tree.git
+S:      Maintained
+F:      drivers/media/radio/radio-ma901.c
+
 MAC80211
 M:	Johannes Berg <johannes@sipsolutions.net>
 L:	linux-wireless@vger.kernel.org


