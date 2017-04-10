Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:59708 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752144AbdDJL2e (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 07:28:34 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.12] ov2640: move out of soc-camera (rebased)
Message-ID: <4b1bc19c-de45-3e1c-3cad-2478ca4138da@xs4all.nl>
Date: Mon, 10 Apr 2017 13:28:29 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here is the remainder of my "atmel-isi/ov7670/ov2640: convert to standalone drivers"
pull request, rebased to the latest master. This should now merge fine.

Regards,

	Hans

The following changes since commit 0538bee6fdec9b79910c1c9835e79be75d0e1bdf:

  [media] MAINTAINERS: update atmel-isi.c path (2017-04-10 08:13:08 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git sama5d3

for you to fetch changes up to 9ef9f8fec3c8283f2186d4dd609e31914202809a:

  em28xx: drop last soc_camera link (2017-04-10 13:23:28 +0200)

----------------------------------------------------------------
Hans Verkuil (4):
      ov2640: convert from soc-camera to a standard subdev sensor driver.
      ov2640: use standard clk and enable it.
      ov2640: add MC support
      em28xx: drop last soc_camera link

 drivers/media/i2c/Kconfig                   |  11 +++++
 drivers/media/i2c/Makefile                  |   1 +
 drivers/media/i2c/{soc_camera => }/ov2640.c | 130 +++++++++++++++++++-------------------------------------
 drivers/media/i2c/soc_camera/Kconfig        |   6 ---
 drivers/media/i2c/soc_camera/Makefile       |   1 -
 drivers/media/usb/em28xx/em28xx-camera.c    |   9 ----
 6 files changed, 55 insertions(+), 103 deletions(-)
 rename drivers/media/i2c/{soc_camera => }/ov2640.c (93%)
