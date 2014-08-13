Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:60791 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbaHMPP3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Aug 2014 11:15:29 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NA9000M63PSDR00@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 13 Aug 2014 11:15:28 -0400 (EDT)
Date: Wed, 13 Aug 2014 12:15:23 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Linux Firmware Mailing List <linux-firmware@kernel.org>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Firmware files for 3 media device drivers
Message-id: <20140813121523.507a4150.m.chehab@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Please pull from:
  ssh://linuxtv.org/git/mchehab/linux-firmware.git master

It has firmware files for media devices based on xc4000, xc5000c and as102.

Thanks!
Mauro

-

The following changes since commit 83b97f580e002ae94f060c5bd5a536b275e81afb:

  Move metadata for intel/fw_sst_0f28.bin-48kHz_i2s_master into WHENCE (2014-08-09 22:05:03 +0100)

are available in the git repository at:

  ssh://linuxtv.org/git/mchehab/linux-firmware.git master

for you to fetch changes up to 330e6abed89f16ab6fdca9dcfbc16105745a13fd:

  xc4000: add firmware for Xceive xc4000 tuner driver (2014-08-13 12:04:15 -0300)

----------------------------------------------------------------
Mauro Carvalho Chehab (3):
      as102: add firmware for Abilis Systems Single DVB-T Receiver
      xc5000: Add firmware for xc5000c variant
      xc4000: add firmware for Xceive xc4000 tuner driver

 LICENCE.Abilis             |   22 +++
 LICENCE.xc4000             |   23 +++
 LICENCE.xc5000c            |   23 +++
 WHENCE                     |   20 ++-
 as102_data1_st.hex         | 1259 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 as102_data2_st.hex         | 1087 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 dvb-fe-xc4000-1.4.1.fw     |  Bin 0 -> 18643 bytes
 dvb-fe-xc5000c-4.1.30.7.fw |  Bin 0 -> 16497 bytes
 8 files changed, 2433 insertions(+), 1 deletion(-)
 create mode 100644 LICENCE.Abilis
 create mode 100644 LICENCE.xc4000
 create mode 100644 LICENCE.xc5000c
 create mode 100644 as102_data1_st.hex
 create mode 100644 as102_data2_st.hex
 create mode 100644 dvb-fe-xc4000-1.4.1.fw
 create mode 100644 dvb-fe-xc5000c-4.1.30.7.fw
