Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:36833 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752174AbdHBIyN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Aug 2017 04:54:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        dri-devel@lists.freedesktop.org
Subject: [PATCHv2 0/9] omapdrm: hdmi4: add CEC support
Date: Wed,  2 Aug 2017 10:53:59 +0200
Message-Id: <20170802085408.16204-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series adds CEC support for the omap4. It is based on
the 4.13-rc2 kernel with this patch series applied:

http://www.spinics.net/lists/dri-devel/msg143440.html

It is virtually identical to the first patch series posted in
April:

http://www.spinics.net/lists/dri-devel/msg138950.html

The only two changes are in the Kconfig due to CEC Kconfig
changes in 4.13 (it now selects CEC_CORE instead of depending on
CEC_CORE) and a final patch was added adding a lost_hotplug op
since for proper CEC support I have to know when the hotplug
signal goes away.

Tested with my Pandaboard.

The lost_hotplug op is called only when the hotplug is lost,
but I am happy to change it to an op that is called whenever
the hotplug signal changes. Just let me know. I just implemented
the minimal solution that I needed.

Regards,

	Hans

Hans Verkuil (9):
  omapdrm: encoder-tpd12s015: keep ls_oe_gpio high
  omapdrm: hdmi.h: extend hdmi_core_data with CEC fields
  omapdrm: hdmi4: make low-level functions available
  omapdrm: hdmi4: prepare irq handling for HDMI CEC support
  omapdrm: hdmi4: move hdmi4_core_powerdown_disable to
    hdmi_power_on_core()
  omapdrm: hdmi4: refcount hdmi_power_on/off_core
  omapdrm: hdmi4_cec: add OMAP4 HDMI CEC support
  omapdrm: hdmi4: hook up the HDMI CEC support
  omapdrm: omapdss_hdmi_ops: add lost_hotplug op

 drivers/gpu/drm/omapdrm/displays/connector-hdmi.c  |   8 +-
 .../gpu/drm/omapdrm/displays/encoder-tpd12s015.c   |  18 +-
 drivers/gpu/drm/omapdrm/dss/Kconfig                |   8 +
 drivers/gpu/drm/omapdrm/dss/Makefile               |   1 +
 drivers/gpu/drm/omapdrm/dss/hdmi.h                 |   6 +-
 drivers/gpu/drm/omapdrm/dss/hdmi4.c                |  62 +++-
 drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c            | 381 +++++++++++++++++++++
 drivers/gpu/drm/omapdrm/dss/hdmi4_cec.h            |  55 +++
 drivers/gpu/drm/omapdrm/dss/hdmi4_core.c           |   7 +-
 drivers/gpu/drm/omapdrm/dss/hdmi4_core.h           |   4 +
 drivers/gpu/drm/omapdrm/dss/omapdss.h              |   1 +
 11 files changed, 521 insertions(+), 30 deletions(-)
 create mode 100644 drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c
 create mode 100644 drivers/gpu/drm/omapdrm/dss/hdmi4_cec.h

-- 
2.13.2
