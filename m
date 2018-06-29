Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53810 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932070AbeF2MxY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 08:53:24 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id A5403634C80
        for <linux-media@vger.kernel.org>; Fri, 29 Jun 2018 15:53:22 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1fYstu-0001Bi-ES
        for linux-media@vger.kernel.org; Fri, 29 Jun 2018 15:53:22 +0300
Date: Fri, 29 Jun 2018 15:53:22 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.19] ak7375 driver, imx274 improvements
Message-ID: <20180629125322.rdlrvkrjuhozjash@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's a new driver for the ak7375 VCM and improvements for imx274.

Please pull.


The following changes since commit 3c4a737267e89aafa6308c6c456d2ebea3fcd085:

  media: ov5640: fix frame interval enumeration (2018-06-28 09:24:38 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.19-2

for you to fetch changes up to d41713e25e7dd52d7e48228072438715660ebe6f:

  media: imx274: fix typo (2018-06-29 12:33:16 +0300)

----------------------------------------------------------------
Bingbu Cao (2):
      dt-bindings: Add bindings for AKM ak7375 voice coil lens
      media: ak7375: Add ak7375 lens voice coil driver

Luca Ceresoli (6):
      media: imx274: initialize format before v4l2 controls
      media: imx274: consolidate per-mode data in imx274_frmfmt
      media: imx274: get rid of mode_index
      media: imx274: actually use IMX274_DEFAULT_MODE
      media: imx274: simplify imx274_write_table()
      media: imx274: fix typo

 .../devicetree/bindings/media/i2c/ak7375.txt       |   8 +
 MAINTAINERS                                        |   8 +
 drivers/media/i2c/Kconfig                          |  10 +
 drivers/media/i2c/Makefile                         |   1 +
 drivers/media/i2c/ak7375.c                         | 292 +++++++++++++++++++++
 drivers/media/i2c/imx274.c                         | 194 ++++++--------
 6 files changed, 406 insertions(+), 107 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ak7375.txt
 create mode 100644 drivers/media/i2c/ak7375.c

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
