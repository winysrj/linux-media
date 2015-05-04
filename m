Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:40532 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752296AbbEDK0H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 May 2015 06:26:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de
Subject: [PATCHv2 0/8] soc-camera sensor improvements
Date: Mon,  4 May 2015 12:25:47 +0200
Message-Id: <1430735155-24110-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

As per Guennadi's suggestions, improve the code of various soc-camera sensor
drivers to avoid duplicating code.

Changes since v1:

- Remove unnecessary change in imx074 and ov5642
- Dropped patch 9. It was not needed after all.

Regards,

	Hans

Hans Verkuil (8):
  imx074: don't call imx074_find_datafmt() twice
  mt9m001: avoid calling mt9m001_find_datafmt() twice
  mt9v022: avoid calling mt9v022_find_datafmt() twice
  ov2640: avoid calling ov2640_select_win() twice
  ov5642: avoid calling ov5642_find_datafmt() twice
  ov772x: avoid calling ov772x_select_params() twice
  ov9640: avoid calling ov9640_res_roundup() twice
  ov9740: avoid calling ov9740_res_roundup() twice

 drivers/media/i2c/soc_camera/imx074.c  |  2 +-
 drivers/media/i2c/soc_camera/mt9m001.c |  8 +++----
 drivers/media/i2c/soc_camera/mt9v022.c |  8 +++----
 drivers/media/i2c/soc_camera/ov2640.c  | 21 +++++++++--------
 drivers/media/i2c/soc_camera/ov5642.c  |  2 +-
 drivers/media/i2c/soc_camera/ov772x.c  | 41 +++++++++++-----------------------
 drivers/media/i2c/soc_camera/ov9640.c  | 24 +++-----------------
 drivers/media/i2c/soc_camera/ov9740.c  | 18 +--------------
 8 files changed, 37 insertions(+), 87 deletions(-)

-- 
2.1.4

