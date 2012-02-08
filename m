Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49775 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058Ab2BHQpg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Feb 2012 11:45:36 -0500
From: Henrique Camargo <henrique@henriquecamargo.com>
To: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	matti.j.aaltonen@nokia.com, laurent.pinchart@ideasonboard.com,
	mchehab@infradead.org,
	Henrique Camargo <henrique@henriquecamargo.com>,
	Diogo Luvizon <diogoluvizon@gmail.com>
Subject: [PATCH] media: davinci: added module.h to resolve unresolved macros
Date: Wed,  8 Feb 2012 14:44:30 -0200
Message-Id: <1328719470-30571-1-git-send-email-henrique@henriquecamargo.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Included module.h explicitly to resolve the macros THIS_MODULE and 
MODULE_LICENSE. This avoids compilations errors as those defines were not 
declared.

Signed-off-by: Henrique Camargo <henrique@henriquecamargo.com>
Signed-off-by: Diogo Luvizon <diogoluvizon@gmail.com>
---
 drivers/media/video/davinci/isif.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/davinci/isif.c b/drivers/media/video/davinci/isif.c
index 1e63852..5278fe7 100644
--- a/drivers/media/video/davinci/isif.c
+++ b/drivers/media/video/davinci/isif.c
@@ -34,6 +34,7 @@
 #include <linux/videodev2.h>
 #include <linux/clk.h>
 #include <linux/err.h>
+#include <linux/module.h>
 
 #include <mach/mux.h>
 
-- 
1.7.8.3

