Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:35807 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754185AbcKVBoT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Nov 2016 20:44:19 -0500
Received: by mail-pg0-f45.google.com with SMTP id p66so1562669pga.2
        for <linux-media@vger.kernel.org>; Mon, 21 Nov 2016 17:44:11 -0800 (PST)
From: Kevin Hilman <khilman@baylibre.com>
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Cc: devicetree@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Axel Haslam <ahaslam@baylibre.com>,
        =?UTF-8?q?Bartosz=20Go=C5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>
Subject: [PATCH v2 0/4] [media] davinci: VPIF: add DT support
Date: Mon, 21 Nov 2016 17:44:04 -0800
Message-Id: <20161122014408.22388-1-khilman@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add DT support, including getting subdevs from DT ports/endpoints.

Changes since v1:
- more specific compatible strings, based on SoC: ti,da850-vpif*
- fix locking bug when unlocking over subdev s_stream

Kevin Hilman (4):
  [media] davinci: add support for DT init
  [media] davinci: vpif_capture: don't lock over s_stream
  [media] davinci: vpif_capture: get subdevs from DT
  [media] dt-bindings: add TI VPIF documentation

 .../bindings/media/ti,da850-vpif-capture.txt       |  65 +++++++++
 .../devicetree/bindings/media/ti,da850-vpif.txt    |   8 ++
 drivers/media/platform/davinci/vpif.c              |   9 ++
 drivers/media/platform/davinci/vpif_capture.c      | 147 ++++++++++++++++++++-
 include/media/davinci/vpif_types.h                 |   9 +-
 5 files changed, 232 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/ti,da850-vpif-capture.txt
 create mode 100644 Documentation/devicetree/bindings/media/ti,da850-vpif.txt

-- 
2.9.3

