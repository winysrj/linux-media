Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35990 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756AbbE3SKf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 May 2015 14:10:35 -0400
Received: by wivl4 with SMTP id l4so42944118wiv.1
        for <linux-media@vger.kernel.org>; Sat, 30 May 2015 11:10:34 -0700 (PDT)
From: Jemma Denson <jdenson@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, patrick.boettcher@posteo.de,
	Jemma Denson <jdenson@gmail.com>
Subject: [PATCH v2 0/4] SkystarS2 pid filtering fix and stream control
Date: Sat, 30 May 2015 19:10:05 +0100
Message-Id: <1433009409-5622-1-git-send-email-jdenson@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series finishes off the addition of the SkyStarS2 card -
the patches here aren't strictly required for running the card so
haven't previously been included.

The first patch fixes a bug present in the current flexcop driver -
I've seen it with this card, and it has also been noticed in some
other cards. Those cards will need identifying and patches created to
use this fix as it is not enabled by default.

The other three patches add in a feature that was half complete in the
original binary blob for this card, and allows the demod chip to
control the streams on the b2c2 when it turns off it's output during
tuning. This helps to avoid a situation where the hardware filter is
constantly reset by a software watchdog in flexcop-pci because it
can't see any data coming in.

Changes since v1:
* Move the stream reset code from flexcop_pci to flexcop_hw_filter so
  the fact it might interfere with hw_filter code isn't missed.
* Control both streams - so output stream aswell as receive.
* Track the external stream state so we don't leave the stream turned
  off in a reset.
* Don't let the external control start the stream until a feed is
  actually requested.

Jemma Denson (4):
  b2c2: Add option to skip the first 6 pid filters
  b2c2: Move stream reset code from flexcop-pci to flexcop
  b2c2: Add external stream control
  cx24120: Take control of b2c2 streams

 drivers/media/common/b2c2/flexcop-common.h    |  5 ++
 drivers/media/common/b2c2/flexcop-fe-tuner.c  | 13 +++++
 drivers/media/common/b2c2/flexcop-hw-filter.c | 71 ++++++++++++++++++++++-----
 drivers/media/dvb-frontends/cx24120.c         | 29 +++++++----
 drivers/media/dvb-frontends/cx24120.h         |  1 +
 drivers/media/pci/b2c2/flexcop-pci.c          | 19 ++-----
 6 files changed, 103 insertions(+), 35 deletions(-)

-- 
2.1.0

