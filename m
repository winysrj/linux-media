Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36701 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751111AbeBQPDk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Feb 2018 10:03:40 -0500
Received: by mail-wm0-f68.google.com with SMTP id f3so7881715wmc.1
        for <linux-media@vger.kernel.org>; Sat, 17 Feb 2018 07:03:40 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at
Subject: [PATCH v2 7/7] [media] MAINTAINERS: add entry for cxd2099
Date: Sat, 17 Feb 2018 16:03:28 +0100
Message-Id: <20180217150328.686-8-d.scheller.oss@gmail.com>
In-Reply-To: <20180217150328.686-1-d.scheller.oss@gmail.com>
References: <20180217150328.686-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

The cxd2099 driver is now maintained and being taken care of by

  * Jasmin Jessich <jasmin@anw.at>

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index aee793bff977..c3b689e2583e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8540,6 +8540,14 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Supported
 F:	drivers/media/dvb-frontends/ascot2e*
 
+MEDIA DRIVERS FOR CXD2099AR CI CONTROLLERS
+M:	Jasmin Jessich <jasmin@anw.at>
+L:	linux-media@vger.kernel.org
+W:	https://linuxtv.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/dvb-frontends/cxd2099*
+
 MEDIA DRIVERS FOR CXD2841ER
 M:	Sergey Kozlov <serjk@netup.ru>
 M:	Abylay Ospan <aospan@netup.ru>
-- 
2.13.6
