Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:38147 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752021AbdIMHf4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 03:35:56 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Wu-Cheng Li <wuchengli@chromium.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v2] v4l-ioctl: Fix typo on v4l_print_frmsizeenum
Date: Wed, 13 Sep 2017 09:35:52 +0200
Message-Id: <20170913073552.29806-1-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

max_width and max_height are swap with step_width and step_height.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---

Since that this bug has been here for ever. I do not know if we should
notify stable or not

I have also cut the lines to respect the 80 char limit

v2: Suggested by Laurent Pinchart <laurent.pinchart@ideasonboard.com>
-Fix indentation

 drivers/media/v4l2-core/v4l2-ioctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index b60a6b0841d1..0292f327467d 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -730,9 +730,9 @@ static void v4l_print_frmsizeenum(const void *arg, bool write_only)
 		break;
 	case V4L2_FRMSIZE_TYPE_STEPWISE:
 		pr_cont(", min=%ux%u, max=%ux%u, step=%ux%u\n",
-				p->stepwise.min_width,  p->stepwise.min_height,
-				p->stepwise.step_width, p->stepwise.step_height,
-				p->stepwise.max_width,  p->stepwise.max_height);
+			  p->stepwise.min_width, p->stepwise.min_height,
+			  p->stepwise.max_width, p->stepwise.max_height,
+			  p->stepwise.step_width, p->stepwise.step_height);
 		break;
 	case V4L2_FRMSIZE_TYPE_CONTINUOUS:
 		/* fall through */
-- 
2.14.1
