Return-path: <linux-media-owner@vger.kernel.org>
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:58099 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933022AbZJLSIj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2009 14:08:39 -0400
Message-ID: <4AD37090.4040002@cam.ac.uk>
Date: Mon, 12 Oct 2009 19:08:16 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] pxa-camera: Fix missing sched.h
References: <4AD36D2D.2000202@cam.ac.uk> <4AD36EE5.1060807@cam.ac.uk>
In-Reply-To: <4AD36EE5.1060807@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

linux/sched.h include was removed form linux/poll.h by
commmit a99bbaf5ee6bad1aca0c88ea65ec6e5373e86184

Required for wakeup call.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/media/video/pxa_camera.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 6952e96..5d01dcf 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -26,6 +26,7 @@
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
+#include <linux/sched.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
-- 
1.6.3.3

