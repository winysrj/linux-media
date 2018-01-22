Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:38605 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbeAVRNv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 12:13:51 -0500
Received: by mail-wm0-f66.google.com with SMTP id 141so18209377wme.3
        for <linux-media@vger.kernel.org>; Mon, 22 Jan 2018 09:13:51 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: rascobie@slingshot.co.nz
Subject: [PATCH v2 0/5] Add FEC rates, S2X params and 64K transmission
Date: Mon, 22 Jan 2018 18:13:41 +0100
Message-Id: <20180122171346.822-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

dddvb brings a few additional FEC rates (1/4 and 1/3), 64/128/256APSK
modulations and more rolloff factors (DVB-S2X), and 64K transmission mode
(DVB-T2). These rather trivial patches bring them to mainline, and puts
these missing bits into the stv0910's get_frontend() callback (FEC 1/4
and 1/3 are handled throughout the rest of the demod driver already). In
addition (as suggestion from Richard Scobie), the stv0910 driver now
reports it's active delivery system.

Changes from v1 to v2:
- DVB-S2X rolloff factors and reporting
- report of the active delivery system in stv0910:get_frontend()

Daniel Scheller (5):
  media: dvb_frontend: add FEC modes, S2X modulations and 64K
    transmission
  media: dvb_frontend: add DVB-S2X rolloff factors
  media: dvb-frontends/stv0910: report FEC 1/4 and 1/3 in get_frontend()
  media: dvb-frontends/stv0910: report S2 rolloff in get_frontend()
  media: dvb-frontends/stv0910: report active delsys in get_frontend()

 Documentation/media/frontend.h.rst.exceptions |  9 +++++++++
 drivers/media/dvb-core/dvb_frontend.c         |  9 +++++++++
 drivers/media/dvb-frontends/stv0910.c         | 16 ++++++++++-----
 include/uapi/linux/dvb/frontend.h             | 29 ++++++++++++++++++++++-----
 4 files changed, 53 insertions(+), 10 deletions(-)

-- 
2.13.6
