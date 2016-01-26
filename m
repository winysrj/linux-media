Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:51022 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934187AbcAZMqn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 07:46:43 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Eduard Gavin <egavinc@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: [PATCH v3 0/2] [media] tvp5150: Add MC support
Date: Tue, 26 Jan 2016 09:46:22 -0300
Message-Id: <1453812384-15512-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This series is a split of patch [0] that was part of this series [1].

All patches in that series were picked besides [0] that Mauro asked
to split in two different patches.

I kept the version number of the previous series (v2) so the patches
are marked as v3.

[0]: http://lkml.iu.edu/hypermail/linux/kernel/1601.0/00923.html
[1]: http://lkml.iu.edu/hypermail/linux/kernel/1601.0/00910.html

Best regards,
Javier

Changes in v3:
- Split the format fix and the MC support in different patches.
  Suggested by Mauro Carvalho Chehab.

Changes in v2:
- Embed mbus_type into struct tvp5150. Suggested by Laurent Pinchart.
- Remove platform data support. Suggested by Laurent Pinchart.
- Check if the hsync, vsync and field even active properties are correct.
  Suggested by Laurent Pinchart.

Laurent Pinchart (2):
  [media] tvp5150: fix tvp5150_fill_fmt()
  [media] tvp5150: Add pad-level subdev operations

 drivers/media/i2c/tvp5150.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

-- 
2.5.0

