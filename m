Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:61980 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab0BBHM4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Feb 2010 02:12:56 -0500
Received: by pxi12 with SMTP id 12so5436744pxi.33
        for <linux-media@vger.kernel.org>; Mon, 01 Feb 2010 23:12:56 -0800 (PST)
From: shijie8@gmail.com
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, zyziii@telegent.com, tiwai@suse.de,
	Huang Shijie <shijie8@gmail.com>
Subject: [PATCH v2 10/10] add maintainers for tlg2300
Date: Tue,  2 Feb 2010 15:12:45 +0800
Message-Id: <4b67d076.9613f30a.5b4a.6e68@mx.google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Huang Shijie <shijie8@gmail.com>

add the maintainers for the tlg2300 driver.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c8f47bf..2e63987 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4676,6 +4676,14 @@ F:	drivers/media/common/saa7146*
 F:	drivers/media/video/*7146*
 F:	include/media/*7146*
 
+TLG2300 VIDEO4LINUX-2 DRIVER
+M 	Huang Shijie	<shijie8@gmail.com>
+M 	Kang Yong	<kangyong@telegent.com>
+M 	Zhang Xiaobing	<xbzhang@telegent.com>
+S:	Supported
+F:	drivers/media/video/tlg2300
+
+
 SC1200 WDT DRIVER
 M:	Zwane Mwaikambo <zwane@arm.linux.org.uk>
 S:	Maintained
-- 
1.6.5.2

