Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:35311 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab3BFLMK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 06:12:10 -0500
Received: from cobaltpc1.localnet (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-1.cisco.com (8.14.5/8.14.5) with ESMTP id r16BC8Gx006628
	for <linux-media@vger.kernel.org>; Wed, 6 Feb 2013 11:12:08 GMT
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.9] Move cx2341x, btcx-risc and tveeprom to common
Date: Wed, 6 Feb 2013 12:11:20 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201302061211.20635.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

As discussed earlier, this pull requests moves cx2341x, btcx-risc and
tveeprom to media/common.

The cx2341x and btcx-risc modules should definitely be moved there as they
have absolutely nothing to do with i2c, but I leave the decision whether
tveeprom should be moved or not up to you.

Most drivers use the i2c part of tveeprom as well, and those that do not still
use i2c to get hold of the eeprom data. So there is a strong relationship with
i2c regardless.

IMHO the i2c directory is slightly more appropriate for tveeprom than the
common directory.

Regards,

	Hans

The following changes since commit f85ed0ceeba78b6b15a857ce48888fdb52de28d0:

  Revert "[media] drivers/media/usb/dvb-usb/dib0700_core.c: fix left shift" (2013-02-06 08:31:55 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git common

for you to fetch changes up to 8d6e9928d56ae92fe8118a2c6aef7b219c3b1399:

  tveeprom: move from media/i2c to media/common (2013-02-06 12:03:41 +0100)

----------------------------------------------------------------
Hans Verkuil (3):
      cx2341x: move from media/i2c to media/common
      btcx-risc: move from media/i2c to media/common
      tveeprom: move from media/i2c to media/common

 drivers/media/common/Kconfig              |   11 +++++++++++
 drivers/media/common/Makefile             |    3 +++
 drivers/media/{i2c => common}/btcx-risc.c |    0
 drivers/media/{i2c => common}/btcx-risc.h |    0
 drivers/media/{i2c => common}/cx2341x.c   |    0
 drivers/media/{i2c => common}/tveeprom.c  |    0
 drivers/media/i2c/Kconfig                 |   26 --------------------------
 drivers/media/i2c/Makefile                |    3 ---
 drivers/media/pci/bt8xx/Makefile          |    1 +
 drivers/media/pci/cx23885/Makefile        |    1 +
 drivers/media/pci/cx25821/Makefile        |    1 +
 drivers/media/pci/cx88/Makefile           |    1 +
 12 files changed, 18 insertions(+), 29 deletions(-)
 rename drivers/media/{i2c => common}/btcx-risc.c (100%)
 rename drivers/media/{i2c => common}/btcx-risc.h (100%)
 rename drivers/media/{i2c => common}/cx2341x.c (100%)
 rename drivers/media/{i2c => common}/tveeprom.c (100%)
