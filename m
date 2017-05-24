Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:42011 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765636AbdEXAJh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 20:09:37 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 0/2] media: entity: add operation to help map DT node to media pad
Date: Wed, 24 May 2017 02:09:05 +0200
Message-Id: <20170524000907.13061-1-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Hi,

This series add a new entity operation which will aid capture
drivers to map a port/endpoint in DT to a media graph pad.

This series is implemented support for the ongoing ADV748x work by 
Kieran Bingham. In his work he have a driver which registers more then 
one subdevice. So when a driver finds this subdevice it must be able to 
ask the subdevice itself which pad number correspond to the DT endpoint 
the driver used to bind subdevice in the first place.

This is tested on Renesas H3 and M3-W together with the Renesas CSI-2 
and VIN Gen3 driver (posted separately). It is based on top of Sakaris 
pull request '[GIT PULL FOR v4.13] V4L2 fwnode support'.

* Changes since v1
- Rebased work ontop of Sakaris fwnode branch and make use of the fwnode 
  instead of the raw DT port/reg numbers.
- Do not assume DT port is equal to pad number if the driver do not 
  implement the lookup function. Instead search for the first pad with 
  the correct direction and use that. Thanks Sakari for the suggestion!
- Use ENXIO instead of EINVAL to signal lookup error.

Niklas Söderlund (2):
  media: entity: Add pad_from_fwnode entity operation
  media: entity: Add media_entity_pad_from_fwnode() function

 drivers/media/media-entity.c | 39 +++++++++++++++++++++++++++++++++++++++
 include/media/media-entity.h | 28 ++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+)

-- 
2.13.0
