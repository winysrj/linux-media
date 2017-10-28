Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:50345 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751483AbdJ1UlB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Oct 2017 16:41:01 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 0/9] media: imx: Add better OF graph support
Date: Sat, 28 Oct 2017 13:36:40 -0700
Message-Id: <1509223009-6392-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a set of patches that improve support for more complex OF
graphs. Currently the imx-media driver only supports a single device
with a single port connected directly to either the CSI muxes or the
MIPI CSI-2 receiver input ports. There can't be a multi-port device in
between. This patch set removes those limitations.

For an example taken from automotive, a camera sensor or decoder could
be literally a remote device accessible over a FPD-III link, via TI
DS90Ux9xx deserializer/serializer pairs. This patch set would support
such OF graphs.

There are still some assumptions and restrictions, regarding the equivalence
of device-tree ports, port parents, and endpoints to media pads, entities,
and links that have been enumerated in the TODO file.

This patch set supersedes the following patches submitted earlier:

"[PATCH v2] media: staging/imx: do not return error in link_notify for unknown sources"
"[PATCH RFC] media: staging/imx: fix complete handler"

Tested by: Steve Longerbeam <steve_longerbeam@mentor.com>
on SabreLite with the OV5640

Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
on Nitrogen6X with the TC358743.

Tested-by: Russell King <rmk+kernel@armlinux.org.uk>
with the IMX219


Steve Longerbeam (9):
  media: staging/imx: get CSI bus type from nearest upstream entity
  media: staging/imx: remove static media link arrays
  media: staging/imx: of: allow for recursing downstream
  media: staging/imx: remove devname string from imx_media_subdev
  media: staging/imx: pass fwnode handle to find/add async subdev
  media: staging/imx: remove static subdev arrays
  media: staging/imx: convert static vdev lists to list_head
  media: staging/imx: reorder function prototypes
  media: staging/imx: update TODO

 drivers/staging/media/imx/TODO                    |  63 +++-
 drivers/staging/media/imx/imx-ic-prp.c            |   4 +-
 drivers/staging/media/imx/imx-media-capture.c     |   2 +
 drivers/staging/media/imx/imx-media-csi.c         | 187 +++++-----
 drivers/staging/media/imx/imx-media-dev.c         | 400 ++++++++++------------
 drivers/staging/media/imx/imx-media-internal-sd.c | 253 +++++++-------
 drivers/staging/media/imx/imx-media-of.c          | 278 ++++++++-------
 drivers/staging/media/imx/imx-media-utils.c       | 122 +++----
 drivers/staging/media/imx/imx-media.h             | 187 ++++------
 9 files changed, 722 insertions(+), 774 deletions(-)

-- 
2.7.4
