Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:60699 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbaAPV6s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jan 2014 16:58:48 -0500
Received: by mail-ee0-f43.google.com with SMTP id c41so1778960eek.30
        for <linux-media@vger.kernel.org>; Thu, 16 Jan 2014 13:58:47 -0800 (PST)
Received: from [192.168.0.13] (89-76-41-4.dynamic.chello.pl. [89.76.41.4])
        by mx.google.com with ESMTPSA id 46sm5228158ees.4.2014.01.16.13.58.45
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 16 Jan 2014 13:58:45 -0800 (PST)
Message-ID: <52D85614.2080101@gmail.com>
Date: Thu, 16 Jan 2014 22:58:44 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] v4l2 driver fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 587d1b06e07b4a079453c74ba9edf17d21931049:

   [media] rc-core: reuse device numbers (2014-01-15 11:46:37 -0200)

are available in the git repository at:
   git://linuxtv.org/snawrocki/samsung.git v3.14-fixes-1

Andrzej Hajda (1):
       s5k5baf: allow to handle arbitrary long i2c sequences

Jacek Anaszewski (1):
       s5p-jpeg: Fix wrong NV12 format parameters

Sylwester Nawrocki (3):
       exynos4-is: Fix error paths in probe() for !pm_runtime_enabled()
       exynos4-is: Compile in fimc runtime PM callbacks conditionally
       exynos4-is: Compile in fimc-lite runtime PM callbacks conditionally

  drivers/media/i2c/s5k5baf.c                   |   30 
+++++++++++++++---------
  drivers/media/platform/exynos4-is/fimc-core.c |    5 +++-
  drivers/media/platform/exynos4-is/fimc-lite.c |    7 ++++-
  drivers/media/platform/s5p-jpeg/jpeg-core.c   |    8 +++---
  4 files changed, 32 insertions(+), 18 deletions(-)
