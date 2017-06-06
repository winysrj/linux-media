Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:36270 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751437AbdFFXhn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Jun 2017 19:37:43 -0400
Received: by mail-pf0-f174.google.com with SMTP id x63so4908011pff.3
        for <linux-media@vger.kernel.org>; Tue, 06 Jun 2017 16:37:43 -0700 (PDT)
From: Kevin Hilman <khilman@baylibre.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: Sekhar Nori <nsekhar@ti.com>, David Lechner <david@lechnology.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Benoit Parrot <bparrot@ti.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 0/4] [media] davinci: vpif_capture: raw camera support
Date: Tue,  6 Jun 2017 16:37:37 -0700
Message-Id: <20170606233741.26718-1-khilman@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Same as v1, just rebased onto master branch of media tree, as
requested by Hans.

This series fixes/updates the support for raw camera input to the VPIF.

Tested on da850-evm boards using the add-on UI board.  Tested with
both composite video input (on-board tvp514x) and raw camera input
using the camera board from On-Semi based on the aptina,mt9v032
sensor[1], as this was the only camera board with the right connector
for the da850-evm UI board.

Verified that composite video capture is still working well after these
updates.

[1] http://www.mouser.com/search/ProductDetail.aspx?R=0virtualkey0virtualkeyMT9V032C12STCH-GEVB

Kevin Hilman (4):
  [media] davinci: vpif_capture: drop compliance hack
  [media] davinci: vpif_capture: get subdevs from DT when available
  [media] davinci: vpif_capture: cleanup raw camera support
  [media] davinci: vpif: adaptions for DT support

 drivers/media/platform/davinci/vpif.c         |  49 +++++-
 drivers/media/platform/davinci/vpif_capture.c | 223 +++++++++++++++++++++++---
 drivers/media/platform/davinci/vpif_display.c |   5 +
 include/media/davinci/vpif_types.h            |   9 +-
 4 files changed, 262 insertions(+), 24 deletions(-)

-- 
2.9.3
