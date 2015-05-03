Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:47334 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751255AbbECJys (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 May 2015 05:54:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de
Subject: [PATCH 0/9] soc-camera sensor improvements
Date: Sun,  3 May 2015 11:54:27 +0200
Message-Id: <1430646876-19594-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

As per Guennadi's suggestions, improve the code of various soc-camera sensor
drivers to avoid duplicating code.

Note that the mt9t112 issue is something I discovered and that has been there
from before my recent patches that removed the old video ops.

Also note that that is the only driver that Guennadi commented upon ("Now
mt9t112_frame_check() will be called twice in the .s_mbus_fmt() case.") that
I did not change: this driver is more complex than the others and I did not
see an easy way of changing this.

I might tackle that one later as I actually have hardware with this sensor.

Regards,

	Hans

Hans Verkuil (9):
  imx074: don't call imx074_find_datafmt() twice
  mt9m001: avoid calling mt9m001_find_datafmt() twice
  mt9v022: avoid calling mt9v022_find_datafmt() twice
  ov2640: avoid calling ov2640_select_win() twice
  ov5642: avoid calling ov5642_find_datafmt() twice
  ov772x: avoid calling ov772x_select_params() twice
  ov9640: avoid calling ov9640_res_roundup() twice
  ov9740: avoid calling ov9740_res_roundup() twice
  mt9t112: initialize left and top

 drivers/media/i2c/soc_camera/imx074.c  |  7 +++---
 drivers/media/i2c/soc_camera/mt9m001.c |  8 +++----
 drivers/media/i2c/soc_camera/mt9t112.c |  3 ++-
 drivers/media/i2c/soc_camera/mt9v022.c |  8 +++----
 drivers/media/i2c/soc_camera/ov2640.c  | 21 +++++++++--------
 drivers/media/i2c/soc_camera/ov5642.c  |  7 +++---
 drivers/media/i2c/soc_camera/ov772x.c  | 41 +++++++++++-----------------------
 drivers/media/i2c/soc_camera/ov9640.c  | 24 +++-----------------
 drivers/media/i2c/soc_camera/ov9740.c  | 18 +--------------
 9 files changed, 45 insertions(+), 92 deletions(-)

-- 
2.1.4

