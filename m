Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:34690 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932687AbcIFKn7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Sep 2016 06:43:59 -0400
Received: from [10.47.79.81] (unknown [173.38.220.42])
        by tschai.lan (Postfix) with ESMTPSA id A8CDE18026A
        for <linux-media@vger.kernel.org>; Tue,  6 Sep 2016 12:43:54 +0200 (CEST)
To: linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.9] Make pxa_camera standalone
Message-ID: <f4398931-a891-3ba4-1572-8911f2a8a39a@xs4all.nl>
Date: Tue, 6 Sep 2016 12:43:53 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series removes the soc-camera dependency of pxa_camera.

Another step closer to being able to drop soc-camera as a framework.

Regards,

	Hans

The following changes since commit e62c30e76829d46bf11d170fd81b735f13a014ac:

   [media] smiapp: Remove set_xclk() callback from hwconfig (2016-09-05 
15:53:20 -0300)

are available in the git repository at:

   git://linuxtv.org/hverkuil/media_tree.git pxa

for you to fetch changes up to 3c8f129464dcd351a34e27daafc01e2baf259729:

   pxa_camera: allow building it if COMPILE_TEST is set (2016-09-06 
12:37:45 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
       pxa_camera: allow building it if COMPILE_TEST is set

Robert Jarzmik (14):
       media: mt9m111: make a standalone v4l2 subdevice
       media: mt9m111: use only the SRGB colorspace
       media: mt9m111: move mt9m111 out of soc_camera
       media: platform: pxa_camera: convert to vb2
       media: platform: pxa_camera: trivial move of functions
       media: platform: pxa_camera: introduce sensor_call
       media: platform: pxa_camera: make printk consistent
       media: platform: pxa_camera: add buffer sequencing
       media: platform: pxa_camera: remove set_selection
       media: platform: pxa_camera: make a standalone v4l2 device
       media: platform: pxa_camera: add debug register access
       media: platform: pxa_camera: change stop_streaming semantics
       media: platform: pxa_camera: move pxa_camera out of soc_camera
       media: platform: pxa_camera: fix style

  drivers/media/i2c/Kconfig                            |    7 +
  drivers/media/i2c/Makefile                           |    1 +
  drivers/media/i2c/{soc_camera => }/mt9m111.c         |   59 ++--
  drivers/media/i2c/soc_camera/Kconfig                 |    7 +-
  drivers/media/i2c/soc_camera/Makefile                |    1 -
  drivers/media/platform/Kconfig                       |    9 +
  drivers/media/platform/Makefile                      |    1 +
  drivers/media/platform/{soc_camera => }/pxa_camera.c | 1449 
++++++++++++++++++++++++++++++++++++++++++++++---------------------------------
  drivers/media/platform/soc_camera/Kconfig            |    8 -
  drivers/media/platform/soc_camera/Makefile           |    1 -
  include/linux/platform_data/media/camera-pxa.h       |    2 +
  11 files changed, 881 insertions(+), 664 deletions(-)
  rename drivers/media/i2c/{soc_camera => }/mt9m111.c (94%)
  rename drivers/media/platform/{soc_camera => }/pxa_camera.c (61%)
