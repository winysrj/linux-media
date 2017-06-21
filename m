Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:36481 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751875AbdFUTpr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Jun 2017 15:45:47 -0400
Received: by mail-wr0-f170.google.com with SMTP id c11so93326811wrc.3
        for <linux-media@vger.kernel.org>; Wed, 21 Jun 2017 12:45:47 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: liplianin@netup.ru, rjkm@metzlerbros.de, crope@iki.fi
Subject: [PATCH v2 0/4] STV0367/DDB DVBv5 signal statistics
Date: Wed, 21 Jun 2017 21:45:40 +0200
Message-Id: <20170621194544.16949-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

This series adds DVBv5 statistics support to the new DDB codepath of the
stv0367 demodulator driver.

The changes utilise already existing functionality (in form of register
readouts), but wraps the reads in separate functions so the existing
relative scale reporting can be kept as-is, while adding the v5 stats
in dB scale where appropriate.

>From my own testing: Reported values look approx. the same as those
reported by the cxd2841er driver for both -C and -T.

Changes from v1 to v2:
 - INTLOG10X100() macro for QAM SNR calculation removed and replaced by
   directly utilising intlog2 plus a div
 - factored statistics collection into *_read_status()
 - prevent a possible division by zero (though requires ridiculously good
   SNR to trigger)
 - _read_status() doesn't return -EINVAL anymore if no demod state is set,
   prevents falsely reported errors from inquiries of userspace tools

Daniel Scheller (4):
  [media] dvb-frontends/stv0367: initial DDB DVBv5 stats, implement
    ucblocks
  [media] dvb-frontends/stv0367: split SNR determination into functions
  [media] dvb-frontends/stv0367: SNR DVBv5 statistics for DVB-C and T
  [media] dvb-frontends/stv0367: DVB-C signal strength statistics

 drivers/media/dvb-frontends/stv0367.c | 178 ++++++++++++++++++++++++++++------
 1 file changed, 148 insertions(+), 30 deletions(-)

-- 
2.13.0
