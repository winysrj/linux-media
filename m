Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:57614 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033994AbdD0WnF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 18:43:05 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 0/2] media: entity: add operation to help map DT node to media pad
Date: Fri, 28 Apr 2017 00:33:21 +0200
Message-Id: <20170427223323.13861-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This small series add a new entity operation which will aid capture 
drivers to map a port/endpoint in DT to a media graph pad. I looked 
around and in my experience most drivers assume the DT port number is 
the same as the media pad number.

This might be true for most devices but there are cases where this 
mapping do not hold true. This series is implemented support to the 
ongoing ADV748x work by Kieran Bingham, [1]. In his work he have a 
driver which registers more then one subdevice. So when a driver finds 
this subdevice it must be able to ask the subdevice itself which pad 
number correspond to the DT endpoint the driver used to bind subdevice 
in the first place.

I have updated my R-Car CSI-2 patch series to use this new function to 
ask it's subdevice to resolve the media pad.

1. [PATCH 0/5] RFC: ADV748x HDMI/Analog video receiver

Niklas Söderlund (2):
  media: entity: Add pad_from_dt_regs entity operation
  media: entity: Add media_entity_pad_from_dt_regs() function

 drivers/media/media-entity.c | 21 +++++++++++++++++++++
 include/media/media-entity.h | 26 ++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

-- 
2.12.2
