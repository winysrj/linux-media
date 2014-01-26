Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42448 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaAZVu5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jan 2014 16:50:57 -0500
Received: by mail-lb0-f174.google.com with SMTP id l4so3905748lbv.19
        for <linux-media@vger.kernel.org>; Sun, 26 Jan 2014 13:50:55 -0800 (PST)
From: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sean Young <sean@mess.org>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [RFCv2 PATCH 0/5] rc: Add generic sysfs interface for handling wakeup codes
Date: Sun, 26 Jan 2014 23:50:21 +0200
Message-Id: <1390773026-567-1-git-send-email-a.seppala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm resending the patch series as it seems that my initial attempt was 
not delivered to patchwork or linux-media list. Apologies for duplicate 
emails to people who may have received the first attempt.


Patches 1 & 2 in this series introduce a simple sysfs file interface for
reading and writing wakeup scancodes or ir samples to rc drivers.

The interface is designed to be flexible yet easy enough to adapt to. It
can support almost any kind of known wakeup scancode and sample formats.

Patches 3-5 in the series port some existing drivers to use this 
interface.

Changes in v2:
 - Added wakeup_protocols file to control which protocol to use with 
wakeup
 - Renamed interface to wakeup_code
 - Clean-up device attribute registration
 - Ported winbond-cir to use this interface
 - Brought interface closer to 
https://patchwork.linuxtv.org/patch/21625/

Antti Seppälä (5):
  rc-core: Add defintions needed for sysfs callback
  rc-core: Add support for reading/writing wakeup codes via sysfs
  rc-loopback: Add support for reading/writing wakeup scancodes via
    sysfs
  nuvoton-cir: Add support for reading/writing wakeup samples via sysfs
  winbond-cir: Add support for reading/writing wakeup scancodes via
    sysfs

 drivers/media/rc/nuvoton-cir.c | 118 +++++++++++++++++++++++++++
 drivers/media/rc/nuvoton-cir.h |   2 +
 drivers/media/rc/rc-loopback.c |  40 +++++++++
 drivers/media/rc/rc-main.c     | 179 +++++++++++++++++++++++++++++++++++++----
 drivers/media/rc/winbond-cir.c |  66 ++++++++++-----
 include/media/rc-core.h        |  17 ++++
 6 files changed, 390 insertions(+), 32 deletions(-)

-- 
1.8.3.2

