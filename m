Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:52796 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751040AbdJLQVb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Oct 2017 12:21:31 -0400
Received: by mail-pf0-f176.google.com with SMTP id e64so5537978pfk.9
        for <linux-media@vger.kernel.org>; Thu, 12 Oct 2017 09:21:30 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 0/4] media: ov7670: add media controller support
Date: Fri, 13 Oct 2017 01:21:13 +0900
Message-Id: <1507825277-18364-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series adds media controller support and other related changes to the
OV7670 which is cheap and highly available CMOS image sensor for hobbyists.

This enables to control a video pipeline system with the OV7670.  I've
tested this with the xilinx video IP pipeline.

Akinobu Mita (4):
  media: ov7670: create subdevice device node
  media: ov7670: use v4l2_async_unregister_subdev()
  media: ov7670: add media controller support
  media: ov7670: add get_fmt() pad ops callback

 drivers/media/i2c/ov7670.c | 55 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
-- 
2.7.4
