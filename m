Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:51659 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756552AbeDXIYd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 04:24:33 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Luca Ceresoli <luca@lucaceresoli.net>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/13] media: imx274: cleanups, improvements and SELECTION API support
Date: Tue, 24 Apr 2018 10:24:05 +0200
Message-Id: <1524558258-530-1-git-send-email-luca@lucaceresoli.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

this patchset introduces cropping support for the Sony IMX274 sensor
using the SELECTION API.

With respect to v1 this patchset adds the "media: " prefix to commits
and fixes a warning in patch 9.

Patches 1-6 clean up and restructure code in various places and are
pretty much independent from the cropping feature.

Patches 7-11 are further restructuring which are mostly useful to
implement cropping API in a cleaner way.

Patch 12 introduces a helper to allow setting many registers computed
at runtime in a straightforward way. This would not have been very
useful before because all long register write sequences came from
const tables, but it's definitely a must for the cropping code.

Patch 13 implements cropping in the set_selection pad operation. On
the v4l2 side there is nothing special. The most tricky part was
respecting all the device constraints on the horizontal crop.

Regards,
Luca

Luca Ceresoli (13):
  media: imx274: document reset delays more clearly
  media: imx274: fix typo in comment
  media: imx274: slightly simplify code
  media: imx274: remove unused data from struct imx274_frmfmt
  media: imx274: rename and reorder register address definitions
  media: imx274: remove non-indexed pointers from mode_table
  media: imx274: initialize format before v4l2 controls
  media: imx274: consolidate per-mode data in imx274_frmfmt
  media: imx274: get rid of mode_index
  media: imx274: actually use IMX274_DEFAULT_MODE
  media: imx274: simplify imx274_write_table()
  media: imx274: add helper function to fill a reg_8 table chunk
  media: imx274: add SELECTION support for cropping

 drivers/media/i2c/imx274.c | 598 ++++++++++++++++++++++++++-------------------
 1 file changed, 348 insertions(+), 250 deletions(-)

-- 
2.7.4
