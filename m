Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:35737 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754772AbcK2X5P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Nov 2016 18:57:15 -0500
Received: by mail-pf0-f173.google.com with SMTP id i88so34649379pfk.2
        for <linux-media@vger.kernel.org>; Tue, 29 Nov 2016 15:57:14 -0800 (PST)
From: Kevin Hilman <khilman@baylibre.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-arm-kernel@lists.infradead.org, Sekhar Nori <nsekhar@ti.com>,
        Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH v4 0/4] davinci: VPIF: add DT support
Date: Tue, 29 Nov 2016 15:57:08 -0800
Message-Id: <20161129235712.29846-1-khilman@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add DT support, including getting subdevs from DT ports/endpoints.

Tested video capture to memory on da850-lcdk board using composite
input.

Changes since v3:
- move to a single VPIF node, DT binding updated accordingly
- misc fixes/updates based on reviews from Sakari

Changes since v2:
- DT binding doc: fix example to use correct compatible

Changes since v1:
- more specific compatible strings, based on SoC: ti,da850-vpif*
- fix locking bug when unlocking over subdev s_stream


Kevin Hilman (4):
  [media] davinci: vpif_capture: don't lock over s_stream
  [media] davinci: VPIF: add basic support for DT init
  [media] davinci: vpif_capture: get subdevs from DT
  [media] dt-bindings: add TI VPIF documentation

 .../devicetree/bindings/media/ti,da850-vpif.txt    |  67 ++++++++++
 drivers/media/platform/davinci/vpif.c              |  48 ++++++-
 drivers/media/platform/davinci/vpif_capture.c      | 147 ++++++++++++++++++++-
 drivers/media/platform/davinci/vpif_display.c      |   6 +
 include/media/davinci/vpif_types.h                 |   9 +-
 5 files changed, 270 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/ti,da850-vpif.txt

-- 
2.9.3

