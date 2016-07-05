Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:39739 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754512AbcGELQ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Jul 2016 07:16:26 -0400
Received: from [64.103.36.133] (proxy-ams-1.cisco.com [64.103.36.133])
	by tschai.lan (Postfix) with ESMTPSA id DA1BD180C6D
	for <linux-media@vger.kernel.org>; Tue,  5 Jul 2016 13:16:20 +0200 (CEST)
To: linux-media <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8] Various dvb/rc fixes/improvements
Message-ID: <577B9704.9040300@xs4all.nl>
Date: Tue, 5 Jul 2016 13:16:20 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

As requested, I'm helping out with reducing the backlog.

This is the third version of this pull request. The only difference with the
older pull requests is that these two patches are dropped:

https://patchwork.linuxtv.org/patch/34338/
https://patchwork.linuxtv.org/patch/34339/

I think you should take a look at those.

Regards,

	Hans

The following changes since commit ab46f6d24bf57ddac0f5abe2f546a78af57b476c:

  [media] videodev2.h: Fix V4L2_PIX_FMT_YUV411P description (2016-06-28 11:54:52 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.8f

for you to fetch changes up to 32f2d0799571b9c2b9c07f9047111fd47329c911:

  media: rc: nuvoton: remove two unused elements in struct nvt_dev (2016-07-05 12:13:36 +0200)

----------------------------------------------------------------
Antti Palosaari (14):
      si2168: add support for newer firmwares
      si2168: do not allow driver unbind
      si2157: do not allow driver unbind
      m88ds3103: remove useless most significant bit clear
      m88ds3103: calculate DiSEqC message sending time
      m88ds3103: improve ts clock setting
      m88ds3103: use Hz instead of kHz on calculations
      m88ds3103: refactor firmware download
      af9033: move statistics to read_status()
      af9033: do not allow driver unbind
      it913x: do not allow driver unbind
      rtl2830: do not allow driver unbind
      rtl2830: move statistics to read_status()
      rtl2832: do not allow driver unbind

Heiner Kallweit (10):
      media: rc: nuvoton: fix rx fifo overrun handling
      media: rc: nuvoton: remove interrupt handling for wakeup
      media: rc: nuvoton: clean up initialization of wakeup registers
      media: rc: nuvoton: remove wake states
      media: rc: nuvoton: simplify a few functions
      media: rc: nuvoton: remove unneeded code in nvt_process_rx_ir_data
      media: rc: nuvoton: remove study states
      media: rc: nuvoton: simplify interrupt handling code
      media: rc: nuvoton: remove unneeded check in nvt_get_rx_ir_data
      media: rc: nuvoton: remove two unused elements in struct nvt_dev

 drivers/media/dvb-frontends/af9033.c         | 327 ++++++++++++++++++++++++++++++++++++++++++----------------------------------------------
 drivers/media/dvb-frontends/m88ds3103.c      | 144 ++++++++++++++++++---------------------
 drivers/media/dvb-frontends/m88ds3103_priv.h |   3 +-
 drivers/media/dvb-frontends/rtl2830.c        | 203 ++++++++++++++++++++++++-------------------------------
 drivers/media/dvb-frontends/rtl2830_priv.h   |   2 +-
 drivers/media/dvb-frontends/rtl2832.c        |   1 +
 drivers/media/dvb-frontends/si2168.c         | 127 ++++++++++++++++++++--------------
 drivers/media/dvb-frontends/si2168_priv.h    |   8 ++-
 drivers/media/rc/nuvoton-cir.c               | 137 ++++---------------------------------
 drivers/media/rc/nuvoton-cir.h               |  25 -------
 drivers/media/tuners/it913x.c                |   1 +
 drivers/media/tuners/si2157.c                |   3 +-
 12 files changed, 411 insertions(+), 570 deletions(-)
