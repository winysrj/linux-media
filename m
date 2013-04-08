Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f49.google.com ([209.85.212.49]:53283 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934567Ab3DHB1m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Apr 2013 21:27:42 -0400
Received: by mail-vb0-f49.google.com with SMTP id 11so3367659vbf.22
        for <linux-media@vger.kernel.org>; Sun, 07 Apr 2013 18:27:41 -0700 (PDT)
Date: Sun, 7 Apr 2013 21:27:47 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Subject: [PULL] Ondrej Zary's patches for AverMedia A706
Message-ID: <20130407212747.55f08939@vujade>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit
53faa685fa7df0e12751eebbda30bc7e7bb5e71a:

  [media] siano: Fix array boundary at smscore_translate_msg()
  (2013-04-04 14:35:40 -0300)

are available in the git repository at:

  git://linuxtv.org/mkrufky/dvb AverMediaA706-April

for you to fetch changes up to 84c1018a6cc3e1650dac5a881727cf4c07b7db81:

  tda8290: change magic LNA config values to enum (2013-04-06 14:07:49
  -0400)

----------------------------------------------------------------
Ondrej Zary (5):
      tda8290: Allow disabling I2C gate
      tda8290: Allow custom std_map for tda18271
      tuner-core: Change config from unsigned int to void *
      saa7134: Add AverMedia A706 AverTV Satellite Hybrid+FM
      tda8290: change magic LNA config values to enum

 drivers/media/i2c/ir-kbd-i2c.c              |   13 ++++++++++++-
 drivers/media/pci/saa7134/saa7134-cards.c   |   94
 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------
 drivers/media/pci/saa7134/saa7134-dvb.c     |   23
 +++++++++++++++++++++++ drivers/media/pci/saa7134/saa7134-i2c.c
 |    1 + drivers/media/pci/saa7134/saa7134-input.c   |    3 +++
 drivers/media/pci/saa7134/saa7134-tvaudio.c |    1 +
 drivers/media/pci/saa7134/saa7134.h         |    4 +++-
 drivers/media/tuners/tda18271-fe.c          |    9 +++++----
 drivers/media/tuners/tda827x.c              |   10 +++++-----
 drivers/media/tuners/tda827x.h              |    3 ++-
 drivers/media/tuners/tda8290.c              |   60
 +++++++++++++++++++++++++++++++++++++-----------------------
 drivers/media/tuners/tda8290.h              |   12 +++++++++++-
 drivers/media/v4l2-core/tuner-core.c        |   20
 +++++++------------- include/media/tuner.h                       |
 2 +- 14 files changed, 185 insertions(+), 70 deletions(-)

Cheers,

Mike
