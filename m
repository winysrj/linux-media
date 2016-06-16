Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:48239 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992AbcFPVlG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 17:41:06 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH 0/6] [media] Fixes and improvements for VIDIOC_QUERYCAP in Samsung media drivers
Date: Thu, 16 Jun 2016 17:40:29 -0400
Message-Id: <1466113235-25909-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This series contains some fixes and improvements for the VIDIOC_QUERYCAP ioctl
handler in different media platform drivers for IP blocks found in Exynos SoCs.

Some of the issues were reported by the v4l2-compliance tool while others are
things I noticed while looking at the Driver name, Card type and Bus info.

Best regards,
Javier


Javier Martinez Canillas (6):
  [media] s5p-mfc: set capablity bus_info as required by VIDIOC_QUERYCAP
  [media] s5p-mfc: improve v4l2_capability driver and card fields
  [media] s5p-jpeg: set capablity bus_info as required by
    VIDIOC_QUERYCAP
  [media] s5p-jpeg: only fill driver's name in capabilities driver field
  [media] gsc-m2m: add device name sufix to bus_info capatiliby field
  [media] gsc-m2m: improve v4l2_capability driver and card fields

 drivers/media/platform/exynos-gsc/gsc-m2m.c     | 7 ++++---
 drivers/media/platform/s5p-jpeg/jpeg-core.c     | 7 ++++---
 drivers/media/platform/s5p-mfc/s5p_mfc.c        | 1 -
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h | 2 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    | 7 ++++---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    | 7 ++++---
 6 files changed, 18 insertions(+), 13 deletions(-)

-- 
2.5.5

