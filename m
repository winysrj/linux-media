Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:32203 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbbDCOLn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2015 10:11:43 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NM8000MBIA3VO40@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 03 Apr 2015 15:15:39 +0100 (BST)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0NM800GGJI3GO530@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 03 Apr 2015 15:11:41 +0100 (BST)
Message-id: <551E9F8D.6030600@samsung.com>
Date: Fri, 03 Apr 2015 16:11:25 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] s5p-jpeg updates
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Mauro,

The following changes since commit 8a56b6b5fd6ff92b7e27d870b803b11b751660c2:

  [media] v4l2-subdev: remove enum_framesizes/intervals (2015-03-23 12:02:41 -0700)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for-v4.1/media/next

for you to fetch changes up to 6263372bc7fc060e9fb70bcb27eb6188767109f3:

  s5p-jpeg: Remove some unused functions (2015-03-30 17:31:45 +0200)

----------------------------------------------------------------
Andrzej Pietrasiewicz (1):
      s5p-jpeg: add 5420 family support

Jacek Anaszewski (1):
      s5p-jpeg: Initialize jpeg_addr fields to zero

Rickard Strandqvist (1):
      s5p-jpeg: Remove some unused functions

 .../bindings/media/exynos-jpeg-codec.txt           |    2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |   63 ++++++++++++++------
 drivers/media/platform/s5p-jpeg/jpeg-core.h        |   12 ++--
 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c      |   32 ----------
 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h      |    3 -
 5 files changed, 53 insertions(+), 59 deletions(-)

-- 
Regards
Sylwester 
