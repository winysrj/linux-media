Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:24545 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932376Ab1FVPoh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 11:44:37 -0400
Received: from spt2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LN700H2V7QCPZ@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Jun 2011 16:44:36 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LN700H7X7QBNB@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Jun 2011 16:44:35 +0100 (BST)
Date: Wed, 22 Jun 2011 17:44:27 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 0/3] noon010pc30 driver conversion to the pad level operations
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1308757470-24421-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following patch set converts noon010pc30 camera sensor driver to the 
subdev pad level operations. Additionally it cleans up some leftover after
conversion to the regulator framework and marks driver as experimental
as it now uses V4L2 sub-device API.


Sylwester Nawrocki (3):
  noon010pc30: Do not ignore errors in initial controls setup
  noon010pc30: Convert to the pad level ops
  noon010pc30: Clean up the s_power callback

 drivers/media/video/Kconfig       |    2 +-
 drivers/media/video/noon010pc30.c |  151 ++++++++++++++++++++++++-------------
 2 files changed, 98 insertions(+), 55 deletions(-)


--
Regards,
Sylwester

