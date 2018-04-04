Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:43897 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750915AbeDDLlx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Apr 2018 07:41:53 -0400
Received: by mail-qt0-f177.google.com with SMTP id s48so22683255qtb.10
        for <linux-media@vger.kernel.org>; Wed, 04 Apr 2018 04:41:53 -0700 (PDT)
Received: from mail-qt0-f179.google.com (mail-qt0-f179.google.com. [209.85.216.179])
        by smtp.gmail.com with ESMTPSA id t20sm2591867qto.4.2018.04.04.04.41.52
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Apr 2018 04:41:52 -0700 (PDT)
Received: by mail-qt0-f179.google.com with SMTP id g5so22714274qth.7
        for <linux-media@vger.kernel.org>; Wed, 04 Apr 2018 04:41:52 -0700 (PDT)
MIME-Version: 1.0
From: Olli Salonen <olli.salonen@iki.fi>
Date: Wed, 4 Apr 2018 14:41:51 +0300
Message-ID: <CAAZRmGz8iTDSZ6S=05V0JKDXBnS47e43MBBSvnGtrVv-QioirA@mail.gmail.com>
Subject: Regression: DVBSky S960 USB tuner doesn't work in 4.10 or newer
To: Nibble Max <nibble.max@gmail.com>, peterz@infradead.org
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Peter and Max,

I noticed that when using kernel 4.10 or newer my DVBSky S960 and
S960CI satellite USB TV tuners stopped working properly. Basically,
they will fail at one point when tuning to a channel. This typically
takes less than 100 tuning attempts. For perspective, when performing
a full channel scan on my system, the tuner tunes at least 500 times.
After the tuner fails, I need to reboot the PC (probably unloading the
driver and loading it again would do).

2018-04-04 10:17:36.756 [   INFO] mpegts: 12149H in 4.8E - tuning on
Montage Technology M88DS3103 : DVB-S #0
2018-04-04 10:17:37.159 [  ERROR] diseqc: failed to send diseqc cmd
(e=Connection timed out)
2018-04-04 10:17:37.160 [   INFO] mpegts: 12265H in 4.8E - tuning on
Montage Technology M88DS3103 : DVB-S #0
2018-04-04 10:17:37.535 [  ERROR] diseqc: failed to send diseqc cmd
(e=Connection timed out)

I did a kernel bisect between 4.9 and 4.10. It seems the commit that
breaks my tuner is the following one:

9d659ae14b545c4296e812c70493bfdc999b5c1c is the first bad commit
commit 9d659ae14b545c4296e812c70493bfdc999b5c1c
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Tue Aug 23 14:40:16 2016 +0200

    locking/mutex: Add lock handoff to avoid starvation

I couldn't easily revert that commit only. I can see that the
drivers/media/usb/dvb-usb-v2/dvbsky.c driver does use mutex_lock() and
mutex_lock_interruptible() in a few places.

Do you guys see anything that's obviously wrong in the way the mutexes
are used in dvbsky.c or anything in that particular patch that could
cause this issue?

Thanks and best regards,
-olli
