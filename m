Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39311 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031384AbbEEJbB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 05:31:01 -0400
Date: Tue, 5 May 2015 06:30:55 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.1-rc3] media fixes
Message-ID: <20150505063055.054b0057@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.1-3


For 3 driver fixes:

- one fix for omap4, fixing a regression due to a subsystem API that
  got removed for 4.1 (commit efde234674d9);
- one fix for one of the formats supported by Marvel ccic driver;
- one fix on rcar_vin driver that, when stopping abnormally, the driver
  can't return from wait_for_completion.

Thanks!
Mauro

-

The following changes since commit 64131a87f2aae2ed9e05d8227c5b009ca6c50d98:

  Merge branch 'drm-next-merged' of git://people.freedesktop.org/~airlied/linux into v4l_for_linus (2015-04-21 09:44:55 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.1-3

for you to fetch changes up to fefad2d54beb8aad6bf4ac6daeb74f86f52565de:

  [media] v4l: omap4iss: Replace outdated OMAP4 control pad API with syscon (2015-04-28 08:38:23 -0300)

----------------------------------------------------------------
media fixes for v4.1-rc3

----------------------------------------------------------------
Hans Verkuil (1):
      [media] marvell-ccic: fix Y'CbCr ordering

Koji Matsuoka (1):
      [media] media: soc_camera: rcar_vin: Fix wait_for_completion

Laurent Pinchart (1):
      [media] v4l: omap4iss: Replace outdated OMAP4 control pad API with syscon

 drivers/media/platform/marvell-ccic/mcam-core.c | 14 +++++++-------
 drivers/media/platform/marvell-ccic/mcam-core.h |  8 ++++----
 drivers/media/platform/soc_camera/rcar_vin.c    |  7 ++++++-
 drivers/staging/media/omap4iss/Kconfig          |  1 +
 drivers/staging/media/omap4iss/iss.c            | 11 +++++++++++
 drivers/staging/media/omap4iss/iss.h            |  4 ++++
 drivers/staging/media/omap4iss/iss_csiphy.c     | 12 +++++++-----
 7 files changed, 40 insertions(+), 17 deletions(-)

