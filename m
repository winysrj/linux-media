Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:55122 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751583AbcD2Knl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 06:43:41 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.7] Add new rcar-vin driver
Message-ID: <57233AD8.1030800@xs4all.nl>
Date: Fri, 29 Apr 2016 12:43:36 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This adds the new non-soc-camera rcar-vin driver, deprecating the older driver.

Tested with my Koelsch board.

This patch just marks the old driver as DEPRECATED.

I am unsure what is better:

1) just mark as DEPRECATED and remove it in the next kernel
2) move it to drivers/staging/media and remove it in the next kernel
3) just remove it now

I have no strong preference myself.

Regards,

	Hans

The following changes since commit 45c175c4ae9695d6d2f30a45ab7f3866cfac184b:

  [media] tw686x: avoid going past array (2016-04-26 06:38:53 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git rcar

for you to fetch changes up to dd34ebe6deb4162993efb5de12b0418354ee5173:

  rcar-vin: add Renesas R-Car VIN driver (2016-04-29 12:13:16 +0200)

----------------------------------------------------------------
Niklas Söderlund (1):
      rcar-vin: add Renesas R-Car VIN driver

 drivers/media/platform/Kconfig              |    1 +
 drivers/media/platform/Makefile             |    2 +
 drivers/media/platform/rcar-vin/Kconfig     |   11 +
 drivers/media/platform/rcar-vin/Makefile    |    3 +
 drivers/media/platform/rcar-vin/rcar-core.c |  337 ++++++++++++++++
 drivers/media/platform/rcar-vin/rcar-dma.c  | 1196 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/rcar-vin/rcar-v4l2.c |  768 +++++++++++++++++++++++++++++++++++
 drivers/media/platform/rcar-vin/rcar-vin.h  |  163 ++++++++
 drivers/media/platform/soc_camera/Kconfig   |    4 +-
 drivers/media/platform/soc_camera/Makefile  |    2 +-
 10 files changed, 2484 insertions(+), 3 deletions(-)
 create mode 100644 drivers/media/platform/rcar-vin/Kconfig
 create mode 100644 drivers/media/platform/rcar-vin/Makefile
 create mode 100644 drivers/media/platform/rcar-vin/rcar-core.c
 create mode 100644 drivers/media/platform/rcar-vin/rcar-dma.c
 create mode 100644 drivers/media/platform/rcar-vin/rcar-v4l2.c
 create mode 100644 drivers/media/platform/rcar-vin/rcar-vin.h
