Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34731 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751255AbeCMWSJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 18:18:09 -0400
Received: by mail-wr0-f196.google.com with SMTP id o8so2544858wra.1
        for <linux-media@vger.kernel.org>; Tue, 13 Mar 2018 15:18:09 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: rascobie@slingshot.co.nz
Subject: [PATCH v3 0/3] Add FEC rates, S2X params and 64K transmission
Date: Tue, 13 Mar 2018 23:18:02 +0100
Message-Id: <20180313221805.26818-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Note: This v3 doesn't yet implement anything to allow userspace to detect
bits regarding S2X, nor does it implement anything new to report frontend
capabilities. At the moment, the main purpose for this is to enable any
demod frontend to report the current signal parameters more accurate.
Right now this (partially) is for the stv0910 demod, and with additional
hardware currently in development in mind which supports more S2X bits.
There's quite a lot missing from fe_caps right now which almost all
demods autodetect anyway, so let's at least properly report signal stats.

dddvb brings a few additional FEC rates (1/4 and 1/3), 64/128/256APSK
modulations and more rolloff factors (DVB-S2X), and 64K transmission mode
(DVB-T2). These rather trivial patches bring them to mainline, and puts
these missing bits into the stv0910's get_frontend() callback (FEC 1/4
and 1/3 are handled throughout the rest of the demod driver already). In
addition (as suggestion from Richard Scobie), the stv0910 driver now
reports it's active delivery system.

Changes from v2 to v3:
- API bits squashed into one commit, stv0910 changes squashed into another
  single commit
- DVB-S2X related bits added to the uAPI docs
- DVB API bumped to v5.12

Changes from v1 to v2:
- DVB-S2X rolloff factors and reporting
- report of the active delivery system in stv0910:get_frontend()

Daniel Scheller (3):
  [media] dvb_frontend: add S2X and misc. other enums
  [media] docs: documentation bits for S2X and the 64K transmission mode
  [media] dvb-frontends/stv0910: more detailed reporting in
    get_frontend()

 Documentation/media/frontend.h.rst.exceptions      |  9 ++++
 .../media/uapi/dvb/fe_property_parameters.rst      | 50 ++++++++++++++--------
 .../dvb/frontend-property-satellite-systems.rst    |  8 ++--
 drivers/media/dvb-core/dvb_frontend.c              |  9 ++++
 drivers/media/dvb-frontends/stv0910.c              | 16 ++++---
 include/uapi/linux/dvb/frontend.h                  | 29 ++++++++++---
 include/uapi/linux/dvb/version.h                   |  2 +-
 7 files changed, 90 insertions(+), 33 deletions(-)

-- 
2.16.1
