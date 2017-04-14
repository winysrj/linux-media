Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:59991 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751350AbdDNKZT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Apr 2017 06:25:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 0/8] omapdrm: add OMAP4 CEC support
Date: Fri, 14 Apr 2017 12:25:04 +0200
Message-Id: <20170414102512.48834-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series adds support for the OMAP4 HDMI CEC IP core.

Most of the patches leading up to the actual CEC implementation
make changes to the HDMI core support. The reason for this is
that CEC has to be enabled even if the HPD is low: some displays will
set the HPD low when they go into standby or when they switch to another
input, but CEC is still available and able to wake up/change input for
such a display.
 
This corner case is explicitly allowed by the CEC standard, and such
displays really exist, even in modern displays.

So CEC has to be able to wake up the HDMI core, even when there is no
HPD.

I also looked at implementing CEC monitoring (i.e. 'snooping' the CEC
bus for messages between other CEC devices), but I couldn't figure
that out. The omap4 datasheet does not give sufficient information
on how it is supposed to work. There is a CEC_SN bit in CEC_DBG_3 and
a 'CEC Snoop Initiator' field in CEC_DBG_2, but no information on
how to use those registers. Trying to enable CEC_SN gave me weird
results, so I decided to leave that feature out.

Links to CEC documentation and utilities:

Public API:

https://www.linuxtv.org/downloads/v4l-dvb-apis-new/uapi/cec/cec-api.html

Kernel API:

https://www.linuxtv.org/downloads/v4l-dvb-apis-new/kapi/cec-core.html

CEC utilities (esp. cec-ctl):

https://git.linuxtv.org/v4l-utils.git/ (master branch)

To test:

First configure the CEC adapter as a playback device:

cec-ctl --playback

Then detect and query any other CEC devices, such as a CEC-enabled display:

cec-ctl -S

Regards,

	Hans

Hans Verkuil (8):
  arm: omap4: enable CEC pin for Pandaboard A4 and ES
  omapdrm: encoder-tpd12s015: keep ls_oe_gpio high if CEC is enabled
  omapdrm: hdmi.h: extend hdmi_core_data with CEC fields
  omapdrm: hdmi4: make low-level functions available
  omapdrm: hdmi4: prepare irq handling for HDMI CEC support
  omapdrm: hdmi4: refcount hdmi_power_on/off_core
  omapdrm: hdmi4_cec: add OMAP4 HDMI CEC support
  omapdrm: hdmi4: hook up the HDMI CEC support

 arch/arm/boot/dts/omap4-panda-a4.dts               |   2 +-
 arch/arm/boot/dts/omap4-panda-es.dts               |   2 +-
 .../gpu/drm/omapdrm/displays/encoder-tpd12s015.c   |   8 +
 drivers/gpu/drm/omapdrm/dss/Kconfig                |   9 +
 drivers/gpu/drm/omapdrm/dss/Makefile               |   1 +
 drivers/gpu/drm/omapdrm/dss/hdmi.h                 |   6 +-
 drivers/gpu/drm/omapdrm/dss/hdmi4.c                |  58 +++-
 drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c            | 381 +++++++++++++++++++++
 drivers/gpu/drm/omapdrm/dss/hdmi4_cec.h            |  55 +++
 drivers/gpu/drm/omapdrm/dss/hdmi4_core.c           |   6 +-
 drivers/gpu/drm/omapdrm/dss/hdmi4_core.h           |   4 +
 11 files changed, 513 insertions(+), 19 deletions(-)
 create mode 100644 drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c
 create mode 100644 drivers/gpu/drm/omapdrm/dss/hdmi4_cec.h

-- 
2.11.0
