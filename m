Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:35228 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757663AbbGUCBf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 22:01:35 -0400
Received: by lblf12 with SMTP id f12so106140564lbl.2
        for <linux-media@vger.kernel.org>; Mon, 20 Jul 2015 19:01:34 -0700 (PDT)
From: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
To: hverkuil@xs4all.nl, horms@verge.net.au, magnus.damm@gmail.com,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	mchehab@osg.samsung.com
Cc: laurent.pinchart@ideasonboard.com, j.anaszewski@samsung.com,
	kamil@wypas.org, sergei.shtylyov@cogentembedded.com,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org,
	linux-sh@vger.kernel.org,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
Subject: [PATCH 3/3] MAINTAINERS: V4L2: PLATFORM: Add entry for Renesas JPEG Processing Unit driver
Date: Tue, 21 Jul 2015 05:00:22 +0300
Message-Id: <1437444022-28916-4-git-send-email-mikhail.ulyanov@cogentembedded.com>
In-Reply-To: <1437444022-28916-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
References: <1437444022-28916-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update RENESAS JPU driver maintainer in MAINTAINERS file.

Signed-off-by: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b65b22b..da57ec1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5381,6 +5381,12 @@ S:	Maintained
 F:	fs/jbd2/
 F:	include/linux/jbd2.h
 
+JPU V4L2 MEM2MEM DRIVER FOR RENESAS
+M:	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/platform/rcar_jpu.c
+
 JSM Neo PCI based serial card
 M:	Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
 L:	linux-serial@vger.kernel.org
-- 
2.1.4

