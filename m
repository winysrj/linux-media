Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:45404 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab3EaVaP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 17:30:15 -0400
Received: by mail-bk0-f52.google.com with SMTP id mz10so973499bkb.39
        for <linux-media@vger.kernel.org>; Fri, 31 May 2013 14:30:14 -0700 (PDT)
Received: from [192.168.1.110] (093105185086.warszawa.vectranet.pl. [93.105.185.86])
        by mx.google.com with ESMTPSA id og1sm12064054bkb.16.2013.05.31.14.30.12
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 31 May 2013 14:30:13 -0700 (PDT)
Message-ID: <51A91663.8020305@gmail.com>
Date: Fri, 31 May 2013 23:30:11 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.10] exynos4-is fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This includes couple bug fixes for the exynos imaging subsystem driver.
Please pull for v3.10.

The following changes since commit 6719a4974600fdaa4a3ac2ea2aed819a35d06605:

   [media] staging/solo6x10: select the desired font (2013-05-27 
09:38:57 -0300)

are available in the git repository at:
   git://linuxtv.org/snawrocki/samsung.git v3.10-fixes-2

Sylwester Nawrocki (4):
       exynos4-is: Prevent NULL pointer dereference when firmware isn't 
loaded
       exynos4-is: Ensure fimc-is clocks are not enabled until properly 
configured
       exynos4-is: Fix reported colorspace at FIMC-IS-ISP subdev
       exynos4-is: Remove "sysreg" clock handling

  drivers/media/platform/exynos4-is/fimc-is.c  |   22 ++++++++++------------
  drivers/media/platform/exynos4-is/fimc-is.h  |    1 -
  drivers/media/platform/exynos4-is/fimc-isp.c |    4 ++--
  3 files changed, 12 insertions(+), 15 deletions(-)

Thanks,
Sylwester
