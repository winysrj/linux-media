Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:54489 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbZIKHid (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 03:38:33 -0400
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id n8B7cFWd018359
	for <linux-media@vger.kernel.org>; Fri, 11 Sep 2009 10:38:21 +0300
Subject: Re: [PATCH 1/1] FM TX: si4713: Kconfig: Fixed two typos.
From: m7aalton <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: Linux-Media <linux-media@vger.kernel.org>
Cc: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
In-Reply-To: <1249729833-24975-8-git-send-email-eduardo.valentin@nokia.com>
References: <1249729833-24975-1-git-send-email-eduardo.valentin@nokia.com>
	 <1249729833-24975-2-git-send-email-eduardo.valentin@nokia.com>
	 <1249729833-24975-3-git-send-email-eduardo.valentin@nokia.com>
	 <1249729833-24975-4-git-send-email-eduardo.valentin@nokia.com>
	 <1249729833-24975-5-git-send-email-eduardo.valentin@nokia.com>
	 <1249729833-24975-6-git-send-email-eduardo.valentin@nokia.com>
	 <1249729833-24975-7-git-send-email-eduardo.valentin@nokia.com>
	 <1249729833-24975-8-git-send-email-eduardo.valentin@nokia.com>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 10:38:04 +0300
Message-Id: <1252654684.19083.140.camel@masi.ntc.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed two typos.

Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>

diff -r 5582a6427a41 -r ff80edccfe24 linux/drivers/media/radio/Kconfig
--- a/linux/drivers/media/radio/Kconfig	Tue Sep 01 22:16:23 2009 +0200
+++ b/linux/drivers/media/radio/Kconfig	Fri Sep 11 10:25:13 2009 +0300
@@ -346,7 +346,7 @@
 	---help---
 	  Say Y here if you want support to Si4713 FM Radio Transmitter.
 	  This device can transmit audio through FM. It can transmit
-	  EDS and EBDS signals as well. This module is the v4l2 radio
+	  RDS and RBDS signals as well. This module is the v4l2 radio
 	  interface for the i2c driver of this device.
 
 	  To compile this driver as a module, choose M here: the


