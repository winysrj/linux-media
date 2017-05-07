Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:35906 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754100AbdEGWE2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 7 May 2017 18:04:28 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com, jasmin@anw.at
Subject: [PATCH 00/11] Fix coding style in en50221 CAM functions
Date: Sun,  7 May 2017 23:23:23 +0200
Message-Id: <1494192214-20082-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

These patch series is a follow up to the series "Add block read/write to
en50221 CAM functions". It fixed nearly all the style issues reported by
checkpatch.pl in dvb-core/dvb_ca_en50221.c
Please note, that there are 7 Warnings left, which I won't fix.

Two of them are "WARNING: memory barrier without comment". I have really
no clue why there is a call to "mb()" in that file, so I can't fill in a
good comment.

Four warnings are "WARNING: line over 80 characters" which are strings for
debugging, which shouldn't be split in several lines (will give other
warning).

And finally one "WARNING: Prefer [subsystem eg: netdev]_dbg", complaining
about the "dprintk" macro. In my opinion it is correctly used and it is
normally disabled anyway.

The main problem of the original code was the size of the lines and the
structural complexity of some functions. Beside shortening the names and
refactoring of the thread state machine, I used in nearly every function
a helper pointer "sl" (for "slot" structure) instead the whole structure
path. This saved also a lot of characters in long lines.

I split the patch set is small pieces for easier review, compiled each
step and tested the resulting driver on my hardware with the DD DuoFlex CI
(single) card.


Jasmin Jessich (11):
  [media] dvb-core/dvb_ca_en50221.c: Rename STATUSREG_??
  [media] dvb-core/dvb_ca_en50221.c: Rename DVB_CA_SLOTSTATE_???
  [media] dvb-core/dvb_ca_en50221.c: Used a helper variable
  [media] dvb-core/dvb_ca_en50221.c: Refactored dvb_ca_en50221_thread
  [media] dvb-core/dvb_ca_en50221.c: Make checkpatch happy 1
  [media] dvb-core/dvb_ca_en50221.c: Make checkpatch happy 2
  [media] dvb-core/dvb_ca_en50221.c: Make checkpatch happy 3
  [media] dvb-core/dvb_ca_en50221.c: Make checkpatch happy 4
  [media] dvb-core/dvb_ca_en50221.c: Make checkpatch happy 5
  [media] dvb-core/dvb_ca_en50221.c: Make checkpatch happy 6
  [media] dvb-core/dvb_ca_en50221.c: Fixed wrong EXPORT_SYMBOL order

 drivers/media/dvb-core/dvb_ca_en50221.c | 916 ++++++++++++++++++--------------
 1 file changed, 527 insertions(+), 389 deletions(-)

-- 
2.7.4
