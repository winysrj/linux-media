Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:12804 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758403Ab3EWKqO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 06:46:14 -0400
Received: from cobaltpc1.localnet (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-1.cisco.com (8.14.5/8.14.5) with ESMTP id r4NAjqcE027847
	for <linux-media@vger.kernel.org>; Thu, 23 May 2013 10:45:52 GMT
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.10] Fix vpfe build dependency
Date: Thu, 23 May 2013 12:45:38 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201305231245.38822.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 6a084d6b3dc200b855ae8a3c6771abe285a3835d:

  [media] saa7115: Don't use a dynamic array (2013-05-21 12:04:16 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.10b

for you to fetch changes up to 5c87794a4ac9008deb8f2f69edbe9a14e9f9c561:

  drivers/staging: davinci: vpfe: fix dependency for building the driver (2013-05-23 12:43:33 +0200)

----------------------------------------------------------------
Lad, Prabhakar (1):
      drivers/staging: davinci: vpfe: fix dependency for building the driver

 drivers/staging/media/davinci_vpfe/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
