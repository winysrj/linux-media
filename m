Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:53241 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751527AbdDKNxt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Apr 2017 09:53:49 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Todor Tomov <todor.tomov@linaro.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.12] New ov5645 driver
Message-ID: <92e3ac6d-d937-4d09-cedd-05bd5cbc2cea@xs4all.nl>
Date: Tue, 11 Apr 2017 15:53:44 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 4aed35ca73f6d9cfd5f7089ba5d04f5fb8623080:

  [media] v4l2-tpg: don't clamp XV601/709 to lim range (2017-04-10 14:58:06 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git ov5645

for you to fetch changes up to 7dbf0345e6d4ca1ba7af572e6d6722bac3f22db2:

  media: Add a driver for the ov5645 camera sensor. (2017-04-11 15:19:07 +0200)

----------------------------------------------------------------
Todor Tomov (2):
      media: i2c/ov5645: add the device tree binding document
      media: Add a driver for the ov5645 camera sensor.

 Documentation/devicetree/bindings/media/i2c/ov5645.txt |   54 ++++
 drivers/media/i2c/Kconfig                              |   12 +
 drivers/media/i2c/Makefile                             |    1 +
 drivers/media/i2c/ov5645.c                             | 1345 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 1412 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5645.txt
 create mode 100644 drivers/media/i2c/ov5645.c
