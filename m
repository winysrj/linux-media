Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:38009 "EHLO
        homiemail-a123.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752446AbeAQVcj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Jan 2018 16:32:39 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 0/2] Hauppauge Solo/Dual HD spectral inversion
Date: Wed, 17 Jan 2018 15:32:34 -0600
Message-Id: <1516224756-1649-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a misplaced addendum to my series:
- Hauppauge em28xx/lgdt3306a soloHD/DualHD support


This patch set requires:
https://patchwork.linuxtv.org/patch/46326/
https://patchwork.linuxtv.org/patch/46330/
https://patchwork.linuxtv.org/patch/46327/
https://patchwork.linuxtv.org/patch/46334/
https://patchwork.linuxtv.org/patch/46333/
https://patchwork.linuxtv.org/patch/46331/
https://patchwork.linuxtv.org/patch/46328/
https://patchwork.linuxtv.org/patch/46335/
https://patchwork.linuxtv.org/patch/46332/


This adds a spectrum inversion property to si2168
frontend configuration. Hauppauge Solo/Dual HD DVB
models have si2157 which produces inverted spectrum,
so they enable the property.


Brad Love (2):
  si2168: Add spectrum inversion property
  em28xx: Enable spectrum inversion for Hauppauge Solo/Dual HD DVB

 drivers/media/dvb-frontends/si2168.c  | 2 ++
 drivers/media/dvb-frontends/si2168.h  | 3 +++
 drivers/media/usb/em28xx/em28xx-dvb.c | 2 ++
 3 files changed, 7 insertions(+)

-- 
2.7.4
