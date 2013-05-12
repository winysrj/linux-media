Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:52894 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab3ELUAU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 May 2013 16:00:20 -0400
Received: by mail-ea0-f179.google.com with SMTP id h14so3162693eaj.10
        for <linux-media@vger.kernel.org>; Sun, 12 May 2013 13:00:19 -0700 (PDT)
Received: from [192.168.1.110] (093105185086.warszawa.vectranet.pl. [93.105.185.86])
        by mx.google.com with ESMTPSA id r10sm18260349eez.10.2013.05.12.13.00.17
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 12 May 2013 13:00:18 -0700 (PDT)
Message-ID: <518FF4D0.5070803@gmail.com>
Date: Sun, 12 May 2013 22:00:16 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL - BUG FIXES FOR 3.10] Samsung media driver fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following are couple bug fixes for the Samsung SoC camera and sensor
drivers.

I have included also a patch correcting the Exynos FIMC-LITE device DT
binding documentation, so as to avoid confusing any board integrators
trying to write .dts files including support for those devices. I hope
it still qualifies for 3.10, it's a fix for stuff that got first added
in this release.

Thanks,
Sylwester

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

   Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:
   git://linuxtv.org/snawrocki/samsung.git v3.10-fixes-1

Axel Lin (2):
       s5c73m3: Fix off-by-one valid range checking for fie->index
       exynos4-is: Fix off-by-one valid range checking for is->config_index

Sachin Kamat (2):
       exynos4-is: Fix potential null pointer dereference in mipi-csis.c
       s3c-camif: Fix incorrect variable type

Sylwester Nawrocki (1):
       exynos4-is: Correct fimc-lite compatible property description

  .../devicetree/bindings/media/exynos-fimc-lite.txt |    2 +-
  drivers/media/i2c/s5c73m3/s5c73m3-core.c           |    2 +-
  drivers/media/platform/exynos4-is/fimc-is-regs.c   |    2 +-
  drivers/media/platform/exynos4-is/mipi-csis.c      |    2 +-
  drivers/media/platform/s3c-camif/camif-core.h      |    2 +-
  5 files changed, 5 insertions(+), 5 deletions(-)
