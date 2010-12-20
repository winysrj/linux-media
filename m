Return-path: <mchehab@gaivota>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59563 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758023Ab0LTP6I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Dec 2010 10:58:08 -0500
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LDQ002LVHOTSL@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 20 Dec 2010 15:58:05 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LDQ00AIGHOTUO@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 20 Dec 2010 15:58:05 +0000 (GMT)
Date: Mon, 20 Dec 2010 16:58:00 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 0/2 v3] I2C/subdev driver for NOON010PC30 camera chip
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com
Message-id: <1292860682-12014-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi all,

following is a third version of patches adding the I2C/subdev driver
for Siliconfile NOON010PC30 camera sensor with integrated ISP.
It includes mostly corrections after the review by Hans. Hopefully 
it can be merged into 2.6.38 in the current form.

Changes since v1:
- reworked to new v4l2-controls framework (-8% LOC)

Changes since v2:
- removed unneeded struct v4l2_ctrl * entries, CodingStyle cleanup,
  fixed error paths in probe, added missing v4l2_ctrl_handler_free
  on driver unload
- removed s_config and an empty s_stream subdev callback implementations

The patch series contains:

[PATCH 1/2 v3] [media] Add chip identity for NOON010PC30 camera sensor
[PATCH 2/2 v3] [media] Add v4l2 subdev driver for NOON010PC30L image sensor

It has been rebased onto linuxtv/staging/for_v2.6.38 branch
at git://linuxtv.org/media_tree.git.


Regards,
Sylwester


--
Sylwester Nawrocki
Samsung Poland R&D Center
