Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59496 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752814AbeEUKQP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 06:16:15 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id D25A6634C85
        for <linux-media@vger.kernel.org>; Mon, 21 May 2018 13:16:13 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1fKhrR-0001RO-KE
        for linux-media@vger.kernel.org; Mon, 21 May 2018 13:16:13 +0300
Date: Mon, 21 May 2018 13:16:13 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.18] Renesas R-Car CSI-2 receiver driver
Message-ID: <20180521101613.czfpo65o32ejowib@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's the driver for the Renesas R-Car CSI-2 receiver.

Please pull.


The following changes since commit 8ed8bba70b4355b1ba029b151ade84475dd12991:

  media: imx274: remove non-indexed pointers from mode_table (2018-05-17 06:22:08 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.18-6

for you to fetch changes up to defb00ec395644ba5a5423e7f59254a253c7755b:

  rcar-csi2: set default format if a unsupported one is requested (2018-05-17 13:56:39 +0300)

----------------------------------------------------------------
Niklas Söderlund (3):
      rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver documentation
      rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver driver
      rcar-csi2: set default format if a unsupported one is requested

 .../bindings/media/renesas,rcar-csi2.txt           |  101 ++
 MAINTAINERS                                        |    1 +
 drivers/media/platform/rcar-vin/Kconfig            |   12 +
 drivers/media/platform/rcar-vin/Makefile           |    1 +
 drivers/media/platform/rcar-vin/rcar-csi2.c        | 1084 ++++++++++++++++++++
 5 files changed, 1199 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
 create mode 100644 drivers/media/platform/rcar-vin/rcar-csi2.c

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
