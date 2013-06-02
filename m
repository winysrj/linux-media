Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f44.google.com ([209.85.213.44]:45732 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab3FBShL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Jun 2013 14:37:11 -0400
Received: by mail-yh0-f44.google.com with SMTP id 29so992649yhl.31
        for <linux-media@vger.kernel.org>; Sun, 02 Jun 2013 11:37:11 -0700 (PDT)
Date: Sun, 2 Jun 2013 14:29:25 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
To: mchehab@redhat.com, linux-media@vger.kernel.org
Subject: [GIT PULL] git://linuxtv.org/mkrufky/dvb stb0899
Message-ID: <20130602142925.55d67d24@vujade>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit
7eac97d7e714429f7ef1ba5d35f94c07f4c34f8e:

  [media] media: pci: remove duplicate checks for EPERM (2013-05-27
  09:34:56 -0300)

are available in the git repository at:

  git://linuxtv.org/mkrufky/dvb stb0899

for you to fetch changes up to fda0cbcc4878079829b5e13101c1c5144c4db3d9:

  stb0899: sign of CRL_FREQ doesn't depend on inversion (2013-06-02
  14:03:13 -0400)

----------------------------------------------------------------
Reinhard Nißl (7):
      stb0899: sign extend raw CRL_FREQ value
      stb0899: enable auto inversion handling unconditionally
      stb0899: fix inversion enum values to match usage with CFR
      stb0899: store successful inversion for next run
      stb0899: store autodetected inversion while tuning in non S2 mode
      stb0899: use autodetected inversion instead of configured
      stb0899: sign of CRL_FREQ doesn't depend on inversion

Zoran Turalija (2):
      stb0899: allow minimum symbol rate of 1000000
      stb0899: allow minimum symbol rate of 2000000

 drivers/media/dvb-frontends/stb0899_algo.c | 105 +++++++++++++++-------------
 drivers/media/dvb-frontends/stb0899_drv.c  |   7 +-
 drivers/media/dvb-frontends/stb0899_drv.h  |   5 +-
 3 files changed, 63 insertions(+), 54 deletions(-)
