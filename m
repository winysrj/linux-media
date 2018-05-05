Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:37582 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750967AbeEEJum (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2018 05:50:42 -0400
Received: by mail-wm0-f67.google.com with SMTP id l1-v6so8580995wmb.2
        for <linux-media@vger.kernel.org>; Sat, 05 May 2018 02:50:42 -0700 (PDT)
From: Thomas Hollstegge <thomas.hollstegge@gmail.com>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Hollstegge <thomas.hollstegge@gmail.com>
Subject: [PATCH 0/2] dvbsky: Add support for MyGica T230C v2
Date: Sat,  5 May 2018 11:50:29 +0200
Message-Id: <1525513831-17682-1-git-send-email-thomas.hollstegge@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for newer revisions of the USB DVB-C/DVB-T/DVB-T2 stick MyGica
T230C, sometimes referred to as MyGica T230C2. The device needs a fixed TS
clock frequency of 10MHz to be able to demod some channels. This is done by
adding two new optional configuration options for the Si2168 demod
(ts_clock_mode and ts_clock_freq).

Although there is a third TS clock mode available (AUTO_FIXED = 0x00), I chose
not to implement it yet as I don't have a device that uses this mode.

Tested with all available DVB-T2 HEVC and DVB-C muxes in my region (Germany).

Thomas Hollstegge (2):
  si2168: Set TS clock mode and frequency
  dvbsky: Add support for MyGica T230C v2

 drivers/media/dvb-frontends/si2168.c      | 20 ++++++-
 drivers/media/dvb-frontends/si2168.h      |  8 +++
 drivers/media/dvb-frontends/si2168_priv.h |  2 +
 drivers/media/usb/dvb-usb-v2/dvbsky.c     | 90 +++++++++++++++++++++++++++++++
 include/media/dvb-usb-ids.h               |  1 +
 5 files changed, 120 insertions(+), 1 deletion(-)

-- 
2.7.4
