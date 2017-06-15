Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:44566 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752427AbdFOJSt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 05:18:49 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v4 0/2] media: entity: add operation to help map DT node to media pad
Date: Thu, 15 Jun 2017 11:17:24 +0200
Message-Id: <20170615091726.22370-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This series add a new entity operation which will aid capture
drivers to map a port/endpoint in DT to a media graph pad.

This series is implemented support for the ongoing ADV748x work by
Kieran Bingham. In his work he have a driver which registers more then
one subdevice. So when a driver finds this subdevice it must be able to
ask the subdevice itself which pad number correspond to the DT endpoint
the driver used to bind subdevice in the first place.

This is tested on Renesas H3 and M3-W together with the Renesas CSI-2
and VIN Gen3 driver (posted separately). It is based on top media-tree.

* Changes since v3
- Rename argument direction to direction_flags and changed type from 
  unsigned int to unsigned long for media_entity_get_fwnode_pad().
- Changed loop data type from int to unsigned int.
- Added Acked-by from Sakari, thanks!

* Changes since v2
- Renamed pad_from_fwnode to get_fwnode_pad as suggested by Sakari.
- Return pad number instead of passing it as a pointer to both
  get_fwnode_pad() and media_entity_pad_from_fwnode().
- Document possible flags of the direction argument to
  media_entity_pad_from_fwnode().
- Use unsigned int instead of int for bitmask.
- Fix numerous spelling mistakes, thanks Hans!
- Rebased to latest media-tree.

* Changes since v1
- Rebased work ontop of Sakaris fwnode branch and make use of the fwnode
  instead of the raw DT port/reg numbers.
- Do not assume DT port is equal to pad number if the driver do not
  implement the lookup function. Instead search for the first pad with
  the correct direction and use that. Thanks Sakari for the suggestion!
- Use ENXIO instead of EINVAL to signal lookup error.

Niklas Söderlund (2):
  media: entity: Add get_fwnode_pad entity operation
  media: entity: Add media_entity_get_fwnode_pad() function

 drivers/media/media-entity.c | 36 ++++++++++++++++++++++++++++++++++++
 include/media/media-entity.h | 28 ++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

-- 
2.13.1
