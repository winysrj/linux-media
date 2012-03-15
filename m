Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36781 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139Ab2COReF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 13:34:05 -0400
Received: by eaaq12 with SMTP id q12so1771285eaa.19
        for <linux-media@vger.kernel.org>; Thu, 15 Mar 2012 10:34:03 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: crope@iki.fi, Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH 0/3] cxd2820r: tweak search algorithm, enable LNA in DVB-T mode
Date: Thu, 15 Mar 2012 18:33:46 +0100
Message-Id: <1331832829-4580-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The PCTV 290e had several issues on my mipsel-based STB (powered by a
Broadcom 7405 SoC), running a Linux 3.1 kernel and the Enigma2 OS.

The most annoying one was that the 290e was able to tune the lone DVB-T2
frequency existing in my area, but was not able to tune any DVB-T channel.

Following a suggestion of the original author of the driver, I tried to
tweak the wait time in the lock loop. In fact, increasing the wait time
from 50 to 200ms in the tuning loop was enough to get the lock on most
channels.
But channel change was quite slow and sometimes, doing an automatic scan,
some frequency was not locked.
So instead of playing with the timings I changed the behavior of the
search algorithm as explained in the patch 1, with very good results.

With this modification, the automatic scan is 100% reliable and zapping
is quite fast (on the STB). There is no noticeable difference when using
Kaffeine on the PC.

But there was a further issue: a few weak channels were affected by high
BER and badly corrupted pictures. The same channels were working fine on
an Avermedia A867 stick (as well as other sticks).

The driver has an option to enable a "Low Noise Amplifier" (LNA) before the
demodulator. Enabling it, the reception of weak channels improved a lot,
as reported in the description of patch 2.

Finally, patch 3 is a trivial clean-up.

Best regards,
Gianluca Gennari

Gianluca Gennari (3):
  cxd2820r: tweak search algorithm behavior
  em28xx-dvb: enable LNA for cxd2820r in DVB-T mode
  cxd2820r: delete unused function cxd2820r_init_t2

 drivers/media/dvb/frontends/cxd2820r_core.c |    4 ++--
 drivers/media/dvb/frontends/cxd2820r_priv.h |    2 --
 drivers/media/video/em28xx/em28xx-dvb.c     |    3 ++-
 3 files changed, 4 insertions(+), 5 deletions(-)

-- 
1.7.5.4

