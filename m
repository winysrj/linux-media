Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:36206 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752844AbcGDLzB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 07:55:01 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 29CA01800C2
	for <linux-media@vger.kernel.org>; Mon,  4 Jul 2016 13:54:56 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8] Various dvb/rc fixes/improvements
Message-ID: <118e026f-ebc0-a540-195c-44434f40ae46@xs4all.nl>
Date: Mon, 4 Jul 2016 13:54:56 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

As requested, I'm helping out with reducing the backlog.

Regards,

	Hans

The following changes since commit ab46f6d24bf57ddac0f5abe2f546a78af57b476c:

  [media] videodev2.h: Fix V4L2_PIX_FMT_YUV411P description (2016-06-28 11:54:52 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.8f

for you to fetch changes up to 920be8ec8843d42ef3181f9a9fb988c49481b165:

  media: rc: nuvoton: remove two unused elements in struct nvt_dev (2016-07-04 13:26:37 +0200)

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

Heiner Kallweit (12):
      media: rc: make fifo size for raw events configurable via rc_dev
      media: rc: nuvoton: decrease size of raw event fifo
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

 drivers/media/dvb-frontends/af9033.c         | 327 ++++++++++++++++++++++++++-----------------------------
 drivers/media/dvb-frontends/m88ds3103.c      | 144 +++++++++++-------------
 drivers/media/dvb-frontends/m88ds3103_priv.h |   3 +-
 drivers/media/dvb-frontends/rtl2830.c        | 203 +++++++++++++++-------------------
 drivers/media/dvb-frontends/rtl2830_priv.h   |   2 +-
 drivers/media/dvb-frontends/rtl2832.c        |   1 +
 drivers/media/dvb-frontends/si2168.c         | 127 ++++++++++++---------
 drivers/media/dvb-frontends/si2168_priv.h    |   8 +-
 drivers/media/rc/nuvoton-cir.c               | 138 +++--------------------
 drivers/media/rc/nuvoton-cir.h               |  25 -----
 drivers/media/rc/rc-core-priv.h              |   2 +-
 drivers/media/rc/rc-ir-raw.c                 |  14 ++-
 drivers/media/tuners/it913x.c                |   1 +
 drivers/media/tuners/si2157.c                |   3 +-
 include/media/rc-core.h                      |   2 +
 15 files changed, 427 insertions(+), 573 deletions(-)
