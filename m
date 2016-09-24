Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:37646 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934778AbcIXWkr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Sep 2016 18:40:47 -0400
Received: by mail-wm0-f43.google.com with SMTP id b130so87487705wmc.0
        for <linux-media@vger.kernel.org>; Sat, 24 Sep 2016 15:40:46 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-media@vger.kernel.org, crope@iki.fi
Cc: benjamin@southpole.se, mchehab@kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [RFC] add DVBv5 statistics support to mn88473
Date: Sun, 25 Sep 2016 00:40:18 +0200
Message-Id: <20160924224019.677-1-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch tries to add DVBv5 statistics support to the mn88473 DVB
frontend driver.
Special thanks to Benjamin Larsson (who has documented the registers
in the LinuxTV wiki: [0]) and to a user with the nickname "dongs" in
the #linuxtv IRC channel (who provided more details about the MN88473).

There are multiple reasons why I decided to send this as RFC:
- I do not have any hardware signal generator, so I can only test with
  what I have available
- a quick test on DVB-C and DVB-T shows that CNR seems correct (DVB-T2
  is untested because it is not available in my area... yet)
- signal strength seems to be too low (compared to my em28xx device)
- I am not sure whether my implementation for bit errors and block
  errors is correct


[0] https://www.linuxtv.org/wiki/index.php/Panasonic_MN88472


Martin Blumenstingl (1):
  media: mn88473: add DVBv5 statistics support

 drivers/media/dvb-frontends/mn88473.c      | 485 ++++++++++++++++++++++++++---
 drivers/media/dvb-frontends/mn88473_priv.h |   1 +
 2 files changed, 445 insertions(+), 41 deletions(-)

-- 
2.10.0

