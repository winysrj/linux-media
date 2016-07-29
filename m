Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:41681 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbcG2Rkg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2016 13:40:36 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	sergei.shtylyov@cogentembedded.com, slongerbeam@gmail.com
Cc: lars@metafoo.de, mchehab@kernel.org, hans.verkuil@cisco.com,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 0/6] Fix adv7180 and rcar-vin field handling
Date: Fri, 29 Jul 2016 19:40:06 +0200
Message-Id: <20160729174012.14331-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This series add V4L2_FIELD_ALTERNATE support to the rcar-vin driver and 
changes the field mode reported by adv7180 from V4L2_FIELD_INTERLACED to 
V4L2_FIELD_ALTERNATE.

The change field mode reported by adv7180 was first done by Steve 
Longerbeam (https://lkml.org/lkml/2016/7/23/107), I have keept and 
reworked Steves patch to report V4L2_FIELD_ALTERNATE instead of 
V4L2_FIELD_SEQ_{TB,BT}, after discussions on #v4l this seems more
correct.

The rcar-vin changes contains some bug fixes needed to enable 
V4L2_FIELD_ALTERNATE.

All work is based on top of media-next and is tested on Koelsch.

This series touch two drivers which is not a good thing. But I could not 
figure out a good way to post them separately since if the adv7180 parts 
where too be merged before the rcar-vin changes the driver would stop to 
work on the Koelsch. If some one wants this series split in two let me 
know.

Niklas Söderlund (5):
  media: rcar-vin: allow field to be changed
  media: rcar-vin: fix bug in scaling
  media: rcar-vin: fix height for TOP and BOTTOM fields
  media: rcar-vin: add support for V4L2_FIELD_ALTERNATE
  media: adv7180: fill in mbus format in set_fmt

Steve Longerbeam (1):
  media: adv7180: fix field type

 drivers/media/i2c/adv7180.c                 |  21 ++--
 drivers/media/platform/rcar-vin/rcar-dma.c  |  26 +++--
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 151 ++++++++++++++++------------
 3 files changed, 123 insertions(+), 75 deletions(-)

-- 
2.9.0

