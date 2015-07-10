Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61452 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbbGJGTx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2015 02:19:53 -0400
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] Drop owner assignment from i2c_driver (and platform left-overs)
Date: Fri, 10 Jul 2015 15:19:41 +0900
Message-id: <1436509188-23320-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,


The i2c drivers also do not have to set 'owner' field because
i2c_register_driver() will do it instead.

'owner' is removed from i2c drivers, which I was able to compile
with allyesconfig (arm, arm64, i386, x86_64, ppc64).
Only compile-tested.

The coccinelle script which generated the patch was sent here:
http://www.spinics.net/lists/kernel/msg2029903.html


Best regards,
Krzysztof

Krzysztof Kozlowski (7):
  [media] dvb-frontends: Drop owner assignment from i2c_driver
  [media] dvb-frontends: Drop owner assignment from platform_driver
  [media] i2c: Drop owner assignment from i2c_driver
  [media] platform: Drop owner assignment from i2c_driver
  [media] radio: Drop owner assignment from i2c_driver
  [media] tuners: Drop owner assignment from i2c_driver
  [media] Drop owner assignment from i2c_driver

 drivers/media/dvb-frontends/a8293.c          | 1 -
 drivers/media/dvb-frontends/af9033.c         | 1 -
 drivers/media/dvb-frontends/au8522_decoder.c | 1 -
 drivers/media/dvb-frontends/m88ds3103.c      | 1 -
 drivers/media/dvb-frontends/rtl2830.c        | 1 -
 drivers/media/dvb-frontends/rtl2832.c        | 1 -
 drivers/media/dvb-frontends/rtl2832_sdr.c    | 1 -
 drivers/media/dvb-frontends/si2168.c         | 1 -
 drivers/media/dvb-frontends/sp2.c            | 1 -
 drivers/media/dvb-frontends/tda10071.c       | 1 -
 drivers/media/dvb-frontends/ts2020.c         | 1 -
 drivers/media/i2c/adv7170.c                  | 1 -
 drivers/media/i2c/adv7175.c                  | 1 -
 drivers/media/i2c/adv7180.c                  | 1 -
 drivers/media/i2c/adv7343.c                  | 1 -
 drivers/media/i2c/adv7511.c                  | 1 -
 drivers/media/i2c/adv7604.c                  | 1 -
 drivers/media/i2c/adv7842.c                  | 1 -
 drivers/media/i2c/bt819.c                    | 1 -
 drivers/media/i2c/bt856.c                    | 1 -
 drivers/media/i2c/bt866.c                    | 1 -
 drivers/media/i2c/cs5345.c                   | 1 -
 drivers/media/i2c/cs53l32a.c                 | 1 -
 drivers/media/i2c/cx25840/cx25840-core.c     | 1 -
 drivers/media/i2c/ks0127.c                   | 1 -
 drivers/media/i2c/m52790.c                   | 1 -
 drivers/media/i2c/msp3400-driver.c           | 1 -
 drivers/media/i2c/mt9v011.c                  | 1 -
 drivers/media/i2c/ov7640.c                   | 1 -
 drivers/media/i2c/ov7670.c                   | 1 -
 drivers/media/i2c/saa6588.c                  | 1 -
 drivers/media/i2c/saa6752hs.c                | 1 -
 drivers/media/i2c/saa7110.c                  | 1 -
 drivers/media/i2c/saa7115.c                  | 1 -
 drivers/media/i2c/saa7127.c                  | 1 -
 drivers/media/i2c/saa717x.c                  | 1 -
 drivers/media/i2c/saa7185.c                  | 1 -
 drivers/media/i2c/sony-btf-mpx.c             | 1 -
 drivers/media/i2c/tda7432.c                  | 1 -
 drivers/media/i2c/tda9840.c                  | 1 -
 drivers/media/i2c/tea6415c.c                 | 1 -
 drivers/media/i2c/tea6420.c                  | 1 -
 drivers/media/i2c/ths7303.c                  | 1 -
 drivers/media/i2c/tvaudio.c                  | 1 -
 drivers/media/i2c/tvp5150.c                  | 1 -
 drivers/media/i2c/tw9903.c                   | 1 -
 drivers/media/i2c/tw9906.c                   | 1 -
 drivers/media/i2c/upd64031a.c                | 1 -
 drivers/media/i2c/upd64083.c                 | 1 -
 drivers/media/i2c/vp27smpx.c                 | 1 -
 drivers/media/i2c/vpx3220.c                  | 1 -
 drivers/media/i2c/wm8739.c                   | 1 -
 drivers/media/i2c/wm8775.c                   | 1 -
 drivers/media/platform/s5p-tv/hdmiphy_drv.c  | 1 -
 drivers/media/platform/s5p-tv/sii9234_drv.c  | 1 -
 drivers/media/radio/radio-tea5764.c          | 1 -
 drivers/media/radio/saa7706h.c               | 1 -
 drivers/media/radio/tef6862.c                | 1 -
 drivers/media/tuners/e4000.c                 | 1 -
 drivers/media/tuners/fc2580.c                | 1 -
 drivers/media/tuners/it913x.c                | 1 -
 drivers/media/tuners/m88rs6000t.c            | 1 -
 drivers/media/tuners/si2157.c                | 1 -
 drivers/media/tuners/tda18212.c              | 1 -
 drivers/media/tuners/tua9001.c               | 1 -
 drivers/media/usb/go7007/s2250-board.c       | 1 -
 drivers/media/v4l2-core/tuner-core.c         | 1 -
 67 files changed, 67 deletions(-)

-- 
1.9.1

