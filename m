Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45125 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab2HLXf2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Aug 2012 19:35:28 -0400
Received: by yhmm54 with SMTP id m54so2717997yhm.19
        for <linux-media@vger.kernel.org>; Sun, 12 Aug 2012 16:35:28 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 12 Aug 2012 19:35:27 -0400
Message-ID: <CALzAhNXkS8P8T8JARE6+r5d=Pe=reN7tJ8kze0WiSJUmDbJmEA@mail.gmail.com>
Subject: [GIT PULL / Firmware] O820E firmware release
From: Steven Toth <stoth@kernellabs.com>
To: Linux-Media <linux-media@vger.kernel.org>
Cc: Mauro Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

The firmware related to the O820 driver addition below. I'm not sure
how you deal with this but here's the license and firmware blob. I
don't see a direct git repo for linux-firmware on linuxtv.org, so this
comes from kernel.org dwmw2/linux-firmware.git

The following changes since commit 7560108a2c94a62056fa82d912282b901aa0904f:

  Add syscfg (different frequency) and patch for AR3002 2.2.1.
(2012-07-19 04:02:52 +0100)

are available in the git repository at:
  git://git.kernellabs.com/stoth/linux-firmware.git master

Steven Toth (1):
      [media] vc8x0: Adding the firmware for the FPGA

 LICENSE.vc8x0                       |   18 ++++++++++++++++++
 v4l-osprey-820e-firmware-v1.5.0.rom |  Bin 0 -> 1932760 bytes
 2 files changed, 18 insertions(+), 0 deletions(-)
 create mode 100644 LICENSE.vc8x0
 create mode 100644 v4l-osprey-820e-firmware-v1.5.0.rom

Regards,

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
