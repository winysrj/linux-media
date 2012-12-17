Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55044 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab2LQBJb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 20:09:31 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so4252207lbb.19
        for <linux-media@vger.kernel.org>; Sun, 16 Dec 2012 17:09:30 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 16 Dec 2012 20:09:29 -0500
Message-ID: <CAOcJUbwdzPEn14P5qA=Sqk56tcaL3neeOwQqNrgDSdGce1Ky-w@mail.gmail.com>
Subject: [PULL] add basic DVB-S2 support for Hauppauge HVR-4400
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Please merge:

git request-pull 49cc629df16f2a15917800a8579bd9c25c41b634
git://linuxtv.org/mkrufky/hauppauge hvr4400
The following changes since commit 49cc629df16f2a15917800a8579bd9c25c41b634:

  [media] MAINTAINERS: add si470x-usb+common and si470x-i2c entries
(2012-12-11 18:16:13 -0200)

are available in the git repository at:

  git://linuxtv.org/mkrufky/hauppauge hvr4400

for you to fetch changes up to 4c8e64232d4a71e68d68b9093506966c0244a526:

  cx23885: add basic DVB-S2 support for Hauppauge HVR-4400 (2012-12-16
12:27:25 -0500)

----------------------------------------------------------------
Michael Krufky (2):
      tda10071: add tuner_i2c_addr to struct tda10071_config
      cx23885: add basic DVB-S2 support for Hauppauge HVR-4400

 drivers/media/dvb-frontends/tda10071.c    |    2 +-
 drivers/media/dvb-frontends/tda10071.h    |    6 ++++++
 drivers/media/pci/cx23885/Kconfig         |    2 ++
 drivers/media/pci/cx23885/cx23885-cards.c |   38
+++++++++++++++++++++++++++++++++++++-
 drivers/media/pci/cx23885/cx23885-dvb.c   |   27 +++++++++++++++++++++++++++
 drivers/media/pci/cx23885/cx23885.h       |    1 +
 6 files changed, 74 insertions(+), 2 deletions(-)

Cheers,

Mike
