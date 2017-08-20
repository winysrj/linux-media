Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:33810 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752945AbdHTM7P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 08:59:15 -0400
Received: by mail-wr0-f194.google.com with SMTP id p14so7992253wrg.1
        for <linux-media@vger.kernel.org>; Sun, 20 Aug 2017 05:59:14 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at
Subject: [PATCH 0/2] stv{0910,6111} cosmetics
Date: Sun, 20 Aug 2017 14:59:10 +0200
Message-Id: <20170820125912.9716-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Two cosmetics for the two new demod/tuner drivers. The stv0910 patch is
a remainder/leftover from the cleanup and cosmetic series, originally
submitted by Colin King. The second one fixes a warning I noticed in
Hans' daily build log.

@Mauro: Together with [1] and [2], everything that cumulated over time
is done now, with the only thing remaining being the IOCTL stuff which
we need to discuss and finalise.

[1] https://patchwork.linuxtv.org/patch/43202/
[2] https://patchwork.linuxtv.org/patch/43350/

Daniel Scheller (2):
  [media] dvb-frontends/stv0910: declare global list_head stvlist static
  [media] dvb-frontends/stv6111.c: return NULL instead of plain integer

 drivers/media/dvb-frontends/stv0910.c | 2 +-
 drivers/media/dvb-frontends/stv6111.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.13.0
