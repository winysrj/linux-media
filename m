Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33191 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755529AbdGCRVT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 13:21:19 -0400
Received: by mail-wm0-f68.google.com with SMTP id j85so21729677wmj.0
        for <linux-media@vger.kernel.org>; Mon, 03 Jul 2017 10:21:18 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH v3 10/10] [media] MAINTAINERS: add entries for stv0910 and stv6111
Date: Mon,  3 Jul 2017 19:21:03 +0200
Message-Id: <20170703172104.27283-11-d.scheller.oss@gmail.com>
In-Reply-To: <20170703172104.27283-1-d.scheller.oss@gmail.com>
References: <20170703172104.27283-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 MAINTAINERS | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c4be6d4af7d2..7b85e578d238 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8246,6 +8246,22 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Supported
 F:	drivers/media/pci/netup_unidvb/*
 
+MEDIA DRIVERS FOR ST STV0910 DEMODULATOR ICs
+M:	Daniel Scheller <d.scheller.oss@gmail.com>
+L:	linux-media@vger.kernel.org
+W:	https://linuxtv.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/dvb-frontends/stv0910*
+
+MEDIA DRIVERS FOR ST STV6111 TUNER ICs
+M:	Daniel Scheller <d.scheller.oss@gmail.com>
+L:	linux-media@vger.kernel.org
+W:	https://linuxtv.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/dvb-frontends/stv6111*
+
 MEDIA INPUT INFRASTRUCTURE (V4L/DVB)
 M:	Mauro Carvalho Chehab <mchehab@s-opensource.com>
 M:	Mauro Carvalho Chehab <mchehab@kernel.org>
-- 
2.13.0
