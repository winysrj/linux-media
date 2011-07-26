Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36439 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281Ab1GZANu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jul 2011 20:13:50 -0400
Received: from dyn3-82-128-185-212.psoas.suomi.net ([82.128.185.212] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <crope@iki.fi>)
	id 1QlVHQ-0005WM-Eg
	for linux-media@vger.kernel.org; Tue, 26 Jul 2011 03:13:48 +0300
Message-ID: <4E2E06BC.4090104@iki.fi>
Date: Tue, 26 Jul 2011 03:13:48 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH 0/3] DVB USB MFE
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement multi-frontend support for DVB USB.

First patch touches every DVB USB driver since it just changes adap->fe 
to adap->fe[0] as preparation of actual patch.

See usage example from Anysee driver, patch 3/3.

regards
Antti

Antti Palosaari (3):
   dvb-usb: prepare for multi-frontend support (MFE)
   dvb-usb: multi-frontend support (MFE)
   anysee: use multi-frontend (MFE)

  drivers/media/dvb/dvb-usb/af9005.c          |    2 +-
  drivers/media/dvb/dvb-usb/af9015.c          |   22 +-
  drivers/media/dvb/dvb-usb/anysee.c          |  321 
++++++++++++++++++---------
  drivers/media/dvb/dvb-usb/anysee.h          |    1 +
  drivers/media/dvb/dvb-usb/au6610.c          |    6 +-
  drivers/media/dvb/dvb-usb/az6027.c          |   10 +-
  drivers/media/dvb/dvb-usb/ce6230.c          |    6 +-
  drivers/media/dvb/dvb-usb/cinergyT2-core.c  |    2 +-
  drivers/media/dvb/dvb-usb/cxusb.c           |   60 +++---
  drivers/media/dvb/dvb-usb/dib0700_devices.c |  262 +++++++++++-----------
  drivers/media/dvb/dvb-usb/dibusb-common.c   |   18 +-
  drivers/media/dvb/dvb-usb/dibusb-mb.c       |   16 +-
  drivers/media/dvb/dvb-usb/digitv.c          |    8 +-
  drivers/media/dvb/dvb-usb/dtt200u.c         |    2 +-
  drivers/media/dvb/dvb-usb/dtv5100.c         |    8 +-
  drivers/media/dvb/dvb-usb/dvb-usb-dvb.c     |   85 ++++++--
  drivers/media/dvb/dvb-usb/dvb-usb-init.c    |    4 +
  drivers/media/dvb/dvb-usb/dvb-usb.h         |   11 +-
  drivers/media/dvb/dvb-usb/dw2102.c          |   92 ++++----
  drivers/media/dvb/dvb-usb/ec168.c           |    6 +-
  drivers/media/dvb/dvb-usb/friio.c           |    4 +-
  drivers/media/dvb/dvb-usb/gl861.c           |    6 +-
  drivers/media/dvb/dvb-usb/gp8psk.c          |    2 +-
  drivers/media/dvb/dvb-usb/lmedm04.c         |   28 ++--
  drivers/media/dvb/dvb-usb/m920x.c           |   14 +-
  drivers/media/dvb/dvb-usb/opera1.c          |    6 +-
  drivers/media/dvb/dvb-usb/technisat-usb2.c  |   24 +-
  drivers/media/dvb/dvb-usb/ttusb2.c          |   10 +-
  drivers/media/dvb/dvb-usb/umt-010.c         |    4 +-
  drivers/media/dvb/dvb-usb/vp702x.c          |    2 +-
  drivers/media/dvb/dvb-usb/vp7045.c          |    2 +-
  31 files changed, 606 insertions(+), 438 deletions(-)

-- 
1.7.6
---


-- 
http://palosaari.fi/


