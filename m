Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.andi.de1.cc ([85.214.239.24]:51688 "EHLO
        h2641619.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752493AbdCOWWw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 18:22:52 -0400
From: Andreas Kemnade <andreas@kemnade.info>
To: crope@iki.fi, mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Andreas Kemnade <andreas@kemnade.info>
Subject: [PATCH 0/3] support for Logilink VG0022a DVB-T2 stick
Date: Wed, 15 Mar 2017 23:22:07 +0100
Message-Id: <1489616530-4025-1-git-send-email-andreas@kemnade.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,
here are some patches needed for supporting the
Logilink VG0022A DVB-T2 stick.
As the combination of chips in that stick is not
uncommon, the first two patches might also fix problems
for similar hardware.

Andreas Kemnade (3):
  [media] si2157: get chip id during probing
  [media] af9035: init i2c already in it930x_frontend_attach
  [media] af9035: add Logilink vg0022a to device id table

 drivers/media/tuners/si2157.c         | 54 +++++++++++++++++++++--------------
 drivers/media/tuners/si2157_priv.h    |  7 +++++
 drivers/media/usb/dvb-usb-v2/af9035.c | 45 ++++++++++++++++++++++++++++-
 3 files changed, 83 insertions(+), 23 deletions(-)

-- 
2.1.4
