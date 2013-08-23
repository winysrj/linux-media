Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:40425 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab3HWLoD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Aug 2013 07:44:03 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MRZ004REF9A2A70@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Aug 2013 12:44:00 +0100 (BST)
Received: from AMDN910 ([106.116.147.102])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MRZ005K8F9CD9B0@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Aug 2013 12:44:00 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL] For v3.12
Date: Fri, 23 Aug 2013 13:43:59 +0200
Message-id: <00f901ce9ff6$0f33fe80$2d9bfb80$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit bfd22c490bc74f9603ea90c37823036660a313e2:

  v4l2-common: warning fix (W=1): add a missed function prototype
(2013-08-18 10:18:30 -0300)

are available in the git repository at:

  git://linuxtv.org/kdebski/media.git 20130823-for-v3.12

for you to fetch changes up to 9e8bbd242c55ebe07a8abb8f62e69885c841eb99:

  coda: No need to check the return value of platform_get_resource()
(2013-08-23 13:40:45 +0200)

----------------------------------------------------------------
Fabio Estevam (3):
      coda: Fix error paths
      coda: Check the return value from clk_prepare_enable()
      coda: No need to check the return value of platform_get_resource()

Shaik Ameer Basha (1):
      v4l2-mem2mem: clear m2m context from job_queue before ctx streamoff

 drivers/media/platform/coda.c          |   71
++++++++++++++++++++++----------
 drivers/media/v4l2-core/v4l2-mem2mem.c |   59 ++++++++++++++++----------
 2 files changed, 87 insertions(+), 43 deletions(-)

