Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52583 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425Ab2GJPFP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 11:05:15 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Andreas Oberritter <obi@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH RFCv3] add DTMB support for DVB API
Date: Tue, 10 Jul 2012 18:04:24 +0300
Message-Id: <1341932665-28580-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes since v2
* add documentation
* FEC_0x => FEC_x_y
* remove typedef

Some questions still:
1)
Should I use INTERLEAVING_AUTO instead of INTERLEAVING_NONE ?

2)
Which is better, enum fe_interleaving or u8 for interleaving type inside struct dtv_frontend_properties?
Only 2 bits is needed to present current values so enum will waste some space.

Cc: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Andreas Oberritter <obi@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>

Antti Palosaari (1):
  add DTMB support for DVB API

 Documentation/DocBook/media/dvb/dvbproperty.xml |   40 ++++++++++++++++++++++-
 drivers/media/dvb/dvb-core/dvb_frontend.c       |   14 ++++++--
 drivers/media/dvb/dvb-core/dvb_frontend.h       |    2 ++
 drivers/media/dvb/frontends/atbm8830.c          |    2 +-
 drivers/media/dvb/frontends/lgs8gl5.c           |    2 +-
 drivers/media/dvb/frontends/lgs8gxx.c           |    2 +-
 include/linux/dvb/frontend.h                    |   21 ++++++++++--
 include/linux/dvb/version.h                     |    2 +-
 8 files changed, 74 insertions(+), 11 deletions(-)

-- 
1.7.10.4

