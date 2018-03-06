Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:47080 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932656AbeCFRql (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2018 12:46:41 -0500
Received: by mail-wr0-f196.google.com with SMTP id m12so21793311wrm.13
        for <linux-media@vger.kernel.org>; Tue, 06 Mar 2018 09:46:40 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 0/2] ngene CI TS fixup
Date: Tue,  6 Mar 2018 18:46:35 +0100
Message-Id: <20180306174637.24618-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Remainder of the ngene updates series, taking care of the TS buffer offset
shift which occurs in conjunction with CICAM hardware during CAM inits.

Changed as requested to get rid of the DEBUG_CI_XFER ifdeffery.

This might aswell be considered a v3 of [1], but as 10 of 12 patches were
merged already, these two patches can be treated separate.

[1] https://www.spinics.net/lists/linux-media/msg129606.html

Daniel Scheller (2):
  [media] ngene: move the tsin_exchange() stripcopy block into a
    function
  [media] ngene: compensate for TS buffer offset shifts

 drivers/media/pci/ngene/ngene-dvb.c | 126 ++++++++++++++++++++++++++++--------
 drivers/media/pci/ngene/ngene.h     |   3 +
 2 files changed, 102 insertions(+), 27 deletions(-)

-- 
2.16.1
