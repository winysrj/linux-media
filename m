Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35403 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752663AbdGITmx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Jul 2017 15:42:53 -0400
Received: by mail-wr0-f196.google.com with SMTP id z45so20514924wrb.2
        for <linux-media@vger.kernel.org>; Sun, 09 Jul 2017 12:42:53 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, d_spingler@gmx.de, rjkm@metzlerbros.de
Subject: [PATCH 4/4] [media] MAINTAINERS: add entry for mxl5xx
Date: Sun,  9 Jul 2017 21:42:46 +0200
Message-Id: <20170709194246.10334-5-d.scheller.oss@gmail.com>
In-Reply-To: <20170709194246.10334-1-d.scheller.oss@gmail.com>
References: <20170709194246.10334-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6abb534c69c7..685886472d8a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8236,6 +8236,14 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Supported
 F:	drivers/media/dvb-frontends/lnbh25*
 
+MEDIA DRIVERS FOR MXL5XX TUNER DEMODULATORS
+M:	Daniel Scheller <d.scheller.oss@gmail.com>
+L:	linux-media@vger.kernel.org
+W:	https://linuxtv.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/dvb-frontends/mxl5xx*
+
 MEDIA DRIVERS FOR NETUP PCI UNIVERSAL DVB devices
 M:	Sergey Kozlov <serjk@netup.ru>
 M:	Abylay Ospan <aospan@netup.ru>
-- 
2.13.0
