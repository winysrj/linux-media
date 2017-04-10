Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:48924 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752587AbdDJSJL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 14:09:11 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.12] ov2640 & soc_camera sensor cleanups
Message-ID: <7bafbaa8-120c-76db-7a78-14eae38d0baa@xs4all.nl>
Date: Mon, 10 Apr 2017 20:09:06 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These are old patches (2015!) that have been lying around in my todo list
ever since. Since I plan to work a bit on soc-camera sensors (at least
those that I have) and since ov2640 was just moved out of soc-camera, it is
time I kick these out.

Regards,

	Hans

The following changes since commit a9b99bbedae6f861de3be635bdc9382e1e29a4f9:

  [media] em28xx: drop last soc_camera link (2017-04-10 14:28:39 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.12g

for you to fetch changes up to 738777dd732e97ac664fe5152660d6e9ce6c033c:

  ov2640: avoid calling ov2640_select_win() twice (2017-04-10 20:02:17 +0200)

----------------------------------------------------------------
Hans Verkuil (8):
      imx074: avoid calling imx074_find_datafmt() twice
      mt9m001: avoid calling mt9m001_find_datafmt() twice
      mt9v022: avoid calling mt9v022_find_datafmt() twice
      ov5642: avoid calling ov5642_find_datafmt() twice
      ov772x: avoid calling ov772x_select_params() twice
      ov9640: avoid calling ov9640_res_roundup() twice
      ov9740: avoid calling ov9740_res_roundup() twice
      ov2640: avoid calling ov2640_select_win() twice

 drivers/media/i2c/ov2640.c             | 18 +++++++-----------
 drivers/media/i2c/soc_camera/imx074.c  |  2 +-
 drivers/media/i2c/soc_camera/mt9m001.c |  8 ++++----
 drivers/media/i2c/soc_camera/mt9v022.c |  8 ++++----
 drivers/media/i2c/soc_camera/ov5642.c  |  2 +-
 drivers/media/i2c/soc_camera/ov772x.c  | 41 +++++++++++++----------------------------
 drivers/media/i2c/soc_camera/ov9640.c  | 24 +++---------------------
 drivers/media/i2c/soc_camera/ov9740.c  | 18 +-----------------
 8 files changed, 34 insertions(+), 87 deletions(-)
