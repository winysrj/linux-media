Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:35380 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726808AbeJDQBY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Oct 2018 12:01:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 0/5] cec/adv/omap: fixes and new status flags
Date: Thu,  4 Oct 2018 11:08:55 +0200
Message-Id: <20181004090900.32915-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The first patch adds new status flags to indicate when a pending
message is aborted because the CEC adapter is unconfigured, and when
a transmit times out (this indicates a driver bug).

The second and third patch fix a minor issue with the adv HDMI receivers:
if the EDID goes away, then the physical address also becomes invalid.

The fourth patch fixes a race condition in the omap4 CEC driver that
causes a transmit time out. The final patch drops the code in the omap4
CEC driver that attempts to set the number of retransmits: those register
bits are read-only, so the code is pointless.

There are no dependencies between these patches, although the first
and fourth patch relate to the same problem. With the new transmit
TIMEOUT status I hope that it will be easier to catch driver bugs like
that earlier since this bug remained hidden for too long.

Regards,

	Hans

Hans Verkuil (5):
  cec: add new tx/rx status bits to detect aborts/timeouts
  adv7604: when the EDID is cleared, unconfigure CEC as well
  adv7842: when the EDID is cleared, unconfigure CEC as well
  omapdrm/dss/hdmi4_cec.c: clear TX FIFO before transmit_done
  omapdrm/dss/hdmi4_cec.c: don't set the retransmit count

 .../media/uapi/cec/cec-ioc-receive.rst        | 25 ++++++-
 drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c       | 38 +++++------
 drivers/media/cec/cec-adap.c                  | 66 +++++--------------
 drivers/media/i2c/adv7604.c                   |  4 +-
 drivers/media/i2c/adv7842.c                   |  4 +-
 include/uapi/linux/cec.h                      |  3 +
 6 files changed, 67 insertions(+), 73 deletions(-)

-- 
2.18.0
