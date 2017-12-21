Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:41050 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751866AbdLUUX3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Dec 2017 15:23:29 -0500
Received: by mail-wm0-f65.google.com with SMTP id g75so18406175wme.0
        for <linux-media@vger.kernel.org>; Thu, 21 Dec 2017 12:23:28 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: rjkm@metzlerbros.de
Subject: [PATCH 0/2] Add FEC rates, S2X modulations and 64K transmission
Date: Thu, 21 Dec 2017 21:23:19 +0100
Message-Id: <20171221202321.30539-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

As the DVB API is bumped to 5.11 for the next cycle.

dddvb brings a few additional FEC rates (1/4 and 1/3), 64/128/256APSK
modulations (DVB-S2X) and the 64K transmission mode. These two rather
trivial patches bring them to mainline, and puts these missing bits
into the stv0910's get_frontend() callback (FEC 1/4 and 1/3 are handled
throughout the rest of the demod driver already).

Let's have these enums as a part of DVB core 5.11.

Daniel Scheller (2):
  media: dvb_frontend: add FEC modes, S2X modulations and 64K
    transmission
  media: dvb-frontends/stv0910: report FEC 1/4 and 1/3 in get_frontend()

 Documentation/media/frontend.h.rst.exceptions |  6 ++++++
 drivers/media/dvb-frontends/stv0910.c         |  2 +-
 include/uapi/linux/dvb/frontend.h             | 13 +++++++++++++
 3 files changed, 20 insertions(+), 1 deletion(-)

-- 
2.13.6
