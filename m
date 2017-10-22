Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49812 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932108AbdJVVzV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 22 Oct 2017 17:55:21 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id E8A0A600FD
        for <linux-media@vger.kernel.org>; Mon, 23 Oct 2017 00:55:19 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1e6ODH-0002PR-AL
        for linux-media@vger.kernel.org; Mon, 23 Oct 2017 00:55:19 +0300
Date: Mon, 23 Oct 2017 00:55:19 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.15 v3] Atomisp oops fix
Message-ID: <20171022215518.wiqtlt3wyb5jemzu@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Mauro,

This pull request includes two fixes for the atomisp driver. This replaces
the earlier atomisp pull request.

Please pull.


The following changes since commit 61065fc3e32002ba48aa6bc3816c1f6f9f8daf55:

  Merge commit '3728e6a255b5' into patchwork (2017-10-17 17:22:20 -0700)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git atomisp-fix

for you to fetch changes up to 50cc0a2f7853e78395a47aaa4b63103f9d69c69e:

  staging: atomisp2: cleanup null check on memory allocation (2017-10-23 00:34:41 +0300)

----------------------------------------------------------------
Aishwarya Pant (1):
      staging: atomisp2: cleanup null check on memory allocation

Hans de Goede (1):
      staging: media: atomisp: Fix oops by unbalanced clk enable/disable call

 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    | 36 +++++++++++-----------
 .../atomisp/pci/atomisp2/css2400/sh_css_firmware.c |  7 ++---
 .../pci/atomisp2/css2400/sh_css_param_shading.c    |  2 +-
 .../platform/intel-mid/atomisp_gmin_platform.c     |  7 +++++
 4 files changed, 29 insertions(+), 23 deletions(-)


-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
