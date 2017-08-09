Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:32939 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751904AbdHIUbq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Aug 2017 16:31:46 -0400
Received: by mail-wm0-f66.google.com with SMTP id q189so770649wmd.0
        for <linux-media@vger.kernel.org>; Wed, 09 Aug 2017 13:31:45 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: r.scobie@clear.net.nz, jasmin@anw.at, d_spingler@freenet.de,
        Manfred.Knick@t-online.de, rjkm@metzlerbros.de
Subject: [PATCH v3 12/12] [media] MAINTAINERS: add entry for ddbridge
Date: Wed,  9 Aug 2017 22:31:28 +0200
Message-Id: <20170809203128.31476-13-d.scheller.oss@gmail.com>
In-Reply-To: <20170809203128.31476-1-d.scheller.oss@gmail.com>
References: <20170809203128.31476-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 931abca006b7..0453a1365c3a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8421,6 +8421,14 @@ T:	git git://linuxtv.org/media_tree.git
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
