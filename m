Return-path: <linux-media-owner@vger.kernel.org>
Received: from o1682455182.outbound-mail.sendgrid.net ([168.245.5.182]:43633
        "EHLO o1682455182.outbound-mail.sendgrid.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750970AbeAVMtx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 07:49:53 -0500
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH 0/2] Add support for i2c_new_secondary_device
Date: Mon, 22 Jan 2018 12:49:52 +0000 (UTC)
Message-Id: <1516625389-6362-1-git-send-email-kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
content-transfer-encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Back in 2014, Jean-Michel provided patches [0] to implement a means of=0D
describing software defined I2C addresses for devices through the DT nodes.=
=0D
=0D
The patch to implement the function "i2c_new_secondary_device()" was integr=
ated,=0D
but the corresponding driver update didn't get applied.=0D
=0D
This short series re-bases Jean-Michel's patch to mainline for the ADV7604 =
driver=0D
in linux-media, and also provides a patch for the ADV7511 DRM Bridge driver=
 taking=0D
the same approach.=0D
=0D
This series allows us to define the I2C address allocations of these device=
s in=0D
the device tree for the Renesas D3 platform where these two devices reside =
on=0D
the same bus and conflict with each other presently..=0D
=0D
[0] https://lkml.org/lkml/2014/10/22/468=0D
[1] https://lkml.org/lkml/2014/10/22/469=0D
=0D
Jean-Michel Hautbois (1):=0D
  media: adv7604: Add support for i2c_new_secondary_device=0D
=0D
Kieran Bingham (1):=0D
  drm: adv7511: Add support for i2c_new_secondary_device=0D
=0D
 .../bindings/display/bridge/adi,adv7511.txt        | 10 +++-=0D
 .../devicetree/bindings/media/i2c/adv7604.txt      | 18 ++++++-=0D
 drivers/gpu/drm/bridge/adv7511/adv7511.h           |  4 ++=0D
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       | 36 ++++++++-----=0D
 drivers/media/i2c/adv7604.c                        | 60 ++++++++++++++----=
----=0D
 5 files changed, 92 insertions(+), 36 deletions(-)=0D
=0D
-- =0D
2.7.4=0D
