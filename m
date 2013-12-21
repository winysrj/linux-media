Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:38437 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab3LULlA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Dec 2013 06:41:00 -0500
Received: by mail-wi0-f181.google.com with SMTP id hq4so4714217wib.2
        for <linux-media@vger.kernel.org>; Sat, 21 Dec 2013 03:40:59 -0800 (PST)
Received: from [192.168.1.110] (093105185086.warszawa.vectranet.pl. [93.105.185.86])
        by mx.google.com with ESMTPSA id c1sm4687871wje.4.2013.12.21.03.40.57
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 21 Dec 2013 03:40:58 -0800 (PST)
Message-ID: <52B57E48.5090303@gmail.com>
Date: Sat, 21 Dec 2013 12:40:56 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] exynos4-is runtime PM related cleanups
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit c57f87e62368c33ebda11a4993380c8e5a19a5c5:

   [media] anysee: fix non-working E30 Combo Plus DVB-T (2013-12-20 
14:24:20 -0200)

are available in the git repository at:
   git://linuxtv.org/snawrocki/samsung.git v3.14-exynos4-is-pm-rework

Sylwester Nawrocki (6):
       exynos4-is: Leave FIMC clocks enabled when runtime PM is disabled
       exynos4-is: Activate mipi-csis in probe() if runtime PM is disabled
       exynos4-is: Enable FIMC-LITE clock if runtime PM is not used
       exynos4-is: Correct clean up sequence on error path in 
fimc_is_probe()
       exynos4-is: Enable fimc-is clocks in probe() if runtime PM is 
disabled
       exynos4-is: Remove dependency on PM_RUNTIME from Kconfig

  drivers/media/platform/exynos4-is/Kconfig     |    2 +-
  drivers/media/platform/exynos4-is/fimc-core.c |   29 
+++++++++++++-----------
  drivers/media/platform/exynos4-is/fimc-is.c   |   29 
+++++++++++++++++++------
  drivers/media/platform/exynos4-is/fimc-lite.c |   24 +++++++++++---------
  drivers/media/platform/exynos4-is/mipi-csis.c |   11 ++++++++-
  5 files changed, 62 insertions(+), 33 deletions(-)
