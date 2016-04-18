Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:51229 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813AbcDROaq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2016 10:30:46 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 4D741180054
	for <linux-media@vger.kernel.org>; Mon, 18 Apr 2016 16:30:40 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.6] Two revert patches
Message-ID: <5714EF90.4040605@xs4all.nl>
Date: Mon, 18 Apr 2016 16:30:40 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

These two patches should go to 4.6.

Note that the usbvision patch is also part of a 4.7 pull request of mine, but
I realized that it should go to 4.6, not 4.7.

Regards,

	Hans

The following changes since commit ecb7b0183a89613c154d1bea48b494907efbf8f9:

  [media] m88ds3103: fix undefined division (2016-04-13 19:17:39 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.6a

for you to fetch changes up to 9990a56c2ed064abfd72e074182800c56a876ae9:

  davinci_vpfe: Revert "staging: media: davinci_vpfe: remove,unnecessary ret variable" (2016-04-18 16:17:31 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      davinci_vpfe: Revert "staging: media: davinci_vpfe: remove,unnecessary ret variable"

Vladis Dronov (1):
      usbvision: revert commit 588afcc1

 drivers/media/usb/usbvision/usbvision-video.c   |  7 -------
 drivers/staging/media/davinci_vpfe/vpfe_video.c | 54 +++++++++++++++++++++++++++++++++--------------------
 2 files changed, 34 insertions(+), 27 deletions(-)
