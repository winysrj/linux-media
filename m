Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:46625 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752775AbeDLQvd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 12:51:33 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Luca Ceresoli <luca@lucaceresoli.net>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/13] imx274: add cropping and misc improvements
Date: Thu, 12 Apr 2018 18:51:05 +0200
Message-Id: <1523551878-15754-1-git-send-email-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

this patchset introduces cropping support for the Sony IMX274 sensor
using the SELECTION API, after several cleanups and general code
improvements.

Patches 1-6 clean up and restructure code in various places and are
pretty much independent from the cropping feature.

Patches 7-11 are further restructuring which are mostly useful to
implement cropping API in a cleaner way.

Patch 12 introduces a helper to allow setting many registers computed
at runtime in a straightforward way. This would not have been very
useful before because all long register write sequences came from
const tables, but it's definitely a must for the cropping code.

Patch 13 implements cropping in the set_selection pad operation. On
the v4l2 side there is nothing special, it fit nicely in the existing
infrastructure. The most tricky part was respecting all the device
constraints on the horizontal crop.

Regards,
Luca

Luca Ceresoli (13):
  imx274: document reset delays more clearly
  imx274: fix typo in comment
  imx274: slightly simplify code
  imx274: remove unused data from struct imx274_frmfmt
  imx274: rename and reorder register address definitions
  imx274: remove non-indexed pointers from mode_table
  imx274: initialize format before v4l2 controls
  imx274: consolidate per-mode data in imx274_frmfmt
  imx274: get rid of mode_index
  imx274: actually use IMX274_DEFAULT_MODE
  imx274: simplify imx274_write_table()
  imx274: add helper function to fill a reg_8 table chunk
  imx274: add SELECTION support for cropping

 drivers/media/i2c/imx274.c | 600 ++++++++++++++++++++++++++-------------------
 1 file changed, 349 insertions(+), 251 deletions(-)

-- 
2.7.4
