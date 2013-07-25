Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:50437 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656Ab3GYNHn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 09:07:43 -0400
Received: from cobaltpc1.localnet (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id r6PD7ePu022253
	for <linux-media@vger.kernel.org>; Thu, 25 Jul 2013 13:07:40 GMT
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.11] Various fixes for 3.11
Date: Thu, 25 Jul 2013 15:07:37 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201307251507.37949.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here is a list of fixes for 3.11.

Regards,

	Hans

The following changes since commit c859e6ef33ac0c9a5e9e934fe11a2232752b4e96:

  [media] dib0700: add support for PCTV 2002e & PCTV 2002e SE (2013-07-22 07:48:11 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.11

for you to fetch changes up to 9f750988a3a4e43b0262f792dc72fecd969dfeba:

  hdpvr: fix iteration over uninitialized lists in hdpvr_probe() (2013-07-25 14:42:45 +0200)

----------------------------------------------------------------
Alexey Khoroshilov (1):
      hdpvr: fix iteration over uninitialized lists in hdpvr_probe()

Andrzej Hajda (2):
      DocBook: upgrade media_api DocBook version to 4.2
      v4l2: added missing mutex.h include to v4l2-ctrls.h

Hans Verkuil (2):
      ml86v7667: fix compile warning: 'ret' set but not used
      usbtv: fix dependency

Lubomir Rintel (2):
      usbtv: Fix deinterlacing
      usbtv: Throw corrupted frames away

 Documentation/DocBook/media_api.tmpl |  4 ++--
 drivers/media/i2c/ml86v7667.c        |  4 ++--
 drivers/media/usb/hdpvr/hdpvr-core.c | 11 ++++++-----
 drivers/media/usb/usbtv/Kconfig      |  2 +-
 drivers/media/usb/usbtv/usbtv.c      | 51 ++++++++++++++++++++++++++++++++++++++-------------
 include/media/v4l2-ctrls.h           |  1 +
 6 files changed, 50 insertions(+), 23 deletions(-)
