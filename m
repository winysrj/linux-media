Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38593 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277AbbC2WnD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2015 18:43:03 -0400
Received: from 85-76-81-44-nat.elisa-mobile.fi ([85.76.81.44] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <crope@iki.fi>)
	id 1YcLv3-0002Yi-J2
	for linux-media@vger.kernel.org; Mon, 30 Mar 2015 01:43:01 +0300
Message-ID: <55187FF2.5020802@iki.fi>
Date: Mon, 30 Mar 2015 01:42:58 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL 4.1] TS2020 / TS2022
References: <5515ECB7.3050702@iki.fi>
In-Reply-To: <5515ECB7.3050702@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

PULL request update. Added pending patches which causes conflict otherwise.

regards
Antti

On 03/28/2015 01:50 AM, Antti Palosaari wrote:
> Add TS2022 support to TS2020 driver. Relative small changes were
> needed. Add I2C binding to TS2020. Switch TS2022 users to TS2020
> and finally drop obsolete TS2022.


The following changes since commit 8a56b6b5fd6ff92b7e27d870b803b11b751660c2:

   [media] v4l2-subdev: remove enum_framesizes/intervals (2015-03-23 
12:02:41 -0700)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git ts2020_pull

for you to fetch changes up to e958e05617a8d5819608b3821a3263653852a761:

   ts2020: do not use i2c_transfer() on sleep() (2015-03-30 01:37:24 +0300)

----------------------------------------------------------------
Antti Palosaari (9):
       ts2020: add support for TS2022
       ts2020: implement I2C client bindings
       em28xx: switch PCTV 461e to ts2020 driver
       cx23885: switch ts2022 to ts2020 driver
       smipcie: switch ts2022 to ts2020 driver
       dvbsky: switch ts2022 to ts2020 driver
       dw2102: switch ts2022 to ts2020 driver
       m88ts2022: remove obsolete driver
       ts2020: do not use i2c_transfer() on sleep()

David Howells (1):
       m88ts2022: Nested loops shouldn't use the same index variable

Olli Salonen (3):
       dw2102: combine su3000_state and s6x0_state into dw2102_state
       dw2102: store i2c client for tuner into dw2102_state
       dw2102: TechnoTrend TT-connect S2-4600 DVB-S/S2 tuner

  MAINTAINERS                             |  10 ---
  drivers/media/dvb-core/dvb-usb-ids.h    |   1 +
  drivers/media/dvb-frontends/ts2020.c    | 302 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
  drivers/media/dvb-frontends/ts2020.h    |  25 +++++-
  drivers/media/pci/cx23885/Kconfig       |   1 -
  drivers/media/pci/cx23885/cx23885-dvb.c |  30 ++++----
  drivers/media/pci/smipcie/Kconfig       |   2 +-
  drivers/media/pci/smipcie/smipcie.c     |  12 ++-
  drivers/media/tuners/Kconfig            |   8 --
  drivers/media/tuners/m88ts2022.c        | 579 
-----------------------------------------------------------------------------------------------------------------------------------------
  drivers/media/tuners/m88ts2022.h        |  54 -------------
  drivers/media/tuners/m88ts2022_priv.h   |  35 ---------
  drivers/media/usb/dvb-usb-v2/Kconfig    |   2 +-
  drivers/media/usb/dvb-usb-v2/dvbsky.c   |  26 +++----
  drivers/media/usb/dvb-usb/Kconfig       |   5 +-
  drivers/media/usb/dvb-usb/dw2102.c      | 192 
++++++++++++++++++++++++++++++++++++++++++----
  drivers/media/usb/em28xx/Kconfig        |   2 +-
  drivers/media/usb/em28xx/em28xx-dvb.c   |  13 ++--
  18 files changed, 514 insertions(+), 785 deletions(-)
  delete mode 100644 drivers/media/tuners/m88ts2022.c
  delete mode 100644 drivers/media/tuners/m88ts2022.h
  delete mode 100644 drivers/media/tuners/m88ts2022_priv.h

-- 
http://palosaari.fi/
