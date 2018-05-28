Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:48089 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940289AbeE1QhZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 12:37:25 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        sakari.ailus@iki.fi, mchehab@kernel.org,
        ysato@users.sourceforge.jp, dalias@libc.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] Remove sh_mobile_ceu_camera from arch/sh
Date: Mon, 28 May 2018 18:37:06 +0200
Message-Id: <1527525431-22852-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
    this series removes dependencies on the soc_camera based
sh_mobile_ceu_camera driver from 3 board files in arch/sh and from one
sensor driver used by one of those boards.

Hans, this means there are no more user of the soc_camera framework that I know
of in Linux, and I guess we can now plan of to remove that framework.

A note on the sensor driver: I haven't been able to find any documentation
for the SHARP RJ54N1CB0C sensor and so I inferred as much as possible from the
existing code. It seems to me that the sensor needs to power-up/enable gpios
(both active high) and I have registered them from the kfr2r09 board file,
assuming this was not a platform-specific design, but something the sensor
requires. As per the previous drivers ported away from soc_camera, I'm in
favour of moving them to staging if they do not match the quality expected
from a modern V4L2 sensor driver. Ie. framerate control is missing, and I
know this has been a blocker for other drivers in the past.

What I've done to three board files closely resembles what I done already for
Migo-R and Ecovec, and it listed in the single commit messages.

The only tough one is probably ap325rxa, which had an additional sensor
registered but controlled from i2c transaction of magic blobs from the board
file. I dare to remove that sensor registration completely as it seems to me
there is no diver for that at all in mainline.

Last, this patch is based on the media tree master branch, with Akinobu Mita's
patches on ov772x driver on top, which I strangely see only partially applied
to the media master tree [1]

Hans, as this is mostly media-related work, but mostly on SH architecture, I
would like to ask if these should go through you or SH tree.

All of that has only been compile tested. It's pretty hard to find this
platforms around and testing would be awesome if somebody happens to have
one of these.

Thanks
   j

[1] https://patchwork.linuxtv.org/patch/49318/
    https://patchwork.linuxtv.org/patch/49317/
    https://patchwork.linuxtv.org/patch/49312/

Jacopo Mondi (5):
  media: i2c: Copy rj54n1cb0c soc_camera sensor driver
  media: i2c: rj54n1: Remove soc_camera dependencies
  arch: sh: kfr2r09: Use new renesas-ceu camera driver
  arch: sh: ms7724se: Use new renesas-ceu camera driver
  arch: sh: ap325rxa: Use new renesas-ceu camera driver

 arch/sh/boards/mach-ap325rxa/setup.c   |  282 ++-----
 arch/sh/boards/mach-kfr2r09/setup.c    |  216 +++--
 arch/sh/boards/mach-se/7724/setup.c    |  120 ++-
 arch/sh/kernel/cpu/sh4a/clock-sh7723.c |    2 +-
 drivers/media/i2c/Kconfig              |   11 +
 drivers/media/i2c/Makefile             |    1 +
 drivers/media/i2c/rj54n1cb0c.c         | 1437 ++++++++++++++++++++++++++++++++
 7 files changed, 1710 insertions(+), 359 deletions(-)
 create mode 100644 drivers/media/i2c/rj54n1cb0c.c

--
2.7.4
