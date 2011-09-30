Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4504 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab1I3JBk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 05:01:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 6/7] V4L menu: remove duplicate USB dependency.
Date: Fri, 30 Sep 2011 11:01:15 +0200
Message-Id: <6cf49522bbf02316645cf34179594ba3fa6dcfa9.1317372990.git.hans.verkuil@cisco.com>
In-Reply-To: <1317373276-5818-1-git-send-email-hverkuil@xs4all.nl>
References: <1317373276-5818-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9198dc44ea6f7b8e481c8e6bb24c80fc1b2429ed.1317372990.git.hans.verkuil@cisco.com>
References: <9198dc44ea6f7b8e481c8e6bb24c80fc1b2429ed.1317372990.git.hans.verkuil@cisco.com>
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
index b4a14f3..9408e69 100644
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

