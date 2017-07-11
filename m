Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:36460 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754784AbdGKGar (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 02:30:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 00/11] drm/sun4i: add CEC support
Date: Tue, 11 Jul 2017 08:30:33 +0200
Message-Id: <20170711063044.29849-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series adds CEC support for the sun4i HDMI controller.

The CEC hardware support for the A10 is very low-level as it just
controls the CEC pin. Since I also wanted to support GPIO-based CEC
hardware most of this patch series is in the CEC framework to
add a generic low-level CEC pin framework. It is only the final patch
that adds the sun4i support.

This patch series first makes some small changes in the CEC framework
(patches 1-4) to prepare for this CEC pin support.

Patch 5-7 adds the new API elements and documents it. Patch 6 reworks
the CEC core event handling.

Patch 8 adds pin monitoring support (allows userspace to see all
CEC pin transitions as they happen).

Patch 9 adds the core cec-pin implementation that translates low-level
pin transitions into valid CEC messages. Basically this does what any
SoC with a proper CEC hardware implementation does.

Patch 10 documents the cec-pin kAPI (and also the cec-notifier kAPI
which was missing).

Finally patch 11 adds the actual sun4i_hdmi CEC implementation.

I tested this on my cubieboard. There were no errors at all
after 126264 calls of 'cec-ctl --give-device-vendor-id' while at the
same time running a 'make -j4' of the v4l-utils git repository and
doing a continuous scp to create network traffic.

This patch series is based on top of the mainline kernel as of
yesterday (so with all the sun4i and cec patches for 4.13 merged).

Maxime, patches 1-10 will go through the media subsystem. How do you
want to handle the final patch? It can either go through the media
subsystem as well, or you can sit on it and handle this yourself during
the 4.14 merge window. Another option is to separate the Kconfig change
into its own patch. That way you can merge the code changes and only
have to handle the Kconfig patch as a final change during the merge
window.

Regards,

	Hans

Hans Verkuil (11):
  cec: improve transmit timeout logging
  cec: add *_ts variants for transmit_done/received_msg
  cec: add adap_free op
  cec-core.rst: document the adap_free callback
  linux/cec.h: add pin monitoring API support
  cec: rework the cec event handling
  cec: document the new CEC pin capability, events and mode
  cec: add core support for low-level CEC pin monitoring
  cec-pin: add low-level pin hardware support
  cec-core.rst: include cec-pin.h and cec-notifier.h
  sun4i_hdmi: add CEC support

 Documentation/media/kapi/cec-core.rst              |  40 ++
 .../media/uapi/cec/cec-ioc-adap-g-caps.rst         |   7 +
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   |  20 +
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst    |  19 +-
 drivers/gpu/drm/sun4i/Kconfig                      |   9 +
 drivers/gpu/drm/sun4i/sun4i_hdmi.h                 |   8 +
 drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c             |  57 +-
 drivers/media/Kconfig                              |   3 +
 drivers/media/cec/Makefile                         |   4 +
 drivers/media/cec/cec-adap.c                       | 196 +++--
 drivers/media/cec/cec-api.c                        |  73 +-
 drivers/media/cec/cec-core.c                       |   2 +
 drivers/media/cec/cec-pin.c                        | 794 +++++++++++++++++++++
 include/media/cec-pin.h                            | 183 +++++
 include/media/cec.h                                |  64 +-
 include/uapi/linux/cec.h                           |   8 +-
 16 files changed, 1389 insertions(+), 98 deletions(-)
 create mode 100644 drivers/media/cec/cec-pin.c
 create mode 100644 include/media/cec-pin.h

-- 
2.11.0
