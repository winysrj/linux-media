Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:33585 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752165AbcJYXzi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Oct 2016 19:55:38 -0400
Received: by mail-pf0-f173.google.com with SMTP id 197so3668977pfu.0
        for <linux-media@vger.kernel.org>; Tue, 25 Oct 2016 16:55:38 -0700 (PDT)
From: Kevin Hilman <khilman@baylibre.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: Sekhar Nori <nsekhar@ti.com>, Axel Haslam <ahaslam@baylibre.com>,
        =?UTF-8?q?Bartosz=20Go=C5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 0/6] media: davinci: VPIF: add DT support
Date: Tue, 25 Oct 2016 16:55:30 -0700
Message-Id: <20161025235536.7342-1-khilman@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series attempts to add DT support to the davinci VPIF capture
driver.

I'm not sure I've completely grasped the proper use of the ports and
endpoints stuff, so this RFC is primarily to get input on whether I'm
on the right track.

The last patch is the one where all my questions are, the rest are
just prep work to ge there.

Tested on da850-lcdk and was able to do basic frame capture from the
composite input.

Series applies on v4.9-rc1

Kevin Hilman (6):
  [media] davinci: add support for DT init
  ARM: davinci: da8xx: VPIF: enable DT init
  ARM: dts: davinci: da850: add VPIF
  ARM: dts: davinci: da850-lcdk: enable VPIF capture
  [media] davinci: vpif_capture: don't lock over s_stream
  [media] davinci: vpif_capture: get subdevs from DT

 arch/arm/boot/dts/da850-lcdk.dts              |  30 ++++++
 arch/arm/boot/dts/da850.dtsi                  |  28 +++++
 arch/arm/mach-davinci/da8xx-dt.c              |  17 +++
 drivers/media/platform/davinci/vpif.c         |   9 ++
 drivers/media/platform/davinci/vpif_capture.c | 150 +++++++++++++++++++++++++-
 include/media/davinci/vpif_types.h            |   9 +-
 6 files changed, 236 insertions(+), 7 deletions(-)

-- 
2.9.3

