Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38137 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757AbbEVU24 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2015 16:28:56 -0400
Received: by wichy4 with SMTP id hy4so58181157wic.1
        for <linux-media@vger.kernel.org>; Fri, 22 May 2015 13:28:55 -0700 (PDT)
From: Jemma Denson <jdenson@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, patrick.boettcher@posteo.de,
	Jemma Denson <jdenson@gmail.com>
Subject: [PATCH 0/4] SkystarS2 pid filtering fix and stream control.
Date: Fri, 22 May 2015 21:28:24 +0100
Message-Id: <1432326508-6825-1-git-send-email-jdenson@gmail.com>
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
control the receive stream on the b2c2 when it turns off it's output
during tuning. I'm not sure it actually needs to turn it's output
stream off, and the patches also make it easy to disable this.

Jemma Denson (4):
  b2c2: Add option to skip the first 6 pid filters
  b2c2: Allow external stream control
  cx24120: Take control of b2c2 receive stream
  b2c2: Always turn off receive stream

 drivers/media/common/b2c2/flexcop-common.h    |  3 +++
 drivers/media/common/b2c2/flexcop-fe-tuner.c  | 13 ++++++++++++
 drivers/media/common/b2c2/flexcop-hw-filter.c | 22 ++++++++++++++++----
 drivers/media/dvb-frontends/cx24120.c         | 29 ++++++++++++++++++---------
 drivers/media/dvb-frontends/cx24120.h         |  1 +
 5 files changed, 55 insertions(+), 13 deletions(-)

-- 
2.1.0

