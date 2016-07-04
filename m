Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:35271 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752357AbcGDWYB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 18:24:01 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 729701800C2
	for <linux-media@vger.kernel.org>; Tue,  5 Jul 2016 00:23:56 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8] Various dvb/rc fixes/improvements
Message-ID: <7362a960-d088-472d-d402-584a5ac69273@xs4all.nl>
Date: Tue, 5 Jul 2016 00:23:56 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

As requested, I'm helping out with reducing the backlog.

This is the second pull request. The only difference with the superseded
first pull request is that I've dropped this patch
https://patchwork.linuxtv.org/patch/34339/ since there are some
concerns about it.

Regards,

	Hans

The following changes since commit ab46f6d24bf57ddac0f5abe2f546a78af57b476c:

  [media] videodev2.h: Fix V4L2_PIX_FMT_YUV411P description (2016-06-28 11:54:52 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.8f

for you to fetch changes up to c6fc73424f80c53cd31b1604833f5fe0f76f9f5d:

  media: rc: nuvoton: remove two unused elements in struct nvt_dev (2016-07-05 00:19:45 +0200)

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

Heiner Kallweit (11):
      media: rc: make fifo size for raw events configurable via rc_dev
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
 drivers/media/rc/nuvoton-cir.c               | 137 +++--------------------
 drivers/media/rc/nuvoton-cir.h               |  25 -----
 drivers/media/rc/rc-core-priv.h              |   2 +-
 drivers/media/rc/rc-ir-raw.c                 |  14 ++-
 drivers/media/tuners/it913x.c                |   1 +
 drivers/media/tuners/si2157.c                |   3 +-
 include/media/rc-core.h                      |   2 +
 15 files changed, 426 insertions(+), 573 deletions(-)
