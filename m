Return-path: <linux-media-owner@vger.kernel.org>
Received: from newton.telenet-ops.be ([195.130.132.45]:40463 "EHLO
	newton.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbcEVJM1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 May 2016 05:12:27 -0400
Received: from andre.telenet-ops.be (andre.telenet-ops.be [IPv6:2a02:1800:120:4::f00:15])
	by newton.telenet-ops.be (Postfix) with ESMTP id 3rCG525n37zMrJRX
	for <linux-media@vger.kernel.org>; Sun, 22 May 2016 11:06:46 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 28/54] MAINTAINERS: Add file patterns for media device tree bindings
Date: Sun, 22 May 2016 11:06:05 +0200
Message-Id: <1463907991-7916-29-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1463907991-7916-1-git-send-email-geert@linux-m68k.org>
References: <1463907991-7916-1-git-send-email-geert@linux-m68k.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Submitters of device tree binding documentation may forget to CC
the subsystem maintainer if this is missing.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
---
Please apply this patch directly if you want to be involved in device
tree binding documentation for your subsystem.
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7acb65bb2590a321..c230cd9ec8aefe45 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7376,6 +7376,7 @@ W:	https://linuxtv.org
 Q:	http://patchwork.kernel.org/project/linux-media/list/
 T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
+F:	Documentation/devicetree/bindings/media/
 F:	Documentation/dvb/
 F:	Documentation/video4linux/
 F:	Documentation/DocBook/media/
-- 
1.9.1

