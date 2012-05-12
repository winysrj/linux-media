Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40506 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab2ELSJN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 May 2012 14:09:13 -0400
Received: by bkcji2 with SMTP id ji2so2938614bkc.19
        for <linux-media@vger.kernel.org>; Sat, 12 May 2012 11:09:12 -0700 (PDT)
From: Thomas Mair <thomas.mair86@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Thomas Mair <thomas.mair86@googlemail.com>
Subject: [PATCH 0/5] support rtl2832 demodulator
Date: Sat, 12 May 2012 20:08:24 +0200
Message-Id: <1336846109-30070-1-git-send-email-thomas.mair86@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series of patches contains the rtl2832 demodulator driver.
In order to work the fc0012 and fc0013 driver from Hans-Frieder Vogt
have to be applied first.
The current version includes all the comments on the previous patches.
I currently only own a Cinergy Terratec T Stick Black (rev 1) device,
that is why i could only test it with that device. Feel free to 
comment on the patch and report issues you are having with it.

Thanks again for all the comments, especially to Antti.

Regards
Thomas

Thomas Mair (5):
  rtl2832 ver 0.3: suport for RTL2832 demodulator revised version
  rtl28xxu: support for the rtl2832 demod driver
  rtl28xxu: renamed rtl2831_rd/rtl2831_wr to rtl28xx_rd/rtl28xx_wr
  rtl28xxu: support G-Tek Electronics Group Lifeview LV5TDLX DVB-T
  rtl28xxu: support Terratec Noxon DAB/DAB+ stick

 drivers/media/dvb/dvb-usb/Kconfig          |    3 +
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h    |    3 +
 drivers/media/dvb/dvb-usb/rtl28xxu.c       |  513 +++++++++++++--
 drivers/media/dvb/frontends/Kconfig        |    7 +
 drivers/media/dvb/frontends/Makefile       |    1 +
 drivers/media/dvb/frontends/rtl2832.c      | 1009 ++++++++++++++++++++++++++++
 drivers/media/dvb/frontends/rtl2832.h      |   81 +++
 drivers/media/dvb/frontends/rtl2832_priv.h |  260 +++++++
 8 files changed, 1829 insertions(+), 48 deletions(-)
 create mode 100644 drivers/media/dvb/frontends/rtl2832.c
 create mode 100644 drivers/media/dvb/frontends/rtl2832.h
 create mode 100644 drivers/media/dvb/frontends/rtl2832_priv.h

-- 
1.7.7.6

