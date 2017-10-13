Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35608 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751081AbdJMWd6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 18:33:58 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 2884E600EE
        for <linux-media@vger.kernel.org>; Sat, 14 Oct 2017 01:33:57 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1e38Wi-00031s-63
        for linux-media@vger.kernel.org; Sat, 14 Oct 2017 01:33:56 +0300
Date: Sat, 14 Oct 2017 01:33:55 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.15] Atomisp cleanups
Message-ID: <20171013223355.pircr25cwyxg6mvl@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's the usual set of atomisp cleanups.

Please pull.


The following changes since commit 8382e556b1a2f30c4bf866f021b33577a64f9ebf:

  Simplify major/minor non-dynamic logic (2017-10-11 15:32:11 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git atomisp

for you to fetch changes up to 9c55caa37197e80b14250ff5709ce49737ed812c:

  staging: atomisp: use ARRAY_SIZE (2017-10-14 00:55:45 +0300)

----------------------------------------------------------------
Jérémy Lefaure (1):
      staging: atomisp: use ARRAY_SIZE

Muhammad Falak R Wani (1):
      staging/atomisp: make six local functions static to appease sparse

Sakari Ailus (3):
      staging: media: MAINTAINERS: Add entry for atomisp driver
      staging: atomisp: Add driver prefix to Kconfig option and module names
      staging: atomisp: Update TODO regarding sensors

 MAINTAINERS                                        |  7 +++++++
 drivers/staging/media/atomisp/TODO                 | 22 +++++++++++++++-------
 drivers/staging/media/atomisp/i2c/Kconfig          | 18 +++++++++---------
 drivers/staging/media/atomisp/i2c/Makefile         | 20 ++++++++++----------
 .../atomisp/i2c/{ap1302.c => atomisp-ap1302.c}     |  0
 .../atomisp/i2c/{gc0310.c => atomisp-gc0310.c}     |  0
 .../atomisp/i2c/{gc2235.c => atomisp-gc2235.c}     |  0
 ...bmsrlisthelper.c => atomisp-libmsrlisthelper.c} |  0
 .../atomisp/i2c/{lm3554.c => atomisp-lm3554.c}     |  0
 .../atomisp/i2c/{mt9m114.c => atomisp-mt9m114.c}   |  0
 .../atomisp/i2c/{ov2680.c => atomisp-ov2680.c}     |  0
 .../atomisp/i2c/{ov2722.c => atomisp-ov2722.c}     |  0
 drivers/staging/media/atomisp/i2c/imx/Kconfig      |  4 ++--
 drivers/staging/media/atomisp/i2c/imx/Makefile     |  8 ++++----
 drivers/staging/media/atomisp/i2c/ov5693/Kconfig   |  2 +-
 drivers/staging/media/atomisp/i2c/ov5693/Makefile  |  2 +-
 .../i2c/ov5693/{ov5693.c => atomisp-ov5693.c}      |  0
 .../css2400/camera/pipe/src/pipe_binarydesc.c      |  9 +++------
 .../media/atomisp/pci/atomisp2/hmm/hmm_bo.c        | 14 +++++++-------
 19 files changed, 59 insertions(+), 47 deletions(-)
 rename drivers/staging/media/atomisp/i2c/{ap1302.c => atomisp-ap1302.c} (100%)
 rename drivers/staging/media/atomisp/i2c/{gc0310.c => atomisp-gc0310.c} (100%)
 rename drivers/staging/media/atomisp/i2c/{gc2235.c => atomisp-gc2235.c} (100%)
 rename drivers/staging/media/atomisp/i2c/{libmsrlisthelper.c => atomisp-libmsrlisthelper.c} (100%)
 rename drivers/staging/media/atomisp/i2c/{lm3554.c => atomisp-lm3554.c} (100%)
 rename drivers/staging/media/atomisp/i2c/{mt9m114.c => atomisp-mt9m114.c} (100%)
 rename drivers/staging/media/atomisp/i2c/{ov2680.c => atomisp-ov2680.c} (100%)
 rename drivers/staging/media/atomisp/i2c/{ov2722.c => atomisp-ov2722.c} (100%)
 rename drivers/staging/media/atomisp/i2c/ov5693/{ov5693.c => atomisp-ov5693.c} (100%)

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
