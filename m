Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2072 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932835Ab3DFL0G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Apr 2013 07:26:06 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id r36BQ3iG058246
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Sat, 6 Apr 2013 13:26:05 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.lan (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 87AB011E018E
	for <linux-media@vger.kernel.org>; Sat,  6 Apr 2013 13:25:57 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH 0/7] VIDIOC_DBG_G_CHIP_NAME fixes/improvements
Date: Sat,  6 Apr 2013 13:25:45 +0200
Message-Id: <1365247552-26795-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Recently VIDIOC_DBG_G_CHIP_NAME was introduced as a replacement for the old
VIDIOC_DBG_G_CHIP_IDENT. While working on modifying v4l2-dbg to use the new
API I realized that a few changes should be made before this API goes public.

The first four patches make some essential improvements:

- put VIDIOC_DBG_G_CHIP_NAME under ADV_DEBUG to prevent abuse of this ioctl
  by other drivers (this happened with G_CHIP_IDENT as I discovered).
- V4L2_CHIP_MATCH_SUBDEV_NAME is not needed. Drop it and rename
  V4L2_CHIP_MATCH_SUBDEV_IDX to V4L2_CHIP_MATCH_SUBDEV.
- make sure chip->name is filled in before calling the vidioc_g_chip_name
  callback. That way drivers do not need to fill in the name field themselves.
- rename CHIP_NAME to CHIP_INFO since more information about the chip is/will
  be exposed than just the name.

The last three patches add support for exposing register ranges. Some devices
have multiple ranges and there is no easy way of exposing that. I have seen
several ways in which this is done today:

- For the ivtv driver you just have to know the address ranges.

- The adv7604 driver maps registers 0x00-0xff of different internal i2c address
  to different address ranges (0x000-0xcff). Note: this is common for these
  adv drivers. I have two other adv drivers pending that use this scheme.

- cx231xx is a big mess with multiple register ranges mapped to different
  bridge/i2c addresses. Sometimes the same register range is exposed but
  with different register widths.

- v4l2-dbg has special support for several drivers: saa7127, ov7670,
  cx25840, cs5345, ivtv, cx18 and cafe where it hardcodes the register
  range based on the driver name.

By moving the information about register ranges into the driver under
ADV_DEBUG it is much easier to keep track of it all, and the v4l2-dbg utility
can be simplified.

Regards,

	Hans

