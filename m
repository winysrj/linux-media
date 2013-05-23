Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:27538 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758125Ab3EWKyX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 06:54:23 -0400
Received: from cobaltpc1.localnet (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id r4NAsIxx026796
	for <linux-media@vger.kernel.org>; Thu, 23 May 2013 10:54:18 GMT
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.10] Build dependency fixes
Date: Thu, 23 May 2013 12:54:05 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201305231254.05071.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Note: this superceeds my previous 3.10 pull request: I realized that the solo fix
should also go to 3.10.

Regards,

	Hans

The following changes since commit 6a084d6b3dc200b855ae8a3c6771abe285a3835d:

  [media] saa7115: Don't use a dynamic array (2013-05-21 12:04:16 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.10b

for you to fetch changes up to a77dac0ac37a9ee6a72a6d2b864feb894d88fbaf:

  staging/solo6x10: select the desired font (2013-05-23 12:52:42 +0200)

----------------------------------------------------------------
Lad, Prabhakar (1):
      drivers/staging: davinci: vpfe: fix dependency for building the driver

Xiong Zhou (1):
      staging/solo6x10: select the desired font

 drivers/staging/media/davinci_vpfe/Kconfig |    2 +-
 drivers/staging/media/solo6x10/Kconfig     |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)
