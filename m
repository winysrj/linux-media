Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34473 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751050AbdFYL0t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 07:26:49 -0400
Received: by mail-wr0-f196.google.com with SMTP id k67so23865221wrc.1
        for <linux-media@vger.kernel.org>; Sun, 25 Jun 2017 04:26:49 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: liplianin@netup.ru, rjkm@metzlerbros.de, crope@iki.fi
Subject: [PATCH v3 0/4] STV0367/DDB DVBv5 signal statistics
Date: Sun, 25 Jun 2017 13:26:42 +0200
Message-Id: <20170625112646.7973-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

This series adds DVBv5 statistics support to the new DDB codepath of the
stv0367 demodulator driver.

The changes utilise already existing functionality (in form of register
readouts), but wraps the reads in separate functions so the existing
relative scale reporting can be kept as-is, while adding the v5 stats
in dB scale where appropriate.

The {ter,cab}_read_status() additionally have been enhanced to provide a
more detailed status from the values the logic already provides (at least
for DVB-C, DVB-T isn't as detailed, so all flags are set upon lock
instead).

>From my own testing: Reported values look approx. the same as those
reported by the cxd2841er driver for both -C and -T.

Testing for v3: The enhanced status works good for DVB-C - signal almost
instantly goes to FE_HAS_LOCK with good signal strength with the cabling
plugged in. When antenna is pulled, fe_status goes away, cnr goes to
unavailable and signal strength to the lowest the driver can provide.
Statistics come back after cable is plugged back in. Re DVB-T,
unfortunately I cannot do anymore testing with this, since over here in
germany DVB-T was replaced by DVB-T2, which the demod cannot handle.
Since it worked before and the logic didn't really change, I strongly
assume things are still good.

Mauro, re your patch (thanks again!), I slightly changed the commit title
and description but kept you as the author, added t-b and signoff. Also,
thank you for writing up the DVBv5 statistics document/howto, which was
very helpful in fixing this!

Hope everything's good to go now :-)

Changes from v2 to v3:
 - ucblocks reporting and register read out splitting are already merged,
   thus not part of the series anymore
 - enhanced {ter,cab}_read_status(), thank you Mauro for pointing this
   out and providing the (untested) patch!
 - always read signal strength, read cnr on FE_HAS_CARRIER, and ucblocks
   on FE_HAS_LOCK
 - adjust if-status-logic for ucblock to match the rest

Changes from v1 to v2:
 - INTLOG10X100() macro for QAM SNR calculation removed and replaced by
   directly utilising intlog2 plus a div
 - factored statistics collection into *_read_status()
 - prevent a possible division by zero (though requires ridiculously good
   SNR to trigger)
 - _read_status() doesn't return -EINVAL anymore if no demod state is set,
   prevents falsely reported errors from inquiries of userspace tools

Daniel Scheller (3):
  [media] dvb-frontends/stv0367: SNR DVBv5 statistics for DVB-C and T
  [media] dvb-frontends/stv0367: DVB-C signal strength statistics
  [media] dvb-frontends/stv0367: make UCB readout logic more clear

Mauro Carvalho Chehab (1):
  [media] dvb-frontends/stv0367: Improve DVB-C/T frontend status

 drivers/media/dvb-frontends/stv0367.c | 85 ++++++++++++++++++++++++++++++++---
 1 file changed, 78 insertions(+), 7 deletions(-)

-- 
2.13.0
