Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:40004 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbeGNSQ2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Jul 2018 14:16:28 -0400
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH] MAINTAINERS: mark ddbridge, stv0910, stv6111 and mxl5xx orphan
Date: Sat, 14 Jul 2018 19:56:34 +0200
Message-Id: <20180714175634.29827-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

I'm definitely not interested to try to maintain drivers in a subsystem/
tree anymore where the subsystem maintainer prefers to have changes
bitrot for months, rejects patches for idiotic reasons and, ontop, simply
ignores emails (lots of) with ie. questions to any requested changes, or
questions in general.

I'd happily continue taking care of these drivers (it's fun and I surely
have time for this, albeit everything being hobbyist, volunteer and
unpaid work). Though recalling all the latest actions and the fact that
the initial series that got the ball rolling at all being ignored for
over four(!) months, I'm now out of this business. This is not about
"getting work done".

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 MAINTAINERS | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index bbd9b9b3d74f..658a677554d3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8830,11 +8830,10 @@ F:	drivers/media/dvb-frontends/cxd2880/*
 F:	drivers/media/spi/cxd2880*
 
 MEDIA DRIVERS FOR DIGITAL DEVICES PCIE DEVICES
-M:	Daniel Scheller <d.scheller.oss@gmail.com>
 L:	linux-media@vger.kernel.org
 W:	https://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
-S:	Maintained
+S:	Orphan
 F:	drivers/media/pci/ddbridge/*
 
 MEDIA DRIVERS FOR FREESCALE IMX
@@ -8879,11 +8878,10 @@ S:	Supported
 F:	drivers/media/dvb-frontends/lnbh25*
 
 MEDIA DRIVERS FOR MXL5XX TUNER DEMODULATORS
-M:	Daniel Scheller <d.scheller.oss@gmail.com>
 L:	linux-media@vger.kernel.org
 W:	https://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
-S:	Maintained
+S:	Orphan
 F:	drivers/media/dvb-frontends/mxl5xx*
 
 MEDIA DRIVERS FOR NETUP PCI UNIVERSAL DVB devices
@@ -8954,19 +8952,17 @@ F:	Documentation/devicetree/bindings/media/renesas,vsp1.txt
 F:	drivers/media/platform/vsp1/
 
 MEDIA DRIVERS FOR ST STV0910 DEMODULATOR ICs
-M:	Daniel Scheller <d.scheller.oss@gmail.com>
 L:	linux-media@vger.kernel.org
 W:	https://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
-S:	Maintained
+S:	Orphan
 F:	drivers/media/dvb-frontends/stv0910*
 
 MEDIA DRIVERS FOR ST STV6111 TUNER ICs
-M:	Daniel Scheller <d.scheller.oss@gmail.com>
 L:	linux-media@vger.kernel.org
 W:	https://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
-S:	Maintained
+S:	Orphan
 F:	drivers/media/dvb-frontends/stv6111*
 
 MEDIA DRIVERS FOR NVIDIA TEGRA - VDE
-- 
2.16.4
