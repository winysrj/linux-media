Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42352 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab3EPM7B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 May 2013 08:59:01 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 1/7] media: davinci: vpif: remove unwanted header includes
Date: Thu, 16 May 2013 18:28:16 +0530
Message-Id: <1368709102-2854-2-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1368709102-2854-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1368709102-2854-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index ea82a8b..d354d50 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -17,18 +17,11 @@
  * GNU General Public License for more details.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/spinlock.h>
-#include <linux/kernel.h>
-#include <linux/io.h>
-#include <linux/err.h>
 #include <linux/pm_runtime.h>
 #include <linux/v4l2-dv-timings.h>
 
-#include <mach/hardware.h>
-
 #include "vpif.h"
 
 MODULE_DESCRIPTION("TI DaVinci Video Port Interface driver");
-- 
1.7.4.1

