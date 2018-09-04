Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45216 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbeIDPzN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Sep 2018 11:55:13 -0400
Received: by mail-wr1-f66.google.com with SMTP id 20-v6so3534395wrb.12
        for <linux-media@vger.kernel.org>; Tue, 04 Sep 2018 04:30:29 -0700 (PDT)
From: Javier Martinez Canillas <javierm@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Tian Shu Qiu <tian.shu.qiu@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jian Xu Zheng <jian.xu.zheng@intel.com>,
        Yong Zhi <yong.zhi@intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Bingbu Cao <bingbu.cao@intel.com>, linux-media@vger.kernel.org
Subject: [PATCH 0/2] media: intel-ipu3: allow the media graph to be used even if a subdev fails
Date: Tue,  4 Sep 2018 13:30:16 +0200
Message-Id: <20180904113018.14428-1-javierm@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This series allows the ipu3-cio2 driver to properly expose a subset of the
media graph even if some drivers for the pending subdevices fail to probe.

Currently the driver exposes a non-functional graph since the pad links are
created and the subdev dev nodes are registered in the v4l2 async .complete
callback. Instead, these operations should be done in the .bound callback.

Patch #1 just adds a v4l2_device_register_subdev_node() function to allow
registering a single device node for a subdev of a v4l2 device.

Patch #2 moves the logic of the ipu3-cio2 .complete callback to the .bound
callback. The .complete callback is just removed since is empy after that.

Best regards,
Javier


Javier Martinez Canillas (2):
  [media] v4l: allow to register dev nodes for individual v4l2 subdevs
  media: intel-ipu3: create pad links and register subdev nodes at bound
    time

 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 66 ++++++-----------
 drivers/media/v4l2-core/v4l2-device.c    | 90 ++++++++++++++----------
 include/media/v4l2-device.h              | 10 +++
 3 files changed, 85 insertions(+), 81 deletions(-)

-- 
2.17.1
