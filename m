Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:32864 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751527AbdGWSQv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Jul 2017 14:16:51 -0400
Received: by mail-wm0-f68.google.com with SMTP id 201so289840wmp.0
        for <linux-media@vger.kernel.org>; Sun, 23 Jul 2017 11:16:50 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: r.scobie@clear.net.nz, jasmin@anw.at, d_spingler@freenet.de,
        Manfred.Knick@t-online.de, rjkm@metzlerbros.de
Subject: [PATCH RESEND 14/14] [media] MAINTAINERS: add entry for ddbridge
Date: Sun, 23 Jul 2017 20:16:30 +0200
Message-Id: <20170723181630.19526-15-d.scheller.oss@gmail.com>
In-Reply-To: <20170723181630.19526-1-d.scheller.oss@gmail.com>
References: <20170723181630.19526-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9826a918d37a..f25f26b5d9f6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8428,6 +8428,14 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/dvb-frontends/stv6111*
 
+MEDIA DRIVERS FOR DIGITAL DEVICES PCIE DEVICES
+M:	Daniel Scheller <d.scheller.oss@gmail.com>
+L:	linux-media@vger.kernel.org
+W:	https://linuxtv.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/pci/ddbridge/*
+
 MEDIA INPUT INFRASTRUCTURE (V4L/DVB)
 M:	Mauro Carvalho Chehab <mchehab@s-opensource.com>
 M:	Mauro Carvalho Chehab <mchehab@kernel.org>
-- 
2.13.0
