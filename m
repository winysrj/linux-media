Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59644 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab3LULli (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Dec 2013 06:41:38 -0500
Received: by mail-wi0-f178.google.com with SMTP id bz8so4723475wib.5
        for <linux-media@vger.kernel.org>; Sat, 21 Dec 2013 03:41:37 -0800 (PST)
Received: from [192.168.1.110] (093105185086.warszawa.vectranet.pl. [93.105.185.86])
        by mx.google.com with ESMTPSA id wy5sm4700172wjc.8.2013.12.21.03.41.35
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 21 Dec 2013 03:41:36 -0800 (PST)
Message-ID: <52B57E6F.6070305@gmail.com>
Date: Sat, 21 Dec 2013 12:41:35 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] exynos4-is driver updates
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit c57f87e62368c33ebda11a4993380c8e5a19a5c5:

   [media] anysee: fix non-working E30 Combo Plus DVB-T (2013-12-20 
14:24:20 -0200)

are available in the git repository at:
   git://linuxtv.org/snawrocki/samsung.git v3.14-exynos4-is

Sylwester Nawrocki (3):
       exynos4-is: Add clock provider for the external clocks
       exynos4-is: Add support for asynchronous subdevices registration
       exynos4-is: Add the FIMC-IS ISP capture DMA driver

  drivers/media/platform/exynos4-is/Kconfig          |    9 +
  drivers/media/platform/exynos4-is/Makefile         |    4 +
  drivers/media/platform/exynos4-is/fimc-is-param.c  |    2 +-
  drivers/media/platform/exynos4-is/fimc-is-param.h  |    5 +
  drivers/media/platform/exynos4-is/fimc-is-regs.c   |   14 +
  drivers/media/platform/exynos4-is/fimc-is-regs.h   |    1 +
  drivers/media/platform/exynos4-is/fimc-is.c        |    3 +
  drivers/media/platform/exynos4-is/fimc-is.h        |    5 +
  drivers/media/platform/exynos4-is/fimc-isp-video.c |  660 
++++++++++++++++++++
  drivers/media/platform/exynos4-is/fimc-isp-video.h |   44 ++
  drivers/media/platform/exynos4-is/fimc-isp.c       |   29 +-
  drivers/media/platform/exynos4-is/fimc-isp.h       |   27 +-
  drivers/media/platform/exynos4-is/media-dev.c      |  350 ++++++++---
  drivers/media/platform/exynos4-is/media-dev.h      |   31 +-
  14 files changed, 1079 insertions(+), 105 deletions(-)
  create mode 100644 drivers/media/platform/exynos4-is/fimc-isp-video.c
  create mode 100644 drivers/media/platform/exynos4-is/fimc-isp-video.h
