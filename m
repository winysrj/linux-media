Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:46473 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751950AbdKZNAN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Nov 2017 08:00:13 -0500
Received: by mail-wm0-f66.google.com with SMTP id u83so29456758wmb.5
        for <linux-media@vger.kernel.org>; Sun, 26 Nov 2017 05:00:13 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: rjkm@metzlerbros.de, rascobie@slingshot.co.nz, jasmin@anw.at
Subject: [PATCH 0/7] stv0910+stv6111 updates/fixes/improvements
Date: Sun, 26 Nov 2017 14:00:02 +0100
Message-Id: <20171126130009.6798-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

This series improves (and fixes) a few pending things and a few new ones
which were discovered by Richard (thanks!), removing some redundant
calls and checks here and there, and putting the symbolrate readout and
reporting to get_frontend(). The changes have been thoroughly tested and
didn't cause any harm or regressions.

This series also includes the WARN_ON() variant of the multi-mutexunlock-
protect ([1] for ref) so users can report misbehaving subdrivers (tuners)
and devs get a chance to fix their code. Also updates stv6111 to take
care that on reported errors, it won't unconditionally penetrate the demod
anymore (so the WARN_ON() in stv0910 won't even be triggered).

Please pull during the upcoming media_tree merge cycle.

[1] http://www.spinics.net/lists/linux-media/msg124573.html

Daniel Scheller (7):
  [media] frontends/stv0910: add field offsets to field defines
  [media] dvb-frontends/stv0910: WARN_ON() on consecutive mutex_unlock()
  [media] dvb-frontends/stv6111: handle gate_ctrl errors
  [media] dvb-frontends/stv0910: remove unneeded check/call to
    get_if_freq
  [media] dvb-frontends/stv0910: read symbolrate in get_frontend()
  [media] dvb-frontends/stv0910: remove unneeded symbol rate inquiry
  [media] dvb-frontends/stv0910: remove unneeded dvb_math.h include

 drivers/media/dvb-frontends/stv0910.c      |   17 +-
 drivers/media/dvb-frontends/stv0910_regs.h | 1854 ++++++++++++++--------------
 drivers/media/dvb-frontends/stv6111.c      |   44 +-
 3 files changed, 963 insertions(+), 952 deletions(-)

-- 
2.13.6
