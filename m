Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:50924 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaIUKxf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Sep 2014 06:53:35 -0400
Received: by mail-la0-f53.google.com with SMTP id ge10so5332845lab.12
        for <linux-media@vger.kernel.org>; Sun, 21 Sep 2014 03:53:33 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>, crope@iki.fi
Subject: [PATCH 0/3] IT930x USB DVB-T2/C tuner
Date: Sun, 21 Sep 2014 13:53:16 +0300
Message-Id: <1411296799-3525-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch set adds support for IT930x reference design. It contains IT9303 USB bridge, Si2168-B40 demodulator and Si2147-A30 tuner.

The patches should be applied on top of Antti's af9035 branch.
http://git.linuxtv.org/cgit.cgi/anttip/media_tree.git/log/?h=af9035

Cc: crope@iki.fi

Olli Salonen (3):
  si2157: Add support for Si2147-A30
  af9035: Add possibility to define which I2C adapter to use
  af9035: Add support for IT930x USB bridge

 drivers/media/dvb-core/dvb-usb-ids.h  |   1 +
 drivers/media/tuners/si2157.c         |  13 +-
 drivers/media/tuners/si2157.h         |   2 +-
 drivers/media/tuners/si2157_priv.h    |   2 +-
 drivers/media/usb/dvb-usb-v2/af9035.c | 333 +++++++++++++++++++++++++++++++---
 drivers/media/usb/dvb-usb-v2/af9035.h |   6 +
 6 files changed, 331 insertions(+), 26 deletions(-)

-- 
1.9.1

