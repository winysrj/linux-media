Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:48043 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbcF2NU7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 09:20:59 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH 00/15] lirc_dev fixes and beautification
Date: Wed, 29 Jun 2016 22:20:29 +0900
Message-id: <1467206444-9935-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

because I wanted to add three ioctl commands in lirc, I ended up
with the patchset below.

This is a collection of fixes, added functionality, coding rework
and trivial coding style fixes.

The first patch is preparatory to the second, which allows the
user to create a lirc driver without receiver buffer, which is
obvious for transmitters. Besides, even though that buffer could
have been used also by transmitters, drivers might have the need
to handle it separately.

The rest of the patches is a series of coding style and code
rework, as I said, some of them are very trivial, but I sent them
anyway because I was on fire.

Patch 14 is a segfault fix, while the last patch adds the
possibility to send to ioctl the set frequency, get frequency and
set length command.

Thanks,
Andi

Andi Shyti (15):
  lirc_dev: place buffer allocation on separate function
  lirc_dev: allow bufferless driver registration
  lirc_dev: remove unnecessary debug prints
  lirc_dev: replace printk with pr_* or dev_*
  lirc_dev: simplify goto paths
  lirc_dev: do not use goto to create loops
  lirc_dev: simplify if statement in lirc_add_to_buf
  lirc_dev: remove double if ... else statement
  lirc_dev: merge three if statements in only one
  lirc_dev: remove CONFIG_COMPAT precompiler check
  lirc_dev: fix variable constant comparisons
  lirc_dev: fix error return value
  lirc_dev: extremely trivial comment style fix
  lirc_dev: fix potential segfault
  include: lirc: add set length and frequency ioctl options

 drivers/media/rc/lirc_dev.c | 297 +++++++++++++++++++++-----------------------
 include/media/lirc_dev.h    |  12 ++
 include/uapi/linux/lirc.h   |   4 +
 3 files changed, 156 insertions(+), 157 deletions(-)

-- 
2.8.1

