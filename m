Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:12354 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbbCCRaI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2015 12:30:08 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NKN00G7MCSZMB50@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Mar 2015 17:34:11 +0000 (GMT)
Received: from [106.116.147.32] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0NKN00MQ7CM50470@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Mar 2015 17:30:05 +0000 (GMT)
Message-id: <54F5EF90.2050400@samsung.com>
Date: Tue, 03 Mar 2015 18:29:52 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] s5p fixes
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull the following s5p driver fixes.

The following changes since commit ce037f19aaef992c634af653b17e61eee30a9404:

  [media] media: atmel-isi: increase the burst length to improve the performance (2015-03-02 13:27:11 -0300)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for-v4.0/media/fixes

for you to fetch changes up to 8278294b92b0a2b49a262342ea1d8ced109ea685:

  s5p-mfc: Fix NULL pointer dereference caused by not set q->lock (2015-03-03 16:52:50 +0100)

----------------------------------------------------------------
Arnd Bergmann (1):
      s5p-tv: hdmi needs I2C support

Jacek Anaszewski (1):
      s5p-jpeg: exynos3250: fix erroneous reset procedure

Kamil Debski (1):
      s5p-mfc: Fix NULL pointer dereference caused by not set q->lock

Tony K Nadackal (1):
      s5p-jpeg: Initialize cb and cr to zero

 drivers/media/platform/s5p-jpeg/jpeg-core.c        |    3 +++
 .../media/platform/s5p-jpeg/jpeg-hw-exynos3250.c   |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |    1 +
 drivers/media/platform/s5p-tv/Kconfig              |    1 +
 4 files changed, 6 insertions(+), 1 deletion(-)

 
Regards,
Sylwester
