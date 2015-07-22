Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:34882 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934149AbbGVLXq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2015 07:23:46 -0400
Received: by lahh5 with SMTP id h5so135961554lah.2
        for <linux-media@vger.kernel.org>; Wed, 22 Jul 2015 04:23:45 -0700 (PDT)
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
Date: Wed, 22 Jul 2015 14:23:05 +0300
Message-Id: <1437564185-13593-4-git-send-email-mikhail.ulyanov@cogentembedded.com>
In-Reply-To: <1437564185-13593-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
References: <1437564185-13593-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
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

