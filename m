Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:57259 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753952AbdDLLT0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 07:19:26 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Todor Tomov <todor.tomov@linaro.org>,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.12] New ov5645 and ov5647 drivers
Message-ID: <47e51deb-b3e0-9137-2c64-4fdee5645792@xs4all.nl>
Date: Wed, 12 Apr 2017 13:19:19 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the ov5645 and ov5647 drivers.

This supersedes an earlier ov5645-only pull request. Having separate pull requests
for these drivers would create a Kconfig conflict, so I've combined them in one
pull request.

Regards,

	Hans

The following changes since commit 4aed35ca73f6d9cfd5f7089ba5d04f5fb8623080:

  [media] v4l2-tpg: don't clamp XV601/709 to lim range (2017-04-10 14:58:06 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git ov5645

for you to fetch changes up to c95be7ca24262d62107b645f08653168afe9c3c3:

  media: i2c: Add support for OV5647 sensor. (2017-04-12 13:16:05 +0200)

----------------------------------------------------------------
Ramiro Oliveira (2):
      Documentation: DT: Add OV5647 bindings
      media: i2c: Add support for OV5647 sensor.

Todor Tomov (2):
      media: i2c/ov5645: add the device tree binding document
      media: Add a driver for the ov5645 camera sensor.

 Documentation/devicetree/bindings/media/i2c/ov5645.txt |   54 ++
 Documentation/devicetree/bindings/media/i2c/ov5647.txt |   35 ++
 MAINTAINERS                                            |    7 +
 drivers/media/i2c/Kconfig                              |   23 +
 drivers/media/i2c/Makefile                             |    2 +
 drivers/media/i2c/ov5645.c                             | 1345 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/i2c/ov5647.c                             |  634 +++++++++++++++++++++
 7 files changed, 2100 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5645.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5647.txt
 create mode 100644 drivers/media/i2c/ov5645.c
 create mode 100644 drivers/media/i2c/ov5647.c
