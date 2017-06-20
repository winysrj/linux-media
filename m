Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:34826 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751094AbdFTRpK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Jun 2017 13:45:10 -0400
Received: by mail-wr0-f170.google.com with SMTP id y25so61355549wrd.2
        for <linux-media@vger.kernel.org>; Tue, 20 Jun 2017 10:45:09 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: liplianin@netup.ru, rjkm@metzlerbros.de
Subject: [PATCH 0/4] STV0367/DDB DVBv5 signal statistics
Date: Tue, 20 Jun 2017 19:45:02 +0200
Message-Id: <20170620174506.7593-1-d.scheller.oss@gmail.com>
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

Daniel Scheller (4):
  [media] dvb-frontends/stv0367: initial DDB DVBv5 stats, implement
    ucblocks
  [media] dvb-frontends/stv0367: split SNR determination into functions
  [media] dvb-frontends/stv0367: SNR DVBv5 statistics for DVB-C and T
  [media] dvb-frontends/stv0367: DVB-C signal strength statistics

 drivers/media/dvb-frontends/stv0367.c | 180 ++++++++++++++++++++++++++++------
 1 file changed, 150 insertions(+), 30 deletions(-)

-- 
2.13.0
