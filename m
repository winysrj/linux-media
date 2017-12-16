Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:45977 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753577AbdLPMYy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Dec 2017 07:24:54 -0500
Received: by mail-wm0-f66.google.com with SMTP id 9so21800621wme.4
        for <linux-media@vger.kernel.org>; Sat, 16 Dec 2017 04:24:54 -0800 (PST)
From: Athanasios Oikonomou <athoik@gmail.com>
To: linux-media@vger.kernel.org
Cc: Athanasios Oikonomou <athoik@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ralph Metzler <rjkm@metzlerbros.de>,
        Manu Abraham <abraham.manu@gmail.com>
Subject: [PATCH 0/2] Support Physical Layer Scrambling
Date: Sat, 16 Dec 2017 14:23:37 +0200
Message-Id: <cover.1513426880.git.athoik@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A new property DTV_SCRAMBLING_SEQUENCE_INDEX introduced to control
the gold sequence that several demods support.

Also the DVB API was increased in order userspace to be aware of the
changes.

The stv090x driver was changed to make use of the new property.

Those commits based on discussion previously made on the mailling list.
https://www.mail-archive.com/linux-media@vger.kernel.org/msg122600.html

I would like to thanks Ralph Metzler (rjkm@metzlerbros.de) for the
great help and ideas he provide me in order create those patches.

Athanasios Oikonomou (2):
  media: dvb_frontend: add physical layer scrambling support
  media: stv090x: add physical layer scrambling support

 .../media/uapi/dvb/fe_property_parameters.rst          | 18 ++++++++++++++++++
 .../uapi/dvb/frontend-property-satellite-systems.rst   |  2 ++
 drivers/media/dvb-core/dvb_frontend.c                  | 12 ++++++++++++
 drivers/media/dvb-core/dvb_frontend.h                  |  5 +++++
 drivers/media/dvb-frontends/stv090x.c                  | 16 ++++++++++++++++
 include/uapi/linux/dvb/frontend.h                      |  5 ++++-
 include/uapi/linux/dvb/version.h                       |  2 +-
 7 files changed, 58 insertions(+), 2 deletions(-)

-- 
2.1.4
