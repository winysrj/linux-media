Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38140 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752029AbdB1QR2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 11:17:28 -0500
Received: by mail-wm0-f51.google.com with SMTP id u199so15896548wmd.1
        for <linux-media@vger.kernel.org>; Tue, 28 Feb 2017 08:17:27 -0800 (PST)
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v3 0/2] media: dt-bindings: extend the vpif bindings
Date: Tue, 28 Feb 2017 17:08:52 +0100
Message-Id: <1488298134-6200-1-git-send-email-bgolaszewski@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series adds pdata quirks and other changes required to make vpif
work on the da850-evm board.

v1 -> v2:
- added patch 3/3
- specified the purpose of port@0 and port@1 nodes

v2 -> v3:
- removed patch 3/3 - it may take some more time to determine the
  correct solution for enable-gpios, so I decided to respin the
  series without it and send it later as a follow-up
- added Rob Herring's acks

Bartosz Golaszewski (2):
  media: dt-bindings: vpif: fix whitespace errors
  media: dt-bindings: vpif: extend the example with an output port

 .../devicetree/bindings/media/ti,da850-vpif.txt    | 50 ++++++++++++++++------
 1 file changed, 37 insertions(+), 13 deletions(-)

-- 
2.9.3
