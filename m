Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:57446 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751215AbcD2JjM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 05:39:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: tomi.valkeinen@ti.com, dri-devel@lists.freedesktop.org
Subject: [RFC PATCH 0/3] OMAP4 HDMI CEC support
Date: Fri, 29 Apr 2016 11:39:03 +0200
Message-Id: <1461922746-17521-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series sits on top of my earlier HDMI CEC framework:

http://www.spinics.net/lists/linux-media/msg99847.html

It is an RFC patch for now as I want to clean up hdmi_cec a bit more
and do a bit more testing.

Many thanks to Tomi for finding obscure problems in the omap4 drivers
that prevented CEC from working on my pandaboard.

Feedback is welcome!

Regards,

	Hans

Hans Verkuil (2):
  omap4: add CEC support
  encoder-tpd12s015: keep the ls_oe_gpio on while the phys_addr is valid

Tomi Valkeinen (1):
  drm/omap: fix OMAP4 hdmi_core_powerdown_disable()

 arch/arm/boot/dts/omap4-panda-a4.dts               |   2 +-
 arch/arm/boot/dts/omap4-panda-es.dts               |   2 +-
 arch/arm/boot/dts/omap4.dtsi                       |   5 +-
 .../gpu/drm/omapdrm/displays/encoder-tpd12s015.c   |  13 +-
 drivers/gpu/drm/omapdrm/dss/Kconfig                |   8 +
 drivers/gpu/drm/omapdrm/dss/Makefile               |   3 +
 drivers/gpu/drm/omapdrm/dss/hdmi.h                 |  62 +++-
 drivers/gpu/drm/omapdrm/dss/hdmi4.c                |  39 ++-
 drivers/gpu/drm/omapdrm/dss/hdmi4_core.c           |   2 +-
 drivers/gpu/drm/omapdrm/dss/hdmi_cec.c             | 329 +++++++++++++++++++++
 10 files changed, 454 insertions(+), 11 deletions(-)
 create mode 100644 drivers/gpu/drm/omapdrm/dss/hdmi_cec.c

-- 
2.8.1

