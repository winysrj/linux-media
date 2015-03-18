Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44468 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424AbbCRKXB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 06:23:01 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <k.debski@samsung.com>,
	Ian Molton <imolton@ad-holdings.co.uk>,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 0/5] i.MX5/6 mem2mem scaler
Date: Wed, 18 Mar 2015 11:22:48 +0100
Message-Id: <1426674173-17088-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

this series uses the IPU IC post-processing task, to implement
a mem2mem device for scaling and colorspace conversion. The first
version had a fixup applied to the wrong patch.

Changes since v1:
 - Removed deinterlacer support left-overs

regards
Philipp

Philipp Zabel (3):
  gpu: ipu-v3: Add missing IDMAC channel names
  gpu: ipu-v3: Add mem2mem image conversion support to IC
  gpu: ipu-v3: Register scaler platform device

Sascha Hauer (2):
  [media] imx-ipu: Add ipu media common code
  [media] imx-ipu: Add i.MX IPUv3 scaler driver

 drivers/gpu/ipu-v3/ipu-common.c             |   2 +
 drivers/gpu/ipu-v3/ipu-ic.c                 | 787 ++++++++++++++++++++++++-
 drivers/media/platform/Kconfig              |   2 +
 drivers/media/platform/Makefile             |   1 +
 drivers/media/platform/imx/Kconfig          |  11 +
 drivers/media/platform/imx/Makefile         |   2 +
 drivers/media/platform/imx/imx-ipu-scaler.c | 869 ++++++++++++++++++++++++++++
 drivers/media/platform/imx/imx-ipu.c        | 313 ++++++++++
 drivers/media/platform/imx/imx-ipu.h        |  36 ++
 include/video/imx-ipu-v3.h                  |  49 +-
 10 files changed, 2055 insertions(+), 17 deletions(-)
 create mode 100644 drivers/media/platform/imx/Kconfig
 create mode 100644 drivers/media/platform/imx/Makefile
 create mode 100644 drivers/media/platform/imx/imx-ipu-scaler.c
 create mode 100644 drivers/media/platform/imx/imx-ipu.c
 create mode 100644 drivers/media/platform/imx/imx-ipu.h

-- 
2.1.4

