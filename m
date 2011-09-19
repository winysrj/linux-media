Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:32133 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab1ISRmd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Sep 2011 13:42:33 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LRS0063X6IVNP70@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 19 Sep 2011 18:42:31 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRS00CJW6IUL6@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 19 Sep 2011 18:42:30 +0100 (BST)
Date: Mon, 19 Sep 2011 19:42:30 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PATCHES FOR 3.2] noon010pc30 conversion to the pad level ops
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Message-id: <4E777F06.7070602@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Mauro, please pull from my tree for a few noon01pc30 driver updates.
This is conversion to the pad level ops and the subdev user-space API 
and other related modifications.


The following changes since commit e27412f5a5966629e3d4213c78a539068ca0ea26:

  [media] mmp_camera: add MODULE_ALIAS (2011-09-18 08:05:43 -0300)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-2.6-samsung v4l_noon010pc30

Sylwester Nawrocki (3):
      noon010pc30: Conversion to the media controller API
      noon010pc30: Improve s_power operation handling
      noon010pc30: Remove g_chip_ident operation handler

 drivers/media/video/Kconfig       |    2 +-
 drivers/media/video/noon010pc30.c |  266 +++++++++++++++++++++++-------------
 include/media/v4l2-chip-ident.h   |    3 -
 3 files changed, 171 insertions(+), 100 deletions(-)

Best regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
