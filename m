Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:13934 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbZCCN4U (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 08:56:20 -0500
Received: from jdelvare.pck.nerim.net ([62.212.121.182] helo=hyperion.delvare)
	by services.gcu-squad.org (GCU Mailer Daemon) with esmtpsa id 1LeWAa-0006hL-SY
	(TLSv1:AES256-SHA:256)
	(envelope-from <khali@linux-fr.org>)
	for linux-media@vger.kernel.org; Tue, 03 Mar 2009 16:04:33 +0100
Date: Tue, 3 Mar 2009 14:56:12 +0100
From: Jean Delvare <khali@linux-fr.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] Drop I2C_M_IGNORE_NAK compatibility bit
Message-ID: <20090303145612.67ffdb90@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I2C_M_IGNORE_NAK is defined since kernel 2.5.54 so we don't need to
declare it in the compatibility header.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 v4l/compat.h |    4 ----
 1 file changed, 4 deletions(-)

--- v4l-dvb.orig/v4l/compat.h	2009-03-01 16:09:10.000000000 +0100
+++ v4l-dvb/v4l/compat.h	2009-03-03 14:39:16.000000000 +0100
@@ -41,10 +41,6 @@
 #  define __pure __attribute__((pure))
 #endif
 
-#ifndef I2C_M_IGNORE_NAK
-# define I2C_M_IGNORE_NAK 0x1000
-#endif
-
 /* device_create/destroy added in 2.6.18 */
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,18)
 /* on older kernels, class_device_create will in turn be a compat macro */


-- 
Jean Delvare
