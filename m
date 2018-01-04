Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60214 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752159AbeADKTY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Jan 2018 05:19:24 -0500
Date: Thu, 4 Jan 2018 12:19:21 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: yong.zhi@intel.com
Subject: [GIT PULL for 4.16] Intel IPU3 CIO2 fixes, cleanup
Message-ID: <20180104101921.h7lbi2rsekvqpr4c@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are a bunch of fixes for the Intel IPU3 CIO2 driver, as well as the
cleanup I wrote earlier.

Please pull.


The following changes since commit d0c8f6ad8b381dd572576ac50b9696d4d31142bb:

  media: imx: fix breakages when compiling for arm (2017-12-29 14:55:41 -0500)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git ipu3

for you to fetch changes up to ec9d117f472d27289bf0e845b325e5852d5799dd:

  media: intel-ipu3: cio2: fix for wrong vb2buf state warnings (2018-01-04 12:14:28 +0200)

----------------------------------------------------------------
Arnd Bergmann (2):
      media: intel-ipu3: cio2: mark PM functions as __maybe_unused
      media: intel-ipu3: cio2: fix building with large PAGE_SIZE

Sakari Ailus (1):
      intel-ipu3: Rename arr_size macro, use min

Yong Zhi (2):
      media: intel-ipu3: cio2: fix a crash with out-of-bounds access
      media: intel-ipu3: cio2: fix for wrong vb2buf state warnings

 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 31 ++++++++++++++++---------------
 drivers/media/pci/intel/ipu3/ipu3-cio2.h |  2 +-
 2 files changed, 17 insertions(+), 16 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
