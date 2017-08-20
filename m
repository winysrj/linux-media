Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:38506 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752516AbdHTK3T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 06:29:19 -0400
Received: by mail-wr0-f194.google.com with SMTP id k10so224028wre.5
        for <linux-media@vger.kernel.org>; Sun, 20 Aug 2017 03:29:19 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH 0/2] stv0910: updates from dddvb 0.9.31
Date: Sun, 20 Aug 2017 12:29:13 +0200
Message-Id: <20170820102915.6196-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Digital Devices released dddvb-0.9.31 which carries these two fixes for
the stv0910 demodulator driver.

Should go in after the seven stv0910/stv6111 cleanup patches (see [1]),
namely after [2]. They might apply cleanly without them, but they may
also hard-depend and conflict without them (I honestly did not test
this as I applied them ontop of my "carry everything" branch).

[1] http://www.spinics.net/lists/linux-media/msg119065.html
[2] https://patchwork.linuxtv.org/patch/42728/

Daniel Scheller (2):
  [media] dvb-frontends/stv0910: fix FE_HAS_LOCK check order in tune()
  [media] dvb-frontends/stv0910: fix mask for scramblingcode setup

 drivers/media/dvb-frontends/stv0910.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

-- 
2.13.0
