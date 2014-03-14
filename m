Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42950 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919AbaCNAQf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 20:16:35 -0400
Received: from dyn3-82-128-190-236.psoas.suomi.net ([82.128.190.236] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1WOFne-0004LT-Cz
	for linux-media@vger.kernel.org; Fri, 14 Mar 2014 02:16:34 +0200
Message-ID: <53224A61.4070602@iki.fi>
Date: Fri, 14 Mar 2014 02:16:33 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] rtl2832_sdr driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 8ea5488a919bbd49941584f773fd66623192ffc0:

   [media] media: rc-core: use %s in rc_map_get() module load 
(2014-03-13 11:32:28 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git sdr_review_v6

for you to fetch changes up to 7927aad8e3513610973d25b1205bb6efa3b207f0:

   MAINTAINERS: add rtl2832_sdr driver (2014-03-14 02:07:56 +0200)

----------------------------------------------------------------
Antti Palosaari (16):
       e4000: convert DVB tuner to I2C driver model
       e4000: implement controls via v4l2 control framework
       e4000: fix PLL calc to allow higher frequencies
       e4000: implement PLL lock v4l control
       rtl2832_sdr: Realtek RTL2832 SDR driver module
       rtl2832_sdr: expose e4000 controls to user
       rtl28xxu: constify demod config structs
       rtl28xxu: attach SDR extension module
       rtl28xxu: fix switch-case style issue
       rtl28xxu: use muxed RTL2832 I2C adapters for E4000 and RTL2832_SDR
       rtl28xxu: depends on I2C_MUX
       e4000: get rid of DVB i2c_gate_ctrl()
       e4000: convert to Regmap API
       e4000: rename some variables
       rtl2832_sdr: clamp bandwidth to nearest legal value in automode
       MAINTAINERS: add rtl2832_sdr driver

Hans Verkuil (1):
       rtl2832_sdr: fixing v4l2-compliance issues

  MAINTAINERS                                      |   10 +
  drivers/media/tuners/Kconfig                     |    3 +-
  drivers/media/tuners/e4000.c                     |  600 
+++++++++++++++++++++++++++++++--------------------
  drivers/media/tuners/e4000.h                     |   21 +-
  drivers/media/tuners/e4000_priv.h                |   88 +++++++-
  drivers/media/usb/dvb-usb-v2/Kconfig             |    2 +-
  drivers/media/usb/dvb-usb-v2/Makefile            |    1 +
  drivers/media/usb/dvb-usb-v2/rtl28xxu.c          |  105 +++++++--
  drivers/media/usb/dvb-usb-v2/rtl28xxu.h          |    2 +
  drivers/staging/media/Kconfig                    |    2 +
  drivers/staging/media/Makefile                   |    2 +
  drivers/staging/media/rtl2832u_sdr/Kconfig       |    7 +
  drivers/staging/media/rtl2832u_sdr/Makefile      |    6 +
  drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 1495 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h |   54 +++++
  15 files changed, 2125 insertions(+), 273 deletions(-)
  create mode 100644 drivers/staging/media/rtl2832u_sdr/Kconfig
  create mode 100644 drivers/staging/media/rtl2832u_sdr/Makefile
  create mode 100644 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
  create mode 100644 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h

-- 
http://palosaari.fi/
