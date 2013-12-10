Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35803 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab3LJNsH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 08:48:07 -0500
Received: from avalon.localnet (9.6-200-80.adsl-dyn.isp.belgacom.be [80.200.6.9])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 7020935A6A
	for <linux-media@vger.kernel.org>; Tue, 10 Dec 2013 14:47:18 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.14] Miscellaneous VSP1 patches
Date: Tue, 10 Dec 2013 14:48:16 +0100
Message-ID: <3048003.N3nmSAqvTJ@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 431cb350187c6bf1ed083622d633418a298a7216:

  [media] az6007: support Technisat Cablestar Combo HDCI (minus remote) 
(2013-12-10 07:15:54 -0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git vsp1/next

for you to fetch changes up to 08057ef1daf4bba618c8145b95b249a7dcc523fd:

  v4l: vsp1: Add LUT support (2013-12-10 14:44:43 +0100)

----------------------------------------------------------------
Laurent Pinchart (6):
      v4l: vsp1: Supply frames to the DU continuously
      v4l: vsp1: Add cropping support
      v4l: Add media format codes for AHSV8888 on 32-bit busses
      v4l: vsp1: Add HST and HSI support
      v4l: vsp1: Add SRU support
      v4l: vsp1: Add LUT support

 Documentation/DocBook/media/v4l/subdev-formats.xml | 157 +++++++++++++
 drivers/media/platform/vsp1/Makefile               |   3 +-
 drivers/media/platform/vsp1/vsp1.h                 |   7 +
 drivers/media/platform/vsp1/vsp1_drv.c             |  39 ++++
 drivers/media/platform/vsp1/vsp1_entity.c          |   7 +
 drivers/media/platform/vsp1/vsp1_entity.h          |   4 +
 drivers/media/platform/vsp1/vsp1_hsit.c            | 222 ++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_hsit.h            |  38 +++
 drivers/media/platform/vsp1/vsp1_lut.c             | 252 ++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_lut.h             |  38 +++
 drivers/media/platform/vsp1/vsp1_regs.h            |  16 ++
 drivers/media/platform/vsp1/vsp1_rpf.c             |  34 ++-
 drivers/media/platform/vsp1/vsp1_rwpf.c            |  96 ++++++++
 drivers/media/platform/vsp1/vsp1_rwpf.h            |  10 +
 drivers/media/platform/vsp1/vsp1_sru.c             | 356 ++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_sru.h             |  41 ++++
 drivers/media/platform/vsp1/vsp1_video.c           |  13 ++
 drivers/media/platform/vsp1/vsp1_wpf.c             |  17 +-
 include/linux/platform_data/vsp1.h                 |   2 +
 include/uapi/linux/v4l2-mediabus.h                 |   3 +
 include/uapi/linux/vsp1.h                          |  34 +++
 21 files changed, 1372 insertions(+), 17 deletions(-)
 create mode 100644 drivers/media/platform/vsp1/vsp1_hsit.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_hsit.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_lut.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_lut.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_sru.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_sru.h
 create mode 100644 include/uapi/linux/vsp1.h

-- 
Regards,

Laurent Pinchart

