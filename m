Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:48624 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727613AbeI3N0Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Sep 2018 09:26:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Joe Perches <joe@perches.com>,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Josh Wu <josh.wu@atmel.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>
Subject: [PATCH] MAINTAINERS: Remove stale file entry for the Atmel ISI driver
Date: Sun, 30 Sep 2018 09:54:48 +0300
Message-Id: <20180930065448.5019-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

include/media/atmel-isi got removed three years ago without the
MAINTAINERS file being updated. Remove the stale entry.

Fixes: 40a78f36fc92 ("[media] v4l: atmel-isi: Remove support for platform data")
Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9989925f658d..1f5da095aff7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2497,7 +2497,6 @@ M:	Ludovic Desroches <ludovic.desroches@microchip.com>
 L:	linux-media@vger.kernel.org
 S:	Supported
 F:	drivers/media/platform/atmel/atmel-isi.c
-F:	include/media/atmel-isi.h
 
 ATMEL LCDFB DRIVER
 M:	Nicolas Ferre <nicolas.ferre@microchip.com>
-- 
Regards,

Laurent Pinchart
