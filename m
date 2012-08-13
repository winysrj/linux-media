Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52841 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278Ab2HMCdm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Aug 2012 22:33:42 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 0/2] add DTMB support for DVB API
Date: Mon, 13 Aug 2012 05:33:20 +0300
Message-Id: <1344825202-2296-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I think it is ready. As a last minute change I added INTERLEAVING_AUTO
but such trivial and meaningless change I don't see necessary even ran
PATCH RFC for it (interlaving was new enum added for DTMB).

Antti Palosaari (2):
  add DTMB support for DVB API
  DVB API: add INTERLEAVING_AUTO

 Documentation/DocBook/media/dvb/dvbproperty.xml | 41 ++++++++++++++++++++++++-
 drivers/media/dvb/dvb-core/dvb_frontend.c       | 14 +++++++--
 drivers/media/dvb/dvb-core/dvb_frontend.h       |  2 ++
 drivers/media/dvb/frontends/atbm8830.c          |  2 +-
 drivers/media/dvb/frontends/lgs8gl5.c           |  2 +-
 drivers/media/dvb/frontends/lgs8gxx.c           |  2 +-
 include/linux/dvb/frontend.h                    | 22 +++++++++++--
 include/linux/dvb/version.h                     |  2 +-
 8 files changed, 76 insertions(+), 11 deletions(-)

-- 
1.7.11.2

