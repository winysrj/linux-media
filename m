Return-path: <linux-media-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:50504 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760674AbZCaNeM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 09:34:12 -0400
Date: Tue, 31 Mar 2009 15:34:10 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: linux-media@vger.kernel.org
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] dvb: Remove reference to obsolete linux-dvb@linuxtv.org
Message-ID: <alpine.LRH.2.00.0903311529050.13151@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

linux-dvb@linuxtv.org auto-responds with:

| This ML is deprecated. Please use linux-media@vger.kernel.org instead.
| For more info about linux-media@vger.kernel.org, please read:
| http://vger.kernel.org/vger-lists.html#linux-media

Hence remove it from MAINTAINERS.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
There are still a few references to it in various docs and source files

diff --git a/MAINTAINERS b/MAINTAINERS
index c5f4e9d..3c07ced 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1538,7 +1538,6 @@ S:	Maintained
 DVB SUBSYSTEM AND DRIVERS
 P:	LinuxTV.org Project
 M:	linux-media@vger.kernel.org
-L:	linux-dvb@linuxtv.org (subscription required)
 W:	http://linuxtv.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
