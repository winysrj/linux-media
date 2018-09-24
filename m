Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34554 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729127AbeIXS2m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Sep 2018 14:28:42 -0400
Date: Mon, 24 Sep 2018 09:26:39 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.19-rc5] media fixes
Message-ID: <20180924092639.6aaf8371@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greg,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.19-2

For some drivers and Kbuild fixes.

DISCLAIMER NOTE
========== ====

Please notice that this pull request complies with what's written at
Documentation/process/submitting-patches.rst with regards to meta-tags
like Acked-by and Signed-off-by. 

The patches in this series contain electronic addresses from people
that posted patches and/or replied to them using the usual Kernel
development workflow, e. g. without any explicit request to publish them. 

Feel free to ignore it if you feel it doesn't follow the new CoC.

Thanks!
Mauro

-


The following changes since commit 5b394b2ddf0347bef56e50c69a58773c94343ff3:

  Linux 4.19-rc1 (2018-08-26 14:11:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.19-2

for you to fetch changes up to 324493fba77500592bbaa66421729421f139d4b5:

  media: platform: fix cros-ec-cec build error (2018-09-17 14:32:29 -0400)

----------------------------------------------------------------
media fixes for v4.19-rc5

----------------------------------------------------------------
Arnd Bergmann (2):
      media: camss: mark PM functions as __maybe_unused
      media: camss: add missing includes

Hans Verkuil (2):
      media: video_function_calls.rst: drop obsolete video-set-attributes reference
      media: staging/media/mt9t031/Kconfig: remove bogus entry

Jacopo Mondi (1):
      media: i2c: mt9v111: Fix v4l2-ctrl error handling

Jozef Balga (1):
      media: af9035: prevent buffer overflow on write

Randy Dunlap (1):
      media: platform: fix cros-ec-cec build error

Todor Tomov (1):
      media: camss: Use managed memory allocations

 .../media/uapi/dvb/video_function_calls.rst        |  1 -
 drivers/media/i2c/mt9v111.c                        | 41 +++++++---------------
 drivers/media/platform/Kconfig                     |  2 ++
 drivers/media/platform/qcom/camss/camss-csid.c     |  1 +
 .../platform/qcom/camss/camss-csiphy-2ph-1-0.c     |  1 +
 .../platform/qcom/camss/camss-csiphy-3ph-1-0.c     |  1 +
 drivers/media/platform/qcom/camss/camss-csiphy.c   |  1 +
 drivers/media/platform/qcom/camss/camss-ispif.c    |  5 +--
 drivers/media/platform/qcom/camss/camss-vfe-4-1.c  |  1 +
 drivers/media/platform/qcom/camss/camss-vfe-4-7.c  |  1 +
 drivers/media/platform/qcom/camss/camss.c          | 15 ++++----
 drivers/media/usb/dvb-usb-v2/af9035.c              |  6 ++--
 drivers/staging/media/mt9t031/Kconfig              |  6 ----
 13 files changed, 36 insertions(+), 46 deletions(-)
