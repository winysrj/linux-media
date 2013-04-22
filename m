Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:57789 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab3DVIMi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 04:12:38 -0400
Received: by mail-wg0-f42.google.com with SMTP id m15so715955wgh.5
        for <linux-media@vger.kernel.org>; Mon, 22 Apr 2013 01:12:37 -0700 (PDT)
Received: from dibcom294.localnet ([46.218.109.88])
        by mx.google.com with ESMTPSA id q18sm18441977wiw.8.2013.04.22.01.12.35
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 22 Apr 2013 01:12:36 -0700 (PDT)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR 3.10] DiBxxxx: fixes and improvements
Date: Mon, 22 Apr 2013 10:12:34 +0200
Message-ID: <1411209.JetyNPSOgp@dibcom294>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

These patches contains some fixes and changes for the DiBcom demods and 
SIPs.

Please merge for 3.10 if possible.


The following changes since commit 60d509fa6a9c4653a86ad830e4c4b30360b23f0e:

  Linux 3.9-rc8 (2013-04-21 14:38:45 -0700)

are available in the git repository at:

  git://git.linuxtv.org/pb/media_tree.git/ master

for you to fetch changes up to 7e39d1958b186e5af259b9fde1a006853b4663ab:

  [media] dib8000: do not freeze AGCs by default (2013-04-22 10:06:48 +0200)

----------------------------------------------------------------
Olivier Grenie (6):
      [media] dib8000: enhancement
      [media] dib7000p: enhancement
      [media] dib0090: enhancement
      [media] dib8096: enhancement
      [media] dib7090p: remove the support for the dib7090E
      [media] dib7090p: improve the support of the dib7090 and dib7790

Patrick Boettcher (1):
      [media] dib8000: do not freeze AGCs by default

 drivers/media/dvb-core/dvb-usb-ids.h         |    3 +-
 drivers/media/dvb-frontends/dib0090.c        |  438 ++---
 drivers/media/dvb-frontends/dib7000p.c       |   17 +-
 drivers/media/dvb-frontends/dib7000p.h       |    7 +
 drivers/media/dvb-frontends/dib8000.c        | 2239 +++++++++++++---------
 drivers/media/dvb-frontends/dib8000.h        |    6 +-
 drivers/media/dvb-frontends/dibx000_common.h |    3 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c  |  465 +++--
 8 files changed, 1780 insertions(+), 1398 deletions(-)


regards,
--
Patrick
