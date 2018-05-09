Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:54812 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934932AbeEIUIH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2018 16:08:07 -0400
Received: by mail-wm0-f66.google.com with SMTP id f6-v6so480453wmc.4
        for <linux-media@vger.kernel.org>; Wed, 09 May 2018 13:08:06 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, mchehab+samsung@kernel.org
Subject: [PATCH 0/4] ddbridge-0.9.33 fixes and improvements
Date: Wed,  9 May 2018 22:07:59 +0200
Message-Id: <20180509200803.5253-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Four post-ddbridge-0.9.33 patches fixing and improving a few things:

Patch 1 adds protection into the new ddbridge-mci code against an
out-of-bounds array write access as reported by CoverityScan and brought
to attention by Colin Ian King.

Patch 2 adds missing function argument identifiers to ddb_mci_attach() to
silence checkpatch. It still complains about the **fn_set_input which IS
the identifier but doesn't seem to be caught by checkpatch properly.

Patches 3 and 4 enable the higher speed TS mode on stv0910-equipped cards
and thus enables for higher bitrate transponders when the detected card
firmware permits this. This is basically what was removed in the initial
ddbridge-0.9.33 patch series but enhanced to be only enabled when the
FPGA firmware permits this.

Please merge, this should go in alongside the already merged ddbridge
0.9.33 patches. Thanks.

Daniel Scheller (4):
  [media] ddbridge/mci: protect against out-of-bounds array access in
    stop()
  [media] ddbridge/mci: add identifiers to function definition arguments
  [media] dvb-frontends/stv0910: make TS speed configurable
  [media] ddbridge: conditionally enable fast TS for stv0910-equipped
    bridges

 drivers/media/dvb-frontends/stv0910.c      |  5 ++---
 drivers/media/dvb-frontends/stv0910.h      |  1 +
 drivers/media/pci/ddbridge/ddbridge-core.c | 35 +++++++++++++++++++++++++-----
 drivers/media/pci/ddbridge/ddbridge-mci.c  | 23 ++++++++++----------
 drivers/media/pci/ddbridge/ddbridge-mci.h  |  6 ++++-
 drivers/media/pci/ngene/ngene-cards.c      |  1 +
 6 files changed, 51 insertions(+), 20 deletions(-)

-- 
2.16.1
