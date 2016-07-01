Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:32943 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbcGAIE1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2016 04:04:27 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Joe Perches <joe@perches.com>, Sean Young <sean@mess.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH v2 00/15] lirc_dev fixes and beautification
Date: Fri, 01 Jul 2016 17:01:23 +0900
Message-id: <1467360098-12539-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

After applying Joe's suggestion, the next patches had some
conflicts, therefore I have to send all the 15 patches again.

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

Changelog: V1->V2

 - As Joe recommended, in patch 4 I added the pr_fmt definition
   and removed all the hardcoded prefixes from the pr_*
   functions.

 - In Patch 15, after Sean's review, I removed the definitions of
   the GET/SET_FREQUENCY, I will use GET/SET_SEND_CARRIER
   instead, even though I find the name a bit confusing.

 - In patch 6 I did a better refactoring

Thanks,
Andi

Andi Shyti (15):
  [media] lirc_dev: place buffer allocation on separate function
  [media] lirc_dev: allow bufferless driver registration
  [media] lirc_dev: remove unnecessary debug prints
  [media] lirc_dev: replace printk with pr_* or dev_*
  [media] lirc_dev: simplify goto paths
  [media] lirc_dev: do not use goto to create loops
  [media] lirc_dev: simplify if statement in lirc_add_to_buf
  [media] lirc_dev: remove double if ... else statement
  [media] lirc_dev: merge three if statements in only one
  [media] lirc_dev: remove CONFIG_COMPAT precompiler check
  [media] lirc_dev: fix variable constant comparisons
  [media] lirc_dev: fix error return value
  [media] lirc_dev: extremely trivial comment style fix
  [media] lirc_dev: fix potential segfault
  [media] include: lirc: add LIRC_GET_LENGTH command

 drivers/media/rc/lirc_dev.c | 301 +++++++++++++++++++++-----------------------
 include/media/lirc_dev.h    |  12 ++
 include/uapi/linux/lirc.h   |   1 +
 3 files changed, 155 insertions(+), 159 deletions(-)

-- 
2.8.1

