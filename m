Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:58429 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755924Ab0BPRJH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2010 12:09:07 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1NhQv2-0008Hz-5c
	for linux-media@vger.kernel.org; Tue, 16 Feb 2010 18:09:04 +0100
Received: from 92.103.125.220 ([92.103.125.220])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 16 Feb 2010 18:09:04 +0100
Received: from ticapix by 92.103.125.220 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 16 Feb 2010 18:09:04 +0100
To: linux-media@vger.kernel.org
From: "pierre.gronlier" <ticapix@gmail.com>
Subject: [PATCH] v4l/firmware/Makefile
Date: Tue, 16 Feb 2010 18:08:33 +0100
Message-ID: <hlejei$i2c$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the use of $(DESTDIR) variable in `make install' for firmwares.

From: Pierre Gronlier <pierre.gronlier@gmail.com>

Signed-off-by: Pierre Gronlier <pierre.gronlier@gmail.com>

diff -r 14021dfc00f3 v4l/firmware/Makefile
--- a/v4l/firmware/Makefile     Thu Feb 11 23:11:30 2010 -0200
+++ b/v4l/firmware/Makefile     Tue Feb 16 18:07:57 2010 +0100
@@ -1,5 +1,5 @@
 TARGETS = vicam/firmware.fw dabusb/firmware.fw dabusb/bitstream.bin
ttusb-budget/dspbootcode.bin cpia2/stv0672_vp4.bin av7110/bootcode.bin
-FW_DIR  = /lib/firmware
+FW_DIR  = $(DESTDIR)/lib/firmware

 ####



-- 
pierre g.

