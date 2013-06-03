Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4293 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab3FCIzR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 04:55:17 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166])
	(authenticated bits=0)
	by smtp-vbr4.xs4all.nl (8.13.8/8.13.8) with ESMTP id r538t5A4052179
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 3 Jun 2013 10:55:08 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 3E33235E004F
	for <linux-media@vger.kernel.org>; Mon,  3 Jun 2013 10:55:05 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.11] Updates for 3.11
Date: Mon, 3 Jun 2013 10:55:05 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201306031055.05081.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 7eac97d7e714429f7ef1ba5d35f94c07f4c34f8e:

  [media] media: pci: remove duplicate checks for EPERM (2013-05-27 09:34:56 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.11

for you to fetch changes up to 6ec4ad4a769a57931b9143ee294a2df2413bffad:

  radio-keene: add delay in order to settle hardware (2013-06-03 09:45:18 +0200)

----------------------------------------------------------------
Antti Palosaari (1):
      radio-keene: add delay in order to settle hardware

Hans Verkuil (6):
      mxl111sf: don't redefine pr_err/info/debug
      hdpvr: fix querystd 'unknown format' return.
      hdpvr: code cleanup
      hdpvr: improve error handling
      ml86v7667: fix the querystd implementation
      radio-keene: set initial frequency.

Vladimir Barinov (2):
      adv7180: add more subdev video ops
      ML86V7667: new video decoder driver

 drivers/media/i2c/Kconfig                     |    9 ++
 drivers/media/i2c/Makefile                    |    1 +
 drivers/media/i2c/adv7180.c                   |   46 ++++++++++
 drivers/media/i2c/ml86v7667.c                 |  431 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/radio/radio-keene.c             |    7 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c |    8 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c       |   90 ++++++++++----------
 drivers/media/usb/hdpvr/hdpvr-control.c       |   21 ++---
 drivers/media/usb/hdpvr/hdpvr-video.c         |   72 ++++++++--------
 drivers/media/usb/hdpvr/hdpvr.h               |    1 +
 10 files changed, 585 insertions(+), 101 deletions(-)
 create mode 100644 drivers/media/i2c/ml86v7667.c
