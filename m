Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1325 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758515Ab1I3MUJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 08:20:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 5/7] V4L menu: remove duplicate USB dependency.
Date: Fri, 30 Sep 2011 14:18:32 +0200
Message-Id: <869ba38b3a89818b8c69a5c5603830a79224b279.1317384926.git.hans.verkuil@cisco.com>
In-Reply-To: <1317385114-7475-1-git-send-email-hverkuil@xs4all.nl>
References: <1317385114-7475-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9198dc44ea6f7b8e481c8e6bb24c80fc1b2429ed.1317384926.git.hans.verkuil@cisco.com>
References: <9198dc44ea6f7b8e481c8e6bb24c80fc1b2429ed.1317384926.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Thanks to Guennadi Liakhovetski <g.liakhovetski@gmx.de> for pointing this
out to me.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index f059eed..399804f 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -582,7 +582,7 @@ menuconfig V4L_USB_DRIVERS
 	depends on USB
 	default y
 
-if V4L_USB_DRIVERS && USB
+if V4L_USB_DRIVERS
 
 source "drivers/media/video/uvc/Kconfig"
 
-- 
1.7.6.3

