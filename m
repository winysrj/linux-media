Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36244 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750909AbdGWKNT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Jul 2017 06:13:19 -0400
Received: by mail-wm0-f65.google.com with SMTP id 184so9146788wmo.3
        for <linux-media@vger.kernel.org>; Sun, 23 Jul 2017 03:13:18 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, r.scobie@clear.net.nz
Subject: [PATCH 0/7] stv0910/stv6111 updates
Date: Sun, 23 Jul 2017 12:13:08 +0200
Message-Id: <20170723101315.12523-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Several, mostly cosmetic updates and fixes to these two new drivers, and
one additional functionality:

- Make both drivers 99% checkpatch-strict clean. stv0910_regs.h still
  has "CHECK: 'VALIDE' may be misspelled - perhaps 'VALID'?", which is
  left as-is intentionally (unclear if this really is a typo, or wanted
  or documented in vendor specs)
- Fixup comments (block comment format, c++-style comments, whitespace
  etc)
- Const'ify all tables
- Better identifier strings
- Signal strength assignment fixed and unneeded var removed (uvalue vs
  svalue)
- Support/Implement the disecq_send_burst fe_op

Based on https://patchwork.linuxtv.org/patch/42702/ and thus requires that
one to be merged beforehand, else this series conflicts in patch 4/7.

Build and runtime tested.

Daniel Scheller (7):
  [media] dvb-frontends/stv0910: fix STR assignment, remove unneeded var
  [media] dvb-frontends/stv0910: implement diseqc_send_burst
  [media] dvb-frontends/stv0910: further coding style cleanup
  [media] dvb-frontends/stv0910: cosmetics: fixup comments, misc
  [media] dvb-frontends/stv6111: coding style cleanup
  [media] dvb-frontends/stv6111: cosmetics: comments fixup, misc
  [media] dvb-frontends/stv{0910,6111}: constify tables

 drivers/media/dvb-frontends/stv0910.c      |  543 ++++----
 drivers/media/dvb-frontends/stv0910.h      |    4 +-
 drivers/media/dvb-frontends/stv0910_regs.h | 1953 ++++++++++++++--------------
 drivers/media/dvb-frontends/stv6111.c      |   85 +-
 drivers/media/dvb-frontends/stv6111.h      |    7 +-
 5 files changed, 1313 insertions(+), 1279 deletions(-)

-- 
2.13.0
