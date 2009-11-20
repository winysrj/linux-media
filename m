Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f202.google.com ([209.85.211.202]:58615 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757305AbZKTDY4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2009 22:24:56 -0500
Received: by mail-yw0-f202.google.com with SMTP id 40so1937121ywh.33
        for <linux-media@vger.kernel.org>; Thu, 19 Nov 2009 19:25:02 -0800 (PST)
From: Huang Shijie <shijie8@gmail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, Huang Shijie <shijie8@gmail.com>
Subject: [PATCH 02/11] add maitainers for tlg2300
Date: Fri, 20 Nov 2009 11:24:44 +0800
Message-Id: <1258687493-4012-3-git-send-email-shijie8@gmail.com>
In-Reply-To: <1258687493-4012-2-git-send-email-shijie8@gmail.com>
References: <1258687493-4012-1-git-send-email-shijie8@gmail.com>
 <1258687493-4012-2-git-send-email-shijie8@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

add maitainers for the driver.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 60299a9..a8f02d6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5673,6 +5673,12 @@ F:	Documentation/networking/z8530drv.txt
 F:	drivers/net/hamradio/*scc.c
 F:	drivers/net/hamradio/z8530.h
 
+TLG2300 VIDEO DRIVER
+M:	Huang Shijie <shijie8@gmail.com>
+M:	Kang Yong <kongyong@telegent.com>
+M:	Zhang Xiaobing<xbzhang@telegent.com>
+S:	Supported
+
 ZD1211RW WIRELESS DRIVER
 M:	Daniel Drake <dsd@gentoo.org>
 M:	Ulrich Kunitz <kune@deine-taler.de>
-- 
1.6.0.6

