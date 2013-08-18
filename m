Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:61433 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab3HRUBG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Aug 2013 16:01:06 -0400
Received: by mail-ea0-f179.google.com with SMTP id b10so1932609eae.10
        for <linux-media@vger.kernel.org>; Sun, 18 Aug 2013 13:01:05 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] s5p-tv: Include missing v4l2-dv-timings.h header file
Date: Sun, 18 Aug 2013 22:00:50 +0200
Message-Id: <1376856050-30538-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Include the v4l2-dv-timings.h header file which in the s5p-tv driver which
was supposed to be updated in commit 2576415846bcbad3c0a6885fc44f95083710
"[media] v4l2: move dv-timings related code to v4l2-dv-timings.c"

This fixes following build error:

drivers/media/platform/s5p-tv/hdmi_drv.c: In function ‘hdmi_s_dv_timings’:
drivers/media/platform/s5p-tv/hdmi_drv.c:628:3: error: implicit declaration of function ‘v4l_match_dv_timings’

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/s5p-tv/hdmi_drv.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index 1b34c36..f9af2c2 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -37,6 +37,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-dv-timings.h>
 
 #include "regs-hdmi.h"
 
-- 
1.7.4.1

