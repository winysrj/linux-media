Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:53038 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750838AbeCFQjV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2018 11:39:21 -0500
Received: by mail-wm0-f65.google.com with SMTP id t3so24022520wmc.2
        for <linux-media@vger.kernel.org>; Tue, 06 Mar 2018 08:39:21 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at
Subject: [PATCH 4/4] [media] MAINTAINERS: add entry for cxd2099
Date: Tue,  6 Mar 2018 17:39:13 +0100
Message-Id: <20180306163913.1519-5-d.scheller.oss@gmail.com>
In-Reply-To: <20180306163913.1519-1-d.scheller.oss@gmail.com>
References: <20180306163913.1519-1-d.scheller.oss@gmail.com>
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
index 0eea2f0e9456..298f0b84a4ed 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8612,6 +8612,14 @@ T:	git git://linuxtv.org/media_tree.git
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
2.16.1
