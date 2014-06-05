Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:20510 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaFEMzm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jun 2014 08:55:42 -0400
Date: Thu, 05 Jun 2014 09:55:35 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 3.16-rc1] updates and DT support for adv7604
Message-id: <20140605095535.7753cb6b.m.chehab@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media topic/adv76xx

For adv7604 driver updates, including DT support.

Thanks!
Mauro

The following changes since commit e5e749dfa8606343fd7956868038bdde2e656ec1:

  [media] adv7604: Add missing include to linux/types.h (2014-05-25 12:48:47 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media topic/adv76xx

for you to fetch changes up to 1b5ab8755ec7b6ac83bf8d09c9f908d94e36b9a4:

  [media] adv7604: Add LLC polarity configuration (2014-05-25 13:10:16 -0300)

----------------------------------------------------------------
Lars-Peter Clausen (3):
      [media] adv7604: Add support for asynchronous probing
      [media] adv7604: Don't put info string arrays on the stack
      [media] adv7604: Add adv7611 support

Laurent Pinchart (18):
      [media] adv7604: Add 16-bit read functions for CP and HDMI
      [media] adv7604: Cache register contents when reading multiple bits
      [media] adv7604: Remove subdev control handlers
      [media] adv7604: Add sink pads
      [media] adv7604: Make output format configurable through pad format operations
      [media] adv7604: Add pad-level DV timings support
      [media] adv7604: Remove deprecated video-level DV timings operations
      [media] v4l: subdev: Remove deprecated video-level DV timings operations
      [media] adv7604: Inline the to_sd function
      [media] adv7604: Store I2C addresses and clients in arrays
      [media] adv7604: Replace *_and_or() functions with *_clr_set()
      [media] adv7604: Sort headers alphabetically
      [media] adv7604: Support hot-plug detect control through a GPIO
      [media] adv7604: Specify the default input through platform data
      [media] adv7604: Add DT support
      [media] adv7604: Add endpoint properties to DT bindings
      [media] adv7604: Set HPD GPIO direction to output
      [media] adv7604: Add LLC polarity configuration

 .../devicetree/bindings/media/i2c/adv7604.txt      |   70 +
 drivers/media/i2c/adv7604.c                        | 1464 ++++++++++++++------
 include/media/adv7604.h                            |  122 +-
 include/media/v4l2-subdev.h                        |    4 -
 4 files changed, 1160 insertions(+), 500 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/adv7604.txt

