Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55364 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932597AbaDIMym (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Apr 2014 08:54:42 -0400
Date: Wed, 9 Apr 2014 13:53:54 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Rob Herring <robh+dt@kernel.org>,
	Rob Landley <rob@landley.net>,
	Denis Carikli <denis@eukrea.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>, arm@kernel.org
Subject: [PATCH 0/8] Current imx-drm queue
Message-ID: <20140409125354.GP16119@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

The following patches are those which I currently have queued up for
Greg for merging into his stable tree when he's next accepting patches.
If you have any concerns about these patches, please let me know in
a timely fashion.

I've re-ordered and cherry-picked some of Denis' patches, as I can't
take the patches which touch arch/arm/boot/dts.  Some other method is
going to have to be found to deal with those changes.

The unfortunate thing is that without the DT changes able to be merged
in a timely and sane manner, in a way which does not result in breaking
this driver, it pushes the point where we can finally think about moving
this driver out of drivers/staging back even further.

It seems arm-soc want to be obtuse, so let's let them be obtuse and show
what damage it does to being able to make progress.

Thanks.

Denis Carikli (3):
      imx-drm: Match ipu_di_signal_cfg's clk_pol with its description.
      v4l2: add new V4L2_PIX_FMT_RGB666 pixel format.
      imx-drm: Add RGB666 support for parallel display.

Fabio Estevam (2):
      imx-drm: ipu-dmfc: Remove unneeded 'dmfc' check
      imx-drm: imx-ldb: Use snprintf()

Philipp Zabel (3):
      imx-drm: Move IPU_PIX_FMT_GBR24 definition into imx-ipu-v3.h
      imx-drm: ipu-dc: Use usleep_range instead of msleep
      imx-drm: imx-ldb: Add drm_panel support

 Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml             | 39 +++++++++++++++++++++++++++++++++++++++
 Documentation/devicetree/bindings/staging/imx-drm/fsl-imx-drm.txt |  3 ++-
 drivers/staging/imx-drm/Kconfig                                   |  1 +
 drivers/staging/imx-drm/imx-drm.h                                 |  4 ----
 drivers/staging/imx-drm/imx-ldb.c                                 | 25 +++++++++++++++++++++++--
 drivers/staging/imx-drm/imx-tve.c                                 |  1 +
 drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h                       |  2 ++
 drivers/staging/imx-drm/ipu-v3/ipu-dc.c                           | 11 ++++++++++-
 drivers/staging/imx-drm/ipu-v3/ipu-di.c                           |  2 +-
 drivers/staging/imx-drm/ipu-v3/ipu-dmfc.c                         |  3 ---
 drivers/staging/imx-drm/ipuv3-crtc.c                              |  2 +-
 drivers/staging/imx-drm/parallel-display.c                        |  2 ++
 include/uapi/linux/videodev2.h                                    |  1 +
 13 files changed, 83 insertions(+), 13 deletions(-)


-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
