Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:60467 "EHLO
        bin-vsp-out-02.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932836AbeBLWEN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 17:04:13 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH] v4l: subdev: compat: update handling for VIDIOC_SUBDEV_[GS]_ROUTING
Date: Mon, 12 Feb 2018 23:03:52 +0100
Message-Id: <20180212220352.21629-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement compat IOCTL handling for VIDIOC_SUBDEV_G_ROUTING and
VIDIOC_SUBDEV_S_ROUTING IOCTLs.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Hi Sakari,

With this fix on-top of your vc branch I get it work with v4.16-rc1, 
feel free to squash it into your branch where appropriate. I tested this 
with a ARM64 kernel and a ARM user-land with v4l2-ctl + my 
--{get,set}-routing patches for v4l-utils.

// Niklas

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index a1f71a83ac076d7f..30700658963d3227 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -1124,7 +1124,10 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 
 	case VIDIOC_SUBDEV_G_ROUTING:
 	case VIDIOC_SUBDEV_S_ROUTING:
-		err = get_v4l2_subdev_routing(&karg.subdev_routing, up);
+		err = alloc_userspace(sizeof(struct v4l2_subdev_routing),
+				      0, &up_native);
+		if (!err)
+			err = get_v4l2_subdev_routing(up_native, up);
 		compatible_arg = 0;
 		break;
 
@@ -1257,7 +1260,7 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		break;
 	case VIDIOC_SUBDEV_G_ROUTING:
 	case VIDIOC_SUBDEV_S_ROUTING:
-		err = put_v4l2_subdev_routing(&karg.subdev_routing, up);
+		err = put_v4l2_subdev_routing(up_native, up);
 		break;
 	}
 	if (err)
-- 
2.16.1
