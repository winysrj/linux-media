Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:55244 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbcGFJnz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 05:43:55 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Joe Perches <joe@perches.com>, Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH v3 00/15] lirc_dev fixes and beautification
Date: Wed, 06 Jul 2016 18:01:12 +0900
Message-id: <1467795687-10737-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This is a collection of fixes, added functionality, coding rework
and trivial coding style fixes.

The first patch is preparatory to the second, which allows the
user to create a lirc driver without receiver buffer, which is
obvious for transmitters.

The rest of the patches is a series of coding style and code
rework, as I said, some of them are very trivial, but I sent them
anyway because I was on fire.

Patch 14 is a segfault fix, while the last patch adds the
possibility to send to ioctl the set frequency, get frequency and
set length command.

Changelog:

V1 -> V2
 - patch 4: added the pr_fmt definition and removed all the
   hardcoded prefixes from the pr_* functions (from Joe Perches).

 - patch 15: removed the definitions of the GET/SET_FREQUENCY, I
   will use GET/SET_SEND_CARRIER instead, even though I find the
   name a bit confusing (from Sean Young).

 - In patch 6 I did a better refactoring

V2 -> V3
 - patch 2: do not create a specific function for bufferless
   allocation, but check whether the device is a transmitter, in
   that case do not allocate any buffer (from Sean Young).

 - patch 10: remove completely compat ioctl (from Hans Verkuil).

 - patch 12: ioctl fails and returns -ENOTTY instead of -EPERM
   (from Hans Verkuil).

 - patch 15: removed the original patch which adds the
   LIRC_GET_LENTGH command to the ioctl (from Sean Young).

 - patch 15: new patch which uses LIRC_CAN_REC() define to check
   if the device is a receiver.

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
  [media] lirc_dev: remove compat_ioctl assignment
  [media] lirc_dev: fix variable constant comparisons
  [media] lirc_dev: fix error return value
  [media] lirc_dev: extremely trivial comment style fix
  [media] lirc_dev: fix potential segfault
  [media] lirc_dev: use LIRC_CAN_REC() define to check if the device can
    receive

 drivers/media/rc/lirc_dev.c | 302 ++++++++++++++++++++------------------------
 1 file changed, 140 insertions(+), 162 deletions(-)

-- 
2.8.1

